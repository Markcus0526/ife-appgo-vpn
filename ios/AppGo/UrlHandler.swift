//
//  UrlHandler.swift
//  AppGoPro
//
//  Created by LEI on 4/13/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

import Foundation
import ICSMainFramework
import Async
import CallbackURLKit

class UrlHandler: NSObject, AppLifeCycleProtocol {
    
    private func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable: Any]?) -> Bool {
        let manager = Manager.shared
        manager.callbackURLScheme = Manager.urlSchemes?.first
        for action in [URLAction.ON, URLAction.OFF, URLAction.SWITCH] {
            manager[action.rawValue] = { parameters, success, failure, cancel in
                action.perform(nil, parameters: parameters) { error in
                    Async.main(after: 1, {
                        if let error = error {
                            failure(error as NSError)
                        }else {
                            success(nil)
                        }
                    })
                    return
                }
            }
        }
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let host = url.host! as String
        
        if host == "safepay" { // from Alipay
            AlipaySDK.defaultService().processOrder(withPaymentResult: url, standbyCallback: {
                result in
                self.dispatchAlipayWithResult(result! as NSDictionary)
            })
            
            return true
        
        } else if host == "platformapi" { // from Alipay
            AlipaySDK.defaultService().processAuthResult(url, standbyCallback: {
                result in
                self.dispatchAlipayWithResult(result! as NSDictionary)
            })
            
            return true
            
        } else { // from Today widget
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            var parameters: Parameters = [:]
            components?.queryItems?.forEach {
                guard let _ = $0.value else {
                    return
                }
                parameters[$0.name] = $0.value
            }
            
            return dispatchAction(url, actionString: host, parameters: parameters)
        }
    }
    
    private func application(_ application: UIApplication, openURL url: URL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        let host = url.host
        
        if host == "safepay" { // from Alipay
            AlipaySDK.defaultService().processAuthResult(url, standbyCallback: {
                result in
                self.dispatchAlipayWithResult(result! as NSDictionary)
            })
            
            AlipaySDK.defaultService().processOrder(withPaymentResult: url, standbyCallback: {
                result in
                self.dispatchAlipayWithResult(result! as NSDictionary)
            })
           
        } else if host == "platformapi" { // from Alipay
            AlipaySDK.defaultService().processAuthResult(url, standbyCallback: {
                result in
                self.dispatchAlipayWithResult(result! as NSDictionary)
            })
        }
        
        return true
    }
    
    func dispatchAction(_ url: URL?, actionString: String, parameters: Parameters) -> Bool {
        guard let action = URLAction(rawValue: actionString) else {
            return false
        }
        return action.perform(url, parameters: parameters)
    }

    func dispatchAlipayWithResult(_ result: NSDictionary) {
        let status = result.object(forKey: "resultStatus") as! String
        if Int(status) == 9000 {
            NotificationCenter.default.post(name: .PAYMENT_RESULT, object: nil, userInfo: ["status": true])
        } else {
            NotificationCenter.default.post(name: .PAYMENT_RESULT, object: nil, userInfo: ["status": false])
        }    
    }
}

enum URLAction: String {

    case ON = "on"
    case OFF = "off"
    case SWITCH = "switch"
    case XCALLBACK = "x-callback-url"

    func perform(_ url: URL?, parameters: Parameters, completion: ((Error?) -> Void)? = nil) -> Bool {
        switch self {
        case .ON:
            AppPref.setTodayLaunch(state: false)
            NotificationCenter.default.post(name: .TODAY_CONNECT_CHANGE, object: nil)
        case .OFF:
            AppPref.setTodayLaunch(state: false)
            NotificationCenter.default.post(name: .TODAY_CONNECT_CHANGE, object: nil)
        case .XCALLBACK:
            if let url = url {
                return Manager.shared.handleOpen(url: url)
            }
        default:
            break
        }
        return true
    }

    func autoClose(_ parameters: Parameters) {
        var autoclose = false
        if let value = parameters["autoclose"], value.lowercased() == "true" || value.lowercased() == "1" {
            autoclose = true
        }
        if autoclose {
            Async.main(after: 1, {
                UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
            })
        }
    }
}
