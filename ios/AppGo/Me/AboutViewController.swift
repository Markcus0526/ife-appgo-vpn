//
//  AboutViewController.swift
//  AppGoPro
//
//  Created by Striver1 on 8/16/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

import UIKit
import Alamofire

class AboutViewController: BaseViewController {

    @IBOutlet weak var labelAllrighgt: UILabel!
    @IBOutlet weak var labelAboutUs: UILabel!
    @IBOutlet weak var buttonTwitter: UIButton!
    //@IBOutlet weak var buttonTelegram: UIButton!
    @IBOutlet weak var textviewDescription: UITextView!
    
    var txtAboutUs:String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
    }
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
        
        buttonTwitter.layer.borderWidth = 1.0
        buttonTwitter.layer.borderColor = Color.BackBlue.cgColor
        buttonTwitter.layer.backgroundColor = Color.BackBlue.cgColor
        buttonTwitter.layer.cornerRadius = self.buttonTwitter.frame.size.height / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func onLanguageChangeNotification(notification: Notification) {
        labelAllrighgt.text = "all rights".localizedString()
        labelAboutUs.text = "aboutus".localizedString()
        buttonTwitter.setTitle("twitter".localizedString(), for: .normal)
        //buttonTelegram.setTitle("telegram".localizedString(), forState: .Normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickBack(_ sender: AnyObject) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickTwitter(_ sender: AnyObject) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: AppInfo.twitterUrl)!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(URL(string: AppInfo.twitterUrl)!)
        }
    }
    
    @IBAction func onClickTelegram(_ sender: AnyObject) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: AppInfo.telegramUrl)!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(URL(string: AppInfo.telegramUrl)!)
        }
    }

    func updateUIFromService(_ data:Data?) {
        if data != nil {
            let json = NSDataUtils.nsdataToJSON(data!)
            if json != nil {
                textviewDescription.text = json!["content"] as! String?
            } else {
                textviewDescription.text = ""
            }
        } else {
            textviewDescription.text = ""
        }
    }
    
    func fetchData() {
        showProgreeHUD()
        let request = WSAPI.getAlamofireManager().request(WSAPI.Path.AboutUS.url,
                                                      method: .get,
                                                      parameters: nil,
                                                      encoding: URLEncoding.default,
                                                      headers: ["Accept": WSAPI.HEADER_ACCEPT])
        request.responseData(completionHandler: { response in
            self.hideHUD()
            
            let successResult = WSAPI.successResult(response.response)
            if successResult {
                let data = response.result.value
                self.updateUIFromService(data)
            } else {
                //Alert.show(self, message: "\("can't connect to server.".localizedString())")
            }
        })
    }
}
