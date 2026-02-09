//
//  API.swift
//  AppGoPro
//
//  Created by LEI on 6/4/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

import Foundation
import Alamofire


public struct WSAPI {

    public static let BASE_URL = "http://39.108.212.90:99"
    public static let CLIENT_ID = "q32LOhbxR4p8TVKTbLCiHKO4FbZUTQ5m3wI1YtCc"
    public static let CLIENT_SECRET = "qQB4T6wuMpEqMx8JiJIqrNynQTSrEnsRaJxo71C4"

    public static let IGNORE_ITUNES = false
    public static let IS_PRODUCT = true
    
    public static let HEADER_ACCEPT = "application/vnd.appgogo.v1+json"    
    
    public enum Path {
        case Register
        case Login
        case Tourist
        case Sms
        case Countries
        case CountryDetail(String)
        case Order
        case UserServices
        case TouristServices
        case User
        case Password
        case Cart
        case TouristCart
        case PayValidateItunes
        case AliPay
        case PayValidateACoin
        case Connect
        case Faq
        case AboutUS
        case RuleTime(String)
        case Rule(String)
        case Tos
        case Notifications
        case ItunesSwitch
        case PaySwitch
        case QRCodeSwitch
        case Version
        
        public var url: String {
            let baseUrl = AppPref.getServiceUrl() + "/"
            let path: String
            switch self {
            case .Register:
                path = "register"
            case .Login:
                path = "login"
            case .Tourist:
                path = "tourist/id/iOS/\(AppInfo.deviceUUID)"
            case .Sms:
                path = "sms"
            case .Countries:
                path = "countries"
            case .CountryDetail(let country_id):
                path = "country/\(country_id)/packages"
            case .Order:
                path = "order"
            case .UserServices:
                path = "user/services"
            case .TouristServices:
                path = "tourist/services"
            case .User:
                path = "user"
            case .Password:
                path = "password"
            case .Cart:
                path = "cart"
            case .TouristCart:
                path = "tourist/cart"
            case .PayValidateItunes:
                path = "pay/validate/itunes"
            case .AliPay:
                path = "pay/alipay/mobileApply"
            case .PayValidateACoin:
                path = "pay/validate/acoin"
            case .Connect:
                path = "connect"
            case .Faq:
                path = "faq"
            case .AboutUS:
                path = "aboutus"
            case .RuleTime(let name):
                path = "rule/\(name)/updated_at"
            case .Rule(let name):
                path = "rule/\(name)"
            case .Tos:
                path = "tos"
            case .Notifications:
                path = "notifications"
            case .ItunesSwitch:
                path = "switch/payment?method=itunes_sandbox"
            case .PaySwitch:
                path = "switch/payment"
            case .QRCodeSwitch:
                path = "switch/qrcode"
            case .Version:
                path = "app/version?platform=iOS"
            }
            
            return baseUrl + path
        }
    }
    
    public enum StatusCode {
        case ok
        case created
        case accepted
        case noContent
        case badRequest
        case unauthorize
        case notFound
        case conflict
        case internalError
        
        public var Code: Int {
            let code: Int
            switch self {
            case .ok:
                code = 200
            case .created:
                code = 201
            case .accepted:
                code = 202
            case .noContent:
                code = 204
            case .badRequest:
                code = 400
            case .unauthorize:
                code = 401
            case .notFound:
                code = 404
            case .conflict:
                code = 409
            case .internalError:
                code = 500
            }
            return code
        }
    }
    
    public static var manager:Alamofire.SessionManager? = nil
    
    public static func getAlamofireManager() -> Alamofire.SessionManager {
        if manager == nil {
            // Create a shared URL cache
            let memoryCapacity = 10 * 1024 * 1024; // 10 MB
            let diskCapacity = 10 * 1024 * 1024; // 10 MB
            let cache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: "shared_cache")
            URLCache.shared = cache
        
            let serverTrustPolicies: [String: ServerTrustPolicy] = [
                "api.gaga51.com": .disableEvaluation
            ]
            
            // Create a custom configuration
            let configuration = URLSessionConfiguration.default
            configuration.requestCachePolicy = .useProtocolCachePolicy // this is the default
            configuration.urlCache = cache
            configuration.timeoutIntervalForRequest = 10.0
        
            manager = Alamofire.SessionManager(configuration: configuration, serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
        }
        
        return manager!
    }
    
    public static func encodeString(_ decode: String) -> String! {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        let allowedCharacterSet = (CharacterSet.urlQueryAllowed as NSCharacterSet).mutableCopy() as! NSMutableCharacterSet
        allowedCharacterSet.removeCharacters(in: generalDelimitersToEncode + subDelimitersToEncode)
        let encode = decode.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet as CharacterSet)
        return encode
    }
    
    public static func successResult(_ response: HTTPURLResponse?) -> Bool {
        if response == nil {
            print("response = nil")
            return false
        }
        
        if response!.statusCode >= StatusCode.ok.Code && response!.statusCode <= StatusCode.noContent.Code {
            return true
        } else {
            return false
        }
    }  

}
