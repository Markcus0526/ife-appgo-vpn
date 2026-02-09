//
//  BaseViewController.swift
//  ImmediateLanguageSwitchSwift
//
//  Created by Manuel Meyer on 07.08.15.
//
//

import UIKit

public extension String {
    
    public var image: UIImage? {
        return UIImage(named: self)
    }
    
    public var templateImage: UIImage? {
        return UIImage(named: self)?.withRenderingMode(.alwaysTemplate)
    }
    
    public var originalImage: UIImage? {
        return UIImage(named: self)?.withRenderingMode(.alwaysOriginal)
    }
    
}

class BaseViewController: UIViewController, UIGestureRecognizerDelegate {
    deinit{
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.onLanguageChangeNotification(notification:)), name: .LANGUAGE_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.onLoginChangeNotification(notification:)), name: .LOGIN_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.onPurchaseChangeNotification(notification:)), name: .PURCHASE_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.onPaymentResultNotification(notification:)), name: .PAYMENT_RESULT, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.onServerChangeNotification(notification:)), name: .SERVER_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.onMainTabChangeNotification(notification:)), name: .MAINTAB_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.onAPNSReceiveNotification(notification:)), name: .APNS_RECEIVE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.onServerListChangeNotification(notification:)), name: .SERVER_LIST_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.onVpnStatusChangeNotification(notification:)), name: .VPN_STATUS_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.onTodayConnectChangeNotification(notification:)), name: .TODAY_CONNECT_CHANGE, object: nil)
        
        NotificationCenter.default.post(name: .LANGUAGE_CHANGE, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let navVC = self.navigationController {            
            print(self.isKind(of: MainTabViewController.self))
            enableSwipeGesture(navVC.viewControllers.count > 1 && !self.isKind(of: MainTabViewController.self))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navVC = self.navigationController {
            showLeftBackButton(navVC.viewControllers.count > 1)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*@IBAction func switchLanguage(sender: UIButton) {
        
        var localeString:String?
        switch sender {
        default: localeString = nil
        }
        
        
        if localeString != nil {
            NSNotificationCenter.defaultCenter().postNotificationName("LANGUAGE_WILL_CHANGE", object: localeString)
        }
    }*/

    func onLanguageChangeNotification(notification: Notification) {
    }
    
    func onVpnStatusChangeNotification(notification:Notification) {
    }
    
    func onServerChangeNotification(notification:Notification) {
    }

    func onLoginChangeNotification(notification:Notification) {
    }
    
    func onPurchaseChangeNotification(notification:Notification) {
    }
    
    func onPaymentResultNotification(notification:Notification) {
    }    
    
    func onServerListChangeNotification(notification:Notification) {
    }
    
    func onMainTabChangeNotification(notification:Notification) {
    }
    
    func onAPNSReceiveNotification(notification:Notification) {
    }
    
    func onTodayConnectChangeNotification(notification:Notification) {
    }

    func showLeftBackButton(_ shouldShow: Bool) {
        if shouldShow {
            let backItem = UIBarButtonItem(image: "Back".templateImage, style: UIBarButtonItemStyle.plain, target: self, action: #selector(pop))
            navigationItem.leftBarButtonItem = backItem
        }else{
            navigationItem.leftBarButtonItem = nil
        }
    }
    
    func enableSwipeGesture(_ shouldShow: Bool) {
        if shouldShow {
            navigationController?.interactivePopGestureRecognizer?.delegate = self
            navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        } else {
            navigationController?.interactivePopGestureRecognizer?.delegate = nil
            navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }
    }

    func addChildVC(_ child: UIViewController) {
        view.addSubview(child.view)
        addChildViewController(child)
        child.didMove(toParentViewController: self)
    }
    
    func removeChildVC(_ child: UIViewController) {
        child.willMove(toParentViewController: nil)
        child.view.removeFromSuperview()
        child.removeFromParentViewController()
    }
    
    func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func close() {
        if let navVC = self.navigationController, navVC.viewControllers.count > 1 {
            pop()
        }else {
            dismiss()
        }
    }   

}
