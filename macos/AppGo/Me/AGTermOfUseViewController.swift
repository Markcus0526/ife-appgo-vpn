//
//  AGTermOfUseViewController.swift
//  AppGoX
//
//  Created by user on 17.10.27.
//  Copyright © 2017 appgo. All rights reserved.
//

import Cocoa
import ProgressKit
import Alamofire


class AGTermOfUseViewController: BaseViewController {

    @IBOutlet weak var vwTitleBar: NSView!
    @IBOutlet weak var lblTitle: NSTextField!
    @IBOutlet var lblContent: NSTextView!
    
    
    @IBOutlet weak var pgLoading: Crawler!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        fetchServiceData()
        
        configureUI()
    }
    
    override func onLanguageChangeNotification(notification: Notification) {
        lblTitle.stringValue = "term of use".localizedString()
    }
    
    @IBAction func onBackButtonClicked(_ sender: NSButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func updateUIFromService(data: Data?) {
        if data != nil {
            let json = NSDataUtils.nsdataToJSON(data: data!)
            if json != nil {
                lblContent.string = json!["content"] as! String?
                
                let area: NSRange = NSMakeRange(0, lblContent.string!.count)
                lblContent.setTextColor(NSColor.hexColor(rgbValue: 0x58C7FF, alpha: 1.0), range: area)
            } else {
                lblContent.string = ""
            }
        } else {
            lblContent.string = ""
        }
    }
    
    private func configureUI() {
        view.setBackgroundColor(color: CGColor.white)
        vwTitleBar.setBackgroundColor(color: CGColor.agMainColor)
    }
    
    func fetchServiceData() {
        let request = WSAPI.getAlamofireManager().request(WSAPI.Path.tos.url,
                                                          method: .get,
                                                          headers: ["Accept": WSAPI.HEADER_ACCEPT, "Content-Language": AppPref.getServiceLanguage()])
        request.responseData { response in
            DispatchQueue.main.async {
                self.pgLoading.animate = false
            }
            let successResult = WSAPI.successResult(response: response.response)
            if successResult {
                let data = response.result.value
                self.updateUIFromService(data: data)
            }
        }
    }
}
