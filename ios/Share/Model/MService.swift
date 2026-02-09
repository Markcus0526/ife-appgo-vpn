//
//  MService.swift
//  AppGoPro
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
    
    public init(data:NSDictionary) {
        let country = data.object(forKey: MService.KEY_COUNTRY) as! NSDictionary
        self.country_id = CastUtils.convInt(country.object(forKey: MService.KEY_ID) as AnyObject)
        self.country_name = CastUtils.convString(country.object(forKey: MService.KEY_NAME) as AnyObject)
        self.country_alias_en = CastUtils.convString(country.object(forKey: MService.KEY_NAME_EN) as AnyObject)
        self.country_alias_zh = CastUtils.convString(country.object(forKey: MService.KEY_NAME_ZH) as AnyObject)
        self.server_port = CastUtils.convInt(data.object(forKey: MService.KEY_PORT) as AnyObject)
        self.password = CastUtils.convString(data.object(forKey: MService.KEY_PASSWORD) as AnyObject)
        self.transfer_enable = CastUtils.convInt64(data.object(forKey: MService.KEY_TRANSFER_ENABLE) as AnyObject)
        self.upload = CastUtils.convInt64(data.object(forKey: MService.KEY_UPLOAD) as AnyObject)
        self.download = CastUtils.convInt64(data.object(forKey: MService.KEY_DOWNLOAD) as AnyObject)
        self.server_ip = CastUtils.convString(data.object(forKey: MService.KEY_IP) as AnyObject)
        self.server_method = CastUtils.convString(data.object(forKey: MService.KEY_METHOD) as AnyObject)
        self.expire_time = CastUtils.convString(data.object(forKey: MService.KEY_EXPIRE_TIME) as AnyObject)
    }
    
    public init(dictionary:[String: Any]) {
        self.country_id = CastUtils.convInt(dictionary[MService.KEY_ID] as AnyObject)
        self.country_name = CastUtils.convString(dictionary[MService.KEY_NAME] as AnyObject)
        self.country_alias_en = CastUtils.convString(dictionary[MService.KEY_NAME_EN] as AnyObject)
        self.country_alias_zh = CastUtils.convString(dictionary[MService.KEY_NAME_ZH] as AnyObject)
        self.server_port = CastUtils.convInt(dictionary[MService.KEY_PORT] as AnyObject)
        self.password = CastUtils.convString(dictionary[MService.KEY_PASSWORD] as AnyObject)
        self.transfer_enable = CastUtils.convInt64(dictionary[MService.KEY_TRANSFER_ENABLE] as AnyObject)
        self.upload = CastUtils.convInt64(dictionary[MService.KEY_UPLOAD] as AnyObject)
        self.download = CastUtils.convInt64(dictionary[MService.KEY_DOWNLOAD] as AnyObject)
        self.server_ip = CastUtils.convString(dictionary[MService.KEY_IP] as AnyObject)
        self.server_method = CastUtils.convString(dictionary[MService.KEY_METHOD] as AnyObject)
        self.expire_time = CastUtils.convString(dictionary[MService.KEY_EXPIRE_TIME] as AnyObject)
    }
    
    public func toDictionary() -> [String: Any] {
        var service: [String: Any] = [:]
        service[MService.KEY_ID] = self.country_id
        service[MService.KEY_NAME] = self.country_name
        service[MService.KEY_NAME_EN] = self.country_alias_en
        service[MService.KEY_NAME_ZH] = self.country_alias_zh
        service[MService.KEY_PORT] = self.server_port
        service[MService.KEY_PASSWORD] = self.password
        service[MService.KEY_TRANSFER_ENABLE] = self.transfer_enable
        service[MService.KEY_UPLOAD] = self.upload
        service[MService.KEY_DOWNLOAD] = self.download
        service[MService.KEY_IP] = self.server_ip
        service[MService.KEY_EXPIRE_TIME] = self.expire_time
        service[MService.KEY_METHOD] = self.server_method
        service[MService.KEY_DELAY] = self.delay
        
        return service
    }
}
