//
//  ResetPasswordViewController.swift
//  AppGoPro
//
//  Created by Striver1 on 8/15/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

import UIKit
import Alamofire

class ResetPasswordViewController: BaseViewController, UITextFieldDelegate, PhoneCodeUpdateEvent {

    @IBOutlet weak var labelCode: UILabel!
    @IBOutlet weak var labelPhoneNum: UILabel!
    @IBOutlet weak var labelVeriCode: UILabel!
    @IBOutlet weak var labelRequest: UILabel!
    @IBOutlet weak var labelPassword: UILabel!
    @IBOutlet weak var labelConfirmPassword: UILabel!
    @IBOutlet weak var textfieldPhoneNum: UITextField!
    @IBOutlet weak var textfieldVeriCode: UITextField!
    @IBOutlet weak var textfieldPassword: UITextField!
    @IBOutlet weak var textfieldConfirmPassword: UITextField!
    @IBOutlet weak var buttonReset: UIButton!
    @IBOutlet weak var buttonReqVerifyCode: UIButton!
    @IBOutlet weak var viewSMS: UIView!
    
    var smsTimer: Timer?
    var smsCounteer: Int = 120
    var countryCode: String = "CN"
    var phoneCode: String = "+86"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
        
        buttonReset.layer.borderWidth = 1.0
        buttonReset.layer.borderColor = Color.BackBlue.cgColor
        buttonReset.layer.backgroundColor = Color.BackBlue.cgColor
        buttonReset.layer.cornerRadius = buttonReset.frame.size.height / 2
        
        viewSMS.layer.borderWidth = 1.0
        viewSMS.layer.borderColor = Color.BackBlue.cgColor
        viewSMS.layer.backgroundColor = Color.BackBlue.cgColor
        viewSMS.layer.cornerRadius = viewSMS.frame.size.height / 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func onLanguageChangeNotification(notification: Notification) {
        labelCode.text = phoneCode
        
        labelPhoneNum.text = "phone number".localizedString()
        labelVeriCode.text = "verification code".localizedString()
        labelPassword.text = "new password".localizedString()
        labelRequest.text = "request code".localizedString()
        labelConfirmPassword.text = "confirm password".localizedString()
        
        textfieldPhoneNum.placeholder = "enter phone number".localizedString()
        textfieldVeriCode.placeholder = "enter code".localizedString()
        textfieldPassword.placeholder = "enter new password".localizedString()
        textfieldConfirmPassword.placeholder = "enter new password again".localizedString()
        
        buttonReset.setTitle("reset password".localizedString(), for: .normal)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PhoneListViewController {
            vc.selCountryCode = countryCode
            vc.selPhoneCode = labelCode.text!
            vc.delegate = self
        }
    }
    
    @IBAction func onClickBack(_ sender: AnyObject) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickRequestVerifyCode(_ sender: AnyObject) {
        let nativenumber = self.textfieldPhoneNum.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let phonenumber = self.labelCode.text! + nativenumber
        
        if nativenumber.isEmpty {
            Alert.show(self, message: "\("please enter phone number.".localizedString())")
        } else if AppPref.isValidSms() == false {
            Alert.show(self, message: "\("you can't use sms today, please retry tomorrow again.".localizedString())")
        } else {
            showProgreeHUD()
            
            let request = WSAPI.getAlamofireManager().request(WSAPI.Path.Sms.url,
                                                              method: .post,
                                                              parameters: ["mobile": phonenumber, "for": "resetPassword"],
                                                              encoding: URLEncoding.default,
                                                              headers: ["Accept": WSAPI.HEADER_ACCEPT, "Content-Language": AppPref.convertServiceLanguageCode()])
            request.responseData(completionHandler: { response in
                self.hideHUD()
                
                let successResult = WSAPI.successResult(response.response)
                if successResult {
                    self.buttonReqVerifyCode.isEnabled = false
                    self.smsCounteer = 120
                    self.smsTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.smsTimerAction), userInfo: nil, repeats: true)
                } else {
                    Alert.show(self, data: response.data)
                }
            })
        }
    }
    
    
    @IBAction func onClickResetButton(_ sender: AnyObject) {
        if checkInfo() {
            
            let nativenumber = self.textfieldPhoneNum.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            let phonenumber = self.labelCode.text! + nativenumber
            
            let verificationCode = self.textfieldVeriCode.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            let newPwd = self.textfieldPassword.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            
            self.showProgreeHUD()
            let request = WSAPI.getAlamofireManager().request(WSAPI.Path.Password.url,
                                                              method: .post,
                                                              parameters: ["mobile": phonenumber, "new_password": newPwd, "verify_code": verificationCode],
                                                              encoding: URLEncoding.default,
                                                              headers: ["Accept": WSAPI.HEADER_ACCEPT, "Content-Language": AppPref.convertServiceLanguageCode()])
            request.responseData(completionHandler: { response in
                self.hideHUD()
                
                let successResult = WSAPI.successResult(response.response)
                if successResult {
                    Alert.show(self, message: "password has been changed successfully.".localizedString()) { [weak self] in
                        self!.onClickBack(self!)
                    }
                } else {
                    Alert.show(self, data: response.data)
                }
            })
        }
    }

    func smsTimerAction() {
        self.labelRequest.text = String.init(format: "%ds", smsCounteer)
        
        if smsCounteer == 0 {
            self.buttonReqVerifyCode.isEnabled = true
            self.labelRequest.text = "request code".localizedString()
            smsTimer?.invalidate()
            smsTimer = nil
        } else {
            smsCounteer -= 1
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textfieldConfirmPassword {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func phoneSelectionDidChanged(_ countryCode: String, phoneCode: String) {
        self.countryCode = countryCode
        self.labelCode.text = phoneCode
    }
    
    func checkInfo() -> Bool {
        var result = false
        
        let phonenumber = self.textfieldPhoneNum.text!.trimmingCharacters(
            in: CharacterSet.whitespacesAndNewlines)
        let verificationCode = self.textfieldVeriCode.text!.trimmingCharacters(
            in: CharacterSet.whitespacesAndNewlines)
        let pwd = self.textfieldPassword.text!.trimmingCharacters(
            in: CharacterSet.whitespacesAndNewlines)
        let confirmPwd = self.textfieldConfirmPassword.text!.trimmingCharacters(
            in: CharacterSet.whitespacesAndNewlines)
        
        if phonenumber.isEmpty {
            Alert.show(self, message: "\("please enter phone number.".localizedString())")
        } else if verificationCode.isEmpty {
            Alert.show(self, message: "\("please enter verification code.".localizedString())")
        } else if pwd.isEmpty {
            Alert.show(self, message: "\("please enter password.".localizedString())")
        } else if confirmPwd.isEmpty {
            Alert.show(self, message: "\("please enter password again.".localizedString())")
        } else if pwd != confirmPwd {
            Alert.show(self, message: "\("please enter password correctly.".localizedString())")
        } else if pwd.count < 6 {
            Alert.show(self, message: "\("the password must be at least 6 characters.".localizedString())")
        } else {
            result = true
        }
        
        return result;
    }
}
