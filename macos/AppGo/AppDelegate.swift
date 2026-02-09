//
//  AppDelegate.swift
//  AppGoX
//
//  Created by 邱宇舟 on 16/6/5.
//  Copyright © 2016年 appgo. All rights reserved.
//

import Cocoa
import Carbon
import Alamofire
import ServiceManagement
import NetworkExtension


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSUserNotificationCenterDelegate {
    
    var mainWindowCtrl: AGMainWindowController!

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var runningStatusMenuItem: NSMenuItem!
    @IBOutlet weak var toggleRunningMenuItem: NSMenuItem!
    @IBOutlet weak var internationalModeMenuItem: NSMenuItem!
    @IBOutlet weak var allModeMenuItem: NSMenuItem!
    @IBOutlet weak var serversMenuItem: NSMenuItem!
    @IBOutlet weak var launchAtLoginMenuItem: NSMenuItem!
    @IBOutlet weak var quitMenuItem: NSMenuItem!

    let kProfileMenuItemIndexBase = 100

    var statusItem: NSStatusItem!
    static let StatusItemIconWidth: CGFloat = NSVariableStatusItemLength
    var services: [MService]!
    var curService: MService?
    var ruleMode = "global"
    var vpnStatus = NEVPNStatus.disconnected
    var serviceUrlTimer: Timer?
    var timeCount: Int = 0
    var isConnecting: Bool = false
    
    func ensureLaunchAgentsDirOwner () {
        let dirPath = NSHomeDirectory() + "/Library/LaunchAgents"
        let fileMgr = FileManager.default
        if fileMgr.fileExists(atPath: dirPath) {
            do {
                let attrs = try fileMgr.attributesOfItem(atPath: dirPath)
                if attrs[FileAttributeKey.ownerAccountName] as! String != NSUserName() {
                    //try fileMgr.setAttributes([FileAttributeKey.ownerAccountName: NSUserName()], ofItemAtPath: dirPath)
                    let bashFilePath = Bundle.main.path(forResource: "fix_dir_owner.sh", ofType: nil)!
                    let script = "do shell script \"bash \\\"(bashFilePath)\\\" \(NSUserName()) \" with administrator privileges"
                    if let appleScript = NSAppleScript(source: script) {
                        var err: NSDictionary? = nil
                        appleScript.executeAndReturnError(&err)
                    }
                }
            }
            catch {
                NSLog("Error when ensure the owner of $HOME/Library/LaunchAgents, \(error.localizedDescription)")
            }
        }
    }
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        if AppPref.getVersionCode() != AppInfo.VersionCode {
            AppPref.removeOldData()
        }
        AppPref.setVersionCode(version: AppInfo.VersionCode)
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        var startedAtLogin = false
        for app in NSWorkspace.shared().runningApplications {
            if app.bundleIdentifier == AppInfo.bundleID {
                startedAtLogin = true
            }
        }
        
        // If the app's started, post to the notification center to kill the launcher app
        if startedAtLogin {
            DistributedNotificationCenter.default().postNotificationName(.LAUNCH_KILL_ME, object: Bundle.main.bundleIdentifier, userInfo: nil, options: DistributedNotificationCenter.Options.deliverImmediately)
        }
        
        // init IAP engine
        IAPManager.shared.startObserving()
        
        NSUserNotificationCenter.default.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.onLanguageChangeNotification(notification:)), name: .LANGUAGE_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onLoginChangeNotification(notification:)), name: .LOGIN_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onPurchaseChangeNotification(notification:)), name: .PURCHASE_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onPayChangeNotification(notification:)), name: .PAY_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onServerChangeNotification(notification:)), name: .SERVER_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onRuleModeChangeNotification(notification:)), name: .RULEMODE_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onServerListChangeNotification(notification:)), name: .SERVER_LIST_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onVpnStatusChangeNotification(notification:)), name: .VPN_STATUS_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onLaunchAtloginChangeNotification(notification:)), name: .LAUNCH_ATLOGIN_CHANGE, object: nil)
        
        // Prepare ss-local
        //self.ensureLaunchAgentsDirOwner()
        
        if AppPref.getCurLanguageCode() == "" {
            let locale = Locale.current.languageCode
            if locale == "zh" {
                AppPref.setCurLanguageCode(langID: Localize.Chinese)
            } else {
                AppPref.setCurLanguageCode(langID: Localize.English)
            }
        }
        
        // Prepare defaults
        AppPref.setVpnStatus(status: NEVPNStatus.disconnected.rawValue)
        AppPref.setRuleMode(mode: "global")
        services = AppPref.getAvailableServices()
        curService = AppPref.getCurrentService()
        vpnStatus = VpnManager.shared.isRunning()
        if vpnStatus == .connecting || vpnStatus == .disconnecting {
            VpnManager.shared.stop()
        }
      
        statusItem = NSStatusBar.system().statusItem(withLength: AppDelegate.StatusItemIconWidth)
        let image : NSImage = NSImage(named: "menu_icon_disabled")!
        //image.isTemplate = true
        statusItem.image = image
        statusItem.menu = statusMenu
        
        updateMainMenu()
        updateServersMenu()

        AppPref.setServiceUrl(url: "")
        let request = WSAPI.getAlamofireManager().request(WSAPI.BASE_URL, method: .get)
        request.responseData { response in
            let url = (String(data: response.data!, encoding: String.Encoding.utf8) as String?)!
            if !url.isEmpty {
                AppPref.setServiceUrl(url: (String(data: response.data!, encoding: String.Encoding.utf8) as String?)!.replacingOccurrences(of: "\n", with: ""))
                
                self.mainWindowCtrl = AGMainWindowController()
                self.mainWindowCtrl.window?.makeKeyAndOrderFront(self)
                NSApp.activate(ignoringOtherApps: true)
            } else {
                Alert.show(message: "\("can't connect to server.".localizedString())")
                NSApplication.shared().terminate(self)
            }
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        NotificationCenter.default.post(name: .APP_QUIT, object: nil)
        IAPManager.shared.stopObserving()
    }
    
    func applicationDidBecomeActive(_ notification: Notification) {
        if AppPref.isLogined() {
            self.serviceUrlTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.serviceUrlTimerAction), userInfo: nil, repeats: true)
        }
    }

    // MARK: - UI Methods
    @IBAction func toggleRunning(_ sender: NSMenuItem) {
        let vpnStatus = NEVPNStatus(rawValue: AppPref.getVpnStatus())!
        switch vpnStatus {
        case .disconnecting:
            break
        case .connecting:
            break
        case .connected:
            self.disconnectVPN()
        case .disconnected:
            if curService == nil {
                Alert.toast(message: "\("please select vpn server.".localizedString())")
            } else {
                AppPref.setRuleMode(mode: self.ruleMode)
                self.connectVPN()
            }
        case .reasserting:
            self.disconnectVPN()
        default:
            break
        }
    }

    @IBAction func selectInternationalMode(_ sender: NSMenuItem) {
        AppPref.setRuleMode(mode: "web browser")

        NotificationCenter.default.post(name: .RULEMODE_CHANGE, object: nil)
    }
    
    @IBAction func selectGlobalMode(_ sender: NSMenuItem) {
        AppPref.setRuleMode(mode: "global")
        
        NotificationCenter.default.post(name: .RULEMODE_CHANGE, object: nil)
    }
    
    @IBAction func launchAtLogin(_ sender: NSMenuItem) {
        let enabled = launchAtLoginMenuItem.state == 1 ? false : true
        
        if SMLoginItemSetEnabled(AppInfo.launcherID as CFString, enabled) {
            launchAtLoginMenuItem.state = enabled ? 1 : 0
            AppPref.setLaunchAtLogin(enable: enabled)
        }
        
        NotificationCenter.default.post(name: .LAUNCH_ATLOGIN_CHANGE, object: nil)
    }
    
    @IBAction func quitApp(_ sender: NSMenuItem) {
    }
    
    @IBAction func selectServer(_ sender: NSMenuItem) {
        let index = sender.tag - kProfileMenuItemIndexBase        
        
        let selService = AppPref.getCurrentService()
        
        if selService == nil || selService != nil && selService?.country_id != services[index].country_id {
            curService = services[index]
            AppPref.setCurrentService(service: curService)
        }
        
        NotificationCenter.default.post(name: .SERVER_CHANGE, object: nil)
    }
    
    func onVpnStatusChangeNotification(notification:Notification) {
        if let status = notification.userInfo?["status"] as? NEVPNStatus {
            if status != vpnStatus {
                vpnStatus = status
                AppPref.setVpnStatus(status: status.rawValue)
                updateUIConnectStatus()
            }
        }
    }
    
    func onRuleModeChangeNotification(notification:Notification) {
        let isLogined = AppPref.isLogined()
        let mode = AppPref.getRuleMode()
        
        if isLogined {
            internationalModeMenuItem.isHidden = false
            allModeMenuItem.isHidden = false
            internationalModeMenuItem.title = "web browser".localizedString()
            allModeMenuItem.title = "global".localizedString()

            if mode == "web browser" {
                internationalModeMenuItem.state = 1
                allModeMenuItem.state = 0
            } else if mode == "global" {
                internationalModeMenuItem.state = 0
                allModeMenuItem.state = 1
            }
        } else {
            internationalModeMenuItem.isHidden = true
            allModeMenuItem.isHidden = true
        }
    }
    
    func onLanguageChangeNotification(notification:Notification) {
        updateMainMenu()
    }
    
    func onServerChangeNotification(notification:Notification) {
        updateMainMenu()
    }
    
    func onLoginChangeNotification(notification:Notification) {
        updateMainMenu()
    }
    
    func onPurchaseChangeNotification(notification:Notification) {
        updateMainMenu()
    }
    
    func onServerListChangeNotification(notification:Notification) {
        updateServersMenu()        
    }
    
    func onPayChangeNotification(notification:Notification) {
        updateMainMenu()
    }
    
    func onLaunchAtloginChangeNotification(notification:Notification) {
        updateMainMenu()
    }
    
    func updateMainMenu() {
        let isLogined = AppPref.isLogined()
        if isLogined {
            runningStatusMenuItem.isHidden = false
            toggleRunningMenuItem.isHidden = false
            launchAtLoginMenuItem.isHidden = false
            
            let vpnStatus = NEVPNStatus(rawValue: AppPref.getVpnStatus())!
            if vpnStatus == .connected {
                runningStatusMenuItem.title = "appgo: on".localizedString()
                toggleRunningMenuItem.title = "turn appgo off".localizedString()
                let image = NSImage(named: "menu_icon")
                statusItem.image = image
                
                serversMenuItem.isEnabled = false
            } else {
                runningStatusMenuItem.title = "appgo: off".localizedString()
                toggleRunningMenuItem.title = "turn appgo on".localizedString()
                let image = NSImage(named: "menu_icon_disabled")
                statusItem.image = image
                
                serversMenuItem.isEnabled = true
            }
            
            if AppPref.getLaunchAtLogin() {
                launchAtLoginMenuItem.state = 1
            } else {
                launchAtLoginMenuItem.state = 0
            }
            
            launchAtLoginMenuItem.title = "launch at login".localizedString()
            quitMenuItem.title = "quit".localizedString()
        } else {
            runningStatusMenuItem.isHidden = true
            toggleRunningMenuItem.isHidden = true
            launchAtLoginMenuItem.isHidden = true
        }
        updateServersMenu()
    }
    
    func updateUIConnectStatus() {
        let vpnStatus = NEVPNStatus(rawValue: AppPref.getVpnStatus())!
        if vpnStatus == .connected {
            statusItem.image = NSImage(named: "menu_icon")
            
            runningStatusMenuItem.title = "appgo: on".localizedString()
            toggleRunningMenuItem.title = "turn appgo off".localizedString()
            let image = NSImage(named: "menu_icon")
            statusItem.image = image
            serversMenuItem.isEnabled = false
        } else {
            statusItem.image = NSImage(named: "menu_icon_disabled")
            
            runningStatusMenuItem.title = "appgo: off".localizedString()
            toggleRunningMenuItem.title = "turn appgo on".localizedString()
            let image = NSImage(named: "menu_icon_disabled")
            statusItem.image = image
            
            serversMenuItem.isEnabled = true
        }
    }
    
    func updateServersMenu() {
        let isLogined = AppPref.isLogined()
        
        if isLogined {
            serversMenuItem.isHidden = false
            
            curService = AppPref.getCurrentService()
            var serverMenuText = "server".localizedString()
            if curService != nil {
                serverMenuText = "\(serverMenuText) - \(Country.getCountryName(code: curService!.country_name, locale: AppPref.getCurLanguageCode()))"
            }
            
            services = AppPref.getAvailableServices()            
            serversMenuItem.title = serverMenuText
            
            guard let menu = serversMenuItem.submenu else { return }
            
            menu.removeAllItems()
            
            for (i, service) in services.enumerated() {
                var title: String = ""
                if Localize.isChinese() { // chinese
                    title = service.country_alias_zh
                } else {
                    title = service.country_alias_en
                }
                
                let menuItem = NSMenuItem(title: title, action: #selector(selectServer(_:)), keyEquivalent: title)
                menuItem.tag = kProfileMenuItemIndexBase + i
                menuItem.target = self
                if curService != nil && curService?.country_id == service.country_id {
                    menuItem.state = 1
                } else {
                    menuItem.state = 0
                }
                
                menu.addItem(menuItem)
            }
        } else {
            serversMenuItem.isHidden = true
        }
    }
   
    //------------------------------------------------------------
    // NSUserNotificationCenterDelegate
    
    func userNotificationCenter(_ center: NSUserNotificationCenter
        , shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }    
    
    func serviceUrlTimerAction() {
        let url = AppPref.getServiceUrl()
        if url != "" {
            serviceUrlTimer?.invalidate()
            serviceUrlTimer = nil
            timeCount = 0
            
            self.checkLoginState()
        } else if timeCount > 20 {
            serviceUrlTimer?.invalidate()
            serviceUrlTimer = nil
            timeCount = 0
            
            AppPref.clearLoginInfo()
            NotificationCenter.default.post(name: .LOGIN_CHANGE, object: nil)
        }
        timeCount += 1
    }
    
    func connectingTimerAction() {
        Alert.toast(message: "\("failed to switch vpn.".localizedString())")
        disconnectVPN()
    }
    
    func connectVPN() {
        if self.curService == nil {return}
        self.isConnecting = true
        
        let access_token = AppPref.getAccessToken()
        let touristId = AppPref.getTouristId()
        let request: Alamofire.DataRequest?
        
        if AppPref.isLogined() {
            request = WSAPI.getAlamofireManager().request(WSAPI.Path.UserServices.url,
                                                          method: .get,
                                                          parameters: nil,
                                                          encoding: URLEncoding.default,
                                                          headers: ["Accept": WSAPI.HEADER_ACCEPT, "Authorization": "Bearer " + access_token])
        } else {
            request = WSAPI.getAlamofireManager().request(WSAPI.Path.TouristServices.url,
                                                          method: .get,
                                                          parameters: nil,
                                                          encoding: URLEncoding.default,
                                                          headers: ["Accept": WSAPI.HEADER_ACCEPT, "Tourist-Id": touristId])
        }
        request?.responseData(completionHandler: { response in
            var services: [MService] = Array()
            let successResult = WSAPI.successResult(response: response.response)
            if successResult {
                let data = response.result.value
                if data != nil {
                    let array = NSDataUtils.nsdataToJSON(data: data!) as? NSArray
                    if array != nil {
                        for item in array! {
                            let service = MService(data: item as! NSDictionary)
                            if CommonUtils.validService(service: service) {
                                services.append(service)
                            }
                            if self.curService?.country_id == service.country_id {
                                if !CommonUtils.validService(service: service) {
                                    Alert.toast(message: "\("your vpn server is expired now.".localizedString())")
                                    self.curService = nil
                                } else {
                                    self.curService = service
                                }
                            }
                        }
                    } else {
                        self.curService = nil
                    }
                } else {
                    self.curService = nil
                }
            } else {
                Alert.toast(data: response.data)
                self.curService = nil
            }
            
            AppPref.setCurrentService(service: self.curService)
            AppPref.setAvailableServices(services: services)
            NotificationCenter.default.post(name: .SERVER_CHANGE, object: nil)
            if self.curService != nil {
                NotificationCenter.default.post(name: .VPN_STATUS_CHANGE, object: nil, userInfo: ["status": NEVPNStatus.connecting])
                VpnManager.shared.start() { (error) in
                    if error != AppGoVpn.ErrorCode.noError {
                        if error == AppGoVpn.ErrorCode.vpnPermissionNotGranted || error == AppGoVpn.ErrorCode.noAdminPermissions {
                            Alert.toast(message: "choose allow option to authorize".localizedString())
                        } else {
                            Alert.toast(message: "failed to switch vpn.".localizedString() + "Error code: \(String(describing: error))")
                        }
                    }
                    CommonUtils.delayWithSeconds(1) {
                        DispatchQueue.main.async {
                            self.isConnecting = false
                        }
                    }
                }
            } else {
                NotificationCenter.default.post(name: .SERVER_CHANGE, object: nil)
                DispatchQueue.main.async {
                    self.isConnecting = false
                }
            }
        })
    }
    
    private func disconnectVPN() {
        self.isConnecting = true
        NotificationCenter.default.post(name: .VPN_STATUS_CHANGE, object: nil, userInfo: ["status": NEVPNStatus.disconnecting])
        
        CommonUtils.delayWithSeconds(2) {
            VpnManager.shared.stop() { (error) in
                CommonUtils.delayWithSeconds(2) {
                    let access_token = AppPref.getAccessToken()
                    let touristId = AppPref.getTouristId()
                    let request: Alamofire.DataRequest?
                    
                    if AppPref.isLogined() {
                        request = WSAPI.getAlamofireManager().request(WSAPI.Path.UserServices.url,
                                                                      method: .get,
                                                                      parameters: nil,
                                                                      encoding: URLEncoding.default,
                                                                      headers: ["Accept": WSAPI.HEADER_ACCEPT, "Authorization": "Bearer " + access_token])
                    } else {
                        request = WSAPI.getAlamofireManager().request(WSAPI.Path.TouristServices.url,
                                                                      method: .get,
                                                                      parameters: nil,
                                                                      encoding: URLEncoding.default,
                                                                      headers: ["Accept": WSAPI.HEADER_ACCEPT, "Tourist-Id": touristId])
                    }
                    request?.responseData(completionHandler: { response in
                        var services: [MService] = Array()
                        let successResult = WSAPI.successResult(response: response.response)
                        if successResult {
                            let json = NSDataUtils.nsdataToJSON(data: response.result.value!)
                            let array = json as? NSArray
                            if array != nil {
                                if (array?.count)! > 0 {
                                    for item in array! {
                                        let service = MService(data: item as! NSDictionary)
                                        if CommonUtils.validService(service: service) {
                                            services.append(service)
                                        }
                                        if self.curService?.country_id == service.country_id {
                                            if !CommonUtils.validService(service: service) {
                                                Alert.toast(message: "\("your vpn server is expired now.".localizedString())")
                                                self.curService = nil
                                            } else {
                                                self.curService = service
                                            }
                                        }
                                    }
                                } else {
                                    self.curService = nil
                                }
                            } else {
                                self.curService = nil
                            }
                        } else {
                            //Alert.toast(data: response.data)
                            //self.curService = nil
                        }
                        AppPref.setCurrentService(service: self.curService)
                        AppPref.setAvailableServices(services: services)
                        NotificationCenter.default.post(name: .SERVER_CHANGE, object: nil)
                        
                        DispatchQueue.main.async {
                            self.isConnecting = false
                        }
                    })
                }
            }
        }
    }
    
    func startVpn() {
        VpnManager.shared.start() { (error) in
            if error != AppGoVpn.ErrorCode.noError {
                if error == AppGoVpn.ErrorCode.vpnPermissionNotGranted || error == AppGoVpn.ErrorCode.noAdminPermissions {
                    Alert.toast(message: "choose allow option to authorize".localizedString())
                } else {
                    Alert.toast(message: "failed to switch vpn.".localizedString())
                }
            }
        }
    }
    
    func stopVpn() {
        VpnManager.shared.stop() { (error) in
            if error != AppGoVpn.ErrorCode.noError {
                if error == AppGoVpn.ErrorCode.vpnPermissionNotGranted || error == AppGoVpn.ErrorCode.noAdminPermissions {
                    Alert.toast(message: "choose allow option to authorize".localizedString())
                } else {
                    Alert.toast(message: "failed to switch vpn.".localizedString())
                }
            }
        }
    }
    
    func updateServiceData() {
        self.isConnecting = true

        let access_token = AppPref.getAccessToken()
        let touristId = AppPref.getTouristId()
        let request: Alamofire.DataRequest?
        if AppPref.isLogined() {
            request = WSAPI.getAlamofireManager().request(WSAPI.Path.UserServices.url,
                                                          method: .get,
                                                          parameters: nil,
                                                          encoding: URLEncoding.default,
                                                          headers: ["Accept": WSAPI.HEADER_ACCEPT, "Authorization": "Bearer " + access_token])
        } else {
            request = WSAPI.getAlamofireManager().request(WSAPI.Path.TouristServices.url,
                                                          method: .get,
                                                          parameters: nil,
                                                          encoding: URLEncoding.default,
                                                          headers: ["Accept": WSAPI.HEADER_ACCEPT, "Tourist-Id": touristId])
        }
        request?.responseData(completionHandler: { response in
            var services: [MService] = Array()
            let successResult = WSAPI.successResult(response: response.response)
            if successResult {
                let json = NSDataUtils.nsdataToJSON(data: response.result.value!)
                let array = json as? NSArray
                if array != nil {
                    if (array?.count)! > 0 {
                        for item in array! {
                            let service = MService(data: item as! NSDictionary)
                            if CommonUtils.validService(service: service) {
                                services.append(service)
                            }
                            if self.curService != nil && self.curService?.country_id == service.country_id {
                                if !CommonUtils.validService(service: service) {
                                    let status = NEVPNStatus(rawValue: AppPref.getVpnStatus())!
                                    if status == .connected {
                                        Alert.toast(message: "\("your vpn server is expired now.".localizedString())")
                                        self.disconnectVPN()
                                    }
                                } else {
                                    self.curService = service
                                }
                            }
                        }
                    } else {
                        self.curService = nil
                    }
                } else {
                    self.curService = nil
                }
            } else {
                self.curService = nil
            }
            
            AppPref.setCurrentService(service: self.curService)
            AppPref.setAvailableServices(services: services)
            NotificationCenter.default.post(name: .SERVER_CHANGE, object: nil)
            
            DispatchQueue.main.async {
                self.isConnecting = false
            }
        })
    }
    
    func checkLoginState() {
        let phonenumber = AppPref.getLastLoginPhoneNumber()
        let password = AppPref.getLastLoginPassword()
        let request = WSAPI.getAlamofireManager().request(WSAPI.Path.Login.url,
                                                          method: .post,
                                                          parameters: ["username": phonenumber, "password": password, "client_id": WSAPI.CLIENT_ID, "client_secret": WSAPI.CLIENT_SECRET, "grant_type": "password"],
                                                          headers: ["Accept": WSAPI.HEADER_ACCEPT, "Content-Language": AppPref.getServiceLanguage()])
        request.responseData { response in
            let successResult = WSAPI.successResult(response: response.response)
            if successResult {
                let json = NSDataUtils.nsdataToJSON(data: response.result.value!)                
                if json == nil {
                    AppPref.clearUserInfo()
                    URLCache.shared.removeAllCachedResponses()
                    
                    NotificationCenter.default.post(name: .LOGIN_CHANGE, object: nil, userInfo: ["status": false])
                } else {
                    AppPref.setAccessToken(token: json!["access_token"] as! String)
                    AppPref.setRefreshToken(token: json!["refresh_token"] as! String)
                }
            } else {
                AppPref.clearUserInfo()
                URLCache.shared.removeAllCachedResponses()
                
                NotificationCenter.default.post(name: .LOGIN_CHANGE, object: nil, userInfo: ["status": false])
            }
        }
    }
}

