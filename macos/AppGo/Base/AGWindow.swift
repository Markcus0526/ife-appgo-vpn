//
//  AGWindow.swift
//  AppGoX
//
//  Created by user on 17.10.27.
//  Copyright © 2017 appgo. All rights reserved.
//

import Cocoa

class AGWindow: NSWindow {

    override public init(contentRect: NSRect, styleMask style: NSWindowStyleMask, backing bufferingType: NSBackingStoreType, defer flag: Bool) {
        
        super.init(contentRect: contentRect, styleMask: NSWindowStyleMask(rawValue: NSWindow.StyleMask.RawValue(UInt8(NSWindowStyleMask.borderless.rawValue) | UInt8(NSWindowStyleMask.miniaturizable.rawValue))), backing: bufferingType, defer: flag)
        
        isMovableByWindowBackground = true
        hasShadow = true
    }
    
    override var canBecomeKey: Bool {
        return true
    }
    
}
