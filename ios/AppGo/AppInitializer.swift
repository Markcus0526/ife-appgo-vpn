//
//  AppInitilizer.swift
//  AppGoPro
//
//  Created by LEI on 12/27/15.
//  Copyright © 2015 TouchingApp. All rights reserved.
//

import Foundation
import ICSMainFramework
import Fabric
import Crashlytics
import Alamofire

class AppInitializer: NSObject, AppLifeCycleProtocol {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Crashlytics.self])
        LoggingLevel.currentLoggingLevel = .off
        
        if AppPref.getVersionCode() != AppInfo.VersionCode {
            AppPref.removeOldData()
        }
        AppPref.setVersionCode(version: AppInfo.VersionCode)
        
        let langCode = AppPref.getCurLanguageCode()
        if langCode == "" {
            AppPref.setCurLanguageCode(langID: Localize.currentLanguage())
        }
        
        AppInfo.deviceUUID = AppPref.getDeviceUUID()
        if AppInfo.deviceUUID == "" {
            AppInfo.deviceUUID = (UIDevice.current.identifierForVendor?.uuidString.replacingOccurrences(of: "-", with: ""))!
            
            AppPref.setDeviceUUID(deviceUUID: AppInfo.deviceUUID)
        }
        
        JPUSHService.register(forRemoteNotificationTypes: (UIUserNotificationType.badge.union(UIUserNotificationType.sound).union(UIUserNotificationType.alert)).rawValue, categories:nil)
        JPUSHService.setup(withOption: launchOptions, appKey:AppInfo.jgAppKey, channel:"App Store", apsForProduction:true)
        
        AppPref.setServiceUrl(url: "")
        let request = WSAPI.getAlamofireManager().request(WSAPI.BASE_URL,
                                                          method: .get,
                                                          parameters: nil,
                                                          encoding: URLEncoding.default,
                                                          headers: ["Accept": WSAPI.HEADER_ACCEPT, "Content-Language": AppPref.convertServiceLanguageCode()])
        request.responseData(completionHandler: { response in
            AppPref.setServiceUrl(url: (String(data: response.data!, encoding: String.Encoding.utf8) as String?)!.replacingOccurrences(of: "\n", with: ""))
        })
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken)
        
        let tokenChars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
        var tokenString = ""
        
        for i in 0..<deviceToken.count {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        AppInfo.deviceToken = tokenString
    }
    
    func application(_ application:UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        JPUSHService.handleRemoteNotification(userInfo)
        
        if(application.applicationState == .active) {
            NotificationCenter.default.post(name: .APNS_RECEIVE, object: nil)
        } else {
            //后台或者没有活动
        }
        
        JPUSHService.resetBadge()    
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        //KFChatManager.sharedChatManager().setUserOffline()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
    }

    func configLogging() {
        //RCJ
//        DDLog.addLogger(DDTTYLogger.sharedInstance()) // TTY = Xcode console
//        DDLog.addLogger(DDASLLogger.sharedInstance()) // ASL = Apple System Logs
//
//        let fileLogger: DDFileLogger = DDFileLogger() // File Logger
//        fileLogger.rollingFrequency = 60*60*24*3  // 24 hours
//        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
//        DDLog.addLogger(fileLogger)
//        #if DEBUG
//            DDLog.setLevel(DDLogLevel.All, forClass: DDTTYLogger.self)
//            DDLog.setLevel(DDLogLevel.All, forClass: DDASLLogger.self)
//        #else
//
//        #endif
    }
    
}

extension AppDelegate : JPUSHRegisterDelegate {
    @available(iOS 10.0, *)
    public func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        print(">JPUSHRegisterDelegate jpushNotificationCenter willPresent");
        let userInfo = notification.request.content.userInfo
        if (notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))!{
            JPUSHService.handleRemoteNotification(userInfo)
        }
        completionHandler(Int(UNAuthorizationOptions.alert.rawValue))// 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    }
    
    @available(iOS 10.0, *)
    public func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        print(">JPUSHRegisterDelegate jpushNotificationCenter didReceive");
        let userInfo = response.notification.request.content.userInfo
        if (response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))!{
            JPUSHService.handleRemoteNotification(userInfo)
        }
        completionHandler()
    }
    
}
