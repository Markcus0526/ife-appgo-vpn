//
//  AppPref.swift
//  AppGoPro
//
//  Created by Administrator on 10/28/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

import Foundation
import NetworkExtension

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


open class AppPref {
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
    static let KEY_LAST_USER_SERVICE = "LastConnectedUserService"
    static let KEY_LAST_TOURIST_SERVICE = "LastConnectedTouristService"
    
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
    
    static let KEY_VERSION_CODE = "VersionCode"
    static let KEY_NOTIFICATION_TIME = "NotificationTime"
    static let KEY_BADGE_VISIBLE = "BadgeVisible"
    
    // vpn status
    static let KEY_VPN_STATUS = "VpnStatus"
    
    // service url
    static let KEY_SERVICE_URL = "ServiceUrl"
    
    // License Agree
    static let KEY_LICENSE_SHOW = "LicenseShow"
    
    open static func setLoginInfo(phone: String, pwd: String, json: AnyObject) {
        let groupDefaults = UserDefaults(suiteName: AppInfo.groupID)
        let access_token = json["access_token"] as! String
        let expires_in = json["expires_in"] as! Int
        let refresh_token = json["refresh_token"] as! String
        let token_type = json["token_type"] as! String
        let curDate:Date = Date()
        
        groupDefaults!.set(phone, forKey: KEY_LOGIN_PHONENUM)
        groupDefaults!.set(pwd, forKey: KEY_LOGIN_PASSWORD)
        groupDefaults!.set(access_token, forKey: KEY_ACCESS_TOKEN)
        groupDefaults!.set(expires_in, forKey: KEY_EXPIRES_IN)
        groupDefaults!.set(refresh_token, forKey: KEY_REFRESH_TOKEN)
        groupDefaults!.set(token_type, forKey: KEY_TOKEN_TYPE)
        groupDefaults!.set(curDate, forKey: KEY_LOGIN_DATE)
        
        setAccessToken(token: access_token)
    }
    
    open static func updateLoginInfo(json: AnyObject) {
        let groupDefaults = UserDefaults(suiteName: AppInfo.groupID)
        let access_token = json["access_token"] as! String
        let expires_in = json["expires_in"] as! Int
        let refresh_token = json["refresh_token"] as! String
        let token_type = json["token_type"] as! String
        let curDate:Date = Date()
        
        groupDefaults!.set(access_token, forKey: KEY_ACCESS_TOKEN)
        groupDefaults!.set(expires_in, forKey: KEY_EXPIRES_IN)
        groupDefaults!.set(refresh_token, forKey: KEY_REFRESH_TOKEN)
        groupDefaults!.set(token_type, forKey: KEY_TOKEN_TYPE)
        groupDefaults!.set(curDate, forKey: KEY_LOGIN_DATE)
        
        setAccessToken(token: access_token)
    }
    
