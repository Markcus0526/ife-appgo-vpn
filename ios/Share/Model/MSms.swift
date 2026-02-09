//
//  MHelp.swift
//  AppGoPro
//
//  Created by rbvirakf on 12/20/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

import UIKit

public final class MSms: NSObject, NSCoding {
    static let KEY_COUNT = "count"
    static let KEY_CREATEDAT = "createdat"
    
    public dynamic var count:Int = 0
    public dynamic var createdat:Date? = nil
    
    public init(data:NSDictionary) {
        self.count = CastUtils.convInt(data.object(forKey: "count") as AnyObject)
        self.createdat = data.object(forKey: "createdat") as? Date
    }
    
    @objc public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.count, forKey: MSms.KEY_COUNT)
        aCoder.encode(self.createdat, forKey: MSms.KEY_CREATEDAT)
    }
    
    @objc public init?(coder aDecoder: NSCoder) {
        self.count = aDecoder.decodeInteger(forKey: MSms.KEY_COUNT)
        self.createdat = aDecoder.decodeObject(forKey: MSms.KEY_CREATEDAT) as? Date
    }
}
