//
//  LanguageManager.swift
//  Appsocks
//
//  Created by Administrator on 10/4/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

import Foundation

public class LanguageManager:NSObject {
    static let English: String = "US"
    static let Chinese: String = "CN"
    static let count: Int = 2

    static func getFlagName(code: String) -> String {
        var flag: String = ""
        
        switch code {
        case "CN":
            flag = "ic_flag_cn"
        default:
            flag = "ic_flag_us"
        }
        
        return flag
    }
    
    static func getLocale(code: String) -> String {
        var locale: String = ""
        
        switch code {
        case "CN":
            locale = "zh-Hans"
        default:
            locale = "en"
        }
        
        return locale
    }
}
