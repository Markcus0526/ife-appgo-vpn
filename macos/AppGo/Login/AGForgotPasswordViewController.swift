//
//  AGForgotPasswordViewController.swift
//  AppGoX
//
//  Created by user on 17.10.25.
//  Copyright © 2017 appgo. All rights reserved.
//

import Cocoa
import Alamofire
import ProgressKit

class AGForgotPasswordViewController: BaseViewController, AGPhoneListEventDelegate {

    @IBOutlet weak var btnPhoneNoPrefix: NSButton!
    @IBOutlet weak var editPhoneNumber: NSTextField!
    
    @IBOutlet weak var editVerificationCode: NSTextField!
    @IBOutlet weak var btnVerificationCode: NSButton!
    
    @IBOutlet weak var editNewPassword: NSSecureTextField!
    
    @IBOutlet weak var editConfirmPassword: NSSecureTextField!
    
    @IBOutlet weak var btnChangePassword: NSButton!
    @IBOutlet weak var vwBottomLine1: NSView!
    @IBOutlet weak var vwBottomLine2: NSView!
    @IBOutlet weak var vwBottomLine3: NSView!
    @IBOutlet weak var vwBottomLine4: NSView!
    @IBOutlet weak var vwSplitter1: NSView!
    
    @IBOutlet weak var lblPhoneNumber: NSTextField!
    @IBOutlet weak var lblVerificationCode: NSTextField!
    @IBOutlet weak var lblNewPassword: NSTextField!
    @IBOutlet weak var lblConfirmPassword: NSTextField!
    
    @IBOutlet weak var pgLoading: Crawler!
    
