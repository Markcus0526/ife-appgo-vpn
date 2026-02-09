//
//  LoginViewController.swift
//  AppGoPro
//
//  Created by Striver1 on 8/11/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

import UIKit
import Alamofire


class LoginViewController: BaseViewController, UITextFieldDelegate, PhoneCodeUpdateEvent {

    @IBOutlet weak var txtfieldPhoneNumber: UITextField!
    @IBOutlet weak var txtfieldPassword: UITextField!
    
    @IBOutlet weak var labelCode: UILabel!
    @IBOutlet weak var labelAppDesc: UILabel!
    @IBOutlet weak var labelPrompt: UILabel!
    @IBOutlet weak var labelAllDevice: UILabel!

    @IBOutlet weak var buttonSignin: UIButton!
    @IBOutlet weak var buttonForgotPwd: UIButton!
    @IBOutlet weak var buttonRegister: UIButton!

    var countryCode: String = "CN"
    var phoneCode: String = "+86"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
        
        buttonSignin.layer.borderWidth = 1.0
        buttonSignin.layer.borderColor = Color.BackBlue.cgColor
        buttonSignin.layer.backgroundColor = Color.TextActive.cgColor
        buttonSignin.layer.cornerRadius = buttonSignin.frame.size.height / 2
        
        
        buttonRegister.layer.borderWidth = 1.0
        buttonRegister.layer.borderColor = Color.BackBlue.cgColor
        buttonRegister.layer.cornerRadius = buttonRegister.frame.size.height / 2
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func onLanguageChangeNotification(notification: Notification) {
        labelCode.text = phoneCode
        
        txtfieldPhoneNumber.placeholder = "enter phone number".localizedString()
        txtfieldPassword.placeholder = "enter password".localizedString()
        buttonSignin.setTitle("sign in".localizedString(), for: .normal)
        buttonForgotPwd.setTitle("forgot password".localizedString(), for: .normal)
        buttonRegister.setTitle("register now".localizedString(), for: .normal)
        labelAppDesc.text! = "stable service and speed, give you a different experience".localizedString()
        labelPrompt.text! = "prompt".localizedString()
        labelAllDevice.text! = "all device install".localizedString()
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
        self.dismiss()
    }
        
    @IBAction func onClickSignIn(_ sender: AnyObject) {
        self.txtfieldPassword.resignFirstResponder()
        self.txtfieldPhoneNumber.resignFirstResponder()
        
        if checkInfo() {
            //let phonenumber = (self.buttonCode.titleLabel?.text)! + (self.buttonCode.titleLabel?.text)! +
            //    self.txtfieldPhoneNumber.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            let phonenumber = self.labelCode.text! + self.txtfieldPhoneNumber.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            let password = self.txtfieldPassword.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            
            showProgreeHUD()            
            let request = WSAPI.getAlamofireManager().request(WSAPI.Path.Login.url,
                                                          method: .post,
                                                          parameters: ["username": phonenumber, "password": password, "client_id": WSAPI.CLIENT_ID, "client_secret": WSAPI.CLIENT_SECRET, "grant_type": "password"],
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
                        AppPref.setLoginInfo(phone: phonenumber, pwd: password, json: json!)
                        NotificationCenter.default.post(name: .LOGIN_CHANGE, object: nil)
                        
                        self.dismiss()

                    }
                } else {
                    Alert.show(self, data: response.data)
                }
            })
        }
    }
    
    // MARK: - Textfield
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.isEqual(self.txtfieldPhoneNumber){
            textField.becomeFirstResponder()
        }else if (textField.isEqual(self.txtfieldPassword)){
            textField.resignFirstResponder()
        }
        return true
    }
    
    func checkInfo()-> Bool{
        var result = false
        
        // field verification
        let phonenumber = self.txtfieldPhoneNumber.text!.trimmingCharacters(
            in: CharacterSet.whitespacesAndNewlines)
        let password = self.txtfieldPassword.text!.trimmingCharacters(
            in: CharacterSet.whitespacesAndNewlines)
        
        if phonenumber.isEmpty {
            Alert.show(self, message: "\("please enter phone number.".localizedString())")
        } else if password.isEmpty {
            Alert.show(self, message: "\("please enter password.".localizedString())")
        } else if password.count < 6 {
            Alert.show(self, message: "\("the password must be at least 6 characters.".localizedString())")
        } else {
            result = true
        }
        
        return result;
    }
    
    func phoneSelectionDidChanged(_ countryCode: String, phoneCode: String) {
        self.countryCode = countryCode
        labelCode.text = phoneCode
    }
}
