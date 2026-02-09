//
//  CountryManager.swift
//  Appsocks
//
//  Created by rbvirakf on 11/27/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

import Foundation

public struct CountryInfo {
    public var code = String();
    public var chinaName = String();
    public var englishName = String();
    public var phoneCode = String();
    public var price:Float;
    public var flag = String();
}

public let countryInfos = [
    CountryInfo(code: "CN", chinaName: "中国", englishName: "China", phoneCode: "+86", price: 0.05, flag: "ic_flag_cn"),
    CountryInfo(code: "HK", chinaName: "香港", englishName: "Hong Kong", phoneCode: "+852", price: 0.227, flag: "ic_flag_hk"),
    CountryInfo(code: "MO", chinaName: "澳门", englishName: "Macau", phoneCode: "+853", price: 0.076, flag: "ic_flag_mo"),
    CountryInfo(code: "TW", chinaName: "台湾", englishName: "Taiwan", phoneCode: "+886", price: 0.16, flag: "ic_flag_tw"),
    CountryInfo(code: "US", chinaName: "美国", englishName: "United States", phoneCode: "+1", price: 0.037, flag: "ic_flag_us"),
    CountryInfo(code: "CA", chinaName: "加拿大", englishName: "Canada", phoneCode: "+1", price: 0.037, flag: "ic_flag_ca"),
    CountryInfo(code: "MX", chinaName: "墨西哥", englishName: "Mexico", phoneCode: "+52", price: 0.294, flag: "ic_flag_mx"),
    CountryInfo(code: "NL", chinaName: "荷兰", englishName: "Netherlands", phoneCode: "+31", price: 0.554, flag: "ic_flag_nl"),
    CountryInfo(code: "BE", chinaName: "比利时", englishName: "Belgium", phoneCode: "+32", price: 0.673, flag: "ic_flag_be"),
    CountryInfo(code: "FR", chinaName: "法国", englishName: "France", phoneCode: "+33", price: 0.311, flag: "ic_flag_fr"),
    CountryInfo(code: "ES", chinaName: "西班牙", englishName: "Spain", phoneCode: "+34", price: 0.336, flag: "ic_flag_es"),
    CountryInfo(code: "IT", chinaName: "意大利", englishName: "Italy", phoneCode: "+39", price: 0.336, flag: "ic_flag_it"),
    CountryInfo(code: "CH", chinaName: "瑞士", englishName: "Switzerland", phoneCode: "+41", price: 0.353, flag: "ic_flag_ch"),
    CountryInfo(code: "AT", chinaName: "奥地利", englishName: "Austria", phoneCode: "+43", price: 0.42, flag: "ic_flag_at"),
    CountryInfo(code: "GB", chinaName: "英国", englishName: "United Kingdom", phoneCode: "+44", price: 0.218, flag: "ic_flag_gb"),
    CountryInfo(code: "DK", chinaName: "丹麦", englishName: "Denmark", phoneCode: "+45", price: 0.139, flag: "ic_flag_dk"),
    CountryInfo(code: "SE", chinaName: "瑞典", englishName: "Sweden", phoneCode: "+46", price: 0.302, flag: "ic_flag_se"),
    CountryInfo(code: "NO", chinaName: "挪威", englishName: "Norway", phoneCode: "+47", price: 0.328, flag: "ic_flag_no"),
    CountryInfo(code: "PL", chinaName: "波兰", englishName: "Poland", phoneCode: "+48", price: 0.193, flag: "ic_flag_pl"),
    CountryInfo(code: "DE", chinaName: "德国", englishName: "Germany", phoneCode: "+49", price: 0.42, flag: "ic_flag_de"),
    CountryInfo(code: "PT", chinaName: "葡萄牙", englishName: "Portugal", phoneCode: "+351", price: 0.337, flag: "ic_flag_pt"),
    CountryInfo(code: "FI", chinaName: "芬兰", englishName: "Finland", phoneCode: "+358", price: 0.555, flag: "ic_flag_fi"),
    CountryInfo(code: "RU", chinaName: "俄罗斯", englishName: "Russia", phoneCode: "+7", price: 0.16, flag: "ic_flag_ru"),
    CountryInfo(code: "UA", chinaName: "乌克兰", englishName: "Ukraine", phoneCode: "+380", price: 0.588, flag: "ic_flag_ua"),
    CountryInfo(code: "AR", chinaName: "阿根廷", englishName: "Argentina", phoneCode: "+54", price: 0.409, flag: "ic_flag_ar"),
    CountryInfo(code: "BR", chinaName: "巴西", englishName: "Brazil", phoneCode: "+55", price: 0.404, flag: "ic_flag_br"),
    CountryInfo(code: "CL", chinaName: "智利", englishName: "Chile", phoneCode: "+56", price: 0.367, flag: "ic_flag_cl"),
    CountryInfo(code: "MY", chinaName: "马来西亚", englishName: "Malaysia", phoneCode: "+60", price: 0.193, flag: "ic_flag_my"),
    CountryInfo(code: "AU", chinaName: "澳大利亚", englishName: "Australia", phoneCode: "+61", price: 0.353, flag: "ic_flag_au"),
    CountryInfo(code: "ID", chinaName: "印度尼西亚", englishName: "Indonesia", phoneCode: "+62", price: 0.143, flag: "ic_flag_id"),
    CountryInfo(code: "PH", chinaName: "菲律宾", englishName: "Philippines", phoneCode: "+63", price: 0.249, flag: "ic_flag_ph"),
    CountryInfo(code: "NZ", chinaName: "新西兰", englishName: "New Zealand", phoneCode: "+64", price: 0.582, flag: "ic_flag_nz"),
    CountryInfo(code: "SG", chinaName: "新加坡", englishName: "Singapore", phoneCode: "+65", price: 0.244, flag: "ic_flag_sg"),
    CountryInfo(code: "TH", chinaName: "泰国", englishName: "Thailand", phoneCode: "+66", price: 0.143, flag: "ic_flag_th"),
    CountryInfo(code: "JP", chinaName: "日本", englishName: "Japan", phoneCode: "+81", price: 0.378, flag: "ic_flag_jp"),
    CountryInfo(code: "KR", chinaName: "韩国", englishName: "South Korea", phoneCode: "+82", price: 0.101, flag: "ic_flag_kr"),
    CountryInfo(code: "VN", chinaName: "越南", englishName: "Vietnam", phoneCode: "+84", price: 0.414, flag: "ic_flag_vn"),
    CountryInfo(code: "TR", chinaName: "土耳其", englishName: "Turkey", phoneCode: "+90", price: 0.126, flag: "ic_flag_tr"),
    CountryInfo(code: "IN", chinaName: "印度", englishName: "India", phoneCode: "+91", price: 0.05, flag: "ic_flag_in"),
    CountryInfo(code: "PK", chinaName: "巴基斯坦", englishName: "Pakistan", phoneCode: "+92", price: 0.168, flag: "ic_flag_pk"),
    CountryInfo(code: "IR", chinaName: "伊朗", englishName: "Iran", phoneCode: "+98", price: 0.266, flag: "ic_flag_ir"),
    CountryInfo(code: "SA", chinaName: "沙特阿拉伯", englishName: "Saudi Arabia", phoneCode: "+966", price: 0.189, flag: "ic_flag_sa"),
    CountryInfo(code: "AE", chinaName: "阿拉伯 联合酋长国", englishName: "United Arab Emirates", phoneCode: "+971", price: 0.193, flag: "ic_flag_ae"),
    CountryInfo(code: "IL", chinaName: "以色列", englishName: "Israel", phoneCode: "+972", price: 0.472, flag: "ic_flag_il"),
    CountryInfo(code: "MN", chinaName: "蒙古", englishName: "Mongolia", phoneCode: "+976", price: 0.156, flag: "ic_flag_mn"),
    CountryInfo(code: "ZA", chinaName: "南非", englishName: "South Africa", phoneCode: "+27", price: 0.146, flag: "ic_flag_za"),
    CountryInfo(code: "Trial", chinaName: "试用", englishName: "Trial", phoneCode: "+27", price: 0.146, flag: "ic_flag_user")
]

