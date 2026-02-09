//
//  MCountry.swift
//  AppGoPro
//
//  Created by Administrator on 10/29/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

import Foundation

public final class MCountry {
    public static let KEY_ID = "id"
    public static let KEY_NAME = "name"
    public static let KEY_NAME_EN = "alias_en"
    public static let KEY_NAME_ZH = "alias_zh"
    public static let KEY_DESCRIPTION = "description"
    
    public dynamic var id:Int = 0
    public dynamic var name:String = ""
    public dynamic var alias_en = ""
    public dynamic var alias_zh = ""
    public dynamic var description = ""
    
    public init(data:NSDictionary) {
        self.id = CastUtils.convInt(data.object(forKey: MCountry.KEY_ID) as AnyObject)
        self.name = CastUtils.convString(data.object(forKey: MCountry.KEY_NAME) as AnyObject)
        self.alias_en = CastUtils.convString(data.object(forKey: MCountry.KEY_NAME_EN) as AnyObject)
        self.alias_zh = CastUtils.convString(data.object(forKey: MCountry.KEY_NAME_ZH) as AnyObject)
        self.description = CastUtils.convString(data.object(forKey: MCountry.KEY_DESCRIPTION) as AnyObject)
    }   
    
}

