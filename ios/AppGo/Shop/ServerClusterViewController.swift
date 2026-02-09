//
//  ServerClusterViewController.swift
//  AppGoPro
//
//  Created by Striver1 on 8/11/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

import UIKit
import Alamofire

class ServerClusterViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate  {

    @IBOutlet weak var labelServerCluster: UILabel!
    @IBOutlet weak var labelDescTitle: UILabel!
    @IBOutlet weak var labelDescContent: UILabel!
    @IBOutlet weak var labelAttentTitle: UILabel!
    @IBOutlet weak var labelAttentContent: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let TVCELL_DURATION_LABEL_TAG = 100
    let TVCELL_TRANSFER_LABEL_TAG = 101
    let TVCELL_PRICE_LABEL_TAG = 102
    let TVCELL_PRICEUNIT_LABEL_TAG = 103
    let TVCELL_PURCHASE_BUTTON_TAG = 104
    
    var country: MCountry!
    var packages:[MPackage] = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = view.frame.size.height * 0.08
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchPackagesData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func onLanguageChangeNotification(notification: Notification) {
        if Localize.isChinese() { // chinese
            self.labelServerCluster.text = country.alias_zh + "server cluster".localizedString()
        } else {
            self.labelServerCluster.text = "server cluster".localizedString() + country.alias_en
        }

        labelDescTitle.text = "package description:".localizedString()
        if country.description != "" {
            var fullNameArr = country.description.components(separatedBy: " | ")
            if Localize.isChinese() {
                labelDescContent.text = fullNameArr[0]
            } else {
                labelDescContent.text = fullNameArr[1]
            }
        } else {
            labelDescContent.text = ""
        }
        
        
        labelAttentTitle.text = "attention:".localizedString()
        labelAttentContent.text = "cluster attention content".localizedString()
        
        tableView.reloadData()
    }
    
    func updateUIFromService(_ data:Data?) {
        packages.removeAll()
        
        if data != nil {
            let array = NSDataUtils.nsdataToJSON(data!) as? NSArray
            if (array != nil) {
                for item in array! {
                    let package = MPackage(data: item as! NSDictionary)
                    packages.append(package)
                }
            }
        }
        tableView.reloadData()
    }
    
    override func onMainTabChangeNotification(notification:Notification) {        
        fetchPackagesData()
    }
    
    @IBAction func onClickBack(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickPurchase(_ sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPosition)!
        
        if AppPref.isLogined() {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PurchaseViewController") as! PurchaseViewController
            vc.package = packages[indexPath.row]
            vc.country = country
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
            // Change font of the title and message
            let titleFont:[String : AnyObject] = [ NSFontAttributeName : UIFont(name: "AmericanTypewriter", size: 18)! ]
            let messageFont:[String : AnyObject] = [ NSFontAttributeName : UIFont(name: "HelveticaNeue-Thin", size: 16)! ]
            let attributedTitle = NSMutableAttributedString(string: "pay alert title".localizedString(), attributes: titleFont)
            let attributedMessage = NSMutableAttributedString(string: "pay after login description".localizedString(), attributes: messageFont)
            alert.setValue(attributedTitle, forKey: "attributedTitle")
            alert.setValue(attributedMessage, forKey: "attributedMessage")
            
            let buttonLogin = UIAlertAction(title: "pay after login".localizedString(), style: .default, handler: { (action) -> Void in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "BaseNavViewController")
                self.navigationController?.present(vc!, animated: true, completion: nil)
            })
            
            let buttonTourist = UIAlertAction(title: "pay as a guest".localizedString(), style: .default, handler: { (action) -> Void in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "PurchaseViewController") as! PurchaseViewController
                vc.package = self.packages[indexPath.row]
                vc.country = self.country
                self.navigationController?.pushViewController(vc, animated: true)
            })
            
            // Cancel button
            let buttonCancel = UIAlertAction(title: "cancel".localizedString(), style: .default, handler: { (action) -> Void in })
            
            // Restyle the view of the Alert            
            alert.view.tintColor = UIColor.blue  // change text color of the buttons
            alert.view.backgroundColor = UIColor.white  // change background color
            alert.view.layer.cornerRadius = 25   // change corner radius
            
            alert.addAction(buttonLogin)
            alert.addAction(buttonTourist)
            alert.addAction(buttonCancel)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func fetchPackagesData() {
        showProgreeHUD()
        let request = WSAPI.getAlamofireManager().request(WSAPI.Path.CountryDetail(String(country.id)).url,
                                                          method: .get,
                                                          parameters: nil,
                                                          encoding: URLEncoding.default,
                                                          headers: ["Accept": WSAPI.HEADER_ACCEPT, "Content-Language": AppPref.convertServiceLanguageCode()])
        request.responseData(completionHandler: { response in
            self.hideHUD()
            
            let successResult = WSAPI.successResult(response.response)
            if successResult {
                let data = response.result.value
                self.updateUIFromService(data)
            } else {
                //Alert.show(self, message: "\("can't connect to server.".localizedString())")
            }
        })
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
        return packages.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ServerClusterTableCell") {
            let package = packages[indexPath.row]
            let lblDuration = cell.viewWithTag(TVCELL_DURATION_LABEL_TAG) as! UILabel
            let lblTransfer = cell.viewWithTag(TVCELL_TRANSFER_LABEL_TAG) as! UILabel
            let lblPrice = cell.viewWithTag(TVCELL_PRICE_LABEL_TAG) as! UILabel
            let lblPriceUnit = cell.viewWithTag(TVCELL_PRICEUNIT_LABEL_TAG) as! UILabel
            let btnPurchase = cell.viewWithTag(TVCELL_PURCHASE_BUTTON_TAG) as! UIButton
            
            lblDuration.text! = String.init(format: "%ddays".localizedString(), package.duration)
            lblTransfer.text! = CommonUtils.humanReadableByteCount(Int64(package.transfer), needFloat: false)
            lblPrice.text! = String(package.price)
            lblPriceUnit.text! = "rmb".localizedString()
            
            btnPurchase.frame.size.height = tableView.rowHeight * 0.6
            btnPurchase.layer.borderWidth = 1.0
            btnPurchase.layer.borderColor = Color.BackBlue.cgColor
            btnPurchase.layer.backgroundColor = Color.TextActive.cgColor
            btnPurchase.layer.cornerRadius = btnPurchase.frame.size.height / 2
            btnPurchase.setTitle("purchase".localizedString(), for: .normal)
                        
            return cell
        }
        
        return UITableViewCell()
    }
}
