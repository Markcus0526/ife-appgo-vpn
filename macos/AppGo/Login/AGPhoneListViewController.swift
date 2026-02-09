//
//  AGPhoneListViewController.swift
//  AppGoX
//
//  Created by user on 17.10.27.
//  Copyright © 2017 appgo. All rights reserved.
//

import Cocoa

class AGPhoneListViewController: BaseViewController, NSTableViewDelegate, NSTableViewDataSource {

    @IBOutlet weak var vwTitleBar: NSView!
    @IBOutlet weak var lblTitle: NSTextField!
    
    @IBOutlet weak var tvCountryList: NSTableView!
    
    @IBOutlet weak var vwButtons: NSView!
    @IBOutlet weak var btnApply: NSButton!
    
    var selectionIndex: Int = 0
    
    var delegate: AGPhoneListEventDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        configureUI()
    }
    
    private func configureUI() {
        view.setBackgroundColor(color: CGColor.white)
        vwTitleBar.setBackgroundColor(color: CGColor.agMainColor)
        vwButtons.setBackgroundColor(color: CGColor.agDarkGreyColor)
        
        tvCountryList.selectionHighlightStyle = NSTableViewSelectionHighlightStyle.none
    }
    
    override func onLanguageChangeNotification(notification: Notification) {
        lblTitle.stringValue = "country code".localizedString()
        configureApplyButton()
    }
    
    private func configureApplyButton() {
        let titleString: String = "ok".localizedString()
        let title: NSMutableAttributedString = NSMutableAttributedString.init(string: titleString)
        title.addAttribute(NSForegroundColorAttributeName, value: NSColor.init(cgColor: CGColor.agDarkBlueColor), range: NSRange.init(location: 0, length: titleString.count))
        
        let style: NSMutableParagraphStyle = NSMutableParagraphStyle.init()
        style.alignment = NSRightTextAlignment
        title.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSRange.init(location: 0, length: titleString.count))
        
        let font: NSFont = NSFont.systemFont(ofSize: 16)
        title.addAttribute(NSFontAttributeName, value: font, range: NSRange.init(location: 0, length: titleString.count))
        
        btnApply.attributedTitle = title
    }
    
    @IBAction func onBackButtonClicked(_ sender: NSButton) {
        onApplyButtonClicked(sender)        
    }
    
    //NSTableView Data Source
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 50
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return countryInfos.count - 1
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let rowView: NSView = tableView.make(withIdentifier: "PhoneListCell", owner: self)!
        let imageFlag: NSImageView = rowView.viewWithTag(1) as! NSImageView
        let countryName: NSTextField = rowView.viewWithTag(2) as! NSTextField
        let countryCode: NSTextField = rowView.viewWithTag(3) as! NSTextField
        let selectionStatus: NSImageView = rowView.viewWithTag(4) as! NSImageView
        let splitter: NSTextField = rowView.viewWithTag(5) as! NSTextField
        
        imageFlag.image = NSImage.init(named: countryInfos[row].flag)
        
        if Localize.isChinese() { // chinese
            countryName.stringValue = countryInfos[row].chinaName
        } else {
            countryName.stringValue = countryInfos[row].englishName
        }
        
        countryCode.stringValue = countryInfos[row].phoneCode
        
        if (row == selectionIndex) {
            selectionStatus.image = NSImage.init(named: "ic_checked")
        } else {
            selectionStatus.image = NSImage.init(named: "ic_checkmark")
        }
        
        rowView.setBackgroundColor(color: CGColor.agMainColor)
        
        splitter.isHidden = (row == tableView.numberOfRows - 1)
        
        return rowView
    }
    
    @IBAction func onTableViewAction(_ sender: NSTableView) {
        selectionIndex = sender.selectedRow
        sender.reloadData()
    }
    
    @IBAction func onApplyButtonClicked(_ sender: NSButton) {
        if (delegate != nil) {
            delegate?.onCountrySelected(countryInfo: countryInfos[selectionIndex])
        }
        navigationController?.popViewControllerAnimated(true)
    }
    
    public func setDelegate(delegate: AGPhoneListEventDelegate) {
        self.delegate = delegate
    }
}

protocol AGPhoneListEventDelegate {
    func onCountrySelected(countryInfo: CountryInfo)
}
