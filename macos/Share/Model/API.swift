//
//  API.swift
//  Appsocks
//
//  Created by LEI on 6/4/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

import Foundation
import Alamofire
//import ObjectMapper
//import ISO8601DateFormatter


/*extension RuleSet: Mappable {
    public convenience init?(_ map: Map) {
        self.init()
        guard let rulesJSON = map.JSONDictionary["rules"] as? [AnyObject] else {
            return
        }
        if let parsedObject = Mapper<Rule>().mapArray(rulesJSON){
            rules.appendContentsOf(parsedObject)
        }
    }

    // Mappable
    public func mapping(map: Map) {
        uuid      <- map["id"]
        name      <- map["name"]
        createAt  <- (map["created_at"], DateTransform())
        remoteUpdatedAt  <- (map["updated_at"], DateTransform())
        desc      <- map["description"]
        ruleCount <- map["rule_count"]
        isOfficial <- map["is_official"]
    }
}

extension RuleSet {
    
    static func addRemoteObject(ruleset: RuleSet, update: Bool = true) throws {
        ruleset.isSubscribe = true
        ruleset.editable = false
        let id = ruleset.uuid
        guard let local = DBUtils.get(id, type: RuleSet.self) else {
            try DBUtils.add(ruleset)
            return
        }
        if local.remoteUpdatedAt == ruleset.remoteUpdatedAt {
            return
        }
        try DBUtils.add(ruleset)
    }
    
    static func addRemoteArray(rulesets: [RuleSet], update: Bool = true) throws {
        for ruleset in rulesets {
            try addRemoteObject(ruleset: ruleset, update: update)
        }
    }
    
}*/

//extension Rule: Mappable {
//    
//    public convenience init?(_ map: Map) {
//        guard let pattern = map.JSONDictionary["pattern"] as? String else {
//            return nil
//        }
//        guard let actionStr = map.JSONDictionary["action"] as? String, let action = RuleAction(rawValue: actionStr) else {
//            return nil
//        }
//        guard let typeStr = map.JSONDictionary["type"] as? String, let type = MMRuleType(rawValue: typeStr) else {
//            return nil
//        }
//        self.init(type: type, action: action, value: pattern)
//    }
//    
//    // Mappable
//    public func mapping(map: Map) {
//    }
//}


