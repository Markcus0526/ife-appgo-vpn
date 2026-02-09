//
//  CommonUtils.swift
//  Appsocks
//
//  Created by Administrator on 10/31/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

import Foundation

extension String {
    
    subscript (i: Int) -> Character {
        return self[self.characters.index(self.characters.startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
}

class CommonUtils {
    static func humanReadableByteCount(bytes: Int64, needFloat: Bool) -> String {
        let unit: Int64 = 1024
        if bytes < unit {
            return "\(bytes) B";
        }
        
        var exp = Int64(log(Float(bytes)) / log(Float(unit)))
        if exp > 3 {
            exp = 3
        }
        let size = Float(bytes) / powf(Float(unit), Float(exp))
        
        if needFloat == false {//size - Float(Int(size)) < 1.0 {
            return String.init(format: "%@ %@B", String(Int64(size)), "KMGTPE"[exp-1] as String)
        } else {
            return String.init(format: "%.2f %@B", size, "KMGTPE"[exp-1] as String)
        }
    }
    
    static func validCountryAndRule(service: MService, rule: String) -> Bool {
        if service.country_name == "CN" && rule == "international" {
            return false
        } else if service.country_name != "CN" && rule == "national" {
            return false
        } else {
            return true
        }
    }
    
    static func validService(service: MService?) -> Bool {
        var valid = true
        
        if service == nil {
            return valid
        }
        
        if service?.expire_time != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let expireDate = dateFormatter.date(from: service!.expire_time)
            if expireDate!.compare(Date()) == ComparisonResult.orderedAscending {
                valid = false
            }
        }
        
        if (service?.transfer_enable)! < (service?.upload)! + (service?.download)! {
            valid = false
        }
        
        return valid
    }
    
    static func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
}
