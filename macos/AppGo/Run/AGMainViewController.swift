//
//  AGMainViewController.swift
//  AppGoX
//
//  Created by user on 17.10.25.
//  Copyright © 2017 appgo. All rights reserved.
//

import Cocoa
import Alamofire
import ProgressKit
import NetworkExtension


class AGMainViewController: BaseViewController, ServerSelectedEvent {
    
    @IBOutlet weak var btnConnect: NSButton!
    @IBOutlet weak var lblConnectState: NSTextField!
    @IBOutlet weak var lblServerLabel: NSTextField!
    @IBOutlet weak var lblServerName: NSTextField!
    @IBOutlet weak var ivServerCountryFlag: NSImageView!
    @IBOutlet weak var imgConnected: NSImageView!
    @IBOutlet weak var btnSelectServer: NSButton!
    @IBOutlet weak var btnSelectOnServer: NSButton!
    @IBOutlet weak var lblAccelerationConfig: NSTextField!
    @IBOutlet weak var btnInternational: NSButton!
    @IBOutlet weak var btnGlobal: NSButton!
    @IBOutlet weak var lblNetworkUsageTitle: NSTextField!
    @IBOutlet weak var lblNetworkUsageStatus: NSTextField!
    @IBOutlet weak var vwNetworkUsageBar: NSView!
    @IBOutlet weak var vwNetworkUsageHighlight: NSView!
    @IBOutlet weak var lblUsageExpireTimeTitle: NSTextField!
    @IBOutlet weak var lblUsageExpireTime: NSTextField!
    @IBOutlet weak var lblPerson: NSTextField!
    @IBOutlet weak var lblShop: NSTextField!
    @IBOutlet weak var lblSettings: NSTextField!
    @IBOutlet weak var lblNotification: NSTextField!
    @IBOutlet weak var vwNotification: NSView!
    @IBOutlet weak var lblFirstNotification: NSTextField!
    @IBOutlet weak var tvServerList: NSTableView!
    @IBOutlet weak var serverListContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var usageHighlightWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var pgLoading: Crawler!
    @IBOutlet weak var imgBadge: NSImageView!
    
