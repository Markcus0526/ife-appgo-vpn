//
//  MHelp.swift
//  Appsocks
//
//  Created by rbvirakf on 12/20/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

public final class MSms: NSObject, NSCoding {
    public func encode(with aCoder: NSCoder) {
        
    }

    static let KEY_COUNT = "count"
    static let KEY_CREATEDAT = "createdat"
    
    public dynamic var count:Int = 0
    public dynamic var createdat:NSDate? = nil
    
    public init(data:NSDictionary) {
        self.count = CastUtils.convInt(field: data.object(forKey: "count") as AnyObject?)
        self.createdat = data.object(forKey: "createdat") as? NSDate
    }
    
    @objc public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(self.count, forKey: MSms.KEY_COUNT)
        aCoder.encode(self.createdat, forKey: MSms.KEY_CREATEDAT)
    }
    
    @objc public init?(coder aDecoder: NSCoder) {
        self.count = aDecoder.decodeInteger(forKey: MSms.KEY_COUNT)
        self.createdat = aDecoder.decodeObject(forKey: MSms.KEY_CREATEDAT) as? NSDate
    }
}
