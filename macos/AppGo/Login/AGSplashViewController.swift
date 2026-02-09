//
//  AGSplashViewController.swift
//  AppGo
//
//  Created by administrator on 18/12/2018.
//  Copyright © 2018 AppGo. All rights reserved.
//

import Cocoa

class AGSplashViewController: BaseViewController {
    
    var serviceUrlTimer: Timer?
    var timeCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        self.serviceUrlTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.serviceUrlTimerAction), userInfo: nil, repeats: true)
    }
    
    private func configureUI() {
        view.setBackgroundColor(color: CGColor.white)
    }
    
    func showMainView() {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateController(withIdentifier: "AGMainViewController") as! AGMainViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showLoginView() {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateController(withIdentifier: "AGLoginViewController") as! AGLoginViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func serviceUrlTimerAction() {
        let url = AppPref.getServiceUrl()
        if url != "" {
            serviceUrlTimer?.invalidate()
            serviceUrlTimer = nil
            timeCount = 0
            
            self.checkLoginState()
            self.checkVersionInfo()
        } else if timeCount > 20 {
            serviceUrlTimer?.invalidate()
            serviceUrlTimer = nil
            timeCount = 0
            
            AppPref.clearLoginInfo()
            NotificationCenter.default.post(name: .LOGIN_CHANGE, object: nil)
        }
        timeCount += 1
    }
    
    func checkLoginState() {
        let phonenumber = AppPref.getLastLoginPhoneNumber()
        let password = AppPref.getLastLoginPassword()
        let request = WSAPI.getAlamofireManager().request(WSAPI.Path.Login.url,
                                                          method: .post,
                                                          parameters: ["username": phonenumber, "password": password, "client_id": WSAPI.CLIENT_ID, "client_secret": WSAPI.CLIENT_SECRET, "grant_type": "password"],
                                                          headers: ["Accept": WSAPI.HEADER_ACCEPT, "Content-Language": AppPref.getServiceLanguage()])
        request.responseData { response in
            let successResult = WSAPI.successResult(response: response.response)
            if successResult {
                let json = NSDataUtils.nsdataToJSON(data: response.result.value!)
                if json == nil {
                    AppPref.clearUserInfo()
                    URLCache.shared.removeAllCachedResponses()
                } else {
                    AppPref.setAccessToken(token: json!["access_token"] as! String)
                    AppPref.setRefreshToken(token: json!["refresh_token"] as! String)
                }
            } else {
                AppPref.clearUserInfo()
                URLCache.shared.removeAllCachedResponses()
            }
            
            if AppPref.isLogined() {
                self.showMainView()
            } else {
                self.showLoginView()
            }
        }
    }
    
    func checkVersionInfo() {
        let request = WSAPI.getAlamofireManager().request(WSAPI.Path.Version.url,
                                                          method: .get,
                                                          headers: ["Accept": WSAPI.HEADER_ACCEPT, "Content-Language": AppPref.getServiceLanguage()])
        request.responseData { response in
            let successResult = WSAPI.successResult(response: response.response)
            if successResult {
                let data = response.result.value
                let json = NSDataUtils.nsdataToJSON(data: data!)
                if json != nil {
                    let version = MVersion(data: json! as! NSDictionary)
                    if version.version > AppInfo.Version {
                        Alert.show(message: "new version is available.please update now.".localizedString(), confirmCallback: {
                            [weak self] in
                            if let url = URL(string: version.link), NSWorkspace.shared().open(url) {
                                print("default browser was successfully opened")
                            }
                            }, cancelCallback: {
                                [weak self] in
                        })
                    }
                }
            }
        }
    }
}
