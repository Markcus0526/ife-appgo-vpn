//
//  ViewExtension.swift
//  AppGoX
//
//  Created by user on 17.10.25.
//  Copyright © 2017 appgo. All rights reserved.
//

import AppKit

public extension NSView {

    public func setBackgroundColor(color: CGColor) {
        self.wantsLayer = true
        self.layer?.backgroundColor = color
    }
    
}
