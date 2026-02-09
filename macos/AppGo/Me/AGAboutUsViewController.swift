//
//  AGAboutUsViewController.swift
//  AppGoX
//
//  Created by user on 17.10.26.
//  Copyright © 2017 appgo. All rights reserved.
//

import Cocoa
import Alamofire
import ProgressKit


class AGAboutUsViewController: BaseViewController {

    @IBOutlet weak var lblAllright: NSTextField!
    @IBOutlet weak var lblAboutUsTitle: NSTextField!
    @IBOutlet weak var lblAboutUs: NSTextView!
    @IBOutlet weak var lblVersion: NSTextField!
    

    @IBOutlet weak var btnTwitter: NSButton!
    
    @IBOutlet weak var pgLoading: Crawler!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do view setup here.
        fetchServiceData()
        configureUI()
    }
    
    override func onLanguageChangeNotification(notification: Notification) {
        lblAllright.stringValue = "all rights".localizedString()
        lblAboutUsTitle.stringValue = "aboutus".localizedString()
        lblVersion.stringValue = "app version".localizedString()
        configureTwitterButton()
    }
    
    @IBAction func onBackButtonClicked(_ sender: NSButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func onTwitterButtonClicked(_ sender: NSButton) {
        if let url = URL(string: AppInfo.twitterUrl), NSWorkspace.shared().open(url) {
            print("default browser was successfully opened")
        }
    }
    
    private func configureUI() {
        view.setBackgroundColor(color: CGColor.white)
    }
    
    func updateUIFromService(data: Data?) {
        if data != nil {
            let json = NSDataUtils.nsdataToJSON(data: data!)
            if json != nil {
                lblAboutUs.string = json!["content"] as! String?
                
                let area: NSRange = NSMakeRange(0, lblAboutUs.string!.count)
                lblAboutUs.setTextColor(NSColor.hexColor(rgbValue: 0x58C7FF, alpha: 1.0), range: area)
            } else {
                lblAboutUs.string = ""
            }
        } else {
            lblAboutUs.string = ""
        }
    }
    
    private func configureTwitterButton() {
        let titleString: String = "twitter".localizedString()
        let title: NSMutableAttributedString = NSMutableAttributedString.init(string: titleString)
        title.addAttribute(NSForegroundColorAttributeName, value: NSColor.white, range: NSRange.init(location: 0, length: titleString.count))
        
        let style: NSMutableParagraphStyle = NSMutableParagraphStyle.init()
        style.alignment = NSCenterTextAlignment
        title.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSRange.init(location: 0, length: titleString.count))
        
        let font: NSFont = NSFont.systemFont(ofSize: 15)
        title.addAttribute(NSFontAttributeName, value: font, range: NSRange.init(location: 0, length: titleString.count))
        
        btnTwitter.attributedTitle = title
    }
    
    func fetchServiceData() {
        let request: Alamofire.DataRequest?
        
        request = WSAPI.getAlamofireManager().request(WSAPI.Path.AboutUS.url,
                                                      method: .get,
                                                      headers: ["Accept": WSAPI.HEADER_ACCEPT, "Content-Language": AppPref.getServiceLanguage()])
        request!.responseData { response in
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
