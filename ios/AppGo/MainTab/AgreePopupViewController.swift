//
//  LicenseAgreeViewController.swift
//  AppGo
//
//  Created by administrator on 6/12/2018.
//

import UIKit


class AgreePopupViewController: BaseViewController, UITextViewDelegate {
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var viewContent: UITextView!
    @IBOutlet weak var buttonOk: UIButton!
    @IBOutlet weak var buttonCancel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.alpha(0.6)
        
        viewMain.layer.cornerRadius = 10
        
        buttonOk.backgroundColor = Color.BackBlue
        buttonOk.setTitleColor(Color.TabBackground, for: UIControlState.normal)
        buttonOk.layer.cornerRadius = buttonOk.frame.size.height / 2
        
        buttonCancel.backgroundColor = Color.Gray
        buttonCancel.setTitleColor(Color.TextMost, for: UIControlState.normal)
        buttonCancel.layer.cornerRadius = buttonCancel.frame.size.height / 2
        
        labelTitle.text = "agree title".localizedString()
        buttonOk.setTitle("agree license".localizedString(), for: .normal)
        buttonCancel.setTitle("not agree license".localizedString(), for: .normal)
        
        let linkAttributes = [
            NSLinkAttributeName: NSURL(string: AppInfo.websiteUrl + "/privacy.html")!
            ] as [String : Any]
        let attributedString = try! NSMutableAttributedString(
            data: "Thanks for choosing AppGo Booster. Prior to boost your apps, there are a few things you should know:<br/><br/>1. AppGo Booster will NOT upload/modify/decrypt/restore your apps data at any time.<br/><br/>2. Your network performance data(like ping/loss etc) will ONLY be used to improve the boost performance and smooth your apps experience.<br/><br/>3. For details, you should read and accept the new Privacy Policy. You may consent all above and continue.".data(using: String.Encoding.unicode, allowLossyConversion: true)!,
            options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil)
        
        attributedString.setAttributes(linkAttributes, range: NSMakeRange(376, 14))
        attributedString.addAttribute(NSUnderlineStyleAttributeName, value: NSNumber(value: 1), range: NSMakeRange(376, 14))
        
        viewContent.delegate = self
        viewContent.attributedText = attributedString
        viewContent.linkTextAttributes = [NSForegroundColorAttributeName: UIColor.blue]
        viewContent.textColor = UIColor.black
        viewContent.font = UIFont(name: (viewContent.font?.fontName)!, size: 16)
        
        self.showAnimate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickOk(_ sender: Any) {
        AppPref.setLicenseShow(show: false)
        self.removeAnimate()
    }
    
    @IBAction func clickCancel(_ sender: Any) {
        self.removeAnimate()
        exit(0)
    }
    
    func showAnimate() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    func removeAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0}, completion: {(finished: Bool) in
                if finished {
                    self.view.removeFromSuperview()
                }
        })
    }
    
    @available(iOS 10.0, *)
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return true
    }
}