/*
struct DateTransform: TransformType {

    func transformFromJSON(value: AnyObject?) -> Double? {
        guard let dateStr = value as? String else {
            return NSDate().timeIntervalSince1970
        }
        if #available(OSX 10.12, *) {
            return ISO8601DateFormatter().date(from: dateStr)?.timeIntervalSince1970
        } else {
            // Fallback on earlier versions
        }
    }

    func transformToJSON(value: Double?) -> AnyObject? {
        guard let v = value else {
            return nil
        }
        let date = NSDate(timeIntervalSince1970: v)
        if #available(OSX 10.12, *) {
            return ISO8601DateFormatter().stringFromDate(date) as (Date) as (Date)
        } else {
            // Fallback on earlier versions
        }
    }

}*/
/*
extension Alamofire.Request {

    public static func ObjectMapperSerializer<T: Mappable>(keyPath: String?, mapToObject object: T? = nil) -> ResponseSerializer<T, NSError> {
        return ResponseSerializer { request, response, data, error in
            guard error == nil else {
                logError(error!, request: request, response: response)
                return .Failure(error!)
            }

            guard let _ = data else {
                let failureReason = "Data could not be serialized. Input data was nil."
                let error = Error.errorWithCode(.DataSerializationFailed, failureReason: failureReason)
                logError(error, request: request, response: response)
                return .Failure(error)
            }

            let JSONResponseSerializer = Alamofire.Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, data, error)

            if let errorMessage = result.value?.valueForKeyPath("error_message") as? String {
                let error = Error.errorWithCode(.StatusCodeValidationFailed, failureReason: errorMessage)
                logError(error, request: request, response: response)
                return .Failure(error)
            }

            var JSONToMap: AnyObject?
            if let keyPath = keyPath, keyPath.isEmpty == false {
                JSONToMap = result.value?.valueForKeyPath(keyPath)
            } else {
                JSONToMap = result.value
            }

            if let object = object {
                Mapper<T>().map(JSONToMap, toObject: object)
                return .Success(object)
            } else if let parsedObject = Mapper<T>().map(JSONToMap){
                return .Success(parsedObject)
            }

            let failureReason = "ObjectMapper failed to serialize response"
            let error = Error.errorWithCode(.DataSerializationFailed, failureReason: failureReason)
            logError(error, request: request, response: response)
            return .Failure(error)
        }
    }

    /**
     Adds a handler to be called once the request has finished.

     - parameter queue:             The queue on which the completion handler is dispatched.
     - parameter keyPath:           The key path where object mapping should be performed
     - parameter object:            An object to perform the mapping on to
     - parameter completionHandler: A closure to be executed once the request has finished and the data has been mapped by ObjectMapper.

     - returns: The request.
     */

    public func responseObject<T: Mappable>(queue: dispatch_queue_t? = nil, keyPath: String? = nil, mapToObject object: T? = nil, completionHandler: Response<T, NSError> -> Void) -> Self {
        return response(queue: queue, responseSerializer: Alamofire.Request.ObjectMapperSerializer(keyPath, mapToObject: object), completionHandler: completionHandler)
    }

    public static func ObjectMapperArraySerializer<T: Mappable>(keyPath: String?) -> ResponseSerializer<[T], NSError> {
        return ResponseSerializer { request, response, data, error in
            guard error == nil else {
                logError(error!, request: request, response: response)
                return .Failure(error!)
            }

            guard let _ = data else {
                let failureReason = "Data could not be serialized. Input data was nil."
                let error = Error.errorWithCode(.DataSerializationFailed, failureReason: failureReason)
                logError(error, request: request, response: response)
                return .Failure(error)
            }

            let JSONResponseSerializer = Alamofire.Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, data, error)

            if let errorMessage = result.value?.valueForKeyPath("error_message") as? String {
                let error = Error.errorWithCode(.StatusCodeValidationFailed, failureReason: errorMessage)
                logError(error, request: request, response: response)
                return .Failure(error)
            }

            let JSONToMap: AnyObject?
            if let keyPath = keyPath, keyPath.isEmpty == false {
                JSONToMap = result.value?.valueForKeyPath(keyPath)
            } else {
                JSONToMap = result.value
            }

            if let parsedObject = Mapper<T>().mapArray(JSONToMap){
                return .Success(parsedObject)
            }

            let failureReason = "ObjectMapper failed to serialize response."
            let error = Error.errorWithCode(.DataSerializationFailed, failureReason: failureReason)
            logError(error, request: request, response: response)
            return .Failure(error)
        }
    }

    /**
     Adds a handler to be called once the request has finished.

     - parameter queue: The queue on which the completion handler is dispatched.
     - parameter keyPath: The key path where object mapping should be performed
     - parameter completionHandler: A closure to be executed once the request has finished and the data has been mapped by ObjectMapper.

     - returns: The request.
     */
    /*public func responseArray<T: Mappable>(queue queue: dispatch_queue_t? = nil, keyPath: String? = nil, completionHandler: Response<[T], NSError> -> Void) -> Self {
        return response(queue: queue, responseSerializer: Alamofire.Request.ObjectMapperArraySerializer(keyPath), completionHandler: completionHandler)
    }*/

    private static func logError(error: NSError, request: NSURLRequest?, response: URLResponse?) {
//        DDLogError("ObjectMapperSerializer failure: \(error.localizedDescription), request: \(request?.debugDescription), response: \(response.debugDescription)")
    }
}*/


public struct WSAPI {
    
