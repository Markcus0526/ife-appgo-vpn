//
//  Notifications.swift
//  AppGoX
//
//  Created by 邱宇舟 on 16/6/7.
//  Copyright © 2016年 appgo. All rights reserved.
//

import Foundation

// Definition:
extension Notification.Name {
    static let LANGUAGE_CHANGE = Notification.Name("LANGUAGE_CHANGE")
    static let LOGIN_CHANGE = Notification.Name("LOGIN_CHANGE")
    static let PURCHASE_CHANGE = Notification.Name("PURCHASE_CHANGE")
    static let VPN_STATUS_CHANGE = Notification.Name("VPN_STATUS_CHANGE")
    static let APP_QUIT = Notification.Name("APP_QUIT")
    static let SERVER_CHANGE = Notification.Name("SERVER_CHANGE")
    static let SERVER_LIST_CHANGE = Notification.Name("SERVER_LIST_CHANGE")
    static let RULEMODE_CHANGE = Notification.Name("RULEMODE_CHANGE")
    static let PAY_CHANGE = Notification.Name("PAY_CHANGE")
    static let LAUNCH_ATLOGIN_CHANGE = Notification.Name("LAUNCH_ATLOGIN_CHANGE")
    
    static let LAUNCH_KILL_ME = Notification.Name("LAUNCH_KILL_ME")
}
