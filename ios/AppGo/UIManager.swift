//
//  UIManager.swift
//  AppGoPro
//
//  Created by LEI on 12/27/15.
//  Copyright © 2015 TouchingApp. All rights reserved.
//

import Foundation
import ICSMainFramework


class UIManager: NSObject, AppLifeCycleProtocol {
    
    var keyWindow: UIWindow? {
        return UIApplication.shared.keyWindow
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable: Any]?) -> Bool {
        UIView.appearance().tintColor = Color.Brand
        
        UITableView.appearance().backgroundColor = Color.Background
        UITableView.appearance().separatorColor = Color.Separator
        
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = Color.NavigationBackground
        
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().backgroundColor = Color.TabBackground
        UITabBar.appearance().tintColor = Color.TabItemSelected
        
        keyWindow?.rootViewController = makeRootViewController()
        
        return true
    }
    
//    func makeRootViewController() -> UITabBarController {
//        let tabBarVC = UITabBarController()
//        tabBarVC.viewControllers = makeChildViewControllers()
//        tabBarVC.selectedIndex = 0
//        return tabBarVC
//    }
    func makeRootViewController() -> UIViewController {
        let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        
        let noSplash = AppPref.getSplashHidden()
        if noSplash {
            let rootNavi = mainStoryboard.instantiateViewController(withIdentifier: "MainTabViewController")
            return rootNavi
        } else {            
            let rootNavi = mainStoryboard.instantiateViewController(withIdentifier: "SplashViewController")
            return rootNavi
        }
        
        // Get the model name based in the extension.
        let modelName = UIDevice.current.modelName
        
        // If the modelName variable contains the string "iPhone 6" inside.
        if modelName.range(of: "iPad") != nil {
            let mainStoryboard = UIStoryboard.init(name: "Main_iPad", bundle: nil)
            let rootNavi = mainStoryboard.instantiateViewController(withIdentifier: "MainTabViewController")
            return rootNavi
        } else { //if (modelName.rangeOfString("iPhone") != nil)
            let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
            let rootNavi = mainStoryboard.instantiateViewController(withIdentifier: "MainTabViewController")
            return rootNavi
        }
    }
}

extension UITabBar {
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 44
        return sizeThatFits
    }
}

/*extension UIButton {
    @IBInspectable var borderUIColor: UIColor? {
        get {
            return UIColor(CGColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.CGColor
        }
    }
}*/
