//
//  AGSignupViewController.swift
//  AppGoX
//
//  Created by user on 17.10.25.
//  Copyright © 2017 appgo. All rights reserved.
//

import Cocoa
import Alamofire
import ProgressKit

class AGSignupViewController: BaseViewController, AGPhoneListEventDelegate {

    @IBOutlet weak var lblEmail: NSTextField!
    @IBOutlet weak var lblNickname: NSTextField!
    @IBOutlet weak var lblPhoneNumber: NSTextField!
    @IBOutlet weak var lblVerificationCode: NSTextField!
    @IBOutlet weak var lblPassword: NSTextField!
    @IBOutlet weak var lblConfirmPassword: NSTextField!
    
    @IBOutlet weak var editEmail: NSTextField!
    @IBOutlet weak var editUsername: NSTextField!
    @IBOutlet weak var editPhoneNumber: NSTextField!
    @IBOutlet weak var editVerificationCode: NSTextField!
    @IBOutlet weak var editPassword: NSSecureTextField!
    @IBOutlet weak var editConfirmPassword: NSSecureTextField!
    
    @IBOutlet weak var btnVerificationCode: NSButton!
    @IBOutlet weak var btnTermsOfUse: NSButton!
    @IBOutlet weak var btnSignup: NSButton!
    
    @IBOutlet weak var vwBottomLine1: NSView!
    @IBOutlet weak var vwBottomLine2: NSView!
    @IBOutlet weak var vwBottomLine3: NSView!
    @IBOutlet weak var vwBottomLine4: NSView!
    @IBOutlet weak var vwBottomLine5: NSView!
    @IBOutlet weak var vwBottomLine6: NSView!
    
    @IBOutlet weak var vwSplitter: NSView!
    
    @IBOutlet weak var lblAlreadyHaveID: NSTextField!
    @IBOutlet weak var btnEmail: NSButton!
    
    @IBOutlet weak var btnPhoneNoPrefix: NSButton!
    
    @IBOutlet weak var pgLoading: Crawler!
    