    var smsTimer: Timer?
    var smsCounteer: Int = 120
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        configureUI()
    }
    
    override func onLanguageChangeNotification(notification: Notification) {
        UIHelper.sharedInstance().applyButtonDefaultStyle(button: btnVerificationCode, titleKey: "verification code", textSize: 11)
        UIHelper.sharedInstance().applyButtonDefaultStyle(button: btnChangePassword, titleKey: "reset password")
        
        lblPhoneNumber.stringValue = "phone number".localizedString()
        lblVerificationCode.stringValue = "verification code".localizedString()
        lblNewPassword.stringValue = "new password".localizedString()
        lblConfirmPassword.stringValue = "confirm password".localizedString()
        
        editPhoneNumber.placeholderString = "enter phone number".localizedString()
        editVerificationCode.placeholderString = "enter code".localizedString()
        editNewPassword.placeholderString = "enter new password".localizedString()
        editConfirmPassword.placeholderString = "enter new password again".localizedString()
    }
    
    private func configureUI() {
        view.setBackgroundColor(color: CGColor.white)
        
        vwBottomLine1.setBackgroundColor(color: CGColor.agMainColor)
        vwBottomLine2.setBackgroundColor(color: CGColor.agMainColor)
        vwBottomLine3.setBackgroundColor(color: CGColor.agMainColor)
        vwBottomLine4.setBackgroundColor(color: CGColor.agMainColor)
        vwSplitter1.setBackgroundColor(color: CGColor.agMainColor)
        
        if AppPref.isLogined() {
            btnPhoneNoPrefix.isEnabled = false
            btnPhoneNoPrefix.title = Country.getPhonePrefix(mobile: AppPref.getLastLoginPhoneNumber())
            editPhoneNumber.isEnabled = false
            editPhoneNumber.stringValue = Country.getNativePhoneNumber(mobile: AppPref.getLastLoginPhoneNumber())
        }
    }
    
    @IBAction func onBackButtonClicked(_ sender: NSButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func onPhoneNumberPrefixButtonClicked(_ sender: NSButton) {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateController(withIdentifier: "AGPhoneListViewController") as! AGPhoneListViewController
        vc.setDelegate(delegate: self)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onVerificationCodeButtonClicked(_ sender: NSButton) {
        let nativenumber = self.editPhoneNumber.stringValue
        let phonenumber = self.btnPhoneNoPrefix.title + nativenumber
        //let phoneUrl = WSAPI.encodeString(decode: phonenumber)
        
        self.pgLoading.animate = true
        self.btnVerificationCode.isEnabled = false
        self.btnChangePassword.isEnabled = false
        
        let request = WSAPI.getAlamofireManager().request(WSAPI.Path.Sms.url,
                                                          method: .post,
                                                          parameters: ["mobile": phonenumber, "for": "resetPassword"],
                                                          headers: ["Accept": WSAPI.HEADER_ACCEPT, "Content-Language": AppPref.getServiceLanguage()])
        
        request.responseData { response in
            DispatchQueue.main.async {
                self.pgLoading.animate = false
                self.btnVerificationCode.isEnabled = true
                self.btnChangePassword.isEnabled = true
            }
            let successResult = WSAPI.successResult(response: response.response)
            if successResult {
                DispatchQueue.main.async {
                    self.btnVerificationCode.isEnabled = false
                }
                self.smsCounteer = 120
                self.smsTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.smsTimerAction), userInfo: nil, repeats: true)
                
            } else {
                Alert.show(data: response.data)
            }
        }
    }
    
    @IBAction func onChangePasswordButtonClicked(_ sender: NSButton) {
        if checkInfo() {
            let nativenumber = self.editPhoneNumber.stringValue
            let phonenumber = self.btnPhoneNoPrefix.title + nativenumber
            let newPwd = self.editNewPassword.stringValue
            let verificationCode = self.editVerificationCode.stringValue
            
            self.pgLoading.animate = true
            self.btnVerificationCode.isEnabled = false
            self.btnChangePassword.isEnabled = false
            
            let request = WSAPI.getAlamofireManager().request(WSAPI.Path.Password.url,
                                                              method: .post,
                                                              parameters: ["mobile": phonenumber, "new_password": newPwd, "verify_code": verificationCode],
                                                              headers: ["Accept": WSAPI.HEADER_ACCEPT, "Content-Language": AppPref.getServiceLanguage()])
            
            request.responseData { response in
                DispatchQueue.main.async {
                    self.pgLoading.animate = false
                    self.btnVerificationCode.isEnabled = true
                    self.btnChangePassword.isEnabled = true
                }
                let successResult = WSAPI.successResult(response: response.response)
                if successResult {
                    Alert.show(message: "password has been changed successfully.".localizedString()) { [weak self] in
                        self!.navigationController?.popViewControllerAnimated(true)
                    }
                } else {
                    Alert.show(data: response.data)
                }
            }
        }
        
        
    }
    
    func onCountrySelected(countryInfo: CountryInfo) {
        btnPhoneNoPrefix.title = countryInfo.phoneCode
    }
    
    func smsTimerAction() {
        self.btnVerificationCode.title = String.init(format: "%ds", smsCounteer)
        
        if smsCounteer == 0 {
            self.btnVerificationCode.isEnabled = true
            self.btnVerificationCode.stringValue = "verification code".localizedString()
            smsTimer?.invalidate()
            smsTimer = nil
        } else {
            smsCounteer -= 1
        }
    }
    
    func checkInfo()-> Bool{
        var result = false
        
        // field verification
        let newPwd = self.editNewPassword.stringValue
        let confirmPwd = self.editConfirmPassword.stringValue
        let verifiycode = self.editVerificationCode.stringValue
        
        if newPwd.isEmpty {
            Alert.show(message: "\("please enter new password.".localizedString())")
        } else if confirmPwd.isEmpty {
            Alert.show(message: "\("please enter new password again.".localizedString())")
        } else if newPwd.count < 6 || confirmPwd.count < 6 {
            Alert.show(message: "\("the password must be at least 6 characters.".localizedString())")
        } else if newPwd != confirmPwd {
            Alert.show(message: "\("please enter password correctly.".localizedString())")
        } else if verifiycode.isEmpty {
            Alert.show(message: "\("please enter verification code.".localizedString())")
        } else {
            result = true
        }
        
        return result
    }
}
