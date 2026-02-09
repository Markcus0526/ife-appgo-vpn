//
//  FeedbackViewController.swift
//  AppGoPro
//
//  Created by rbviraf on 8/16/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

import UIKit


class FeedbackViewController: BaseViewController {

    @IBOutlet weak var labelFeedback: UILabel!
    @IBOutlet weak var labelRequest: UILabel!
    @IBOutlet weak var labelList: UILabel!
    @IBOutlet weak var labelChat: UILabel!
    
    var needBackButton: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (self.navigationController != nil) {
            self.navigationController!.setNavigationBarHidden(true, animated: false)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if needBackButton && self.navigationController != nil {
            navigationController!.setNavigationBarHidden(false, animated: false)

            let backItem = UIBarButtonItem(image: UIImage(named: "ic_back"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(pop))
            navigationItem.leftBarButtonItem = backItem
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func onLanguageChangeNotification(notification: Notification) {        
        labelFeedback.text = "feedback".localizedString()
        labelRequest.text = "request feedback".localizedString()
        labelList.text = "feedback list".localizedString()
        labelChat.text = "feedback chat".localizedString()
    }
    
    @IBAction func onClickBack(_ sender: AnyObject) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func onClickRequest(_ sender: AnyObject) {
        needBackButton = true
        
    }
    
    @IBAction func onClickList(_ sender: AnyObject) {
        needBackButton = true
    }
    
    @IBAction func onClickChat(_ sender: AnyObject) {
        needBackButton = true
    }
}