    var smsTimer: Timer?
    var smsCounteer: Int = 120
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        configureUI()
    }
    
    override func onLanguageChangeNotification(notification: Notification) {
        lblEmail.stringValue = "email account".localizedString()
        editEmail.placeholderString = "enter email account".localizedString()
        
        lblNickname.stringValue = "nick name".localizedString()
        editUsername.placeholderString = "enter nick name".localizedString()
        
        lblPhoneNumber.stringValue = "phone number".localizedString()
        editPhoneNumber.placeholderString = "enter phone number".localizedString()
        
        lblVerificationCode.stringValue = "verification code".localizedString()
        editVerificationCode.placeholderString = "enter code".localizedString()
        
        lblPassword.stringValue = "password".localizedString()
        editPassword.placeholderString = "enter password".localizedString()
        
        lblConfirmPassword.stringValue = "confirm password".localizedString()
        editConfirmPassword.placeholderString = "enter password again".localizedString()
        
        lblAlreadyHaveID.stringValue = "already have id?".localizedString()
        btnEmail.title = ""
        
        UIHelper.sharedInstance().applyButtonDefaultStyle(button: btnVerificationCode, titleKey: "verification code", textSize: 11)
        btnTermsOfUse.title = "term of use".localizedString()
        btnTermsOfUse.setTextColor(textColor: CGColor.agMainColor)
        UIHelper.sharedInstance().applyButtonDefaultStyle(button: btnSignup, titleKey: "sign up")
        
        configureLoginButton()
    }
    
    private func configureUI () {
        view.setBackgroundColor(color: CGColor.white)
        
        vwBottomLine1.setBackgroundColor(color: CGColor.agMainColor)
        vwBottomLine2.setBackgroundColor(color: CGColor.agMainColor)
        vwBottomLine3.setBackgroundColor(color: CGColor.agMainColor)
        vwBottomLine4.setBackgroundColor(color: CGColor.agMainColor)
        vwBottomLine5.setBackgroundColor(color: CGColor.agMainColor)
        vwBottomLine6.setBackgroundColor(color: CGColor.agMainColor)
        vwSplitter.setBackgroundColor(color: CGColor.agMainColor)
    }
    
    public func configureLoginButton() {
        let titleString: String = "contact us".localizedString()
        let title: NSMutableAttributedString = NSMutableAttributedString.init(string: titleString)
        title.addAttribute(NSForegroundColorAttributeName, value: NSColor.init(cgColor: CGColor.agMainColor), range: NSRange.init(location: 0, length: titleString.count))
        title.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange.init(location: 0, length: titleString.count))
        
        let style: NSMutableParagraphStyle = NSMutableParagraphStyle.init()
        style.alignment = NSLeftTextAlignment        
        title.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSRange.init(location: 0, length: titleString.count))
        
        btnEmail.attributedTitle = title
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
        let phoneUrl = WSAPI.encodeString(decode: phonenumber)
        
        self.pgLoading.animate = true
        self.btnVerificationCode.isEnabled = false
        self.btnSignup.isEnabled = false
        
        let request = WSAPI.getAlamofireManager().request(WSAPI.Path.Sms.url,
                                                          method: .post,
                                                          parameters: ["mobile": phoneUrl!, "for": "register"],
                                                          headers: ["Accept": WSAPI.HEADER_ACCEPT, "Content-Language": AppPref.getServiceLanguage()])
        
        request.responseData { response in
            DispatchQueue.main.async {
                self.pgLoading.animate = false
                self.btnVerificationCode.isEnabled = true
                self.btnSignup.isEnabled = true
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
    
    @IBAction func onEmailButtonClicked(_ sender: NSButton) {
        let service = NSSharingService(named: NSSharingServiceNameComposeEmail)
        if service != nil {
            service!.recipients = [AppInfo.emailAccount]
            service!.subject = ""
            
            service!.perform(withItems: ["This is an email for sending AppGo team."])
        }
    }
    
    @IBAction func onTermsOfUseButtonClicked(_ sender: NSButton) {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let termsOfUseViewController: AGTermOfUseViewController = storyboard.instantiateController(withIdentifier: "AGTermOfUseViewController") as! AGTermOfUseViewController
        navigationController?.pushViewController(termsOfUseViewController, animated: true)
    }
    
    @IBAction func onSignupButtonClicked(_ sender: NSButton) {
        if checkInfo() {
            let mailaccount = self.editEmail.stringValue
            let nickname = self.editUsername.stringValue
            let nativenumber = self.editPhoneNumber.stringValue
            let phonenumber = self.btnPhoneNoPrefix.title + nativenumber
            let verificationCode = self.editVerificationCode.stringValue
            let password = self.editPassword.stringValue
            self.pgLoading.animate = true
            self.btnVerificationCode.isEnabled = false
            self.btnSignup.isEnabled = false
            
            let request = WSAPI.getAlamofireManager().request(WSAPI.Path.Register.url,
                                                              method: .post,
                                                              parameters: ["email": mailaccount, "mobile": phonenumber, "nickname": nickname, "password": password, "verify_code": verificationCode],
                                                              headers: ["Accept": WSAPI.HEADER_ACCEPT, "Content-Language": AppPref.getServiceLanguage()])
            request.responseData { response in
                DispatchQueue.main.async {
                    self.pgLoading.animate = false
                    self.btnVerificationCode.isEnabled = true
                    self.btnSignup.isEnabled = true
                }                
                let successResult = WSAPI.successResult(response: response.response)
                if successResult {
                    Alert.show(message: "sign up succeeded!".localizedString()) { [weak self] in
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
        
        let mailaccount = self.editEmail.stringValue
        let nickname = self.editUsername.stringValue
        let nativenumber = self.editPhoneNumber.stringValue
        let phonenumber = self.btnPhoneNoPrefix.title + nativenumber
        let password = self.editPassword.stringValue
        let confirmPwd = self.editConfirmPassword.stringValue
        let verifiycode = self.editVerificationCode.stringValue
        
        if mailaccount.isEmpty {
            Alert.show(message: "\("please enter email account.".localizedString())")
        } else if isInvalidEmail(input: mailaccount) {
            Alert.show(message: "\("the email account is invalid format.".localizedString())")
        } else if nickname.isEmpty {
            Alert.show(message: "\("please enter nick name.".localizedString())")
        } else if phonenumber.isEmpty {
            Alert.show(message: "\("please enter phone number.".localizedString())")
        } else if password.isEmpty {
            Alert.show(message: "\("please enter password.".localizedString())")
        } else if confirmPwd.isEmpty {
            Alert.show(message: "\("please enter password again.".localizedString())")
        } else if password != confirmPwd {
            Alert.show(message: "\("please enter password correctly.".localizedString())")
        } else if password.count < 6 {
            Alert.show(message: "\("the password must be at least 6 characters.".localizedString())")
        } else if verifiycode.isEmpty {
            Alert.show(message: "\("please enter verification code.".localizedString())")
        } else {
            result = true
        }
        
        return result
    }
    
    func isInvalidEmail(input:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if emailTest.evaluate(with: input) {
            return false
        } else {
            return true
        }
    }
}
