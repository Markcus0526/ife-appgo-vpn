//
//  AlertUtils.swift
//  AppGoPro
//
//  Created by LEI on 4/10/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

import UIKit

struct Alert {
    
    static func show(_ vc: UIViewController, title: String? = nil, message: String? = nil, confirmCallback: (() -> Void)?, cancelCallback: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok".localizedString(), style: .default, handler: { (action) in
            confirmCallback?()
        }))
        alert.addAction(UIAlertAction(title: "cancel".localizedString(), style: .cancel, handler: { (action) in
            cancelCallback?()
        }))
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func show(_ vc: UIViewController, title: String? = nil, message: String? = nil, confirmCallback: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "close".localizedString(), style: .default, handler: { (action) in
            confirmCallback?()
        }))
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func show(_ vc: UIViewController, title: String? = nil, data: Data? = nil, confirmCallback: (() -> Void)? = nil) {
        if let data = data {
            
            if let json = NSDataUtils.nsdataToJSON(data) {
                let message = json["message"] as? String
                if message != nil {
                    Alert.show(vc, message: message, confirmCallback: confirmCallback)
                } else {
                    Alert.show(vc, message: "\("can't connect to server.".localizedString())", confirmCallback: confirmCallback)
                }
            } else {
                Alert.show(vc, message: "\("can't connect to server.".localizedString())", confirmCallback: confirmCallback)
            }
        } else {
            Alert.show(vc, message: "\("can't connect to server.".localizedString())", confirmCallback: confirmCallback)
        }
    }
}
