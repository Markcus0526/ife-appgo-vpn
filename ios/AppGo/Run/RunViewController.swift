
//  RunViewController.swift
//  AppGoPro
//
//  Created by Striver1 on 8/11/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

import UIKit
import Alamofire
import NetworkExtension

private let kFormName = "name"
private let kFormDNS = "dns"
private let kFormProxies = "proxies"
private let kFormDefaultToProxy = "defaultToProxy"

class RunViewController: BaseViewController, RunUpdateEvent {

    @IBOutlet weak var buttonConnect: UIButton!
    @IBOutlet weak var imageRun: UIImageView!
    @IBOutlet weak var imageRunBack: UIImageView!
    
    @IBOutlet weak var labelConnect: UILabel!
    @IBOutlet weak var labelConnectTime: UILabel!
    @IBOutlet weak var labelServer: UILabel!
    @IBOutlet weak var imageServerFlag: UIImageView!
    @IBOutlet weak var labelServerCluster: UILabel!
    @IBOutlet weak var labelServerDelay: UILabel!
    @IBOutlet weak var labelAcceleration: UILabel!
    @IBOutlet weak var buttonServerCluster: UIButton!
    @IBOutlet weak var buttonInternational: UIButton!
    @IBOutlet weak var buttonGlobal: UIButton!
    @IBOutlet weak var labelAdsfree: UILabel!
    @IBOutlet weak var labelNetworkUsage: UILabel!
    @IBOutlet weak var labelNetworkUsageVal: UILabel!
    @IBOutlet weak var labelDuetime: UILabel!
    @IBOutlet weak var labelDuetimeVal: UILabel!
    
    @IBOutlet weak var viewNetworkUsageHighlight: UIView!
    @IBOutlet weak var viewNetworkUsageBackground: UIView!
    
    @IBOutlet weak var usageCtrlWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewTransfer: UIView!
    @IBOutlet weak var viewExpiretime: UIView!
    @IBOutlet weak var imageBadge: UIImageView!
    @IBOutlet weak var buttonNotification: UIButton!
    
    static var _singleton: RunViewController?
    var curService:MService? = nil
    var ruleMode: String = "global"
    var delay: Date?
    var vpnStatus: NEVPNStatus = .disconnected
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        curService = AppPref.getCurrentService()
        if curService != nil {
            if !CommonUtils.validService(service: curService) {
                curService = nil
                AppPref.setCurrentService(service: curService)
            }
        }
        vpnStatus = VPNManager.shared.isRunning()
        AppPref.setVpnStatus(status: vpnStatus.rawValue)
        if vpnStatus == .connecting || vpnStatus == .disconnecting {
            VPNManager.shared.stop()
        }
                
        updateUI()
        updateUIConnectStatus()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func onAPNSReceiveNotification(notification:Notification) {
        if AppPref.getBadgeVisible() {
            imageBadge.isHidden = false
        } else {
            imageBadge.isHidden = true
        }
    }
    
    override func onLanguageChangeNotification(notification: Notification) {
        let status = NEVPNStatus(rawValue: AppPref.getVpnStatus())!
        switch status {
        case .disconnecting:
            labelConnect.text = "disconnecting".localizedString()
        case .connecting:
            labelConnect.text = "connecting".localizedString()
        case .connected:
            labelConnect.text = "connected".localizedString()
        case .disconnected:
            labelConnect.text = "connect".localizedString()
        default:
            break
        }
        
        self.labelServer.text = "server".localizedString()

        if let curService = curService {
            if curService.delay == -1 {
                labelServerDelay.text! = ""//String.init(format: "delay:%@".localizedString(), "overtime".localizedString())
            } else if curService.delay == 0 {
                labelServerDelay.text! = ""
            } else {
                labelServerDelay.text! = String.init(format: "delay:%dms".localizedString(), curService.delay)
            }

            if Localize.isChinese() { // chinese
                self.labelServerCluster.text = curService.country_alias_zh
            } else {
                self.labelServerCluster.text = curService.country_alias_en
            }
            
            buttonServerCluster.setTitle("", for: UIControlState())
        } else {
            labelServerCluster.text = ""
            labelServerDelay.text = ""
            buttonServerCluster.setTitle("select server".localizedString(), for: .normal)
            labelNetworkUsageVal.text = ""
        }
        
        //labelConnectTime.text = "connect time:".localizedString()
        labelAcceleration.text = "acceleration config".localizedString()
        labelAdsfree.text = "ads free".localizedString()
        labelNetworkUsage.text = "network usage".localizedString()
        labelDuetime.text = "due time".localizedString()
        
        let mode = CommonUtils.getCountryDefaultRule(service: curService)
        if mode == "national" {
            buttonInternational.setTitle("national".localizedString(), for: .normal)
        } else {
            buttonInternational.setTitle("international".localizedString(), for: .normal)
        }
        buttonGlobal.setTitle("global".localizedString(), for: .normal)
    }
    
