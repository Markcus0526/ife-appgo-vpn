//
//  MService.swift
//  Appsocks
//
//  Created by Administrator on 10/30/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

import Foundation


public final class MService {
    public static let KEY_COUNTRY = "country"
    public static let KEY_ID = "id"
    public static let KEY_NAME = "name"
    public static let KEY_NAME_EN = "alias_en"
    public static let KEY_NAME_ZH = "alias_zh"
    public static let KEY_PORT = "port"
    public static let KEY_PASSWORD = "passwd"
    public static let KEY_TRANSFER_ENABLE = "transfer_enable"
    public static let KEY_UPLOAD = "upload"
    public static let KEY_DOWNLOAD = "download"
    public static let KEY_EXPIRE_TIME = "expire_time"
    public static let KEY_IP = "ip"
    public static let KEY_METHOD = "method"
    public static let KEY_DELAY = "delay"
    
    public dynamic var country_id: Int = 0
    public dynamic var country_name: String = ""
    public dynamic var country_alias_en: String = ""
    public dynamic var country_alias_zh: String = ""
    public dynamic var server_ip: String = ""
    public dynamic var server_port: Int = 0
    public dynamic var server_method: String = ""
    public dynamic var password: String = ""
    public dynamic var transfer_enable: Int64 = 0
    public dynamic var upload: Int64 = 0
    public dynamic var download: Int64 = 0
    public dynamic var expire_time: String = ""
    public dynamic var delay: Int = 0
    
    public init() {
    }
    
    public init(data:NSDictionary) {
        let country = data.object(forKey: MService.KEY_COUNTRY) as! NSDictionary
        self.country_id = CastUtils.convInt(field: country.object(forKey: MService.KEY_ID) as AnyObject)
        self.country_name = CastUtils.convString(field: country.object(forKey: MService.KEY_NAME) as AnyObject)
        self.country_alias_en = CastUtils.convString(field: country.object(forKey: MService.KEY_NAME_EN) as AnyObject)
        self.country_alias_zh = CastUtils.convString(field: country.object(forKey: MService.KEY_NAME_ZH) as AnyObject)
        self.server_port = CastUtils.convInt(field: data.object(forKey: MService.KEY_PORT) as AnyObject)
        self.password = CastUtils.convString(field: data.object(forKey: MService.KEY_PASSWORD) as AnyObject)
        self.transfer_enable = CastUtils.convInt64(field: data.object(forKey: MService.KEY_TRANSFER_ENABLE) as AnyObject)
        self.upload = CastUtils.convInt64(field: data.object(forKey: MService.KEY_UPLOAD) as AnyObject)
        self.download = CastUtils.convInt64(field: data.object(forKey: MService.KEY_DOWNLOAD) as AnyObject)
        self.server_ip = CastUtils.convString(field: data.object(forKey: MService.KEY_IP) as AnyObject)
        self.server_method = CastUtils.convString(field: data.object(forKey: MService.KEY_METHOD) as AnyObject)
        self.expire_time = CastUtils.convString(field: data.object(forKey: MService.KEY_EXPIRE_TIME) as AnyObject)
    }
    