    open static func isLogined() -> Bool {
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
    
    
    open static func getLastLoginPhoneNumber() -> String {
        let groupDefaults = UserDefaults(suiteName: AppInfo.groupID)
        let phone = groupDefaults!.object(forKey: KEY_LOGIN_PHONENUM) as? String
        if phone == nil {
            return ""
        } else {
            return phone!
        }
    }
    
    open static func getLastLoginPassword() -> String {
        let groupDefaults = UserDefaults(suiteName: AppInfo.groupID)
        let password = groupDefaults!.object(forKey: KEY_LOGIN_PASSWORD) as? String
        if password == nil {
            return ""
        } else {
            return password!
        }
    }
    
    open static func getLastLoginDate() -> Date? {
        let groupDefaults = UserDefaults(suiteName: AppInfo.groupID)
        return groupDefaults!.object(forKey: KEY_LOGIN_DATE) as? Date
    }
    
    open static func getExpireIn() -> Int? {
        let groupDefaults = UserDefaults(suiteName: AppInfo.groupID)
        return groupDefaults!.object(forKey: KEY_EXPIRES_IN) as? Int
    }
    
    open static func clearUserInfo() {
        let groupDefaults = UserDefaults(suiteName: AppInfo.groupID)
        groupDefaults!.set(nil, forKey: KEY_ACCESS_TOKEN)
        groupDefaults!.set(nil, forKey: KEY_LOGIN_PHONENUM)
        groupDefaults!.set(nil, forKey: KEY_LOGIN_PASSWORD)
    }
    
    open static func clearLoginInfo() {
        let groupDefaults = UserDefaults(suiteName: AppInfo.groupID)
        groupDefaults!.set(nil, forKey: KEY_ACCESS_TOKEN)
    }
    
    open static func setSplashHidden(hidden: Bool) {
        let groupDefaults = UserDefaults(suiteName: AppInfo.groupID)
        groupDefaults!.set(hidden, forKey: KEY_SPLASH_HIDDEN)
    }
    
    open static func getSplashHidden() -> Bool {
        let groupDefaults = UserDefaults(suiteName: AppInfo.groupID)
        let hidden = groupDefaults!.object(forKey: KEY_SPLASH_HIDDEN) as? Bool
        if hidden == nil {
            return false
        } else {
            return hidden!
        }
    }
    
    open static func setLicenseShow(show: Bool) {
        let groupDefaults = UserDefaults(suiteName: AppInfo.groupID)
        groupDefaults!.set(show, forKey: KEY_LICENSE_SHOW)
    }
    
    open static func getLicenseShow() -> Bool {
        let groupDefaults = UserDefaults(suiteName: AppInfo.groupID)
        let show = groupDefaults!.object(forKey: KEY_LICENSE_SHOW) as? Bool
        if show == nil {
            return true
        } else {
            return show!
        }
    }
    
    // MARK: group sharing infos
    open static func setAccessToken(token: String) {
        let groupDefaults = UserDefaults(suiteName: AppInfo.groupID)
        groupDefaults!.set(token, forKey: KEY_ACCESS_TOKEN)
    }
    
    open static func getAccessToken() -> String {
        let groupDefaults = UserDefaults(suiteName: AppInfo.groupID)
        let token = groupDefaults!.object(forKey: KEY_ACCESS_TOKEN) as? String
        if token == nil {
            return ""
        } else {
            return token!
        }
    }
    
    open static func setTouristId(tourist: String) {
        let groupDefaults = UserDefaults(suiteName: AppInfo.groupID)
        groupDefaults!.set(tourist, forKey: KEY_TOURIST_ID)
    }
    
    open static func getTouristId() -> String {
        let groupDefaults = UserDefaults(suiteName: AppInfo.groupID)
        let tourist = groupDefaults!.object(forKey: KEY_TOURIST_ID) as? String
        if tourist == nil {
            return ""
        } else {
            return tourist!
        }
    }
    
    open static func setCurrentService(service: MService?) {
        let groupDefaults = UserDefaults(suiteName: AppInfo.groupID)
        if isLogined() {
            if service != nil {
                let data: [String: Any] = service!.toDictionary()
                groupDefaults!.set(data, forKey: KEY_LAST_USER_SERVICE)
            } else {
                groupDefaults!.set(nil, forKey: KEY_LAST_USER_SERVICE)
            }
        } else {
            if service != nil {
                let data: [String: Any] = service!.toDictionary()
                groupDefaults!.set(data, forKey: KEY_LAST_TOURIST_SERVICE)
            } else {
                groupDefaults!.set(nil, forKey: KEY_LAST_TOURIST_SERVICE)
            }
        }
        
    }
    
    open static func getCurrentService() -> MService? {
        let groupDefaults = UserDefaults(suiteName: AppInfo.groupID)
        var data: [String: Any]?
        if isLogined() {
            data = groupDefaults!.object(forKey: KEY_LAST_USER_SERVICE) as? [String: Any]
        } else {
            data = groupDefaults!.object(forKey: KEY_LAST_TOURIST_SERVICE) as? [String: Any]
        }
        if data != nil && data!.count > 0 {
            let service: MService = MService(dictionary: data!)
            return service
        } else {
            return nil
        }
    }
    
    open static func setAvailableServices(services: [MService]) {
        let groupDefaults = UserDefaults(suiteName: AppInfo.groupID)
        var data: [[String: Any]] = []
        for item in services {
            data.append(item.toDictionary())
        }
        if isLogined() {
            groupDefaults!.set(data, forKey: KEY_USER_SERVICES)
        } else {
            groupDefaults!.set(data, forKey: KEY_TOURIST_SERVICES)
        }
    }
    
    open static func getAvailableServices() -> [MService] {
        let groupDefaults = UserDefaults(suiteName: AppInfo.groupID)
        var data: [[String: Any]]?
        if isLogined() {
            data = groupDefaults!.object(forKey: KEY_USER_SERVICES) as? [[String: Any]]
        } else {
            data = groupDefaults!.object(forKey: KEY_TOURIST_SERVICES) as? [[String: Any]]
        }
        var services: [MService] = Array()
        if data != nil && data!.count > 0 {
            for item in data! {
                services.append(MService(dictionary: item))
            }
        }
        return services
    }
    
    open static func setVpnStatus(status: Int) {
        let groupDefaults = UserDefaults(suiteName: AppInfo.groupID)
        groupDefaults!.set(status, forKey: KEY_VPN_STATUS)
    }
    
    open static func getVpnStatus() -> Int {
        let groupDefaults = UserDefaults(suiteName: AppInfo.groupID)
        let status = groupDefaults!.object(forKey: KEY_VPN_STATUS) as? Int
        if status == nil {
            return NEVPNStatus.disconnected.rawValue
        } else {
            return status!
        }
    }
    
    open static func setServiceUrl(url: String) {
        let groupDefaults = UserDefaults(suiteName: AppInfo.groupID)
        groupDefaults!.set(url, forKey: KEY_SERVICE_URL)
    }
    
    open static func getServiceUrl() -> String {
        let groupDefaults = UserDefaults(suiteName: AppInfo.groupID)
        let url = groupDefaults!.object(forKey: KEY_SERVICE_URL) as? String
        if url == nil {
            return ""
        } else {
            return url!
        }
    }
    
    open static func setCurLanguageCode(langID: String) {
        let groupDefaults = UserDefaults(suiteName: AppInfo.groupID)
        groupDefaults!.set(langID, forKey: KEY_LANGUAGE_CODE)
    }
    
    open static func getCurLanguageCode() -> String {
        let groupDefaults = UserDefaults(suiteName: AppInfo.groupID)
        let langCode = groupDefaults!.object(forKey: KEY_LANGUAGE_CODE) as? String
        if langCode == nil {
            return ""
        } else {
            return langCode!
        }
    }
    
    open static func convertServiceLanguageCode() -> String {
        let lang = getCurLanguageCode()
        if (lang.uppercased() == "CN" || lang.uppercased() == "ZH-HANS") {
            return "CN"
        } else {
            return "US"
        }
    }
    
    open static func setConnectedStartTime(time: Date?) {
        let groupDefaults = UserDefaults(suiteName: AppInfo.groupID)
        groupDefaults!.set(time, forKey: KEY_CONNECTED_TIME)
    }
    
    open static func getLastConnectedStartTime() -> Date? {
        let groupDefaults = UserDefaults(suiteName: AppInfo.groupID)
        return groupDefaults!.object(forKey: KEY_CONNECTED_TIME) as? Date
    }
    
    open static func setRuleMode(mode: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(mode, forKey: KEY_RULE_MODE)
    }
    
    open static func getLastRuleMode() -> String {
        let userDefaults = UserDefaults.standard
        let ruleMode = userDefaults.object(forKey: KEY_RULE_MODE) as? String
        if ruleMode == nil {
            return "global"
        } else {
            return ruleMode!
        }
    }
    
    open static func setTodayLaunch(state: Bool?) {
        let groupDefaults = UserDefaults(suiteName: AppInfo.groupID)
        groupDefaults!.set(state, forKey: KEY_TODAYLAUNCH_STATE)
    }
    
    open static func getTodayLaunch() -> Bool {
        let groupDefaults = UserDefaults(suiteName: AppInfo.groupID)
        let launch = groupDefaults!.object(forKey: KEY_TODAYLAUNCH_STATE) as? Bool
        if launch == nil {
            return false
        } else {
            return launch!
        }
    }
    
    open static func setAdsState(state: Bool?) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(state, forKey: KEY_ADS_STATE)
    }
    
