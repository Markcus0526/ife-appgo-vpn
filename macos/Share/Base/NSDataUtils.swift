//
//  NSDataUtils.swift
//  Appsocks
//
//  Created by Administrator on 10/30/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

import Foundation

class NSDataUtils {
    static func nsdataToJSON(data: Data) -> AnyObject? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject!
        } catch {
        }
        return nil
    }
    
    static func nsdataFromJSON(data: AnyObject) -> NSData? {
        do {
            return try JSONSerialization.data(withJSONObject: data, options: []) as NSData?
        } catch {            
        }
        return nil
    }
}
