//
//  CastUtils.swift
//  AppGoPro
//
//  Created by rbvirakf on 4/30/17.
//  Copyright © 2017 TouchingApp. All rights reserved.
//

import Foundation

public final class CastUtils {
    
    static func convString(_ field: AnyObject?) -> String {
        let value: String? = field as? String
        if value == nil {
            return ""
        } else {
            return value!
        }
    }
    
    static func convInt(_ field: AnyObject?) -> Int {
        let value: Int? = field as? Int
        if value == nil {
            return 0
        } else {
            return value!
        }
    }
    
    static func convInt64(_ field: AnyObject?) -> Int64 {
        let value: NSNumber? = field as? NSNumber
        if value == nil {
            return 0
        } else {
            return (value?.int64Value)!
        }
    }
}
