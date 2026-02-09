//
//  AGMainWindowController.swift
//  AppGoX
//
//  Created by user on 17.10.24.
//  Copyright © 2017 appgo. All rights reserved.
//

import Cocoa
import Alamofire

class AGMainWindowController: NSWindowController {
    
    override func windowDidLoad() {
        super.windowDidLoad()

        self.window?.isMovable = true
        self.window?.isMovableByWindowBackground = true
        
        if (!(self.window?.isKeyWindow)!) {
            self.window?.becomeKey()
        }
        
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateController(withIdentifier: "AGSplashViewController") as! AGSplashViewController
        
        let navigationController = AGNavigationController(rootViewController: vc, window: self.window!)
        navigationController?.view.frame = NSMakeRect(0.0, 0.0, 380.0, 570.0)
        self.contentViewController = navigationController
        
        /*if AppPref.isLogined() {
            let mainViewController = storyboard.instantiateController(withIdentifier: "AGMainViewController") as! AGMainViewController
            
            let navigationController = AGNavigationController(rootViewController: mainViewController, window: self.window!)
            navigationController?.view.frame = NSMakeRect(0.0, 0.0, 380.0, 570.0)
            self.contentViewController = navigationController
        } else {
            let loginViewController = storyboard.instantiateController(withIdentifier: "AGLoginViewController") as! AGLoginViewController
            
            let navigationController = AGNavigationController(rootViewController: loginViewController, window: self.window!)
            navigationController?.view.frame = NSMakeRect(0.0, 0.0, 380.0, 570.0)
            self.contentViewController = navigationController
        }*/
    }
    
}
