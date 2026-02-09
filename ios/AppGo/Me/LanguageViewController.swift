//
//  LanguageViewController.swift
//  AppGoPro
//
//  Created by Striver1 on 8/16/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

import UIKit

class LanguageViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var labelLanguage: UILabel!
    @IBOutlet weak var buttonSave:UIButton!
    @IBOutlet weak var tableView:UITableView!
    
    final let TVCELL_FLAG_ICON_TAG = 100
    final let TVCELL_LANGUAGE_LABEL_TAG = 101
    final let TVCELL_CHECKED_TAG = 102
    
    var curLangCode: String = ""
    var languages:[MCountry] = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        curLangCode = AppPref.getCurLanguageCode()
        
        let item = NSMutableDictionary()
        
        item[MCountry.KEY_ID] = 1
        item[MCountry.KEY_NAME] = Localize.English
        item[MCountry.KEY_NAME_EN] = "english"
        item[MCountry.KEY_NAME_ZH] = "english".localizedString()
        
        var language = MCountry(data: item)
        languages.append(language)
        
        item[MCountry.KEY_ID] = 2
        item[MCountry.KEY_NAME] = Localize.Chinese
        item[MCountry.KEY_NAME_EN] = "chinese"
        item[MCountry.KEY_NAME_ZH] = "chinese".localizedString()
        
        language = MCountry(data: item)
        languages.append(language)
        
        tableView.rowHeight = view.frame.size.height * 0.08
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func onLanguageChangeNotification(notification: Notification) {
        labelLanguage.text = "language".localizedString()
        buttonSave.setTitle("save".localizedString(), for: .normal)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func onClickBack(_ sender: AnyObject) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func onClickSave(_ sender: AnyObject) {
        if (AppPref.getCurLanguageCode() != curLangCode) {
            AppPref.setCurLanguageCode(langID: curLangCode)
            Localize.setCurrentLanguage(curLangCode)
            NotificationCenter.default.post(name: .LANGUAGE_CHANGE, object: nil)
            
            tableView.reloadData()
            onClickBack(self)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageTableCell") {
            let imageFlag = cell.viewWithTag(TVCELL_FLAG_ICON_TAG) as! UIImageView
            let lblLanguage = cell.viewWithTag(TVCELL_LANGUAGE_LABEL_TAG) as! UILabel
            let ivChecked = cell.viewWithTag(TVCELL_CHECKED_TAG) as! UIImageView
            
            if AppPref.getCurLanguageCode() == Localize.Chinese {
                lblLanguage.text! = languages[indexPath.row].alias_zh.localizedString()
            } else {
                lblLanguage.text! = languages[indexPath.row].alias_en.localizedString()
            }
            
            imageFlag.image = UIImage(named: Localize.getFlagName(languages[indexPath.row].name))
            
            if languages[indexPath.row].name == curLangCode {
                ivChecked.isHidden = false
                cell.isSelected = true
            } else {
                ivChecked.isHidden = true
            }
            
            return cell
        }
        return UITableViewCell()
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let ivChecked = cell.viewWithTag(TVCELL_CHECKED_TAG) as! UIImageView
            ivChecked.isHidden = false
            curLangCode = languages[indexPath.row].name
            
            for othercell in tableView.visibleCells {
                let ivChecked = othercell.viewWithTag(TVCELL_CHECKED_TAG) as! UIImageView
                
                if (cell != othercell) {
                    ivChecked.isHidden = true
                }
            }
        }
    }    

    func reloadRootViewController() {
        
    }

}
