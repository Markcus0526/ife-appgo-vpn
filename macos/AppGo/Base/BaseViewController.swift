//
//  BaseViewController.swift
//  ImmediateLanguageSwitchSwift
//
//  Created by Manuel Meyer on 07.08.15.
//
//

import Cocoa

class BaseViewController: NSViewController, NSGestureRecognizerDelegate, AGNavigationControllerCompatible {
    
    var navigationController: AGNavigationController?
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.onLanguageChangeNotification(notification:)), name: .LANGUAGE_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.onLoginChangeNotification(notification:)), name: .LOGIN_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.onPurchaseChangeNotification(notification:)), name: .PURCHASE_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.onPayChangeNotification(notification:)), name: .PAY_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.onServerChangeNotification(notification:)), name: .SERVER_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.onRuleModeChangeNotification(notification:)), name: .RULEMODE_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.onServerListChangeNotification(notification:)), name: .SERVER_LIST_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.onVpnStatusChangeNotification(notification:)), name: .VPN_STATUS_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.onLaunchAtloginChangeNotification(notification:)), name: .LAUNCH_ATLOGIN_CHANGE, object: nil)
        
        NotificationCenter.default.post(name: .LANGUAGE_CHANGE, object: nil)
    }
    
    func onLanguageChangeNotification(notification: Notification) {
    }
    
    func onVpnStatusChangeNotification(notification:Notification) {
    }
    
    func onServerChangeNotification(notification:Notification) {
    }
    
    func onRuleModeChangeNotification(notification:Notification) {
    }
    
    func onLoginChangeNotification(notification:Notification) {
    }
    
    func onPurchaseChangeNotification(notification:Notification) {
    }
    
    func onServerListChangeNotification(notification:Notification) {
    }
    
    func onPayChangeNotification(notification:Notification) {
    }
    
    func onLaunchAtloginChangeNotification(notification:Notification) {
    }
    
    func pop() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func dismiss() {
        navigationController?.dismissViewController(self)
    }
    
    func close() {
        if let navVC = self.navigationController, navVC.viewControllers.count > 1 {
            pop()
        }else {
            dismiss()
        }
    }
}
