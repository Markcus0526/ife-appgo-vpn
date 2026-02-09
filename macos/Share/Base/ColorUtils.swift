//
//  ColorExtension.swift
//  AppGoX
//
//  Created by user on 17.10.24.
//  Copyright © 2017 appgo. All rights reserved.
//

import Foundation
import AppKit


public extension CGColor {
    
    public static func color(red: Int, green: Int, blue: Int, alpha: CGFloat) -> CGColor {
        let fRed: CGFloat = (CGFloat)((Float)(red) / 256)
        let fGreen: CGFloat = (CGFloat)((Float)(green) / 256)
        let fBlue: CGFloat = (CGFloat)((Float)(blue) / 256)
        return CGColor.init(red: fRed, green: fGreen, blue: fBlue, alpha: alpha)
    }
 
    public static var agMainColor: CGColor {
        return CGColor.color(red: 0x58, green: 0xc7, blue: 0xff, alpha: 1)
    }
    
    public static var agDarkBlueColor: CGColor {
        return CGColor.color(red: 0x37, green: 0x96, blue: 0xc6, alpha: 1)
    }
    
    public static var agLightBlueColor: CGColor {
        return CGColor.color(red: 0x93, green: 0xdb, blue: 0xff, alpha: 1)
    }
    
    public static var agLightGreyColor: CGColor {
        return CGColor.color(red: 0xdd, green: 0xdd, blue: 0xdd, alpha: 1)
    }
    
    public static var agGreyColor: CGColor {
        return CGColor.color(red: 0xaa, green: 0xaa, blue: 0xaa, alpha: 1)
    }
    
    public static var agDarkGreyColor: CGColor {
        return CGColor.color(red: 0xcc, green: 0xcc, blue: 0xcc, alpha: 1)
    }
    
    public static var agYellowColor: CGColor {
        return CGColor.color(red: 0xff, green: 0xe4, blue: 0x01, alpha: 1)
    }
    
    public static var agWhiteColor: CGColor {
        return CGColor.color(red: 0xff, green: 0xff, blue: 0xff, alpha: 1)
    }
}

public extension NSColor {
    
    /**
     Returns an NSColor instance from the given hex value
     
     - parameter rgbValue: The hex value to be used for the color
     - parameter alpha:    The alpha value of the color
     
     - returns: A NSColor instance from the given hex value
     */
    public class func hexColor(rgbValue: Int, alpha: CGFloat = 1.0) -> NSColor {
        return NSColor(red: ((CGFloat)((rgbValue & 0xFF0000) >> 16))/255.0, green:((CGFloat)((rgbValue & 0xFF00) >> 8))/255.0, blue:((CGFloat)(rgbValue & 0xFF))/255.0, alpha:alpha)
        
    }
}
