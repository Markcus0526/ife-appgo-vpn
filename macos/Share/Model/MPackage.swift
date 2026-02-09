//
//  MPackage.swift
//  Appsocks
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
    public dynamic var usd_price: Double = 0
    public dynamic var apple_product_id: String = ""
    public dynamic var mac_product_id: String = ""
    
    public init(data:NSDictionary) {
        self.id = CastUtils.convInt(field: data.object(forKey: "id") as AnyObject?)
        self.duration = CastUtils.convInt(field: data.object(forKey: "duration") as AnyObject?)
        self.price = CastUtils.convInt(field: data.object(forKey: "price") as AnyObject?)
        self.usd_price = CastUtils.convDouble(field: data.object(forKey: "usd_price") as AnyObject?)
        self.transfer = CastUtils.convInt64(field: data.object(forKey: "transfer") as AnyObject?)
        self.apple_product_id = CastUtils.convString(field: data.object(forKey: "apple_product_id") as AnyObject?)
        self.mac_product_id = CastUtils.convString(field: data.object(forKey: "mas_product_id") as AnyObject?)
    }
    
}