    // developer version
    public static var BASE_URL = "http://39.108.212.90:99"
    public static let CLIENT_ID = "q32LOhbxR4p8TVKTbLCiHKO4FbZUTQ5m3wI1YtCc"
    public static let CLIENT_SECRET = "qQB4T6wuMpEqMx8JiJIqrNynQTSrEnsRaJxo71C4"

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
        case FAQ
        case AboutUS
        case RuleTime(String)
        case Rule(String)
        case tos
        case Notifications
        case ItunesSwitch
        case PaySwitch
        case RefreshToken
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
            case .FAQ:
                path = "faq"
            case .AboutUS:
                path = "aboutus"
            case .RuleTime(let name):
                path = "rule/\(name)/updated_at"
            case .Rule(let name):
                path = "rule/\(name)"
            case .tos:
                path = "tos"
            case .Notifications:
                path = "notifications"
            case .ItunesSwitch:
                path = "switch/payment?method=itunes_sandbox"
            case .PaySwitch:
                path = "switch/payment"
            case .RefreshToken:
                path = "refreshtoken"
            case .Version:
                path = "app/version?platform=macOS"
            }
            
            return baseUrl + path
        }
    }
    
    public enum StatusCode {
        case Ok
        case Created
        case Accepted
        case NoContent
        case BadRequest
        case Unauthorize
        case NotFound
        case Conflict
        case InternalError
        
        public var Code: Int {
            let code: Int
            switch self {
            case .Ok:
                code = 200
            case .Created:
                code = 201
            case .Accepted:
                code = 202
            case .NoContent:
                code = 204
            case .BadRequest:
                code = 400
            case .Unauthorize:
                code = 401
            case .NotFound:
                code = 404
            case .Conflict:
                code = 409
            case .InternalError:
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
            configuration.timeoutIntervalForRequest = 30.0
        
            manager = Alamofire.SessionManager(configuration: configuration, serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
        }
        
        return manager!
    }
    
    public static func encodeString(decode: String) -> String! {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowedCharacterSet = NSCharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: generalDelimitersToEncode + subDelimitersToEncode)
        let encode = decode.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)
        return encode
    }
    
    public static func successResult(response: HTTPURLResponse?) -> Bool {
        if response == nil {
            return false
        }
        //DebugPrint.dprint("successResult: \(response!.statusCode)")
        if response!.statusCode >= StatusCode.Ok.Code && response!.statusCode <= StatusCode.NoContent.Code {
            return true
        } else {
            return false
        }
    }
    
    public static func fetchServiceDataWithToken() {
        let refresh_token = AppPref.getRefreshToken()
        if !AppPref.isLogined() || refresh_token == "" {return}
        
        let request = WSAPI.getAlamofireManager().request(WSAPI.Path.RefreshToken.url,
                                                          method: .post,
                                                          parameters: ["grant_type": "refresh_token", "client_id": WSAPI.CLIENT_ID, "client_secret": WSAPI.CLIENT_SECRET, "refresh_token": refresh_token],
                                                          headers: ["Accept": WSAPI.HEADER_ACCEPT,
                                                                    "Content-Language": AppPref.getServiceLanguage()])
        request.responseData { response in
            
            let successResult = WSAPI.successResult(response: response.response)
            if successResult {
                let json = NSDataUtils.nsdataToJSON(data: response.result.value!)
                
                if json == nil {
                    Alert.show(data: response.data)
                } else {
                    AppPref.setAccessToken(token: json!["access_token"] as! String)
                    AppPref.setRefreshToken(token: json!["refresh_token"] as! String)
                }
            } else {
                let phonenumber = AppPref.getLastLoginPhoneNumber()
                let password = AppPref.getLastLoginPassword()
                let request = WSAPI.getAlamofireManager().request(WSAPI.Path.Login.url,
                                                              method: .post,
                                                              parameters: ["username": phonenumber, "password": password, "client_id": WSAPI.CLIENT_ID, "client_secret": WSAPI.CLIENT_SECRET, "grant_type": "password"],
                                                              headers: ["Accept": WSAPI.HEADER_ACCEPT, "Content-Language": AppPref.getServiceLanguage()])
                
                request.responseData { response in

                    let successResult = WSAPI.successResult(response: response.response)
                    if successResult {
                        let json = NSDataUtils.nsdataToJSON(data: response.result.value!)
                        
                        if json == nil {
                            Alert.show(data: response.data)
                        } else {
                            AppPref.setAccessToken(token: json!["access_token"] as! String)
                            AppPref.setRefreshToken(token: json!["refresh_token"] as! String)
                        }
                    } 
                }
            }
        }
    }
    
    
//    static func connect(country_id: String, server_port: String, passwd: String, callback: Alamofire.Response<AnyObject, NSError> -> Void) {
//        let access_token = AppPref.getAccessToken()
//        Alamofire.request(.POST, Path.Connect.url, parameters: ["country_id": country_id, "server_port": server_port,
//            "passwd": passwd], encoding: .URL, headers: ["Authorization": "Bearer \(access_token)"]).responseJSON(completionHandler: callback)
//    }
}

