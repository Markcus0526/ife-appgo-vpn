//
//  RegisterViewController.swift
//  AppGoPro
//
//  Created by Striver1 on 8/15/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

import UIKit
import Alamofire


class RegisterViewController: BaseViewController, UITextFieldDelegate, PhoneCodeUpdateEvent {

    @IBOutlet weak var labelMailAccount: UILabel!
    @IBOutlet weak var labelNickName: UILabel!
    @IBOutlet weak var labelPhoneNum: UILabel!
    @IBOutlet weak var labelVeriCode: UILabel!
    @IBOutlet weak var labelRequest: UILabel!
    @IBOutlet weak var labelPassword: UILabel!
    @IBOutlet weak var labelConfirmPassword: UILabel!
    @IBOutlet weak var labelCode: UILabel!
    @IBOutlet weak var textfieldMailAccount: UITextField!
    @IBOutlet weak var textfieldNickName: UITextField!
    @IBOutlet weak var textfieldPhoneNum: UITextField!
    @IBOutlet weak var textfieldVeriCode: UITextField!
    @IBOutlet weak var textfieldPassword: UITextField!
    @IBOutlet weak var textfieldConfirmPassword: UITextField!
    @IBOutlet weak var buttonSignUp: UIButton!
    @IBOutlet weak var buttonAleadyHave: UIButton!
    @IBOutlet weak var buttonSignIn: UIButton!
    @IBOutlet weak var buttonReqVerifyCode: UIButton!
    @IBOutlet weak var buttonTerm: UIButton!
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
        
        buttonSignUp.layer.borderWidth = 1.0
        buttonSignUp.layer.borderColor = Color.BackBlue.cgColor
        buttonSignUp.layer.backgroundColor = Color.BackBlue.cgColor
        buttonSignUp.layer.cornerRadius = buttonSignUp.frame.size.height / 2
        
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
        labelMailAccount.text = "email account".localizedString()
        labelNickName.text = "nick name".localizedString()
        labelPhoneNum.text = "phone number".localizedString()
        labelVeriCode.text = "verification code".localizedString()
        labelRequest.text = "request code".localizedString()
        labelPassword.text = "password".localizedString()
        labelConfirmPassword.text = "confirm password".localizedString()
        
        textfieldMailAccount.placeholder = "enter email account".localizedString()
        textfieldNickName.placeholder = "enter nick name".localizedString()
        textfieldPhoneNum.placeholder = "enter phone number".localizedString()
        textfieldVeriCode.placeholder = "enter code".localizedString()
        textfieldPassword.placeholder = "enter password".localizedString()
        textfieldConfirmPassword.placeholder = "enter password again".localizedString()
        
        
        buttonSignUp.setTitle("sign up".localizedString(), for: .normal)
        buttonAleadyHave.setTitle("already have id?".localizedString(), for: .normal)
        buttonSignIn.setTitle("sign in".localizedString(), for: .normal)
        buttonTerm.setTitle("term of use".localizedString(), for: .normal)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PhoneListViewController {
            vc.selCountryCode = countryCode
            vc.selPhoneCode = labelCode.text!
            vc.delegate = self
        }
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
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickSignUpButton(_ sender: AnyObject) {
        // field verification
        let mailaccount = self.textfieldMailAccount.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let nickname = self.textfieldNickName.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let nativenumber = self.textfieldPhoneNum.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let phonenumber = self.labelCode.text! + nativenumber
        let verificationCode = self.textfieldVeriCode.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let password = self.textfieldPassword.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if checkInfo() {
            showProgreeHUD()
            let request = WSAPI.getAlamofireManager().request(WSAPI.Path.Register.url,
                                                          method: .post,
                                                          parameters: ["email": mailaccount, "mobile": phonenumber, "nickname": nickname, "password": password, "verify_code": verificationCode],
                                                          encoding: URLEncoding.default,
                                                          headers: ["Accept": WSAPI.HEADER_ACCEPT, "Content-Language": AppPref.convertServiceLanguageCode()])
            request.responseData(completionHandler: { response in
                self.hideHUD()
                
                let successResult = WSAPI.successResult(response.response)
                if successResult {
                    let json = NSDataUtils.nsdataToJSON(response.result.value!)
                    if json == nil {
                        Alert.show(self, data: response.data)
                    } else {
                        Alert.show(self, message: "\("sign up succeeded!".localizedString())") { [weak self] in
                            self!.onClickBack(self!)
                        }
                    }
                } else {
                    Alert.show(self, data: response.data)
                }
            })
        }
    }
    
    @IBAction func onClickRequestVerifyCode(_ sender: AnyObject) {
        let nativenumber = self.textfieldPhoneNum.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if nativenumber.isEmpty {
            Alert.show(self, message: "\("please enter phone number.".localizedString())")
        } else if AppPref.isValidSms() == false {
            Alert.show(self, message: "\("you can't use sms today, please retry tomorrow again.".localizedString())")
        } else {
            let phonenumber = self.labelCode.text! + self.textfieldPhoneNum.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            showProgreeHUD()
            
            let request = WSAPI.getAlamofireManager().request(WSAPI.Path.Sms.url,
                                                             method: .post,
                                                             parameters: ["mobile": phonenumber, "for": "register"],
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
    
    func checkInfo()-> Bool{
        var result = false
        
        let mailaccount = self.textfieldMailAccount.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let nickname = self.textfieldNickName.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let phonenumber = self.textfieldPhoneNum.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let verificationCode = self.textfieldVeriCode.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let pwd = self.textfieldPassword.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let confirmPwd = self.textfieldConfirmPassword.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        
        if mailaccount.isEmpty {
            Alert.show(self, message: "\("please enter email account.".localizedString())")
        } else if isInvalidEmail(mailaccount) {
            Alert.show(self, message: "\("the email account is invalid format.".localizedString())")
        } else if nickname.isEmpty {
            Alert.show(self, message: "\("please enter nick name.".localizedString())")
        } else if phonenumber.isEmpty {
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

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textfieldConfirmPassword {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func phoneSelectionDidChanged(_ countryCode: String, phoneCode: String) {
        self.countryCode = countryCode
        labelCode.text = phoneCode
    }
    
    func isInvalidEmail(_ input:String) -> Bool {
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
