//
//  AppPref.swift
//  Appsocks
//
//  Created by Administrator on 10/28/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

import Foundation
import CryptoSwift
import NetworkExtension


extension String {
    func aesEncrypt() throws -> String {
        let encrypted = try AES(key: AppInfo.AES_KEY, iv: AppInfo.AES_IV, padding: .pkcs7).encrypt([UInt8](self.data(using: .utf8)!))
        return Data(encrypted).base64EncodedString()
    }
    
    func aesDecrypt() throws -> String {
        guard let data = Data(base64Encoded: self) else { return "" }
        let decrypted = try AES(key: AppInfo.AES_KEY, iv: AppInfo.AES_IV, padding: .pkcs7).decrypt([UInt8](data))
        return String(bytes: Data(decrypted).bytes, encoding: .utf8) ?? "Could not decrypt"
    }
}

public class AppPref {
    // service url
    static let KEY_SERVICE_URL = "ServiceUrl"
    
    // login
    static let KEY_LOGIN_PHONENUM = "LoginPhoneNum"
    static let KEY_LOGIN_PASSWORD = "LoginPassword"
    static let KEY_ACCESS_TOKEN = "AccessToken"
    static let KEY_TOURIST_ID = "TouristId"
    static let KEY_EXPIRES_IN = "ExpiresIn"
    static let KEY_REFRESH_TOKEN = "RefreshToken"
    static let KEY_TOKEN_TYPE = "TokenType"
    static let KEY_LOGIN_DATE = "LoginDate"
    static let KEY_SPLASH_HIDDEN = "SplashHidden"
    
    // vpn environment
    static let KEY_CONNECTED_TIME = "ConnectedTime"
    static let KEY_RULE_MODE = "RuleMode"
    static let KEY_ADS_STATE = "AdsState"
    
    // language, and then share with today-widget
    static let KEY_LANGUAGE_CODE = "LanguageCode"
    
    // connected service
    static let KEY_CURRENT_USER_SERVICE = "CurrentUserService"
    static let KEY_CURRENT_TOURIST_SERVICE = "CurrentTouristService"
    
    // available services
    static let KEY_USER_SERVICES = "UserServices"
    static let KEY_TOURIST_SERVICES = "TouristServices"
    
    // sms count
    static let KEY_SMS_COUNT = "SmsCount"
    
    // from Today widget
    static let KEY_TODAYLAUNCH_STATE = "TodayLaunch"
    
    // rule collections
    static let KEY_RULES_INTERNATIONAL = "InternationalRuls"
    static let KEY_RULES_INTERNATIONALADS = "InternationalRulsAds"
    static let KEY_RULES_NATIONAL = "NationalRuls"
    static let KEY_RULES_NATIONALADS = "NationalRulsAds"
    
    static let KEY_RULES_INTERNATIONAL_TIME = "InternationalRulsTime"
    static let KEY_RULES_INTERNATIONALADS_TIME = "InternationalRulsAdsTimee"
    static let KEY_RULES_NATIONAL_TIME = "NationalRulsTime"
    static let KEY_RULES_NATIONALADS_TIME = "NationalRulsAdsTime"
    
    static let KEY_SERVER_PROFILES = "ServerProfiles"
    static let KEY_ACTIVE_SERVER_PROFILEID = "ActiveServerProfileId"
    
    static let KEY_NOTIFICATION_TIME = "NotificationTime"
    static let KEY_BADGE_VISIBLE = "BadgeVisible"
    
    static let KEY_LAUNCHATLOGIN = "LaunchAtLogin"
    
    static let KEY_VERSION_CODE = "VersionCode"
    // vpn status
    static let KEY_VPN_STATUS = "VpnStatus"
    
    public static func setServiceUrl(url: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(url, forKey: KEY_SERVICE_URL)
    }
    
