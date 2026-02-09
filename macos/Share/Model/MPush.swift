//
//  MPush.swift
//  Appsocks
//
//  Created by rbvirakf on 1/6/17.
//  Copyright © 2017 TouchingApp. All rights reserved.
//

public final class MPush {
    public dynamic var id = 0
    public dynamic var title:String = ""
    public dynamic var content:String = ""
    public dynamic var updatedat:String = ""
    
    public init(data:NSDictionary) {
        self.id = CastUtils.convInt(field: data.object(forKey: "id") as AnyObject?)
        self.title = CastUtils.convString(field: data.object(forKey: "title") as AnyObject?)
        self.content = CastUtils.convString(field: data.object(forKey: "content") as AnyObject?)
        self.updatedat = CastUtils.convString(field: data.object(forKey: "updated_at") as AnyObject?)
    }
    
    public init(id: Int, title: String, content: String, updatedat: String) {
        self.id = id
        self.title = title
        self.content = content
        self.updatedat = updatedat
    }
}
