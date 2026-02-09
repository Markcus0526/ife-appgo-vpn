//
//  AGLoginViewController.swift
//  AppGoX
//
//  Created by user on 17.10.24.
//  Copyright © 2017 appgo. All rights reserved.
//

import Cocoa
import ProgressKit

class AGLoginViewController: BaseViewController, AGPhoneListEventDelegate {
    
    @IBOutlet weak var btnPhoneNoPrefix: NSButton!
    @IBOutlet weak var tfPhoneNumber: NSTextField!
    @IBOutlet weak var tfPassword: NSSecureTextField!
    @IBOutlet weak var btnLogin: NSButton!
    @IBOutlet weak var btnForgotPassword: NSButton!
    @IBOutlet weak var btnSignup: NSButton!
    @IBOutlet weak var vwSplitterLeft: NSView!
    @IBOutlet weak var vwSplitterRight: NSView!
    @IBOutlet weak var lblSlogan: NSTextField!
    @IBOutlet weak var vwSplitter: NSView!
    @IBOutlet weak var pgLogin: Crawler!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        //RCJ updateLoginState();
    }
    
    override func viewWillAppear() {
        configureUI()
    }
    
    override func onLanguageChangeNotification(notification: Notification) {
        UIHelper.sharedInstance().applyButtonDefaultStyle(button: btnLogin, titleKey: "sign in", textSize: 15)
        
        configureForgotPasswordButton()
        configureSignupButton()
        configureSloganLabel()
        
        tfPhoneNumber.placeholderString = "enter phone number".localizedString()
        tfPassword.placeholderString = "enter password".localizedString()
    }
    
    override func onLoginChangeNotification(notification: Notification) {
        let phonenum = AppPref.getLastLoginPhoneNumber()
        if (phonenum != "") {
            btnPhoneNoPrefix.title = Country.getPhonePrefix(mobile: phonenum)
            tfPhoneNumber.stringValue = Country.getNativePhoneNumber(mobile: phonenum)
            tfPassword.stringValue = AppPref.getLastLoginPassword()
        }
    }
    
    func configureUI() {
        view.setBackgroundColor(color: CGColor.white)
        
        vwSplitterLeft.setBackgroundColor(color: CGColor.agMainColor)
        vwSplitterRight.setBackgroundColor(color: CGColor.agMainColor)
        vwSplitter.setBackgroundColor(color: CGColor.agMainColor)
    }
    
    private func configureForgotPasswordButton() {
        let titleString: String = "forgot password".localizedString()
        let title: NSMutableAttributedString = NSMutableAttributedString.init(string: titleString)
        title.addAttribute(NSForegroundColorAttributeName, value: NSColor.init(cgColor: CGColor.agGreyColor)!, range: NSRange.init(location: 0, length: titleString.count))
        
        let style: NSMutableParagraphStyle = NSMutableParagraphStyle.init()
        style.alignment = NSLeftTextAlignment
        title.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSRange.init(location: 0, length: titleString.count))
        
        let font: NSFont = NSFont.systemFont(ofSize: 14)
        title.addAttribute(NSFontAttributeName, value: font, range: NSRange.init(location: 0, length: titleString.count))
        
        btnForgotPassword.attributedTitle = title
    }
    
    private func configureSignupButton() {
        let titleString: String = "register now".localizedString()
        let title: NSMutableAttributedString = NSMutableAttributedString.init(string: titleString)
        title.addAttribute(NSForegroundColorAttributeName, value: NSColor.init(cgColor: CGColor.agGreyColor)!, range: NSRange.init(location: 0, length: titleString.count))
        
        let style: NSMutableParagraphStyle = NSMutableParagraphStyle.init()
        style.alignment = NSRightTextAlignment
        title.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSRange.init(location: 0, length: titleString.count))
        
        let font: NSFont = NSFont.systemFont(ofSize: 14)
        title.addAttribute(NSFontAttributeName, value: font, range: NSRange.init(location: 0, length: titleString.count))
        
        btnSignup.attributedTitle = title
    }
    
    private func configureSloganLabel() {
        let titleString: String = "stable service and speed, give you a different experience".localizedString()
        let title: NSMutableAttributedString = NSMutableAttributedString.init(string: titleString)
        title.addAttribute(NSForegroundColorAttributeName, value: NSColor.init(cgColor: CGColor.agMainColor)!, range: NSRange.init(location: 0, length: titleString.count))
        
        let style: NSMutableParagraphStyle = NSMutableParagraphStyle.init()
        style.alignment = NSCenterTextAlignment
        title.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSRange.init(location: 0, length: titleString.count))
        
        lblSlogan.attributedStringValue = title
    }
    
    @IBAction func onLoginButtonClicked(_ sender: NSButton) {
        if(checkInfo()) {
            let phonenumber = self.btnPhoneNoPrefix.title + self.tfPhoneNumber.stringValue.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
            let password = self.tfPassword.stringValue.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
            
            self.pgLogin.animate = true
            self.btnLogin.isEnabled = false
            self.btnForgotPassword.isEnabled = false
            self.btnSignup.isEnabled = false
            
            let request = WSAPI.getAlamofireManager().request(WSAPI.Path.Login.url,
                                                              method: .post,
                                                              parameters: ["username": phonenumber, "password": password, "client_id": WSAPI.CLIENT_ID, "client_secret": WSAPI.CLIENT_SECRET, "grant_type": "password"],
                                                              headers: ["Accept": WSAPI.HEADER_ACCEPT, "Content-Language": AppPref.getServiceLanguage()])
            
            request.responseData { response in
                self.pgLogin.animate = false
                self.btnLogin.isEnabled = true
                self.btnForgotPassword.isEnabled = true
                self.btnSignup.isEnabled = true
                
                let successResult = WSAPI.successResult(response: response.response)
                if successResult {
                    let json = NSDataUtils.nsdataToJSON(data: response.result.value!)                    
                    if json == nil {
                        Alert.show(data: response.data)
                    } else {
                        let orgPhonenum = AppPref.getLastLoginPhoneNumber()
                        AppPref.setLoginInfo(phone: phonenumber, pwd: password, json: json!)
                        if orgPhonenum != phonenumber {
                            let services: [MService] = [MService].init()
                            AppPref.setAvailableServices(services: services)
                            AppPref.setCurrentService(service: nil)
                        }
                        NotificationCenter.default.post(name: .LOGIN_CHANGE, object: nil, userInfo: ["status": true])
                        
                        let storyboard = NSStoryboard(name: "Main", bundle: nil)
                        let mainViewController = storyboard.instantiateController(withIdentifier: "AGMainViewController") as! AGMainViewController
                        self.navigationController?.pushViewController(mainViewController, animated: true)
                        
                    }
                } else {
                    Alert.show(data: response.data)
                }
            }
        }
    }
    
    @IBAction func onSignupButtonClicked(_ sender: NSButton) {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let signupViewController = storyboard.instantiateController(withIdentifier: "AGSignupViewController") as! AGSignupViewController
        navigationController?.pushViewController(signupViewController, animated: true)
    }
    
    @IBAction func onForgotPasswordButtonClicked(_ sender: NSButton) {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let forgotPasswordViewController = storyboard.instantiateController(withIdentifier: "AGForgotPasswordViewController") as! AGForgotPasswordViewController
        navigationController?.pushViewController(forgotPasswordViewController, animated: true)
    }
    
    @IBAction func onMailButtonClicked(_ sender: NSButton) {
        let service = NSSharingService(named: NSSharingServiceNameComposeEmail)
        if service != nil {
            service!.recipients = [AppInfo.emailAccount]
            service!.subject = ""
            
            service!.perform(withItems: ["This is an email for sending AppGo team."])
        }
    }
    
    @IBAction func onTwitterButtonClicked(_ sender: NSButton) {
        if let url = URL(string: AppInfo.twitterUrl), NSWorkspace.shared().open(url) {
            print("default browser was successfully opened")
        }
    }
    
    @IBAction func onTelegramButtonClicked(_ sender: NSButton) {
        if let url = URL(string: AppInfo.websiteUrl), NSWorkspace.shared().open(url) {
            print("default browser was successfully opened")
        }
    }
    
    @IBAction func onCloseButtonClicked(_ sender: NSButton) {
        navigationController?.closeWindow()
    }
    
    @IBAction func onMinimizeButtonClicked(_ sender: NSButton) {
        navigationController?.minimizeWindow()
    }
    
    @IBAction func onPhoneNumberButtonClicked(_ sender: NSButton) {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateController(withIdentifier: "AGPhoneListViewController") as! AGPhoneListViewController
        vc.setDelegate(delegate: self)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func onCountrySelected(countryInfo: CountryInfo) {
        btnPhoneNoPrefix.title = countryInfo.phoneCode
    }
    
    func checkInfo()-> Bool {
        var result = false
        
        // field verification
        let phonenumber = self.tfPhoneNumber.stringValue.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        let password = self.tfPassword.stringValue.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        if phonenumber.isEmpty {
            Alert.show(message: "\("please enter phone number.".localizedString())")
        } else if password.isEmpty {
            Alert.show(message: "\("please enter password.".localizedString())")
        } else if password.count < 6 {
            Alert.show(message: "\("the password must be at least 6 characters.".localizedString())")
        } else {
            result = true
        }
        
        return result;
    }
}
