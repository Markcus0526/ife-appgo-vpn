//
//  Strings.swift
//  AppGoPro
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
    public func localizedFormat(_ arguments: CVarArg...) -> String {
        return String(format: localizedString(), arguments: arguments)
    }
    
    /**
     Swift 2 friendly plural localization syntax with a format argument
     
     - parameter argument: Argument to determine pluralisation
     
     - returns: Pluralized localized string.
     */
    public func localizedPlural(_ argument: CVarArg) -> String {
        return NSString.localizedStringWithFormat(localizedString() as NSString, argument) as String
    }
}


// MARK: Language Setting Functions

open class Localize: NSObject {
    open static let English: String = "en"
    open static let Chinese: String = "zh-Hans"
    
    /**
     List available languages
     - Returns: Array of available languages.
     */
    open class func availableLanguages() -> [String] {
        return Bundle.main.localizations
    }
    
    /**
     Current language
     - Returns: The current language. String.
     */
    open class func currentLanguage() -> String {
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
    open class func setCurrentLanguage(_ language: String) {
        let selectedLanguage = availableLanguages().contains(language) ? language : defaultLanguage()
        if (selectedLanguage != currentLanguage()) {
            AppPref.setCurLanguageCode(langID: selectedLanguage)
        }
    }
    
    /**
     Default language
     - Returns: The app's default language. String.
     */
    open class func defaultLanguage() -> String {
        var defaultLanguage: String = String()
        guard let preferredLanguage = Bundle.main.preferredLocalizations.first else {
            return Localize.English
        }
        let availableLanguages: [String] = self.availableLanguages()
        if (availableLanguages.contains(preferredLanguage)) {
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
    open class func resetCurrentLanguageToDefault() {
        setCurrentLanguage(self.defaultLanguage())
    }
    
    /**
     Get the current language's display name for a language.
     - Parameter language: Desired language.
     - Returns: The localized string.
     */
    open class func displayNameForLanguage(_ language: String) -> String {
        let locale : Locale = Locale(identifier: currentLanguage())
        if let displayName = (locale as NSLocale).displayName(forKey: NSLocale.Key.languageCode, value: language) {
            return displayName
        }
        return String()
    }
    
    open class func isChinese() -> Bool {
        let language = AppPref.getCurLanguageCode()
        if language == Localize.Chinese {
            return true
        } else {
            return false
        }
    }
    
    open class func getFlagName(_ code: String) -> String {
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