    public func toDictionary(crypto: Bool) -> [String: Any] {
        var dictionary: [String: Any] = [:]
        do {
            dictionary[MService.KEY_ID] = self.country_id
            dictionary[MService.KEY_NAME] = try self.country_name.aesEncrypt()
            dictionary[MService.KEY_NAME_EN] = try self.country_alias_en.aesEncrypt()
            dictionary[MService.KEY_NAME_ZH] = try self.country_alias_zh.aesEncrypt()
            dictionary[MService.KEY_PORT] = self.server_port
            dictionary[MService.KEY_PASSWORD] = try self.password.aesEncrypt()
            dictionary[MService.KEY_TRANSFER_ENABLE] = self.transfer_enable
            dictionary[MService.KEY_UPLOAD] = self.upload
            dictionary[MService.KEY_DOWNLOAD] = self.download
            dictionary[MService.KEY_IP] = try self.server_ip.aesEncrypt()
            dictionary[MService.KEY_EXPIRE_TIME] = try self.expire_time.aesEncrypt()
            dictionary[MService.KEY_METHOD] = try self.server_method.aesEncrypt()
            dictionary[MService.KEY_DELAY] = self.delay
        } catch {
            dictionary[MService.KEY_ID] = self.country_id
            dictionary[MService.KEY_NAME] = self.country_name
            dictionary[MService.KEY_NAME_EN] = self.country_alias_en
            dictionary[MService.KEY_NAME_ZH] = self.country_alias_zh
            dictionary[MService.KEY_PORT] = self.server_port
            dictionary[MService.KEY_PASSWORD] = self.password
            dictionary[MService.KEY_TRANSFER_ENABLE] = self.transfer_enable
            dictionary[MService.KEY_UPLOAD] = self.upload
            dictionary[MService.KEY_DOWNLOAD] = self.download
            dictionary[MService.KEY_IP] = self.server_ip
            dictionary[MService.KEY_EXPIRE_TIME] = self.expire_time
            dictionary[MService.KEY_METHOD] = self.server_method
            dictionary[MService.KEY_DELAY] = self.delay
        }
        
        return dictionary
    }
    
    public func fromDictionary(dictionary:[String: Any], crypto: Bool) {
        do {
            self.country_id = CastUtils.convInt(field: dictionary[MService.KEY_ID] as AnyObject)
            self.country_name = try CastUtils.convString(field: dictionary[MService.KEY_NAME] as AnyObject).aesDecrypt()
            self.country_alias_en = try CastUtils.convString(field: dictionary[MService.KEY_NAME_EN] as AnyObject).aesDecrypt()
            self.country_alias_zh = try CastUtils.convString(field: dictionary[MService.KEY_NAME_ZH] as AnyObject).aesDecrypt()
            self.server_port = CastUtils.convInt(field: dictionary[MService.KEY_PORT] as AnyObject)
            self.password = try CastUtils.convString(field: dictionary[MService.KEY_PASSWORD] as AnyObject).aesDecrypt()
            self.transfer_enable = CastUtils.convInt64(field: dictionary[MService.KEY_TRANSFER_ENABLE] as AnyObject)
            self.upload = CastUtils.convInt64(field: dictionary[MService.KEY_UPLOAD] as AnyObject)
            self.download = CastUtils.convInt64(field: dictionary[MService.KEY_DOWNLOAD] as AnyObject)
            self.server_ip = try CastUtils.convString(field: dictionary[MService.KEY_IP] as AnyObject).aesDecrypt()
            self.server_method = try CastUtils.convString(field: dictionary[MService.KEY_METHOD] as AnyObject).aesDecrypt()
            self.expire_time = try CastUtils.convString(field: dictionary[MService.KEY_EXPIRE_TIME] as AnyObject).aesDecrypt()
        } catch {
            self.country_id = CastUtils.convInt(field: dictionary[MService.KEY_ID] as AnyObject)
            self.country_name = CastUtils.convString(field: dictionary[MService.KEY_NAME] as AnyObject)
            self.country_alias_en = CastUtils.convString(field: dictionary[MService.KEY_NAME_EN] as AnyObject)
            self.country_alias_zh = CastUtils.convString(field: dictionary[MService.KEY_NAME_ZH] as AnyObject)
            self.server_port = CastUtils.convInt(field: dictionary[MService.KEY_PORT] as AnyObject)
            self.password = CastUtils.convString(field: dictionary[MService.KEY_PASSWORD] as AnyObject)
            self.transfer_enable = CastUtils.convInt64(field: dictionary[MService.KEY_TRANSFER_ENABLE] as AnyObject)
            self.upload = CastUtils.convInt64(field: dictionary[MService.KEY_UPLOAD] as AnyObject)
            self.download = CastUtils.convInt64(field: dictionary[MService.KEY_DOWNLOAD] as AnyObject)
            self.server_ip = CastUtils.convString(field: dictionary[MService.KEY_IP] as AnyObject)
            self.server_method = CastUtils.convString(field: dictionary[MService.KEY_METHOD] as AnyObject)
            self.expire_time = CastUtils.convString(field: dictionary[MService.KEY_EXPIRE_TIME] as AnyObject)
        }
    }
}
