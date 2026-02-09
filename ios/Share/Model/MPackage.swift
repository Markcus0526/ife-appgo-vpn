//
//  MPackage.swift
//  AppGoPro
//
//  Created by Administrator on 10/29/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

import Foundation

public final class MPackage {
    public dynamic var id: Int = 0
    public dynamic var duration: Int = 0
    public dynamic var transfer: Int64 = 0
    public dynamic var price: Int = 0
    public dynamic var apple_product_id: String = ""
    
    public init(data:NSDictionary) {
        self.id = CastUtils.convInt(data.object(forKey: "id") as AnyObject)
        self.duration = CastUtils.convInt(data.object(forKey: "duration") as AnyObject)
        self.price = CastUtils.convInt(data.object(forKey: "price") as AnyObject)
        self.transfer = CastUtils.convInt64(data.object(forKey: "transfer") as AnyObject)
        self.apple_product_id = CastUtils.convString(data.object(forKey: "apple_product_id") as AnyObject)
    }
    
}
