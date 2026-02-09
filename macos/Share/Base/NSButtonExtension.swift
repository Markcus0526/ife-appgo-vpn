//
//  NSButtonExtension.swift
//  AppGoX
//
//  Created by user on 17.10.27.
//  Copyright © 2017 appgo. All rights reserved.
//

import AppKit

public extension NSButton {

    public func setTextColor(textColor: CGColor) {
        let attributedString: NSMutableAttributedString = NSMutableAttributedString.init(attributedString: attributedTitle)
        attributedString.removeAttribute(NSForegroundColorAttributeName, range: NSRange.init(location: 0, length: attributedString.string.count))
        attributedString.addAttribute(NSForegroundColorAttributeName, value: NSColor.init(cgColor: textColor), range: NSRange.init(location: 0, length: attributedString.string.count))
        attributedTitle = attributedString
    }
    
}