public class Country {
    public static func getFlagName(code: String) -> String {
        for i in 0..<countryInfos.count {
            if code == countryInfos[i].code {
                return countryInfos[i].flag
            }
        }
        return "ic_flag_user"
    }
    
    public static func getCountryName(code: String, locale localeCode: String) -> String {
        for i in 0..<countryInfos.count {
            if code == countryInfos[i].code {
                if localeCode == Localize.Chinese { // chinese
                    return countryInfos[i].chinaName
                } else {
                    return countryInfos[i].englishName
                }
            }
        }
        return code
    }
    
    public static func getCryptPhoneNumber(mobile: String) -> String {
        if mobile.count < 10  || mobile.contains("+") == false {
            return mobile
        }
        
        var cryptNumber = ""
        
        for i in 0..<countryInfos.count {
            var countrycode = mobile.substring(to: mobile.index(mobile.startIndex, offsetBy: 4))
            if countrycode == countryInfos[i].phoneCode {
                cryptNumber = mobile.substring(from: mobile.index(mobile.startIndex, offsetBy: 4)).substring(to: mobile.index(mobile.startIndex, offsetBy: 7)) +
                    fillCryptCode(count: mobile.count-10) +
                    mobile.substring(from: mobile.index(mobile.startIndex, offsetBy: mobile.count-3))
                break
            }
            
            countrycode = mobile.substring(to: mobile.index(mobile.startIndex, offsetBy: 3))
            if countrycode == countryInfos[i].phoneCode {
                cryptNumber = mobile.substring(from: mobile.index(mobile.startIndex, offsetBy: 3)).substring(to: mobile.characters.index(mobile.startIndex, offsetBy: 6)) +
                    fillCryptCode(count: mobile.count-9) +
                    mobile.substring(from: mobile.index(mobile.startIndex, offsetBy: mobile.count-3))
                break
            }
            
            countrycode = mobile.substring(to: mobile.index(mobile.startIndex, offsetBy: 2))
            if countrycode == countryInfos[i].phoneCode {
                cryptNumber = mobile.substring(from: mobile.index(mobile.startIndex, offsetBy: 2)).substring(to: mobile.characters.index(mobile.startIndex, offsetBy: 5
                )) +
                    fillCryptCode(count: mobile.count-8) +
                    mobile.substring(from: mobile.index(mobile.startIndex, offsetBy: mobile.count-3))
                break
            }
        }
        
        return cryptNumber
    }
    
