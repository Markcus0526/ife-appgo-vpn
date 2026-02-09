//
//  AGSettingsViewController.swift
//  AppGoX
//
//  Created by user on 17.10.26.
//  Copyright © 2017 appgo. All rights reserved.
//

import Cocoa
import ServiceManagement

class AGSettingsViewController: BaseViewController {

    @IBOutlet weak var vwTitleBar: NSView!
    @IBOutlet weak var lblTitle: NSTextField!
    
    @IBOutlet weak var vwLanguage: NSView!
    @IBOutlet weak var vwFeedback: NSView!
    @IBOutlet weak var vwFAQ: NSView!
    @IBOutlet weak var lblLanguage: NSTextField!
    @IBOutlet weak var lblPreference: NSTextField!
    @IBOutlet weak var lblFAQ: NSTextField!
    @IBOutlet weak var lblCurrentLanguage: NSTextField!    
    @IBOutlet weak var btnLaunchAtLogin: NSButton!
    
    private var languageMenu: NSMenu!
    
    var curLangCode: String = ""
    var languages:[MCountry] = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        curLangCode = AppPref.getCurLanguageCode()
        
        let item = NSMutableDictionary()
        
        item[MCountry.KEY_ID] = 1
        item[MCountry.KEY_NAME] = Localize.English
        item[MCountry.KEY_NAME_EN] = "english"
        item[MCountry.KEY_NAME_ZH] = "english".localizedString()
        
        var language = MCountry(data: item)
        languages.append(language)
        
        item[MCountry.KEY_ID] = 2
        item[MCountry.KEY_NAME] = Localize.Chinese
        item[MCountry.KEY_NAME_EN] = "chinese"
        item[MCountry.KEY_NAME_ZH] = "chinese".localizedString()
        
        language = MCountry(data: item)
        languages.append(language)
        
        configureUI()
    }
    
    override func onLanguageChangeNotification(notification: Notification) {
        lblTitle.stringValue = "settings".localizedString()
        lblLanguage.stringValue = "language".localizedString()
        lblPreference.stringValue = "launch at login".localizedString()
        lblFAQ.stringValue = "help".localizedString()
    }
    
    override func onLaunchAtloginChangeNotification(notification:Notification) {
        configureUI()
    }
    
    private func configureUI() {
        vwTitleBar.setBackgroundColor(color: CGColor.agMainColor)
        
        vwLanguage.setBackgroundColor(color: CGColor.init(red: 0xdd, green: 0xdd, blue: 0xdd, alpha: 1))
        vwFeedback.setBackgroundColor(color: CGColor.init(red: 0xdd, green: 0xdd, blue: 0xdd, alpha: 1))
        vwFAQ.setBackgroundColor(color: CGColor.init(red: 0xdd, green: 0xdd, blue: 0xdd, alpha: 1))
        
        if curLangCode == "en" {
            lblCurrentLanguage.stringValue = "English"
        } else if curLangCode == "zh-Hans" {
            lblCurrentLanguage.stringValue = "中文"
        }
        
        languageMenu = NSMenu()
        
        let miEnglish: NSMenuItem = NSMenuItem.init(title: "English", action: #selector(onLanguageMenuItemSelected(sender:)), keyEquivalent: "english")
        
        let miChinese: NSMenuItem = NSMenuItem.init(title: "中文", action: #selector(onLanguageMenuItemSelected(sender:)), keyEquivalent: "chinese")
        
        miEnglish.target = self
        miChinese.target = self
        
        languageMenu.addItem(miEnglish)
        languageMenu.addItem(miChinese)
        
        btnLaunchAtLogin.state = AppPref.getLaunchAtLogin() ? 1 : 0
    }
    
    @IBAction func onBackButtonClicked(_ sender: NSButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func onLanguageButtonClicked(_ sender: NSButton) {
        languageMenu.popUp(positioning: languageMenu.item(at: 0), at: NSPoint.init(x: 280, y: 500), in: view)
    }
    
    @IBAction func onStartupButtonClicked(_ sender: NSButton) {
        let enabled = btnLaunchAtLogin.state == 1 ? true : false
        
        if SMLoginItemSetEnabled(AppInfo.launcherID as CFString, enabled) {
            AppPref.setLaunchAtLogin(enable: enabled)
            NotificationCenter.default.post(name: .LAUNCH_ATLOGIN_CHANGE, object: nil)
        }
    }
    
    /*@IBAction func onPreferenceButtonClicked(_ sender: NSButton) {
        if allInOnePreferencesWinCtrl != nil {
            allInOnePreferencesWinCtrl.close()
        }
        
        allInOnePreferencesWinCtrl = PreferencesWinController(windowNibName: "PreferencesWinController")
        
        allInOnePreferencesWinCtrl.showWindow(self)
        NSApp.activate(ignoringOtherApps: true)
        allInOnePreferencesWinCtrl.window?.makeKeyAndOrderFront(self)
    }*/
    
    @IBAction func onFAQButtonClicked(_ sender: NSButton) {
        
    }
    
    func onLanguageMenuItemSelected(sender: NSMenuItem) {
        if sender.keyEquivalent == "english" {
            curLangCode = languages[0].name
            lblCurrentLanguage.stringValue = "English"
        } else if sender.keyEquivalent == "chinese" {
            curLangCode = languages[1].name
            lblCurrentLanguage.stringValue = "中文"
        }
        
        if AppPref.getCurLanguageCode() != curLangCode {
            AppPref.setCurLanguageCode(langID: curLangCode)
            Localize.setCurrentLanguage(language: curLangCode)
            NotificationCenter.default.post(name: .LANGUAGE_CHANGE, object: nil)
        } 
        
    }
}
