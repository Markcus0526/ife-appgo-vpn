//
//  PhoneListViewController.swift
//  AppGoPro
//
//  Created by rbvirakf on 11/24/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

import UIKit

class PhoneListViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    final let TVCELL_FLAG_ICON_TAG = 100
    final let TVCELL_NAME_LABEL_TAG = 101
    final let TVCELL_CODE_LABEL_TAG = 102
    final let TVCELL_CHECKED_TAG = 103
    
    @IBOutlet weak var labelPhoneCodes: UILabel!
    @IBOutlet weak var tableView: UITableView!

    var selCountryCode: String = ""
    var selPhoneCode: String = ""
    var delegate: PhoneCodeUpdateEvent!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = view.frame.size.height * 0.07
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func onLanguageChangeNotification(notification: Notification) {        
        labelPhoneCodes.text = "country code".localizedString()
        tableView.reloadData()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryInfos.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PhoneListTableCell") {
            let imageFlag = cell.viewWithTag(TVCELL_FLAG_ICON_TAG) as! UIImageView
            let labelCountryName = cell.viewWithTag(TVCELL_NAME_LABEL_TAG) as! UILabel
            let labelCode = cell.viewWithTag(TVCELL_CODE_LABEL_TAG) as! UILabel
            let ivChecked = cell.viewWithTag(TVCELL_CHECKED_TAG) as! UIImageView
            
            imageFlag.image = UIImage(named: countryInfos[indexPath.row].flag)
            
            if Localize.isChinese() { // chinese
                labelCountryName.text! = countryInfos[indexPath.row].chinaName
            } else {
                labelCountryName.text! = countryInfos[indexPath.row].englishName
            }
            
            labelCode.text! = countryInfos[indexPath.row].phoneCode
            
            if (selCountryCode == countryInfos[indexPath.row].code) {
                ivChecked.isHidden = false
            } else {
                ivChecked.isHidden = true
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selCountryCode = countryInfos[indexPath.row].code
        selPhoneCode = countryInfos[indexPath.row].phoneCode
        self.onClickBack(self)
    }
    
    @IBAction func onClickBack(_ sender: AnyObject) {
        delegate.phoneSelectionDidChanged(selCountryCode, phoneCode: selPhoneCode)
        navigationController?.popViewController(animated: true)
    }
}

protocol PhoneCodeUpdateEvent {
    mutating func phoneSelectionDidChanged(_ countryCode: String, phoneCode: String)
}
