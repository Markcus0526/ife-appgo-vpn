// KeychainItemWrapper.swift
//
// Copyright (c) 2015 Mihai Costea (http://mcostea.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import Security

class KeychainItemWrapper {
    
    var genericPasswordQuery = [AnyHashable: Any]()
    var keychainItemData = [AnyHashable: Any]()
    
    var values = [String: AnyObject]()
    
    init(identifier: String, accessGroup: String?) {
        self.genericPasswordQuery[kSecClass as AnyHashable] = kSecClassGenericPassword
        self.genericPasswordQuery[kSecAttrAccount as AnyHashable] = identifier as AnyObject?
        
        if (accessGroup != nil) {
            if TARGET_IPHONE_SIMULATOR != 1 {
                self.genericPasswordQuery[kSecAttrAccessGroup as AnyHashable] = accessGroup as AnyObject?
            }
        }
        
        self.genericPasswordQuery[kSecMatchLimit as AnyHashable] = kSecMatchLimitOne
        self.genericPasswordQuery[kSecReturnAttributes as AnyHashable] = kCFBooleanTrue
        
        var outDict: AnyObject?
        
        let copyMatchingResult = SecItemCopyMatching(genericPasswordQuery as CFDictionary, &outDict)
        
        if copyMatchingResult != noErr {
            self.resetKeychain()
            
            self.keychainItemData[kSecAttrAccount as AnyHashable] = identifier as AnyObject?
            if (accessGroup != nil) {
                if TARGET_IPHONE_SIMULATOR != 1 {
                    self.keychainItemData[kSecAttrAccessGroup as AnyHashable] = accessGroup as AnyObject?
                }
            }
        } else {
            self.keychainItemData = self.secItemDataToDict(outDict as! [AnyHashable: Any])
        }
    }
    
    subscript(key: String) -> AnyObject? {
        get {
            return self.values[key]
        }
        
        set(newValue) {
            self.values[key] = newValue
            self.writeKeychainData()
        }
    }
    
    func resetKeychain() {
        
        if !self.keychainItemData.isEmpty {
            let tempDict = self.dictToSecItemData(self.keychainItemData)
            var junk = noErr
            junk = SecItemDelete(tempDict as CFDictionary)
            
            assert(junk == noErr || junk == errSecItemNotFound, "Failed to delete current dict")
        }
        
        self.keychainItemData[kSecAttrAccount as AnyHashable] = "" as AnyObject?
        self.keychainItemData[kSecAttrLabel as AnyHashable] = "" as AnyObject?
        self.keychainItemData[kSecAttrDescription as AnyHashable] = "" as AnyObject?
        
        self.keychainItemData[kSecValueData as AnyHashable] = "" as AnyObject?
    }
    
    fileprivate func secItemDataToDict(_ data: [AnyHashable: Any]) -> [AnyHashable: Any] {
        var returnDict = [AnyHashable: Any]()
        for (key, value) in data {
            returnDict[key] = value
        }
        
        returnDict[kSecReturnData as AnyHashable] = kCFBooleanTrue
        returnDict[kSecClass as AnyHashable] = kSecClassGenericPassword
        
        var passwordData: AnyObject?
        
        // We could use returnDict like the Apple example but this crashes the app with swift_unknownRelease
        // when we try to access returnDict again
        let queryDict = returnDict
        
        let copyMatchingResult = SecItemCopyMatching(queryDict as CFDictionary, &passwordData)
        
        if copyMatchingResult != noErr {
            assert(false, "No matching item found in keychain")
        } else {
            let retainedValuesData = passwordData as! Data
            do {
                let val = try JSONSerialization.jsonObject(with: retainedValuesData as Data, options: []) as! [String: AnyObject]
                
                returnDict.removeValue(forKey: kSecReturnData as AnyHashable)
                returnDict[kSecValueData as AnyHashable] = val as AnyObject?
                
                self.values = val
            } catch {
                assert(false, "Error parsing json value. \(error)")
            }
        }
        
        return returnDict
    }
    
    fileprivate func dictToSecItemData(_ dict: [AnyHashable: Any]) -> [AnyHashable: Any] {
        var returnDict = [AnyHashable: Any]()
        
        for (key, value) in self.keychainItemData {
            returnDict[key] = value
        }
        
        returnDict[kSecClass as AnyHashable] = kSecClassGenericPassword
        
        do {
            returnDict[kSecValueData as AnyHashable] = try JSONSerialization.data(withJSONObject: self.values, options: []) as AnyObject?
        } catch {
            assert(false, "Error paring json value. \(error)")
        }
        
        return returnDict
    }
    
    fileprivate func writeKeychainData() {
        var attributes: AnyObject?
        var updateItem: [String: AnyObject]? = [String: AnyObject]()
        
        var result: OSStatus?
        
        let copyMatchingResult = SecItemCopyMatching(self.genericPasswordQuery as CFDictionary, &attributes)
        
        if copyMatchingResult != noErr {
            result = SecItemAdd(self.dictToSecItemData(self.keychainItemData) as CFDictionary, nil)
            assert(result == noErr, "Failed to add keychain item")
        } else {
            
            for (key, value) in attributes as! [String: AnyObject] {
                updateItem![key] = value
            }
            updateItem![kSecClass as String] = self.genericPasswordQuery[kSecClass] as AnyObject
            
            var tempCheck = self.dictToSecItemData(self.keychainItemData)
            tempCheck.removeValue(forKey: kSecClass as AnyHashable)
            
            if TARGET_IPHONE_SIMULATOR == 1 {
                tempCheck.removeValue(forKey: kSecAttrAccessGroup as AnyHashable)
            }
            
            result = SecItemUpdate(updateItem! as CFDictionary, tempCheck as CFDictionary)
            assert(result == noErr, "Failed to update keychain item")
        }
    }
}