    public static func getPhonePrefix(mobile: String) -> String {
        if mobile.characters.contains("+") == false {
            return ""
        }
        
        var prefix = ""
        
        for i in 0..<countryInfos.count {
            var countrycode = mobile.substring(to: mobile.characters.index(mobile.startIndex, offsetBy: 4))
            if countrycode == countryInfos[i].phoneCode {
                prefix = countrycode
                break
            }
            
            countrycode = mobile.substring(to: mobile.characters.index(mobile.startIndex, offsetBy: 3))
            if countrycode == countryInfos[i].phoneCode {
                prefix = countrycode
            }
            
            countrycode = mobile.substring(to: mobile.characters.index(mobile.startIndex, offsetBy: 2))
            if countrycode == countryInfos[i].phoneCode {
                prefix = countrycode
            }
        }
        
        return prefix
    }
    
    public static func getNativePhoneNumber(mobile: String) -> String {
        if mobile.characters.contains("+") == false {
            return mobile
        }
        
        var nativeNumber = ""
        
        for i in 0..<countryInfos.count {
            var countrycode = mobile.substring(to: mobile.characters.index(mobile.startIndex, offsetBy: 4))
            if countrycode == countryInfos[i].phoneCode {
                nativeNumber = mobile.substring(from: mobile.characters.index(mobile.startIndex, offsetBy: 4))
                break
            }
            
            countrycode = mobile.substring(to: mobile.characters.index(mobile.startIndex, offsetBy: 3))
            if countrycode == countryInfos[i].phoneCode {
                nativeNumber = mobile.substring(from: mobile.characters.index(mobile.startIndex, offsetBy: 3))
                break
            }
            
            countrycode = mobile.substring(to: mobile.characters.index(mobile.startIndex, offsetBy: 2))
            if countrycode == countryInfos[i].phoneCode {
                nativeNumber = mobile.substring(from: mobile.characters.index(mobile.startIndex, offsetBy: 2))
                break
            }
        }
        
        return nativeNumber
    }
    
    public static func fillCryptCode(count: Int) -> String {
        var result: String = ""
        for _ in 0..<count {
            result += "*"
        }
        return result
    }
}
