//
//  AGFeedbackViewController.swift
//  AppGoX
//
//  Created by user on 17.10.27.
//  Copyright © 2017 appgo. All rights reserved.
//

import Cocoa

class AGFeedbackViewController: BaseViewController {

    @IBOutlet weak var vwTitleBar: NSView!
    @IBOutlet weak var lblTitle: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        configureUI()
    }
    
    private func configureUI() {
        view.setBackgroundColor(color: CGColor.white)
        vwTitleBar.setBackgroundColor(color: CGColor.agMainColor)
    }
    
    override func onLanguageChangeNotification(notification: Notification) {
        lblTitle.stringValue = "feedback".localizedString()
    }
    
    @IBAction func onBackButtonClicked(_ sender: NSButton) {
        navigationController?.popViewControllerAnimated(true)
    }    
    
}
