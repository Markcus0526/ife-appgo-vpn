//
//  AGAccountViewController.swift
//  AppGoX
//
//  Created by user on 17.10.26.
//  Copyright © 2017 appgo. All rights reserved.
//

import Cocoa
import Alamofire
import ProgressKit
import NetworkExtension

class AGAccountViewController: BaseViewController {

    @IBOutlet weak var vwTitleBar: NSView!
    @IBOutlet weak var lblTitle: NSTextField!
    
    @IBOutlet weak var lblUsername: NSTextField!
    @IBOutlet weak var lblPhoneNumber: NSTextField!
    
    @IBOutlet weak var lblACoinTitle: NSTextField!
    @IBOutlet weak var lblACoin: NSTextField!
    
    @IBOutlet weak var lblLevelTitle: NSTextField!
    @IBOutlet weak var btnLevel: NSButton!
    
    @IBOutlet weak var lblFeedback: NSTextField!
    @IBOutlet weak var lblWebsite: NSTextField!
    @IBOutlet weak var lblAboutUs: NSTextField!
    @IBOutlet weak var lblChangePassword: NSTextField!
    @IBOutlet weak var lblLogout: NSTextField!
    
    @IBOutlet weak var pgLoading: Crawler!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        fetchServiceData()
        configureUI()
    }
    
    override func onLanguageChangeNotification(notification: Notification) {
        lblTitle.stringValue = "account".localizedString()
        lblACoinTitle.stringValue = "acoin".localizedString()
        lblLevelTitle.stringValue = "level".localizedString()
        
        lblFeedback.stringValue = "feedback".localizedString()
        lblAboutUs.stringValue = "about".localizedString()
        lblWebsite.stringValue = "website".localizedString()
        lblChangePassword.stringValue = "password".localizedString()
        lblLogout.stringValue = "logout".localizedString()
    }
    
    @IBAction func onBackButtonClicked(_ sender: NSButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func onNotificationButtonClicked(_ sender: NSButton) {
        AppPref.setBadgeVisible(visible: false)
        
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let notificationViewController = storyboard.instantiateController(withIdentifier: "AGNotificationViewController") as! AGNotificationViewController
        navigationController?.pushViewController(notificationViewController, animated: true)
    }
    
    @IBAction func onFeedbackButtonClicked(_ sender: NSButton) {
        //let storyboard = NSStoryboard(name: "Main", bundle: nil)
        //let feedbackViewController = storyboard.instantiateController(withIdentifier: "AGFeedbackViewController") as! AGFeedbackViewController
        //navigationController?.pushViewController(feedbackViewController, animated: true)
        
        let service = NSSharingService(named: NSSharingServiceNameComposeEmail)
        if service != nil {
            service!.recipients = [AppInfo.emailAccount]
            service!.subject = ""
            
            service!.perform(withItems: ["This is an email for sending AppGo team."])
        }
        
    }
    
    @IBAction func onWebsiteButtonClicked(_ sender: NSButton) {
        if let url = URL(string: AppInfo.websiteUrl), NSWorkspace.shared().open(url) {
            print("default browser was successfully opened")
        }
    }
    
    @IBAction func onAboutUsButtonClicked(_ sender: NSButton) {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let aboutUsViewController = storyboard.instantiateController(withIdentifier: "AGAboutUsViewController") as! AGAboutUsViewController
        navigationController?.pushViewController(aboutUsViewController, animated: true)
    }
    
    @IBAction func onChangePasswordButtonClicked(_ sender: NSButton) {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateController(withIdentifier: "AGForgotPasswordViewController") as! AGForgotPasswordViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onLogoutButtonClicked(_ sender: NSButton) {
        Alert.show(message: "are you sure you want to sign out?".localizedString(), confirmCallback: {
            [weak self] in
            let vpnStatus = NEVPNStatus(rawValue: AppPref.getVpnStatus())!
            if vpnStatus == .connected {
                NotificationCenter.default.post(name: .VPN_STATUS_CHANGE, object: nil, userInfo: ["status": NEVPNStatus.disconnecting])
                VpnManager.shared.stop()
                
                NotificationCenter.default.post(name: .VPN_STATUS_CHANGE, object: nil, userInfo: ["status": NEVPNStatus.disconnected])
            }            
            
            AppPref.clearUserInfo()
            URLCache.shared.removeAllCachedResponses()            
            
            NotificationCenter.default.post(name: .LOGIN_CHANGE, object: nil, userInfo: ["status": false])
            
            let storyboard = NSStoryboard(name: "Main", bundle: nil)
            let loginViewController = storyboard.instantiateController(withIdentifier: "AGLoginViewController") as! AGLoginViewController
            self?.navigationController?.pushViewController(loginViewController, animated: true)
            }, cancelCallback: {})
    }
    
    func updateUIFromService(data: Data?) {
        if data != nil {
            let json = NSDataUtils.nsdataToJSON(data: data!)
            if json != nil {
                
                let user = MUser(data: json! as! NSDictionary)
                lblUsername.stringValue = user.nickname
                lblPhoneNumber.stringValue = Country.getNativePhoneNumber(mobile: user.mobile)
                lblACoin.stringValue = String(user.acoin)
                btnLevel.title = "LV.\(user.level)"
                //mailAccount = user.mailaccount
            }
        } else {
            lblUsername.stringValue = ""
            lblPhoneNumber.stringValue = ""
            lblACoin.stringValue = ""
            btnLevel.title = ""
        }
    }
    
    private func configureUI() {
        view.setBackgroundColor(color: CGColor.white)
        btnLevel.setTextColor(textColor: CGColor.white)
        vwTitleBar.setBackgroundColor(color: CGColor.agMainColor)
        
        UIHelper.sharedInstance().applyButtonWhiteRoundedRectStyle(button: btnLevel, titleKey: "LV.1")
    }
    
    func fetchServiceData() {
        let access_token = AppPref.getAccessToken()
        let request: Alamofire.DataRequest?
        
        request = WSAPI.getAlamofireManager().request(WSAPI.Path.User.url,
                                                      method: .get,
                                                      headers: ["Accept": WSAPI.HEADER_ACCEPT, "Content-Language": AppPref.getServiceLanguage(), "Authorization": "Bearer \(access_token)"])
        request!.responseData { response in
            DispatchQueue.main.async {
                self.pgLoading.animate = false
            }
            let successResult = WSAPI.successResult(response: response.response)
            if successResult {
                let data = response.result.value
                self.updateUIFromService(data: data)
            }
        }
    }
}