    override func onLoginChangeNotification(notification:Notification) {
        curService = AppPref.getCurrentService()
        updateServiceData(true)
    }
    
    override func onPurchaseChangeNotification(notification:Notification) {
        updateServiceData(false)
    }
    
    override func onVpnStatusChangeNotification(notification: Notification) {
        if let status = notification.userInfo?["status"] as? NEVPNStatus {
            if status != vpnStatus {
                vpnStatus = status
                AppPref.setVpnStatus(status: status.rawValue)
                updateUIConnectStatus()
            }
        }
    }

    override func onTodayConnectChangeNotification(notification: Notification) {
        //if AppPref.getTodayLaunch() {
            //AppPref.setTodayLaunch(state: false)
            curService = AppPref.getCurrentService()
            NotificationCenter.default.post(name: .SERVER_CHANGE, object: nil)
            //onClickConnectBtn(self)
        //}
    }
    
    override func onServerChangeNotification(notification:Notification) {
        updateUI()
    }
    
    @IBAction func onClickNotification(_ sender: AnyObject) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        //imageBadge.isHidden = true
        //NotificationCenter.default.post(name: .APNS_DID_RECEIVE, object: true)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        navigationController?.pushViewController(vc, animated: true)
    }
  
    @IBAction func onClickServerSelect(_ sender: UIButton) {
        AppPref.setRuleMode(mode: ruleMode)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChooseServerViewController") as! ChooseServerViewController
        vc.curService = curService
        vc.delegate = self
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onInternationalButtonClicked(_ sender: UIButton) {
        if vpnStatus == .connected {
            if ruleMode != "international" {
                Alert.show(self, message: "\("change acceleration config after disconnecting service.".localizedString())")
            }
        } else {
            ruleMode = CommonUtils.getCountryDefaultRule(service: curService)
            AppPref.setRuleMode(mode: ruleMode)
            updateUIForAcceConfigBtns()
        }
    }
    
    @IBAction func onGlobalButtonClicked(_ sender: UIButton) {
        if vpnStatus == .connected {
            if ruleMode != "global" {
                Alert.show(self, message: "\("change acceleration config after disconnecting service.".localizedString())")
            }
        } else {
            ruleMode = "global"
            AppPref.setRuleMode(mode: ruleMode)
            updateUIForAcceConfigBtns()
        }
    }
    
    @IBAction func onClickConnectBtn(_ sender: AnyObject) {
        self.vpnStatus = VPNManager.shared.vpnStatus
        switch self.vpnStatus {
        case .disconnecting:
            break
        case .connecting:
            break
        case .connected:
            self.disconnectVPN()
        case .disconnected:
            if curService == nil {
                Alert.show(self, message: "\("please select vpn server.".localizedString())")
            } else {
                AppPref.setRuleMode(mode: self.ruleMode)
                self.connectVPN()
            }
        case .reasserting:
            break//self.disconnectVPN()
        default:
            break
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
        
    func updateUI() {
        if self.curService != nil {
            // server name
            self.buttonServerCluster.setTitle("", for: UIControlState())
            self.imageServerFlag.image = UIImage(named: Country.getFlagName(curService!.country_name))
            
            if Localize.isChinese() { // chinese
                self.labelServerCluster.text = curService!.country_alias_zh
            } else {
                self.labelServerCluster.text = curService!.country_alias_en
            }
            
            if self.curService!.delay == -1 {
                self.labelServerDelay.text! = ""//String.init(format: "delay:%@".localizedString(), "overtime".localizedString())
            } else if curService!.delay == 0 {
                self.labelServerDelay.text! = ""
            } else {
                self.labelServerDelay.text! = String.init(format: "delay:%dms".localizedString(), curService!.delay)
            }
            
            viewTransfer.isHidden = false
            viewExpiretime.isHidden = false
            
            // network usage
            let usage = Int64(curService!.upload) + Int64(curService!.download)
            let total = Int64(curService!.transfer_enable)
            labelNetworkUsageVal.text! = String.init(format: "%@ / %@", CommonUtils.humanReadableByteCount(usage, needFloat: true), CommonUtils.humanReadableByteCount(total, needFloat: false))
            usageCtrlWidthConstraint.constant = CGFloat(usage) * self.viewNetworkUsageBackground.frame.width / CGFloat(total)
            
            // due time
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let expireDate = dateFormatter.date(from: curService!.expire_time)
            dateFormatter.dateFormat = "yyyy-MM-dd"
            labelDuetimeVal.text! = dateFormatter.string(from: expireDate!)
        } else {
            buttonServerCluster.setTitle("select server".localizedString(), for: .normal)
            imageServerFlag.image = nil
            labelServerCluster.text! = ""
            labelServerDelay.text! = ""
            labelNetworkUsageVal.text! = ""
            usageCtrlWidthConstraint.constant = 0
            labelDuetimeVal.text! = ""
        }
        
        updateUIForAcceConfigBtns()
        updateUIForTransfer()
    }
    
    func updateUIForAcceConfigBtns() {
        ruleMode = AppPref.getLastRuleMode()
        
        buttonInternational.backgroundColor = UIColor.white
        buttonInternational.setTitleColor(Color.TextReadonly, for: UIControlState.normal)
        buttonInternational.layer.cornerRadius = buttonInternational.frame.size.height / 2
        
        buttonGlobal.backgroundColor = UIColor.white
        buttonGlobal.setTitleColor(Color.TextReadonly, for: UIControlState.normal)
        buttonGlobal.layer.cornerRadius = buttonGlobal.frame.size.height / 2
        
        switch (ruleMode) {
        case "international":
            buttonInternational.setTitle("international".localizedString(), for: .normal)
            buttonInternational.backgroundColor = Color.BackBlue
            buttonInternational.setTitleColor(UIColor.white, for: UIControlState.normal)
            break;
            
        case "national":
            buttonInternational.setTitle("national".localizedString(), for: .normal)
            buttonInternational.backgroundColor = Color.BackBlue
            buttonInternational.setTitleColor(UIColor.white, for: UIControlState.normal)
            break;
            
        case "global":
            buttonGlobal.setTitle("global".localizedString(), for: .normal)
            buttonGlobal.backgroundColor = Color.BackBlue
            buttonGlobal.setTitleColor(UIColor.white, for: UIControlState.normal)
            break;
            
        default:
            break;
        }
    }
    
    func updateUIForTransfer() {
        self.viewNetworkUsageHighlight.layer.cornerRadius = self.viewNetworkUsageHighlight.frame.size.height / 2
        self.viewNetworkUsageBackground.layer.cornerRadius = self.viewNetworkUsageBackground.frame.size.height / 2
    }
    
    func updateUIConnectStatus() {
        DispatchQueue.main.async {
            let status = NEVPNStatus(rawValue: AppPref.getVpnStatus())!
            if status == .connected {
                self.labelConnect.text = "connected".localizedString()
                self.labelServerCluster.textColor = Color.TextReadonly
                self.labelServerDelay.textColor = Color.TextReadonly
                self.buttonInternational.isEnabled = true
                self.buttonGlobal.isEnabled = true
                self.labelNetworkUsageVal.textColor = Color.TextReadonly
                self.labelDuetimeVal.textColor = Color.TextReadonly
                self.buttonServerCluster.isEnabled = false
                self.imageRun.image = UIImage(named: "ic_connected")
                self.imageRunBack.isHidden = false
                
                self.stopConnectAnimation()
            } else if status == .disconnecting {
                self.labelConnect.text = "disconnecting".localizedString()
                self.buttonInternational.isEnabled = false
                self.buttonGlobal.isEnabled = false
                self.buttonServerCluster.isEnabled = false
                
                self.startConnectAnimation()
            } else if status == .connecting {
                self.labelConnect.text = "connecting".localizedString()
                self.buttonInternational.isEnabled = false
                self.buttonGlobal.isEnabled = false
                self.buttonServerCluster.isEnabled = false
                
                self.startConnectAnimation()
            } else if status == .disconnected {
                self.labelConnect.text = "connect".localizedString()
                self.labelServerCluster.textColor = Color.TextActive
                self.labelServerDelay.textColor = Color.TextGreen
                self.buttonInternational.isEnabled = true
                self.buttonGlobal.isEnabled = true
                self.labelNetworkUsageVal.textColor = Color.TextActive
                self.labelDuetimeVal.textColor = Color.TextActive
                self.buttonServerCluster.isEnabled = true
                self.imageRun.image = UIImage(named: "ic_connect")
                self.imageRunBack.isHidden = true
                
                self.stopConnectAnimation()
            }
        }
    }
    
    func serverSelectionDidChanged(_ service: MService?) {
        curService = service
        ruleMode = CommonUtils.getCountryDefaultRule(service: curService)
        AppPref.setRuleMode(mode: ruleMode)
        
        if curService?.country_name == "CN" {
            buttonInternational.isHidden = true
        } else {
            buttonInternational.isHidden = false
        }
        
        updateUI()
    }
    
    func startConnectAnimation() {
        var images: [UIImage] = []
        for i in 1...18 {
            images.append(UIImage(named: "ic_connecting\(i)")!)
        }
        
        imageRun.animationImages = images
        imageRun.animationDuration = 1.0
        imageRun.startAnimating()
    }
    
    func stopConnectAnimation() {
        imageRun.stopAnimating()
    }
        
    // MARK: - switch VPN
    
    func connectVPN() {
        if self.curService == nil {return}
        self.buttonConnect.isEnabled = false
        
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
            let successResult = WSAPI.successResult(response.response)
            if successResult {
                let data = response.result.value
                if data != nil {
                    let array = NSDataUtils.nsdataToJSON(data!) as? NSArray
                    if array != nil {
                        for item in array! {
                            let service = MService(data: item as! NSDictionary)
                            if CommonUtils.validService(service: service) {
                                services.append(service)
                            }
                            if self.curService?.country_id == service.country_id {
                                if !CommonUtils.validService(service: service) {
                                    Alert.show(self, message: "\("your vpn server is expired now.".localizedString())")
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
                Alert.show(self, data: response.data)
                self.curService = nil
            }
            
            AppPref.setCurrentService(service: self.curService)
            AppPref.setAvailableServices(services: services)
            NotificationCenter.default.post(name: .SERVER_CHANGE, object: nil)
            
            if self.curService != nil {
                NotificationCenter.default.post(name: .VPN_STATUS_CHANGE, object: nil, userInfo: ["status": NEVPNStatus.connecting])
                VPNManager.shared.start() { (error) in
                    if error != AppGoVpn.ErrorCode.noError {
                        if error == AppGoVpn.ErrorCode.vpnPermissionNotGranted || error == AppGoVpn.ErrorCode.noAdminPermissions {
                            Alert.show(self, message: "choose allow option to authorize".localizedString())
                        } else {
                            Alert.show(self, message: "failed to switch vpn.".localizedString())
                        }
                    }
                    CommonUtils.delayWithSeconds(1) {
                        DispatchQueue.main.async {
                            self.buttonConnect.isEnabled = true
                        }
                    }
                }
            } else {
                NotificationCenter.default.post(name: .SERVER_CHANGE, object: nil)
                DispatchQueue.main.async {
                    self.buttonConnect.isEnabled = true
                }
            }
        })
    }
    
    func disconnectVPN() {
        self.buttonConnect.isEnabled = false
        NotificationCenter.default.post(name: .VPN_STATUS_CHANGE, object: nil, userInfo: ["status": NEVPNStatus.disconnecting])
        
        CommonUtils.delayWithSeconds(2) {
            VPNManager.shared.stop() { (error) in
                CommonUtils.delayWithSeconds(2) {
                    let access_token = AppPref.getAccessToken()
                    let touristId = AppPref.getTouristId()
                    let request: Alamofire.DataRequest?
                    
                    self.showProgreeHUD()
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
                        self.hideHUD()
                        var services: [MService] = Array()
                        let successResult = WSAPI.successResult(response.response)
                        if successResult {
                            let json = NSDataUtils.nsdataToJSON(response.result.value!)
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
                                                Alert.show(self, message: "\("your vpn server is expired now.".localizedString())")
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
                            Alert.show(self, data: response.data)
                            self.curService = nil
                        }
                        AppPref.setCurrentService(service: self.curService)
                        AppPref.setAvailableServices(services: services)
                        NotificationCenter.default.post(name: .SERVER_CHANGE, object: nil)
                        
                        DispatchQueue.main.async {
                            self.buttonConnect.isEnabled = true
                        }
                    })
                }
            }
        }
    }

    func updateServiceData(_ showing: Bool) {
        self.buttonConnect.isEnabled = false
        if showing {            
            showProgreeHUD()
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
            self.hideHUD()
            var services: [MService] = Array()
            let successResult = WSAPI.successResult(response.response)
            if successResult {
                let json = NSDataUtils.nsdataToJSON(response.result.value!)
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
                                        Alert.show(self, message: "\("your vpn server is expired now.".localizedString())")
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
                self.buttonConnect.isEnabled = true
            }
        })
    }
    
    func startVpn() {
        VPNManager.shared.start() { (error) in
            if error != AppGoVpn.ErrorCode.noError {
                if error == AppGoVpn.ErrorCode.vpnPermissionNotGranted || error == AppGoVpn.ErrorCode.noAdminPermissions {
                    Alert.show(self, message: "choose allow option to authorize".localizedString())
                } else {
                    Alert.show(self, message: "failed to switch vpn.".localizedString())
                }
            }
        }
    }
    
    func stopVpn(_ completion: (() -> Void)? = nil) {
        VPNManager.shared.stop() { (error) in
            if error != AppGoVpn.ErrorCode.noError {
                if error == AppGoVpn.ErrorCode.vpnPermissionNotGranted || error == AppGoVpn.ErrorCode.noAdminPermissions {
                    Alert.show(self, message: "choose allow option to authorize".localizedString())
                } else {
                    Alert.show(self, message: "failed to switch vpn.".localizedString())
                }
            }
            completion?()
        }
    }
}

protocol RunUpdateEvent {
    mutating func serverSelectionDidChanged(_ service: MService?)
}
