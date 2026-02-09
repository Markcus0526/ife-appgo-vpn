//
//  HelpDetailViewController.swift
//  AppGoPro
//
//  Created by rbvirakf on 12/20/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

import UIKit

class HelpDetailViewController: BaseViewController {
    
    @IBOutlet weak var labelHelpDetail: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var textviewContent: UITextView!
    
    var helpTitle: String = ""
    var content: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelTitle.text = helpTitle
        textviewContent.text = content
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
       
    }
    
    override func onLanguageChangeNotification(notification: Notification) {        
        labelHelpDetail.text = "help detail".localizedString()
    }
    
    @IBAction func onClickBack(_ sender: AnyObject) {
        navigationController?.popViewController(animated: true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
