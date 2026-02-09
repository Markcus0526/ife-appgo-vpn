//
//  MUser.swift
//  AppGoPro
//
//  Created by Administrator on 11/1/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

import Foundation

public final class MUser {
    public dynamic var acoin: Int = 0
    public dynamic var id: Int = 0
    public dynamic var level: Int = 0
    public dynamic var mobile: String = ""
    public dynamic var nickname: String = ""
    public dynamic var mailaccount: String = ""
    public dynamic var createdat: Date
    
    public init(data:NSDictionary) {
        self.acoin = CastUtils.convInt(data.object(forKey: "acoin") as AnyObject)
        //self.id = data.objectForKey("id") as! Int
        self.level = CastUtils.convInt(data.object(forKey: "level") as AnyObject)
        self.mobile = CastUtils.convString(data.object(forKey: "mobile") as AnyObject)
        self.nickname = CastUtils.convString(data.object(forKey: "nickname") as AnyObject)
        self.mailaccount = "appgotest@163.com"//data.objectForKey("mailaccount") as! String
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.createdat = dateFormatter.date(from: CastUtils.convString(data.object(forKey: "created_at") as AnyObject))!
    }
    
}
