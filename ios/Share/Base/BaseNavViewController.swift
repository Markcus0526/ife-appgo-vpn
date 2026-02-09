//
//  MainNavViewController.swift
//  AppGoPro
//
//  Created by rbvirakf on 11/23/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

import UIKit

class BaseNavViewController: UINavigationController {
    
//    override func awakeFromNib() {        
//        let phonenum = AppPref.getLastLoginPhoneNumber()
//        let password = AppPref.getLastLoginPassword()
//        let lastLoginDate = AppPref.getLastLoginDate()
//        let expires_in = AppPref.getExpireIn()
//        
//        if phonenum == nil || password == nil || lastLoginDate == nil || expires_in == nil {
//            return // login
//        }
//        
//        let elapsed = Int(NSDate().timeIntervalSinceDate(lastLoginDate as NSDate!))
//        if elapsed >= expires_in {
//            return // login
//        }
//        
//        let mainVC = self.storyboard?.instantiateViewControllerWithIdentifier("MainTabViewController")
//        (mainVC! as! MainTabViewController).autoLogin = true
//        
//        self.viewControllers = [mainVC!]
//    }
}
