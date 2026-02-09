//
//  AlertUtils.swift
//  AppGoPro
//
//  Created by LEI on 4/10/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

import AppKit

struct Alert {
    
    static func show(title: String? = nil, message: String? = nil, confirmCallback: (() -> Void)?, cancelCallback: (() -> Void)?) {
        let alert = NSAlert()
        if title == nil {
            alert.messageText = ""
        } else {
            alert.messageText = title!
        }
        alert.informativeText = message!
        alert.alertStyle = NSAlertStyle.warning
        alert.addButton(withTitle: "ok".localizedString())
        alert.addButton(withTitle: "cancel".localizedString())
        let res = alert.runModal()
        if res == NSAlertFirstButtonReturn {
            confirmCallback?()
        }
    }
    
    static func show(title: String? = nil, message: String? = nil, confirmCallback: (() -> Void)? = nil) {
        let alert = NSAlert()
        if title == nil {
            alert.messageText = ""
        } else {
            alert.messageText = title!
        }
        alert.informativeText = message!
        alert.alertStyle = NSAlertStyle.informational
        alert.addButton(withTitle: "ok".localizedString())
        //alert.addButton(withTitle: "cancel".localizedString())
        let res = alert.runModal()
        if res == NSAlertFirstButtonReturn {
            confirmCallback?()
        }
    }
    
    static func show(title: String? = nil, data: Data? = nil, confirmCallback: (() -> Void)? = nil) {
        var message = "can't connect to server.".localizedString()
        
        if let data = data {
            if let json = NSDataUtils.nsdataToJSON(data: data) {
                let result = json["message"] as? String
                if result != nil {
                    message = result!
                }
            }
        }
        
        let alert = NSAlert()
        if title == nil {
            alert.messageText = ""
        } else {
            alert.messageText = title!
        }
        alert.informativeText = message
        alert.alertStyle = NSAlertStyle.informational
        alert.addButton(withTitle: "ok".localizedString())
        //alert.addButton(withTitle: "cancel".localizedString())
        let res = alert.runModal()
        if res == NSAlertFirstButtonReturn {
            confirmCallback?()
        }
    }
    
    static func toast(message: String) {
        var toastWindowCtrl: ToastWindowController!
        
        toastWindowCtrl = ToastWindowController(windowNibName: "ToastWindowController")
        toastWindowCtrl.message = message
        toastWindowCtrl.showWindow(self)
        //NSApp.activate(ignoringOtherApps: true)
        //toastWindowCtrl.window?.makeKeyAndOrderFront(self)
        toastWindowCtrl.fadeInHud()
    }
    
    static func toast(data: Data? = nil) {
        var message = "can't connect to server.".localizedString()
        
        if let data = data {
            if let json = NSDataUtils.nsdataToJSON(data: data) {
                let result = json["message"] as? String
                if result != nil {
                    message = result!
                }
            }
        }
        
        var toastWindowCtrl: ToastWindowController!
        
        toastWindowCtrl = ToastWindowController(windowNibName: "ToastWindowController")
        toastWindowCtrl.message = message
        toastWindowCtrl.showWindow(self)
        //NSApp.activate(ignoringOtherApps: true)
        //toastWindowCtrl.window?.makeKeyAndOrderFront(self)
        toastWindowCtrl.fadeInHud()
    }
}
