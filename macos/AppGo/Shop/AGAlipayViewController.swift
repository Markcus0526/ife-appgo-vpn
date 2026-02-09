//
//  AGAlipayViewController.swift
//  AppGoX
//
//  Created by Jadestar on 08/11/2017.
//  Copyright © 2017 appgo. All rights reserved.
//

import Cocoa
import WebKit

class AGAlipayViewController: BaseViewController {
    
    @IBOutlet weak var lblTitle: NSTextField!
    @IBOutlet weak var vwTitleBar: NSView!
    
    @IBOutlet weak var vwWebview: WebView!
    
    var alipayUrl: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        configureUI()        
        
        let url = URL(string: alipayUrl)
        vwWebview.mainFrame.load(URLRequest(url: url!))
    }
    
    override func onLanguageChangeNotification(notification: Notification) {
        lblTitle.stringValue = "alipay".localizedString()
    }
    
    
    private func configureUI() {
        view.setBackgroundColor(color: CGColor.white)
        vwTitleBar.setBackgroundColor(color: CGColor.agMainColor)
    }
    
    @IBAction func onBackButtonClicked(_ sender: NSButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    
}
