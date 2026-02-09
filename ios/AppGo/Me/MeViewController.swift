//
//  MeViewController.swift
//  AppGoPro
//
//  Created by Striver1 on 8/11/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

import Foundation
import UIKit
import MessageUI
import Alamofire
import NetworkExtension


class MeViewController: BaseViewController, MFMailComposeViewControllerDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var labelUsername: UILabel!
    @IBOutlet weak var labelPhonenumber: UILabel!
    @IBOutlet weak var labelACoin: UILabel!
    @IBOutlet weak var labelACoinVale: UILabel!
    @IBOutlet weak var labelLevel: UILabel!
    @IBOutlet weak var labelLevelValue: UILabel!
    
    @IBOutlet weak var labelNotification: UILabel!
    @IBOutlet weak var labelFeedback: UILabel!
    @IBOutlet weak var labelSite: UILabel!
    @IBOutlet weak var labelShare: UILabel!
    @IBOutlet weak var labelRate: UILabel!
    @IBOutlet weak var labelAbout: UILabel!
    @IBOutlet weak var labelLanguage: UILabel!
    @IBOutlet weak var labelPassword: UILabel!
    @IBOutlet weak var labelLogout: UILabel!
    @IBOutlet weak var imageBadge: UIImageView!
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var viewUserInfo: UIView!
    
    @IBOutlet weak var viewNotification: UIView!
    @IBOutlet weak var viewFeedback: UIView!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var viewLogout: UIView!
    
     @IBOutlet weak var constraintFeedback: NSLayoutConstraint!
    @IBOutlet weak var constraintPassword: NSLayoutConstraint!
    @IBOutlet weak var constraintLogout: NSLayoutConstraint!
    
    // MARK: - Variables
    
    static var _singleton: MeViewController?
    var mailAccount: String! = ""
    var aboutUs: String? = nil
    var kf5engine: Bool = false
    
    // MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MeViewController._singleton = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if navigationController != nil && kf5engine {
            navigationController!.setNavigationBarHidden(true, animated: false)
        }
    }
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
        
        labelLevelValue.layer.cornerRadius = 4;
        labelLevelValue.layer.borderColor = UIColor.white.cgColor;
        labelLevelValue.layer.borderWidth = 1;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func onMainTabChangeNotification(notification:Notification) {        
        fetchUserData()
    }
    
    override func onAPNSReceiveNotification(notification:Notification) {
        if AppPref.getBadgeVisible() {
            imageBadge.isHidden = false
        } else {
            imageBadge.isHidden = true
        }
    }
    
    override func onLanguageChangeNotification(notification: Notification) {
        buttonLogin.setTitle("login/register".localizedString(), for: .normal)
        
        labelACoin.text = "acoin".localizedString()
        labelLevel.text = "level".localizedString()
        
        labelNotification.text = "notifications".localizedString()
        labelFeedback.text = "feedback".localizedString()
        labelSite.text = "official site".localizedString()
        labelShare.text = "share appgo".localizedString()
        labelRate.text = "rate appgo".localizedString()
        labelAbout.text = "about".localizedString()
        labelLanguage.text = "language".localizedString()
        labelPassword.text = "password ".localizedString()
        labelLogout.text = "logout".localizedString()
    }
     
    override func onLoginChangeNotification(notification:Notification) {        
        if AppPref.isLogined() {
            viewUserInfo.isHidden = false
            labelUsername.isHidden = false
            buttonLogin.isHidden = true
            
            constraintFeedback.constant = viewNotification.frame.height
            constraintPassword.constant = viewNotification.frame.height
            constraintLogout.constant = viewNotification.frame.height

            viewFeedback.isHidden = false
            viewPassword.isHidden = false
            viewLogout.isHidden = false
            
            fetchUserData()
        } else {
            viewUserInfo.isHidden = true
            labelUsername.isHidden = true
            buttonLogin.isHidden = false
            
            constraintFeedback.constant = 0
            constraintPassword.constant = 0
            constraintLogout.constant = 0

            viewFeedback.isHidden = true
            viewPassword.isHidden = true
            viewLogout.isHidden = true
        }
        
        view.layoutIfNeeded()
    }
    
    override func onPurchaseChangeNotification(notification:Notification) {
        fetchUserData()
    }
    
    // MARK: - IBActions
    
    @IBAction func onClickLogin(_ sender: AnyObject) {
        let vpnStatus = NEVPNStatus(rawValue: AppPref.getVpnStatus())!
        if vpnStatus == .connected {
            NotificationCenter.default.post(name: .VPN_STATUS_CHANGE, object: nil, userInfo: ["status": NEVPNStatus.disconnecting])
            VPNManager.shared.stop()
            
            NotificationCenter.default.post(name: .VPN_STATUS_CHANGE, object: nil, userInfo: ["status": NEVPNStatus.disconnected])
        }
        
        NotificationCenter.default.post(name: .LOGIN_CHANGE, object: nil)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BaseNavViewController")
        self.navigationController?.present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func onClickLogout(_ sender: AnyObject) {
        let vpnStatus = NEVPNStatus(rawValue: AppPref.getVpnStatus())!
        if vpnStatus == .connected {
            NotificationCenter.default.post(name: .VPN_STATUS_CHANGE, object: nil, userInfo: ["status": NEVPNStatus.disconnecting])
            VPNManager.shared.stop()
            
            NotificationCenter.default.post(name: .VPN_STATUS_CHANGE, object: nil, userInfo: ["status": NEVPNStatus.disconnected])
        }
        AppPref.clearUserInfo()
        URLCache.shared.removeAllCachedResponses()
        
        NotificationCenter.default.post(name: .LOGIN_CHANGE, object: nil)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BaseNavViewController")
        self.navigationController?.present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func onClickNotification(_ sender: AnyObject) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        //imageBadge.isHidden = true
        //NotificationCenter.default.post(name: .APNS_DID_RECEIVE, object: true)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onClickFeedback(_ sender: AnyObject) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            //Alert.show(self, title: "could not send email".localizedString(), message: "your device could not send e-mail. please check e-mail configuration and try again.".localizedString())
        }
    }
    
    @IBAction func onClickWebsite(_ sender: UIButton) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: AppInfo.websiteUrl)!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(URL(string: AppInfo.websiteUrl)!)
        }
    }
    
    @IBAction func onClickShare(_ sender: AnyObject) {
        var shareItems: [AnyObject] = []
        shareItems.append("AppGo: " as AnyObject)
        shareItems.append(URL(string: AppInfo.websiteUrl)! as AnyObject)
        shareItems.append(UIImage(named: "AppIcon60x60")!)
        let vc = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        if let ppvc = vc.popoverPresentationController {
            ppvc.sourceView = labelShare
        }
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func onClickRate(_ sender: AnyObject) {
        UIApplication.shared.openURL(URL(string: AppInfo.reviewUrl)!)
    }
    
    @IBAction func onClickHelp(_ sender: AnyObject) {
        
    }
    
    func updateUIFromService(_ data: Data?) {
        if data != nil {
            let json = NSDataUtils.nsdataToJSON(data!)
            if (json != nil) {
                viewUserInfo.isHidden = false
                labelUsername.isHidden = false
                buttonLogin.isHidden = true
                
                constraintFeedback.constant = viewNotification.frame.height
                constraintPassword.constant = viewNotification.frame.height
                constraintLogout.constant = viewNotification.frame.height
                
                viewFeedback.isHidden = false
                viewPassword.isHidden = false
                viewLogout.isHidden = false
                
                let user = MUser(data: json! as! NSDictionary)
                labelUsername.text! = user.nickname
                labelPhonenumber.text! = Country.getNativePhoneNumber(user.mobile)
                labelACoinVale.text! = String(user.acoin)
                labelLevelValue.text! = "LV.\(user.level)"
                mailAccount = user.mailaccount
            }
        } else {
            labelUsername.text! = ""
            labelPhonenumber.text! = ""
            labelACoinVale.text! = ""
            labelLevelValue.text! = ""
            
            viewUserInfo.isHidden = true
            labelUsername.isHidden = true
            buttonLogin.isHidden = false
            
            constraintFeedback.constant = 0
            constraintPassword.constant = 0
            constraintLogout.constant = 0
            
            viewFeedback.isHidden = true
            viewPassword.isHidden = true
            viewLogout.isHidden = true
        }
        
        view.layoutIfNeeded()
    }
    
    // MARK: - Private
    
    func fetchUserData() {
        if AppPref.getServiceUrl() == "" { return }
        
        if AppPref.isLogined() {
            showProgreeHUD()
            let access_token = AppPref.getAccessToken()
            
            let request = WSAPI.getAlamofireManager().request(WSAPI.Path.User.url,
                                                          method: .get,
                                                          parameters: nil,
                                                          encoding: URLEncoding.default,
                                                          headers: ["Accept": WSAPI.HEADER_ACCEPT, "Content-Language": AppPref.convertServiceLanguageCode(), "Authorization": "Bearer \(access_token)"])
            request.responseData(completionHandler: { response in
                self.hideHUD()
                
                let successResult = WSAPI.successResult(response.response)
                if successResult {
                    let data = response.result.value                    
                    self.updateUIFromService(response.result.value)
                } else {
                    self.updateUIFromService(nil)
                }
            })
        } else {
            updateUIFromService(nil)
        }
    }
    
    func sendEmail() {        
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients([AppInfo.emailAccount])
        mailComposerVC.setSubject("appgo feedback".localizedString())
        mailComposerVC.setMessageBody("", isHTML: false)
        
        return mailComposerVC
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}


extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}
