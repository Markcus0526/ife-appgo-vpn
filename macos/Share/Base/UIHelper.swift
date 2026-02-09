//
//  UIHelper.swift
//  AppGoX
//
//  Created by user on 17.10.25.
//  Copyright © 2017 appgo. All rights reserved.
//

import Cocoa

class UIHelper {
    
    private static var instance: UIHelper!
    
    public static func sharedInstance() -> UIHelper {
        if instance == nil {
            instance = UIHelper.init()
        }
        
        return instance
    }

    public func applyButtonDefaultStyle(button: NSButton, titleKey: String) {
        applyButtonDefaultStyle(button: button, titleKey: titleKey, textSize: 14)
    }
    
    public func applyButtonDefaultStyle(button: NSButton, titleKey: String, textSize: Int) {
        let titleString: String = titleKey.localizedString()
        let title: NSMutableAttributedString = NSMutableAttributedString.init(string: titleString)
        title.addAttribute(NSForegroundColorAttributeName, value: NSColor.white, range: NSRange.init(location: 0, length: titleString.count))
        
        let style: NSMutableParagraphStyle = NSMutableParagraphStyle.init()
        style.alignment = NSCenterTextAlignment
        title.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSRange.init(location: 0, length: titleString.count))
        
        let font: NSFont = NSFont.systemFont(ofSize: CGFloat(textSize))
        title.addAttribute(NSFontAttributeName, value: font, range: NSRange.init(location: 0, length: titleString.count))
        
        button.attributedTitle = title
    }
    
    public func applyButtonMainColorStyle(button: NSButton, titleKey: String) {
        let titleString: String = titleKey.localizedString()
        let title: NSMutableAttributedString = NSMutableAttributedString.init(string: titleString)
        title.addAttribute(NSForegroundColorAttributeName, value: NSColor.init(cgColor: CGColor.agMainColor), range: NSRange.init(location: 0, length: titleString.count))
        
        let style: NSMutableParagraphStyle = NSMutableParagraphStyle.init()
        style.alignment = NSCenterTextAlignment
        title.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSRange.init(location: 0, length: titleString.count))
        
        let font: NSFont = NSFont.systemFont(ofSize: 14)
        title.addAttribute(NSFontAttributeName, value: font, range: NSRange.init(location: 0, length: titleString.count))
        
        button.attributedTitle = title
    }
    
    public func applyButtonWhiteRoundedRectStyle(button: NSButton, titleKey: String) {
        let titleString: String = titleKey.localizedString()
        let title: NSMutableAttributedString = NSMutableAttributedString.init(string: titleString)
        title.addAttribute(NSForegroundColorAttributeName, value: NSColor.init(cgColor: CGColor.white), range: NSRange.init(location: 0, length: titleString.count))
        
        let style: NSMutableParagraphStyle = NSMutableParagraphStyle.init()
        style.alignment = NSCenterTextAlignment
        title.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSRange.init(location: 0, length: titleString.count))
        
        button.attributedTitle = title
        
        button.wantsLayer = true
        button.layer?.borderColor = CGColor.white
        button.layer?.borderWidth = 1
        button.layer?.cornerRadius = 5
    }
    
    public func applyViewWhiteRoundedRectStyle(view: NSView) {
        view.wantsLayer = true
        view.layer?.borderColor = CGColor.white
        view.layer?.borderWidth = 1
        view.layer?.cornerRadius = 5
    }
}