    open static func getLastAdsState() -> Bool? {
        return true
        let userDefaults = UserDefaults.standard
        return userDefaults.object(forKey: KEY_ADS_STATE) as? Bool
    }
    
    open static func setSmsCount(sms: MSms) {
        let userDefaults = UserDefaults.standard
        let data : Data = NSKeyedArchiver.archivedData(withRootObject: sms)
        userDefaults.set(data, forKey: KEY_SMS_COUNT)
    }
    
    open static func getLastSmsCount() -> MSms? {
        let userDefaults = UserDefaults.standard
        let data = userDefaults.object(forKey: KEY_SMS_COUNT) as! Data?
        if data != nil {
            let sms : MSms = NSKeyedUnarchiver.unarchiveObject(with: data!) as! MSms
            return sms
        } else {
            return nil
        }
    }    
    
    open static func isLastLogin() -> Bool {
        let userDefaults = UserDefaults.standard
        let phonenum = userDefaults.object(forKey: KEY_LOGIN_PHONENUM) as? String
        let lastLoginDate = userDefaults.object(forKey: KEY_LOGIN_DATE) as? Date
        let expires_in = userDefaults.object(forKey: KEY_EXPIRES_IN) as? Int
        
        if phonenum == nil || lastLoginDate == nil || expires_in == nil {
            return false
        }
        
        let elapsed = Int(Date().timeIntervalSince((lastLoginDate as Date?)!))
        if elapsed >= expires_in {
            return false
        }
        
        return true
    }
    
