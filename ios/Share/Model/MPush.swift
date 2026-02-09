//
//  MPush.swift
//  AppGoPro
//
//  Created by rbvirakf on 1/6/17.
//  Copyright © 2017 TouchingApp. All rights reserved.
//

import UIKit

public final class MPush {
    public dynamic var id = 0
    public dynamic var title:String = ""
    public dynamic var content:String = ""
    public dynamic var updatedat:String = ""
    
    public init(data:NSDictionary) {
        self.id = CastUtils.convInt(data.object(forKey: "id") as AnyObject)
        self.title = CastUtils.convString(data.object(forKey: "title") as AnyObject)
        self.content = CastUtils.convString(data.object(forKey: "content") as AnyObject)
        self.updatedat = CastUtils.convString(data.object(forKey: "updated_at") as AnyObject)
    }
}
