//
//  NSDataUtils.swift
//  AppGoPro
//
//  Created by Administrator on 10/30/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

import Foundation

class NSDataUtils {
    static func nsdataToJSON(_ data: Data) -> AnyObject? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as AnyObject
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }
    
    static func nsdataFromJSON(_ data: AnyObject) -> Data? {
        do {
            return try JSONSerialization.data(withJSONObject: data, options: [])
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }
}