    public static func getServiceUrl() -> String {
        let userDefaults = UserDefaults.standard
        let url = userDefaults.object(forKey: KEY_SERVICE_URL) as? String
        if url == nil {
            return ""
        } else {
            return url!
        }
    }
    
    public static func setLoginInfo(phone: String, pwd: String, json: AnyObject) {
        let userDefaults = UserDefaults.standard
        let access_token = json["access_token"] as! String
        let expires_in = json["expires_in"] as! Int
        let refresh_token = json["refresh_token"] as! String
        let token_type = json["token_type"] as! String
        let curDate: Date = Date()
        
        do {
            try userDefaults.set(phone.aesEncrypt(), forKey: KEY_LOGIN_PHONENUM)
            try userDefaults.set(pwd.aesEncrypt(), forKey: KEY_LOGIN_PASSWORD)
            userDefaults.set(access_token, forKey: KEY_ACCESS_TOKEN)
            userDefaults.set(expires_in, forKey: KEY_EXPIRES_IN)
            userDefaults.set(refresh_token, forKey: KEY_REFRESH_TOKEN)
            userDefaults.set(token_type, forKey: KEY_TOKEN_TYPE)
            userDefaults.set(curDate, forKey: KEY_LOGIN_DATE)
        } catch {
        }
        
        setAccessToken(token: access_token)
    }
   
    public static func updateLoginInfo(json: AnyObject) {
        let userDefaults = UserDefaults.standard
        let access_token = json["access_token"] as! String
        let expires_in = json["expires_in"] as! Int
        let refresh_token = json["refresh_token"] as! String
        let token_type = json["token_type"] as! String
        let curDate: Date = Date()
        
        userDefaults.set(access_token, forKey: KEY_ACCESS_TOKEN)
        userDefaults.set(expires_in, forKey: KEY_EXPIRES_IN)
        userDefaults.set(refresh_token, forKey: KEY_REFRESH_TOKEN)
        userDefaults.set(token_type, forKey: KEY_TOKEN_TYPE)
        userDefaults.set(curDate, forKey: KEY_LOGIN_DATE)
        
        setAccessToken(token: access_token)
    }
    
    public static func isLogined() -> Bool {
        if getAccessToken() == "" {
            return false
        }
        
        if getLastLoginPhoneNumber() == "" {
            return false
        }
        
        if getLastLoginPassword() == "" {
            return false
        }
        
        return true
    }
    
    
    public static func getLastLoginPhoneNumber() -> String {
        let userDefaults = UserDefaults.standard
        let phone = userDefaults.object(forKey: KEY_LOGIN_PHONENUM) as? String
        if phone == nil {
            return ""
        } else {
            do {
                return try phone!.aesDecrypt()
            } catch {
                return ""
            }
        }
    }
    
    public static func getLastLoginPassword() -> String {
        let userDefaults = UserDefaults.standard
        let password = userDefaults.object(forKey: KEY_LOGIN_PASSWORD) as? String
        if password == nil {
            return ""
        } else {
            do {
                return try password!.aesDecrypt()
            } catch {
                return ""
            }
        }
    }
    
    public static func getLastLoginDate() -> NSDate? {
        let userDefaults = UserDefaults.standard
        return userDefaults.object(forKey: KEY_LOGIN_DATE) as? NSDate
    }
    
    public static func getExpireIn() -> Int? {
        let userDefaults = UserDefaults.standard
        return userDefaults.object(forKey: KEY_EXPIRES_IN) as? Int
    }
    
