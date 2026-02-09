//
//  MainTabViewController.swift
//  AppGoPro
//
//  Created by Striver1 on 8/11/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

import UIKit
import Alamofire

class MainTabViewController: BaseViewController {
    
    @IBOutlet var containerViewCollections: [UIView]!
    @IBOutlet var viewCollectionTabItems: [UIView]!
    @IBOutlet weak var labelRun: UILabel!
    @IBOutlet weak var labelShop: UILabel!
    @IBOutlet weak var labelMe: UILabel!
    @IBOutlet weak var imageRun: UIImageView!
    @IBOutlet weak var imageShop: UIImageView!
    @IBOutlet weak var imageMe: UIImageView!
    @IBOutlet weak var imageBadge: UIImageView!

    final let TRANSFER_MAX: TimeInterval = 60 * 1
    var tabNo = 0
    var baseUrlTimer: Timer? = nil
    var timeCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        baseUrlTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(onBaseUrlTimer), userInfo: nil, repeats: true)
    }
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
        
        self.showTab(tabNo)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func onLanguageChangeNotification(notification: Notification) {
        self.labelRun.text = "run".localizedString()
        self.labelShop.text = "shop".localizedString()
        self.labelMe.text = "me".localizedString()
    }
    
    @IBAction func onClickTabItems(_ sender: UIButton) {
        self.showTab(sender.tag);
        tabNo = sender.tag
    }
    
    func showTab(_ tag : NSInteger) {
        // update tab bar item
        if tag == 0 {
            labelRun.textColor = Color.TextActive
            imageRun.image = UIImage(named: "ic_tab_run")
            
            labelShop.textColor = Color.TextReadonly
            imageShop.image = UIImage(named: "ic_tab_shop_gray")
            labelMe.textColor = Color.TextReadonly
            imageMe.image = UIImage(named: "ic_tab_me_gray")
        } else if tag == 1 {
            labelShop.textColor = Color.TextActive
            imageShop.image = UIImage(named: "ic_tab_shop")
            
            labelRun.textColor = Color.TextReadonly
            imageRun.image = UIImage(named: "ic_tab_run_gray")
            labelMe.textColor = Color.TextReadonly
            imageMe.image = UIImage(named: "ic_tab_me_gray")
        } else {
            labelMe.textColor = Color.TextActive
            imageMe.image = UIImage(named: "ic_tab_me")
            
            labelRun.textColor = Color.TextReadonly
            imageRun.image = UIImage(named: "ic_tab_run_gray")
            labelShop.textColor = Color.TextReadonly
            imageShop.image = UIImage(named: "ic_tab_shop_gray")
        }
        
        
        // update content container
        for container in containerViewCollections {
            if tag == container.tag {
                container.isHidden = false
                NotificationCenter.default.post(name: .MAINTAB_CHANGE, object: nil)
            } else {
                container.isHidden = true
            }
        }
    }
    
    func onBaseUrlTimer() {
        let url = AppPref.getServiceUrl()
        if url != "" {
            baseUrlTimer?.invalidate()
            baseUrlTimer = nil
            
            if AppPref.getLicenseShow() {
                showLicenseAgreeView()
            }
            
            self.checkLoginState()
            self.fetchVersionData()
            self.checkNotificationData()            
        } else if timeCount > 20 {
            baseUrlTimer?.invalidate()
            baseUrlTimer = nil
            
            AppPref.clearLoginInfo()
            NotificationCenter.default.post(name: .LOGIN_CHANGE, object: nil)
        }
        timeCount += 1
    }
    
    func checkLoginState() {
        let phonenumber = AppPref.getLastLoginPhoneNumber()
        let password = AppPref.getLastLoginPassword()
        
        if phonenumber != "" && password != "" {
            let request = WSAPI.getAlamofireManager().request(WSAPI.Path.Login.url,
                                                              method: .post,
                                                              parameters: ["username": phonenumber, "password": password, "client_id": WSAPI.CLIENT_ID, "client_secret": WSAPI.CLIENT_SECRET, "grant_type": "password"],
                                                              encoding: URLEncoding.default,
                                                              headers: ["Accept": WSAPI.HEADER_ACCEPT, "Content-Language": AppPref.convertServiceLanguageCode()])
            request.responseData(completionHandler: { response in
                let successResult = WSAPI.successResult(response.response)
                if successResult {
                    let json = NSDataUtils.nsdataToJSON(response.result.value!)
                    AppPref.updateLoginInfo(json: json!)
                } else {
                    AppPref.clearLoginInfo()
                }
                
                NotificationCenter.default.post(name: .LOGIN_CHANGE, object: nil)
            })
        } else if AppPref.getTouristId() == "" {
            let request = WSAPI.getAlamofireManager().request(WSAPI.Path.Tourist.url,
                                                              method: .get,
                                                              parameters: nil,
                                                              encoding: URLEncoding.default,
                                                              headers: ["Accept": WSAPI.HEADER_ACCEPT, "Content-Language": AppPref.convertServiceLanguageCode()])
            request.responseData(completionHandler: { response in
                let successResult = WSAPI.successResult(response.response)
                if successResult {
                    let json = NSDataUtils.nsdataToJSON(response.result.value!)
                    let tourist = json!["tourist_id"] as! String
                    AppPref.setTouristId(tourist: tourist)
                } else {
                    Alert.show(self, message: "can't connect to server.".localizedString())
                }
                
                NotificationCenter.default.post(name: .LOGIN_CHANGE, object: nil)
            })
        }
    }

    func fetchVersionData() {
        let request = WSAPI.getAlamofireManager().request(WSAPI.Path.Version.url,
                                                          method: .get,
                                                          parameters: nil,
                                                          encoding: URLEncoding.default,
                                                          headers: ["Accept": WSAPI.HEADER_ACCEPT, "Content-Language": AppPref.convertServiceLanguageCode()])
        request.responseData(completionHandler: { response in
            self.hideHUD()
            
            let successResult = WSAPI.successResult(response.response)
            if successResult {
                let json = NSDataUtils.nsdataToJSON(response.result.value!)
                if json != nil {
                    let ver = ((json!["version"] as! String) as NSString).floatValue
                    if ver > Float(AppInfo.Version) {
                        Alert.show(self, message: "\("new version is available. please update now.".localizedString())", confirmCallback: { [weak self] in
                            let link = json!["link"] as! String
                            if #available(iOS 10.0, *) {
                                UIApplication.shared.open(URL(string: link)!, options: [:], completionHandler: nil)
                            } else {
                                UIApplication.shared.openURL(URL(string: link)!)
                            }
                            }, cancelCallback: {})
                    }
                }
            }
        })
    }
    
    func checkNotificationData() {
        let request = WSAPI.getAlamofireManager().request(WSAPI.Path.Notifications.url,
                                                          method: .get,
                                                          parameters: ["page": 1, "per_page": 15],
                                                          encoding: URLEncoding.default,
                                                          headers: ["Accept": WSAPI.HEADER_ACCEPT, "Content-Language": AppPref.convertServiceLanguageCode()])
        request.responseData(completionHandler: { response in
            let successResult = WSAPI.successResult(response.response)
            if successResult {
                var visible = false
                
                let data = response.result.value
                if data != nil {
                    let json = NSDataUtils.nsdataToJSON(data!) as! NSDictionary
                    let lasttime = AppPref.getNotificationTime()
                    let array = json["data"] as? NSArray
                    if array != nil && array!.count > 0 {
                        let push = MPush(data: array![0] as! NSDictionary)
                        if push.updatedat == "" { return }
                        if lasttime == "" || lasttime != push.updatedat {
                            visible = true
                        }
                    }
                }
                
                AppPref.setBadgeVisible(visible: visible)
                NotificationCenter.default.post(name: .APNS_RECEIVE, object: nil)
            }
        })
    }
    
    func showLicenseAgreeView() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AgreePopupViewController") as! AgreePopupViewController
        self.addChildViewController(vc)
        vc.view.frame = self.view.frame
        self.view.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
    }
}