    open static func isValidSms() -> Bool {
        var sms = AppPref.getLastSmsCount()
        if sms == nil {
            let data = NSMutableDictionary()
            data["count"] = 1
            data["createdat"] = Date()
            sms = MSms(data: data)
            
            setSmsCount(sms: sms!)
            return true

        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date1String = dateFormatter.string(from: Date())
            let date2String = dateFormatter.string(from: sms!.createdat! as Date)
            if date1String == date2String {
                sms?.count += 1
            } else {
                sms?.count = 1
                sms?.createdat = Date()
            }

            if sms?.count > 10 {
                return false
            } else {
                setSmsCount(sms: sms!)
                return true
            }
        }
    }
    
    open static func setDeviceUUID(deviceUUID: String) {
        let keychainItemWrapper = KeychainItemWrapper(identifier: AppInfo.appID, accessGroup: AppInfo.groupID)
        keychainItemWrapper["superSecretKey"] = deviceUUID as AnyObject?
    }
    
    open static func getDeviceUUID() -> String {
        let keychainItemWrapper = KeychainItemWrapper(identifier: AppInfo.appID, accessGroup: AppInfo.groupID)
        let deviceUUID = keychainItemWrapper["superSecretKey"] as? String
        
        if deviceUUID == nil {
            return ""
        } else {
            return deviceUUID!
        }
    }
    