    private var connectImages: [NSImage] = []
    private var connectImageIndex: Int = -1
    public var services: [MService] = [MService].init()
    public var curService:MService? = nil
    public var ruleMode: String = "global"
    private var isConnecting: Bool = false
    private var vpnStatus: NEVPNStatus = NEVPNStatus.disconnected
    lazy var window: NSWindow = self.view.window!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved]) {
            let pt = self.window.mouseLocationOutsideOfEventStream
            let titleString: String = self.lblFirstNotification.stringValue
            let title: NSMutableAttributedString = NSMutableAttributedString.init(string: titleString)
            
            if self.lblFirstNotification.frame.contains(pt) {
                title.addAttribute(NSForegroundColorAttributeName, value: NSColor.init(cgColor: CGColor.agWhiteColor)!, range: NSRange.init(location: 0, length: titleString.count))
            } else {
                title.addAttribute(NSForegroundColorAttributeName, value: NSColor.init(cgColor: CGColor.agDarkBlueColor)!, range: NSRange.init(location: 0, length: titleString.count))
            }
            self.lblFirstNotification.attributedStringValue = title
            
            return $0
        }
        
        // Do view setup here.
        connectImages = []
        for i in 1...18 {
            connectImages.append(NSImage(named: "ic_connecting\(i)")!)
        }
        
        ruleMode = AppPref.getRuleMode()
        services = AppPref.getAvailableServices()
        curService = AppPref.getCurrentService()
        if curService != nil {
            if !CommonUtils.validService(service: curService) {
                curService = nil
                AppPref.setCurrentService(service: curService)
            }
        }        
        vpnStatus = NEVPNStatus(rawValue: AppPref.getVpnStatus())!
        if vpnStatus == .connecting || vpnStatus == .disconnecting {
            VpnManager.shared.stop()
        }
        
        checkLastNotification()
        
        configureUI()
    }
    
    override func onLanguageChangeNotification(notification: Notification) {
        let vpnStatus = NEVPNStatus(rawValue: AppPref.getVpnStatus())!
        switch vpnStatus {
        case .disconnecting:
            lblConnectState.stringValue = "disconnecting".localizedString()
        case .connecting:
            lblConnectState.stringValue = "connecting".localizedString()
        case .connected:
            lblConnectState.stringValue = "connected".localizedString()
        case .disconnected:
            lblConnectState.stringValue = "connect".localizedString()
        default:
            break
        }
        lblServerLabel.stringValue = "server".localizedString()
        lblAccelerationConfig.stringValue = "acceleration config".localizedString()
        
        UIHelper.sharedInstance().applyButtonDefaultStyle(button: btnInternational, titleKey: "web browser")
        UIHelper.sharedInstance().applyButtonDefaultStyle(button: btnGlobal, titleKey: "global")
        
        if curService != nil {
            lblServerName.stringValue = Country.getCountryName(code: curService!.country_name, locale: AppPref.getCurLanguageCode())
        }
        
        lblNetworkUsageTitle.stringValue = "network usage".localizedString()
        lblPerson.stringValue = "account".localizedString()
        lblShop.stringValue = "shop".localizedString()
        lblSettings.stringValue = "settings".localizedString()
        lblNotification.stringValue = "notifications".localizedString()
        lblUsageExpireTimeTitle.stringValue = "usage expire time".localizedString()
        lblFirstNotification.toolTip = "view more".localizedString()
        
        tvServerList.reloadData()
        
        updateAccelerationConfigMode()
    }
    
    override func onRuleModeChangeNotification(notification: Notification) {
        ruleMode = AppPref.getRuleMode()
        updateAccelerationConfigMode()
    }
    
    override func onLoginChangeNotification(notification:Notification) {
        if AppPref.isLogined() {
            updateServiceData(showing: true)
        } else {
            let storyboard = NSStoryboard(name: "Main", bundle: nil)
            let loginViewController = storyboard.instantiateController(withIdentifier: "AGLoginViewController") as! AGLoginViewController
            self.navigationController?.pushViewController(loginViewController, animated: true)
        }        
    }
    
    override func onServerChangeNotification(notification: Notification) {
        configureUI()
    }
    
    override func onServerListChangeNotification(notification: Notification) {
        services = AppPref.getAvailableServices()
        tvServerList.reloadData()
    }
    
    override func onPayChangeNotification(notification: Notification) {        
    }
    
    override func onVpnStatusChangeNotification(notification: Notification) {
        if let status = notification.userInfo?["status"] as? NEVPNStatus {
            if status != self.vpnStatus {
                self.vpnStatus = status
                AppPref.setVpnStatus(status: status.rawValue)
                //DebugPrint.dprint("onVpnStatusChanged: \(String(status.rawValue))")
                updateUIConnectStatus()
            }
        }
    }
    
    @IBAction func onCloseButtonClicked(_ sender: NSButton) {
        navigationController?.closeWindow()
    }
    
    @IBAction func onMinimizeButtonClicked(_ sender: NSButton) {
        navigationController?.minimizeWindow()
    }
    
    @IBAction func onConnectButtonClicked(_ sender: NSButton) {
        if isConnecting { return }
        self.vpnStatus = VpnManager.shared.vpnStatus
        switch self.vpnStatus {
        case .disconnecting:
            break
        case .connecting:
            break
        case .connected:
            self.disconnectVPN()
        case .disconnected:
            if curService == nil {
                Alert.show(message: "\("please select vpn server.".localizedString())")
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
    
    @IBAction func onServerButtonClicked(_ sender: NSButton) {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let serverSelectionViewController = storyboard.instantiateController(withIdentifier: "AGServerSelectionViewController") as! AGServerSelectionViewController
        serverSelectionViewController.serverDelegate = self
        navigationController?.pushViewController(serverSelectionViewController, animated: true)
    }
    
    @IBAction func onServerNameButtonClicked(_ sender: NSButton) {
        //setServerTableViewVisibility(isVisible: serverListContainerHeightConstraint.constant == 0)
    }
    
    @IBAction func onInternationalButtonClicked(_ sender: NSButton) {
        ruleMode = "web browser"
        AppPref.setRuleMode(mode: ruleMode)
        updateAccelerationConfigMode()
        NotificationCenter.default.post(name: .RULEMODE_CHANGE, object: nil)
    }
   
    @IBAction func onGlobalButtonClicked(_ sender: NSButton) {
        ruleMode = "global"
        AppPref.setRuleMode(mode: ruleMode)
        updateAccelerationConfigMode()
        NotificationCenter.default.post(name: .RULEMODE_CHANGE, object: nil)
    }
    
    @IBAction func onPersonButtonClicked(_ sender: NSButton) {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let accountViewController = storyboard.instantiateController(withIdentifier: "AGAccountViewController") as! AGAccountViewController
        navigationController?.pushViewController(accountViewController, animated: true)
    }
    
    @IBAction func onShopButtonClicked(_ sender: NSButton) {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let shopViewController = storyboard.instantiateController(withIdentifier: "AGShopViewController") as! AGShopViewController
        navigationController?.pushViewController(shopViewController, animated: true)
    }
    
    @IBAction func onSettingsButtonClicked(_ sender: NSButton) {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let settingsViewController = storyboard.instantiateController(withIdentifier: "AGSettingsViewController") as! AGSettingsViewController
        navigationController?.pushViewController(settingsViewController, animated: true)
    }
    
    @IBAction func onNotificationButtonClicked(_ sender: NSButton) {
        AppPref.setBadgeVisible(visible: false)
        imgBadge.isHidden = true
        
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let notificationViewController = storyboard.instantiateController(withIdentifier: "AGNotificationViewController") as! AGNotificationViewController
        navigationController?.pushViewController(notificationViewController, animated: true)
    }
    
    @IBAction func onLastNotificationClicked(_ sender: NSButton) {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let notificationViewController = storyboard.instantiateController(withIdentifier: "AGNotificationViewController") as! AGNotificationViewController
        navigationController?.pushViewController(notificationViewController, animated: true)
    }
    
    @IBAction func onServerTableViewAction(_ sender: NSTableView) {
        curService = services[sender.selectedRow]
        AppPref.setCurrentService(service: curService)
        AppPref.setRuleMode(mode: ruleMode)
        
        setServerTableViewVisibility(isVisible: false)
        
        NotificationCenter.default.post(name: .SERVER_CHANGE, object: nil)
    }
    
    @IBAction func onServerListContainerOutsideButtonClicked(_ sender: NSButton) {
        setServerTableViewVisibility(isVisible: false)
    }
    
    func updateUIConnectStatus() {
        let vpnStatus = NEVPNStatus(rawValue: AppPref.getVpnStatus())!
        if vpnStatus == .connected {
            lblConnectState.stringValue = "connected".localizedString()
            lblServerName.textColor = NSColor.hexColor(rgbValue: 0x3796C6, alpha: 1.0)
            btnSelectServer.isEnabled = false
            btnSelectOnServer.isEnabled = false
            btnInternational.isEnabled = false
            btnGlobal.isEnabled = false
            
            stopConnectAnimation()
            btnConnect.image = NSImage(named: "ic_connected")
            imgConnected.isHidden = false
        } else if vpnStatus == .disconnecting {
            lblConnectState.stringValue = "disconnecting".localizedString()
            lblServerName.textColor = NSColor.hexColor(rgbValue: 0x3796C6, alpha: 1.0)
            btnSelectServer.isEnabled = false
            btnSelectOnServer.isEnabled = false
            btnInternational.isEnabled = false
            btnGlobal.isEnabled = false
            
            btnConnect.image = NSImage(named: "ic_connect")
            imgConnected.isHidden = true
            startConnectAnimation()
        } else if vpnStatus == .connecting {
            lblConnectState.stringValue = "connecting".localizedString()
            lblServerName.textColor = NSColor.hexColor(rgbValue: 0x3796C6, alpha: 1.0)
            btnSelectServer.isEnabled = false
            btnSelectOnServer.isEnabled = false
            btnInternational.isEnabled = false
            btnGlobal.isEnabled = false
            
            btnConnect.image = NSImage(named: "ic_connect")
            imgConnected.isHidden = true
            startConnectAnimation()
        } else if vpnStatus == .disconnected {
            lblConnectState.stringValue = "connect".localizedString()
            lblServerName.textColor = NSColor.hexColor(rgbValue: 0xFFFFFF, alpha: 1.0)
            btnSelectServer.isEnabled = true
            btnSelectOnServer.isEnabled = true
            btnInternational.isEnabled = true
            btnGlobal.isEnabled = true
            
            stopConnectAnimation()
            btnConnect.image = NSImage(named: "ic_connect")
            imgConnected.isHidden = true
        }
    }
    
    private func configureUI() {
        setServerTableViewVisibility(isVisible: false)
        view.setBackgroundColor(color: CGColor.white)
        
        self.curService = AppPref.getCurrentService()
        if self.curService != nil {
            //self.buttonServerCluster.setTitle("", forState: .Normal)
            lblServerName.stringValue = Country.getCountryName(code: curService!.country_name, locale: AppPref.getCurLanguageCode())
            ivServerCountryFlag.image = NSImage.init(named: Country.getFlagName(code: curService!.country_name))
            
            vwNetworkUsageBar.isHidden = false
            vwNetworkUsageHighlight.isHidden = false
            lblUsageExpireTime.isHidden = false
            
            // network usage
            let usage = Int64(curService!.upload) + Int64(curService!.download)
            let total = Int64(curService!.transfer_enable)
            lblNetworkUsageStatus.stringValue = String.init(format: "%@ / %@", CommonUtils.humanReadableByteCount(bytes: usage, needFloat: true), CommonUtils.humanReadableByteCount(bytes: total, needFloat: false))
            usageHighlightWidthConstraint.constant = CGFloat(usage) * self.vwNetworkUsageBar.frame.width / CGFloat(total)
            
            // due time
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let expireDate = dateFormatter.date(from: curService!.expire_time)
            dateFormatter.dateFormat = "yyyy-MM-dd"
            lblUsageExpireTime.stringValue = dateFormatter.string(from: expireDate!)
            
            if curService?.country_name == "CN" {
                btnInternational.isHidden = true
            } else {
                btnInternational.isHidden = false
            }
        } else {
            //buttonServerCluster.setTitle("select server".localized(), forState: .Normal)
            lblServerName.stringValue = ""
            ivServerCountryFlag.image = nil
            lblNetworkUsageStatus.stringValue = ""
            usageHighlightWidthConstraint.constant = 0
            
            //buttonServerCluster.setTitle("select server".localized(), forState: .Normal)
            lblNetworkUsageStatus.stringValue = ""
        }
        
        btnInternational.layer?.cornerRadius = (btnInternational.layer?.frame.height)! / 2
        btnGlobal.layer?.cornerRadius = (btnGlobal.layer?.frame.height)! / 2
        
        vwNetworkUsageBar.setBackgroundColor(color: CGColor.color(red: 0xee, green: 0xee, blue: 0xee, alpha: 1))
        vwNetworkUsageHighlight.setBackgroundColor(color: CGColor.agYellowColor)
        vwNetworkUsageBar.layer?.cornerRadius = (vwNetworkUsageBar.layer?.frame.height)! / 2
        vwNetworkUsageHighlight.layer?.cornerRadius = (vwNetworkUsageHighlight.layer?.frame.height)! / 2
        
        
        vwNotification.setBackgroundColor(color: CGColor.agDarkGreyColor)
        
        updateAccelerationConfigMode()
    }
    
    private func setServerTableViewVisibility(isVisible: Bool) {
        if isVisible {
            serverListContainerHeightConstraint.constant = 570
            tvServerList.reloadData()
        } else {
            serverListContainerHeightConstraint.constant = 0
        }
    }
    
    private func updateAccelerationConfigMode() {
        ruleMode = AppPref.getRuleMode()
        
        btnInternational.setBackgroundColor(color: CGColor.agLightGreyColor)
        btnGlobal.setBackgroundColor(color: CGColor.agLightGreyColor)
        
        btnInternational.setTextColor(textColor: CGColor.agGreyColor)
        btnGlobal.setTextColor(textColor: CGColor.agGreyColor)
        
        switch (ruleMode) {
        case "web browser":
            btnInternational.title = "web browser".localizedString()
            btnInternational.setBackgroundColor(color: CGColor.agMainColor)
            btnInternational.setTextColor(textColor: CGColor.white)
            break;
        case "global":
            btnGlobal.setBackgroundColor(color: CGColor.agMainColor)
            btnGlobal.setTextColor(textColor: CGColor.white)
            break;
        default:
            break;
        }
    }
    
    private func startConnectAnimation() {
        connectImageIndex = 0
        
        let animationThread: Thread = Thread(target: self, selector: #selector(self.connectAnimationThreadFunc(sender:)), object: nil)
        animationThread.start()
    }
    
    func connectAnimationThreadFunc(sender: NSObject) {
        while self.connectImageIndex >= 0 && self.connectImageIndex < self.connectImages.count {
            DispatchQueue.main.async {
                if self.connectImageIndex >= 0 && self.connectImageIndex < self.connectImages.count {
                    self.btnConnect.image = self.connectImages[self.connectImageIndex]
                }
            }            
            self.connectImageIndex += 1
            if self.connectImageIndex >= self.connectImages.count {
                self.connectImageIndex = 0
            }
            Thread.sleep(forTimeInterval: 0.07)
        }
    }
    
    private func onConnectButtonAnimationTick() {
        btnConnect.image = connectImages[connectImageIndex]
        connectImageIndex += 1
    }
    
    private func stopConnectAnimation() {
        connectImageIndex = -1
    }
    
    func serverSelectionDidChanged(service: MService?) {
        services = AppPref.getAvailableServices()
        curService = AppPref.getCurrentService()
        AppPref.setRuleMode(mode: ruleMode)
        
        NotificationCenter.default.post(name: .SERVER_CHANGE, object: nil)
    }
    
    func connectVPN() {
        if self.curService == nil {return}
        self.isConnecting = true
        
        let access_token = AppPref.getAccessToken()
        let request = WSAPI.getAlamofireManager().request(WSAPI.Path.UserServices.url,
                                                          method: .get,
                                                          headers: ["Accept": WSAPI.HEADER_ACCEPT, "Content-Language": AppPref.getServiceLanguage(), "Authorization": "Bearer \(access_token)"])        
        request.responseData { response in
            let successResult = WSAPI.successResult(response: response.response)
            if successResult {
                let data = response.result.value
                if data != nil {
                    self.services.removeAll()
                    let array = NSDataUtils.nsdataToJSON(data: data!) as? NSArray
                    if array != nil {
                        for item in array! {
                            let service = MService(data: item as! NSDictionary)
                            if CommonUtils.validService(service: service) {
                                self.services.append(service)
                            }
                            if self.curService?.country_id == service.country_id {
                                if !CommonUtils.validService(service: service) {
                                    Alert.show(message: "\("your vpn server is expired now.".localizedString())")
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
                Alert.show(data: response.data)
                self.curService = nil
            }
            
            AppPref.setCurrentService(service: self.curService)
            AppPref.setAvailableServices(services: self.services)
            NotificationCenter.default.post(name: .SERVER_CHANGE, object: nil)
            
            if self.curService != nil {
                NotificationCenter.default.post(name: .VPN_STATUS_CHANGE, object: nil, userInfo: ["status": NEVPNStatus.connecting])
                VpnManager.shared.start() { (error) in
                    if error != AppGoVpn.ErrorCode.noError {
                        if error == AppGoVpn.ErrorCode.vpnPermissionNotGranted || error == AppGoVpn.ErrorCode.noAdminPermissions {
                            Alert.show(message: "choose allow option to authorize".localizedString())
                        } else {
                            Alert.show(message: "failed to switch vpn.".localizedString() + "Error code: \(String(describing: error))")
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
        }
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
                    
                    self.pgLoading.animate = true
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
                        DispatchQueue.main.async {
                            self.pgLoading.animate = false
                        }
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
                                                Alert.show(message: "\("your vpn server is expired now.".localizedString())")
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
                            //Alert.show(data: response.data)
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
    
    func updateServiceData(showing: Bool) {
        self.isConnecting = true
        if showing {
            self.pgLoading.animate = true
        }
        
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
            DispatchQueue.main.async {
                self.pgLoading.animate = false
            }
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
                                        Alert.show(message: "\("your vpn server is expired now.".localizedString())")
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
    
    func startVpn() {
        VpnManager.shared.start() { (error) in
            if error != AppGoVpn.ErrorCode.noError {
                if error == AppGoVpn.ErrorCode.vpnPermissionNotGranted || error == AppGoVpn.ErrorCode.noAdminPermissions {
                    Alert.show(message: "choose allow option to authorize".localizedString())
                } else {
                    Alert.show(message: "failed to switch vpn.".localizedString())
                }
            }
        }
    }
    
    func stopVpn() {
        VpnManager.shared.stop() { (error) in
            if error != AppGoVpn.ErrorCode.noError {
                if error == AppGoVpn.ErrorCode.vpnPermissionNotGranted || error == AppGoVpn.ErrorCode.noAdminPermissions {
                    Alert.show(message: "choose allow option to authorize".localizedString())
                } else {
                    Alert.show(message: "failed to switch vpn.".localizedString())
                }
            }
        }
    }
    
    func checkLastNotification() {
        let request = WSAPI.getAlamofireManager().request(WSAPI.Path.Notifications.url,
                                                          method: .get,
                                                          parameters: ["page": 1, "per_page": 15],
                                                          headers: ["Accept": WSAPI.HEADER_ACCEPT, "Content-Language": AppPref.getServiceLanguage()])
        
        request.responseData { response in
            
            let successResult = WSAPI.successResult(response: response.response)
            if successResult {
                let data = response.result.value
                
                if data != nil {
                    let json = NSDataUtils.nsdataToJSON(data: data!)
                    
                    let array = json?["data"] as? NSArray
                    if array != nil {
                        for item in array! {
                            let push = MPush(data: item as! NSDictionary)
                            let lasttime = AppPref.getLastNotificationTime()
                            if lasttime == "" || lasttime != push.updatedat {
                                AppPref.setLastNotificationTime(time: push.updatedat)
                                AppPref.setBadgeVisible(visible: true)
                            }
                            if AppPref.getBadgeVisible() {
                                self.imgBadge.isHidden = false
                            } else {
                                self.imgBadge.isHidden = true
                            }
                            
                            self.lblFirstNotification.stringValue = push.title
                            break
                        }
                    }
                }
            } else {
                //Alert.show(self, message: "\("can't connect to server.".localized())")
            }
            
            //self.refreshControl.endRefreshing()
        }
    }
}

extension AGMainViewController: NSTableViewDataSource, NSTableViewDelegate {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return services.count
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellView: NSView = tableView.make(withIdentifier: "ServerTableViewCell", owner: self)!
        cellView.setBackgroundColor(color: CGColor.agLightBlueColor)
        let ivFlag: NSImageView = cellView.viewWithTag(1) as! NSImageView
        let lblServerName: NSTextField = cellView.viewWithTag(2) as! NSTextField
        
        lblServerName.stringValue = Country.getCountryName(code: services[row].country_name, locale: AppPref.getCurLanguageCode())
        
        ivFlag.image = NSImage.init(named: Country.getFlagName(code: services[row].country_name))
        
        let splitter = cellView.viewWithTag(3)
        splitter?.isHidden = row == tableView.numberOfRows - 1
        
        return cellView
    }
}

protocol ServerSelectedEvent {
    mutating func serverSelectionDidChanged(service: MService?)
}
