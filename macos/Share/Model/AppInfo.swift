//
//  AppInfo.swift
//  AppGo
//
//  Created by administrator on 1/12/2018.
//  Copyright © 2018 AppGo. All rights reserved.
//

import Foundation

public class AppInfo: NSObject {
    public static let appID = "1309550203"
    public static let itunesUrl = "https://itunes.apple.com/us/app/id\(appID)"
    public static let reviewUrl = "itms-apps://itunes.apple.com/app/viewContentsUserReviews?id=\(appID)"
    
    public static let jgAppKey = "c7fb4bd891952f3081bdf1d4"
    
    public static var deviceToken = ""
    public static var deviceUUID = ""
    
    public static let bundleID = "com.appgo.macos"
    public static let launcherID = "com.appgo.macos.AppGoLauncher"
    
    public static var emailAccount = "appgohk@gmail.com"
    public static var twitterUrl = "https://twitter.com/appgohk"
    public static var telegramUrl = "https://t.me/appgo"
    public static var alipayUrl = "http://mediabiu.com/"
    public static var websiteUrl = "https://app135.com"
    
    public static let VersionCode = 12
    public static let Version:Float = 2.5
    
    public static let AES_KEY = "appgomac20180910" // 16 chars
    public static let AES_IV = "appgoaes20180910" // 16 chars
}