    open static func setVersionCode(version: Int) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(version, forKey: KEY_VERSION_CODE)
    }
    
    open static func getVersionCode() -> Int {
        let userDefaults = UserDefaults.standard
        let ret = userDefaults.object(forKey: KEY_VERSION_CODE) as? Int
        if ret == nil {
            return 0
        } else {
            return ret!
        }
    }
    
    open static func setNotificationTime(date: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(date, forKey: KEY_NOTIFICATION_TIME)
    }
    
    open static func getNotificationTime() -> String {
        let userDefaults = UserDefaults.standard
        let ret = userDefaults.object(forKey: KEY_NOTIFICATION_TIME) as? String
        if ret == nil {
            return ""
        } else {
            return ret!
        }
    }
    
    open static func setBadgeVisible(visible: Bool) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(visible, forKey: KEY_BADGE_VISIBLE)
    }
    
    open static func getBadgeVisible() -> Bool {
        let userDefaults = UserDefaults.standard
        let ret = userDefaults.object(forKey: KEY_BADGE_VISIBLE) as? Bool
        if ret == nil {
            return false
        } else {
            return ret!
        }
    }
    
    open static func removeOldData() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        
        UserDefaults(suiteName: AppInfo.groupID)?.removeObject(forKey: KEY_LOGIN_PHONENUM)
        UserDefaults(suiteName: AppInfo.groupID)?.removeObject(forKey: KEY_LOGIN_PASSWORD)
        UserDefaults(suiteName: AppInfo.groupID)?.removeObject(forKey: KEY_ACCESS_TOKEN)
        UserDefaults(suiteName: AppInfo.groupID)?.removeObject(forKey: KEY_EXPIRES_IN)
        UserDefaults(suiteName: AppInfo.groupID)?.removeObject(forKey: KEY_REFRESH_TOKEN)
        UserDefaults(suiteName: AppInfo.groupID)?.removeObject(forKey: KEY_TOKEN_TYPE)
        UserDefaults(suiteName: AppInfo.groupID)?.removeObject(forKey: KEY_LOGIN_DATE)
        UserDefaults(suiteName: AppInfo.groupID)?.removeObject(forKey: KEY_LOGIN_PHONENUM)
        UserDefaults(suiteName: AppInfo.groupID)?.removeObject(forKey: KEY_USER_SERVICES)
        UserDefaults(suiteName: AppInfo.groupID)?.removeObject(forKey: KEY_TOURIST_SERVICES)
        UserDefaults(suiteName: AppInfo.groupID)?.removeObject(forKey: KEY_LAST_USER_SERVICE)
        UserDefaults(suiteName: AppInfo.groupID)?.removeObject(forKey: KEY_LAST_TOURIST_SERVICE)
        UserDefaults(suiteName: AppInfo.groupID)?.removeObject(forKey: KEY_TOURIST_ID)
        UserDefaults(suiteName: AppInfo.groupID)?.removeObject(forKey: KEY_TODAYLAUNCH_STATE)
        UserDefaults(suiteName: AppInfo.groupID)?.removeObject(forKey: KEY_CONNECTED_TIME)
        
        UserDefaults(suiteName: AppInfo.groupID)!.synchronize()
    }
}	

open class AppInfo: NSObject {
    open static let appID = "1316309399"
    open static let itunesUrl = "https://itunes.apple.com/us/app/id\(appID)"
    open static let reviewUrl = "itms-apps://itunes.apple.com/app/viewContentsUserReviews?id=\(appID)"
    
    open static let jgAppKey = "c7fb4bd891952f3081bdf1d4"

    
    open static var deviceToken = ""
    open static var deviceUUID = ""
    
    open static var merchantID = "merchant.com.appgo.appgoios"
    open static var groupID = "group.com.appgo.appgoios"
    
    open static var emailAccount = "appgohk@gmail.com"
    open static var twitterUrl = "https://twitter.com/appgohk"
    open static var telegramUrl = "https://t.me/appgo"
    open static var websiteUrl = "https://app135.com"
    
    open static let VersionCode = 32
    open static let Version = 2.2
}
