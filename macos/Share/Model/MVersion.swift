//
//  MVersion.swift
//  AppGo
//
//  Created by administrator on 26/8/2018.
//  Copyright © 2018 qiuyuzhou. All rights reserved.
//

import Foundation

public final class MVersion {
    public dynamic var version: Float = 0
    public dynamic var link: String = ""
    
    public init(data:NSDictionary) {
        self.version = CastUtils.convFloat(field: data.object(forKey: "version") as AnyObject?)
        self.link = CastUtils.convString(field: data.object(forKey: "link") as AnyObject?)
    }
}
