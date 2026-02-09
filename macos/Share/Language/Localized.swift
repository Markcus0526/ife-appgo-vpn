//
//  Strings.swift
//  Appsocks
//
//  Created by LEI on 1/23/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

import Foundation


public extension String {
    /**
     Swift 2 friendly localization syntax, replaces NSLocalizedString
     - Returns: The localized string.
     */
    public func localizedString() -> String {
        if let path = Bundle.main.path(forResource: Localize.currentLanguage(), ofType: "lproj"), let bundle = Bundle(path: path) {
            return bundle.localizedString(forKey: self, value: nil, table: nil)
        } else if let path = Bundle.main.path(forResource: "Base", ofType: "lproj"), let bundle = Bundle(path: path) {
            return bundle.localizedString(forKey: self, value: nil, table: nil)
        }
        return self
    }
    
    /**
     Swift 2 friendly localization syntax with format arguments, replaces String(format:NSLocalizedString)
     - Returns: The formatted localized string with arguments.
     */
    public func localizedFormat(arguments: CVarArg...) -> String {
        return String(format: localizedString(), arguments: arguments)
    }
    
    /**
     Swift 2 friendly plural localization syntax with a format argument
     
     - parameter argument: Argument to determine pluralisation
     
     - returns: Pluralized localized string.
     */
    public func localizedPlural(argument: CVarArg) -> String {
        return NSString.localizedStringWithFormat(localizedString() as NSString, argument) as String
    }
}


// MARK: Language Setting Functions

public class Localize: NSObject {
    public static let English: String = "en"
    public static let Chinese: String = "zh-Hans"
    
    /**
     List available languages
     - Returns: Array of available languages.
     */
    public class func availableLanguages() -> [String] {
        return Bundle.main.localizations
    }
    
    /**
     Current language
     - Returns: The current language. String.
     */
    public class func currentLanguage() -> String {
        let langCode = AppPref.getCurLanguageCode()
        if langCode == "" {
            return defaultLanguage()
        } else {
            return langCode
        }
    }
    
    /**
     Change the current language
     - Parameter language: Desired language.
     */
    public class func setCurrentLanguage(language: String) {
        let selectedLanguage = availableLanguages().contains(language) ? language : defaultLanguage()
        if selectedLanguage != currentLanguage() {
            AppPref.setCurLanguageCode(langID: selectedLanguage)
        }
    }
    
    /**
     Default language
     - Returns: The app's default language. String.
     */
    public class func defaultLanguage() -> String {
        var defaultLanguage: String = String()
        guard let preferredLanguage = Bundle.main.preferredLocalizations.first else {
            return Localize.English
        }
        let availableLanguages: [String] = self.availableLanguages()
        if availableLanguages.contains(preferredLanguage) {
            defaultLanguage = preferredLanguage
        }
        else {
            defaultLanguage = Localize.English
        }
        return defaultLanguage
    }
    
    /**
     Resets the current language to the default
     */
    public class func resetCurrentLanguageToDefault() {
        setCurrentLanguage(language: self.defaultLanguage())
    }
    
    /**
     Get the current language's display name for a language.
     - Parameter language: Desired language.
     - Returns: The localized string.
     */
    public class func displayNameForLanguage(language: String) -> String {
        let locale : NSLocale = NSLocale(localeIdentifier: currentLanguage())
        if let displayName = locale.displayName(forKey: NSLocale.Key.languageCode, value: language) {
            return displayName
        }
        return String()
    }
    
    public class func isChinese() -> Bool {
        let language = AppPref.getCurLanguageCode()
        if language == Localize.Chinese {
            return true
        } else {
            return false
        }
    }
    
    public class func getFlagName(code: String) -> String {
        var flag: String = ""
        
        switch code {
        case Localize.Chinese:
            flag = "ic_flag_cn"
        default:
            flag = "ic_flag_us"
        }
        
        return flag
    }
}
