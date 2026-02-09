//
//  PasswordViewController.swift
//  AppGoPro
//
//  Created by Striver1 on 8/16/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

import UIKit
import Alamofire

class PasswordViewController: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var labelPassword: UILabel!
    @IBOutlet weak var labelCurrentPassword: UILabel!
    @IBOutlet weak var labelNewPassword: UILabel!
    @IBOutlet weak var labelConfirmPassword: UILabel!
    @IBOutlet weak var labelVerifyCode: UILabel!
    @IBOutlet weak var labelRequest: UILabel!
    @IBOutlet weak var buttonDone: UIButton!
    @IBOutlet weak var buttonReqVerifyCode: UIButton!
    @IBOutlet weak var textFieldCurrentPassword: UITextField!
    @IBOutlet weak var textFieldNewPassword: UITextField!
    @IBOutlet weak var textFieldConfirmPassword: UITextField!
    @IBOutlet weak var textFieldVerifyCode: UITextField!
    @IBOutlet weak var viewSMS: UIView!
    
    var smsTimer: Timer?
    var smsCounteer: Int = 120
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
        
        buttonDone.layer.borderWidth = 1.0
        buttonDone.layer.borderColor = Color.BackBlue.cgColor
        buttonDone.layer.backgroundColor = Color.BackBlue.cgColor
        buttonDone.layer.cornerRadius = buttonDone.frame.size.height / 2
        
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
        labelPassword.text = "modify password".localizedString()
        labelCurrentPassword.text = "current password".localizedString()
        labelNewPassword.text = "new password".localizedString()
        labelConfirmPassword.text = "confirm password".localizedString()
        labelVerifyCode.text = "verification code".localizedString()
        labelRequest.text = "request code".localizedString()
        
        textFieldCurrentPassword.placeholder = "enter password".localizedString()
        textFieldNewPassword.placeholder = "enter new password".localizedString()
        textFieldConfirmPassword.placeholder = "enter new password again".localizedString()
        textFieldVerifyCode.placeholder = "enter code".localizedString()
        
        buttonDone.setTitle("modify password".localizedString(), for: .normal)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onClickBack(_ sender: AnyObject) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickRequestVerifyCode(_ sender: AnyObject) {
        let phonenumber = AppPref.getLastLoginPhoneNumber()
        
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
    
    
    @IBAction func onClickSave(_ sender: AnyObject) {
        if checkInfo() {
            let newPwd = self.textFieldNewPassword.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            let verificationCode = self.textFieldVerifyCode.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            
            showProgreeHUD()
            
            let request = WSAPI.getAlamofireManager().request(WSAPI.Path.Password.url,
                                                              method: .post,
                                                              parameters: ["mobile": AppPref.getLastLoginPhoneNumber(), "new_password": newPwd, "verify_code": verificationCode],
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
    
    func checkInfo() -> Bool {
        var result = false
        
        // field verification
        let curPwd = self.textFieldCurrentPassword.text!.trimmingCharacters(
            in: CharacterSet.whitespacesAndNewlines)
        let newPwd = self.textFieldNewPassword.text!.trimmingCharacters(
            in: CharacterSet.whitespacesAndNewlines)
        let confirmPwd = self.textFieldConfirmPassword.text!.trimmingCharacters(
            in: CharacterSet.whitespacesAndNewlines)
        
        if curPwd.isEmpty {
            Alert.show(self, message: "\("please enter current password.".localizedString())")
        } else if newPwd.isEmpty {
            Alert.show(self, message: "\("please enter new password.".localizedString())")
        } else if confirmPwd.isEmpty {
            Alert.show(self, message: "\("please enter new password again.".localizedString())")
        } else if curPwd.count < 6 ||  newPwd.count < 6 || confirmPwd.count < 6 {
            Alert.show(self, message: "\("the password must be at least 6 characters.".localizedString())")
        } else if newPwd != confirmPwd {
            Alert.show(self, message: "\("please enter password correctly.".localizedString())")
        } else if curPwd != AppPref.getLastLoginPassword() {
            Alert.show(self, message: "\("please enter password correctly.".localizedString())")
        } else {
            result = true
        }
        
        return result;
    }
    
    func smsTimerAction() {
        labelRequest.text = String.init(format: "%ds", smsCounteer)
        
        if smsCounteer == 0 {
            buttonReqVerifyCode.isEnabled = true
            labelRequest.text = "request code".localizedString()
            smsTimer?.invalidate()
            smsTimer = nil
        } else {
            smsCounteer -= 1
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == textFieldConfirmPassword){
            textField.resignFirstResponder()
        }
        return true
    }
}