    public static func clearUserInfo() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(nil, forKey: KEY_ACCESS_TOKEN)
        userDefaults.set(nil, forKey: KEY_LOGIN_PHONENUM)
        userDefaults.set(nil, forKey: KEY_LOGIN_PASSWORD)
    }
    
    public static func clearLoginInfo() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(nil, forKey: KEY_ACCESS_TOKEN)
    }
    
    public static func setSplashHidden(hidden: Bool) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(hidden, forKey: KEY_SPLASH_HIDDEN)
    }
    
    public static func getSplashHidden() -> Bool {
        let userDefaults = UserDefaults.standard
        let hidden = userDefaults.object(forKey: KEY_SPLASH_HIDDEN) as? Bool
        if hidden == nil {
            return false
        } else {
            return hidden!
        }
    }
    
    public static func setAccessToken(token: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(token, forKey: KEY_ACCESS_TOKEN)
    }
    
    public static func getAccessToken() -> String {
        let userDefaults = UserDefaults.standard
        let token = userDefaults.object(forKey: KEY_ACCESS_TOKEN) as? String
        if token == nil {
            return ""
        } else {
            return token!
        }
    }
    
    public static func setRefreshToken(token: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(token, forKey: KEY_REFRESH_TOKEN)
    }
    
    public static func getRefreshToken() -> String {
        let userDefaults = UserDefaults.standard
        let token = userDefaults.object(forKey: KEY_REFRESH_TOKEN) as? String
        if token == nil {
            return ""
        } else {
            return token!
        }
    }
    
    public static func setTouristId(tourist: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(tourist, forKey: KEY_TOURIST_ID)
    }
    
    public static func getTouristId() -> String {
        let userDefaults = UserDefaults.standard
        let tourist = userDefaults.object(forKey: KEY_TOURIST_ID) as? String
        if tourist == nil {
            return ""
        } else {
            return tourist!
        }
    }
    
    public static func setCurrentService(service: MService?) {
        let userDefaults = UserDefaults.standard
        if isLogined() {
            if service != nil {
                let data: [String: Any] = service!.toDictionary(crypto: true)
                userDefaults.set(data, forKey: KEY_CURRENT_USER_SERVICE)
            } else {
                userDefaults.set(nil, forKey: KEY_CURRENT_USER_SERVICE)
            }
        } else {
            if service != nil {
                let data: [String: Any] = service!.toDictionary(crypto: true)
                userDefaults.set(data, forKey: KEY_CURRENT_TOURIST_SERVICE)
            } else {
                userDefaults.set(nil, forKey: KEY_CURRENT_TOURIST_SERVICE)
            }
        }
    }
    
    public static func getCurrentService() -> MService? {
        let userDefaults = UserDefaults.standard
        var data: [String: Any]?
        if isLogined() {
            data = userDefaults.object(forKey: KEY_CURRENT_USER_SERVICE) as? [String: Any]
        } else {
            data = userDefaults.object(forKey: KEY_CURRENT_TOURIST_SERVICE) as? [String: Any]
        }
        if data != nil && data!.count > 0 {
            let service: MService = MService()
            service.fromDictionary(dictionary: data!, crypto: true)
            return service
        } else {
            return nil
        }
    }
    
    public static func setAvailableServices(services: [MService]) {
        let userDefaults = UserDefaults.standard
        var data: [[String: Any]] = []
        for item in services {
            data.append(item.toDictionary(crypto: true))
        }
        if isLogined() {
            userDefaults.set(data, forKey: KEY_USER_SERVICES)
        } else {
            userDefaults.set(data, forKey: KEY_TOURIST_SERVICES)
        }
    }
    
    public static func getAvailableServices() -> [MService] {
        let userDefaults = UserDefaults.standard
        var data: [[String: Any]]?
        if isLogined() {
            data = userDefaults.object(forKey: KEY_USER_SERVICES) as? [[String: Any]]
        } else {
            data = userDefaults.object(forKey: KEY_TOURIST_SERVICES) as? [[String: Any]]
        }
        var services: [MService] = Array()
        if data != nil && data!.count > 0 {
            for item in data! {
                let service: MService = MService()
                service.fromDictionary(dictionary: item, crypto: true)
                services.append(service)
            }
        }
        return services
    }
    
    public static func setCurLanguageCode(langID: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(langID, forKey: KEY_LANGUAGE_CODE)
    }
    
    public static func getCurLanguageCode() -> String {
        let userDefaults = UserDefaults.standard
        let langCode = userDefaults.object(forKey: KEY_LANGUAGE_CODE) as? String
        if langCode == nil {
            return ""
        } else {
            return langCode!
        }
    }
    
    public static func getServiceLanguage() -> String {
        let langCode = getCurLanguageCode()
        if langCode == "zh-Hans" {
            return "CN"
        } else {
            return "US"
        }
    }
    
    public static func setConnectedStartTime(time: NSDate?) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(time, forKey: KEY_CONNECTED_TIME)
    }
    
    public static func getLastConnectedStartTime() -> NSDate? {
        let userDefaults = UserDefaults.standard
        return userDefaults.object(forKey: KEY_CONNECTED_TIME) as? NSDate
    }
    
    public static func setRuleMode(mode: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(mode, forKey: KEY_RULE_MODE)
    }
    
    public static func getRuleMode() -> String {
        let userDefaults = UserDefaults.standard
        let mode = userDefaults.object(forKey: KEY_RULE_MODE) as? String
        if mode == nil || mode == "international" {
            return "global"
        } else {
            return mode!
        }
    }
    
    public static func setSmsCount(sms: MSms) {
        let userDefaults = UserDefaults.standard
        let data : NSData = NSKeyedArchiver.archivedData(withRootObject: sms) as NSData
        userDefaults.set(data, forKey: KEY_SMS_COUNT)
    }
    
    public static func getLastSmsCount() -> MSms? {
        let userDefaults = UserDefaults.standard
        let data = userDefaults.object(forKey: KEY_SMS_COUNT) as! NSData?
        if data != nil {
            let sms : MSms = NSKeyedUnarchiver.unarchiveObject(with: data! as Data) as! MSms
            return sms
        } else {
            return nil
        }
    }
    
    public static func isLastLogin() -> Bool {
        let userDefaults = UserDefaults.standard
        let phonenum = userDefaults.object(forKey: KEY_LOGIN_PHONENUM) as? String
        let lastLoginDate = userDefaults.object(forKey: KEY_LOGIN_DATE) as? NSDate
        let expires_in = userDefaults.object(forKey: KEY_EXPIRES_IN) as? Int
        
        if phonenum == nil || lastLoginDate == nil || expires_in == nil {
            return false
        }
        
        let elapsed = Int(NSDate().timeIntervalSince((lastLoginDate as NSDate!) as Date))
        if elapsed >= expires_in! {
            return false
        }
        
        return true
    }
    
    public static func setDefaultServices() {
        let userDefaults = UserDefaults.standard
        
        userDefaults.set(NSNumber(value: 1081 as UInt16), forKey: "LocalSocks5.ListenPort")
        userDefaults.set("127.0.0.1", forKey: "LocalSocks5.ListenAddress")
        userDefaults.set("127.0.0.1", forKey: "PacServer.ListenAddress")
        userDefaults.set(NSNumber(value: 1085 as UInt16), forKey: "PacServer.ListenPort")
        userDefaults.set(NSNumber(value: 60 as UInt), forKey: "LocalSocks5.Timeout")
        userDefaults.set(NSNumber(value: false as Bool), forKey: "LocalSocks5.EnableUDPRelay")
        userDefaults.set(NSNumber(value: false as Bool), forKey: "LocalSocks5.EnableVerboseMode")
        userDefaults.set(NSNumber(value: true as Bool), forKey: "AutoConfigureNetworkServices")
        userDefaults.set("127.0.0.1", forKey: "LocalHTTP.ListenAddress")
        userDefaults.set(NSNumber(value: 1086 as UInt16), forKey: "LocalHTTP.ListenPort")
        userDefaults.set(true, forKey: "LocalHTTPOn")
        userDefaults.set(true, forKey: "LocalHTTP.FollowGlobal")
    }
    
    public static func setVpnStatus(status: Int) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(status, forKey: KEY_VPN_STATUS)
    }
    
    public static func getVpnStatus() -> Int {
        let userDefaults = UserDefaults.standard
        let status = userDefaults.object(forKey: KEY_VPN_STATUS) as? Int
        if status == nil {
            return NEVPNStatus.disconnected.rawValue
        } else {
            return status!
        }
    }
  
    public static func setActiveProfileId(profileId: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(profileId, forKey: KEY_ACTIVE_SERVER_PROFILEID)
    }
    
    public static func getActiveProfileId() -> String {
        let userDefaults = UserDefaults.standard
        let ret = userDefaults.object(forKey: KEY_ACTIVE_SERVER_PROFILEID) as? String
        if ret == nil {
            return ""
        } else {
            return ret!
        }
    }
    
    public static func isValidSms() -> Bool {
        var sms = AppPref.getLastSmsCount()
        if sms == nil {
            let data = NSMutableDictionary()
            data["count"] = 1
            data["createdat"] = NSDate()
            sms = MSms(data: data)
            
            setSmsCount(sms: sms!)
            return true

        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date1String = dateFormatter.string(from: NSDate() as Date)
            let date2String = dateFormatter.string(from: sms!.createdat! as Date)
            if date1String == date2String {
                sms?.count += 1
            } else {
                sms?.count = 1
                sms?.createdat = NSDate()
            }

            if (sms?.count)! > 5 {
                return false
            } else {
                setSmsCount(sms: sms!)
                return true
            }
        }
    }
    
    public static func setLastNotificationTime(time: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(time, forKey: KEY_NOTIFICATION_TIME)
    }
    
    public static func getLastNotificationTime() -> String {
        let userDefaults = UserDefaults.standard
        let ret = userDefaults.object(forKey: KEY_NOTIFICATION_TIME) as? String
        if ret == nil {
            return ""
        } else {
            return ret!
        }
    }
    
    public static func setBadgeVisible(visible: Bool) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(visible, forKey: KEY_BADGE_VISIBLE)
    }
    
    public static func getBadgeVisible() -> Bool {
        let userDefaults = UserDefaults.standard
        let ret = userDefaults.object(forKey: KEY_BADGE_VISIBLE) as? Bool
        if ret == nil {
            return false
        } else {
            return ret!
        }
    }
    
    public static func setLaunchAtLogin(enable: Bool) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(enable, forKey: KEY_LAUNCHATLOGIN)
    }
    
    public static func getLaunchAtLogin() -> Bool {
        let userDefaults = UserDefaults.standard
        let ret = userDefaults.object(forKey: KEY_LAUNCHATLOGIN) as? Bool
        if ret == nil {
            return false
        } else {
            return ret!
        }
    }
    
    public static func setVersionCode(version: Int) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(version, forKey: KEY_VERSION_CODE)
    }
    
    public static func getVersionCode() -> Int {
        let userDefaults = UserDefaults.standard
        let ret = userDefaults.object(forKey: KEY_VERSION_CODE) as? Int
        if ret == nil {
            return 0
        } else {
            return ret!
        }
    }
    
    public static func removeOldData() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }
    
    /*public static func saveDeviceUUID(deviceUUID: String) {
        let keychainItemWrapper = KeychainItemWrapper(identifier: AppInfo.appID, accessGroup: AppInfo.groupID)
        keychainItemWrapper["superSecretKey"] = deviceUUID as AnyObject?
    }
    
    public static func getDeviceUUID() -> String {
        let keychainItemWrapper = KeychainItemWrapper(identifier: AppInfo.appID, accessGroup: AppInfo.groupID)
        let deviceUUID = keychainItemWrapper["superSecretKey"] as? String
        
        if deviceUUID == nil {
            return ""
        } else {
            return deviceUUID!
        }
    }*/
}	
