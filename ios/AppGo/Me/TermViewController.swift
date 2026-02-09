//
//  FeedBackViewController.swift
//  AppGoPro
//
//  Created by Striver1 on 8/16/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

import UIKit
import Alamofire


class TermViewController: BaseViewController {
    
    @IBOutlet weak var labelTerm: UILabel!
    @IBOutlet weak var textviewContent: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchTermData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
    }
    
    override func onLanguageChangeNotification(notification: Notification) {
        labelTerm.text = "term of use".localizedString()
    }
    
    @IBAction func onClickBack(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }

    func updateUIFromService(_ data:Data?) {
        if data != nil {
            let json = NSDataUtils.nsdataToJSON(data!)
            if json != nil {
                textviewContent.text = json!["content"] as! String?
            } else {
                textviewContent.text = ""
            }
        } else {
            textviewContent.text = ""
        }
    }
    
    func fetchTermData() {
        let request = WSAPI.getAlamofireManager().request(WSAPI.Path.Tos.url,
                                                          method: .get,
                                                          parameters: nil,
                                                          encoding: URLEncoding.default,
                                                          headers: ["Accept": WSAPI.HEADER_ACCEPT, "Content-Language": AppPref.convertServiceLanguageCode()])
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
