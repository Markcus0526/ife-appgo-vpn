//
//  ShopViewController.swift
//  AppGoPro
//
//  Created by Striver1 on 8/11/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

import UIKit
import Alamofire

class ShopViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var labelShop: UILabel!
    @IBOutlet weak var labelPackageContent: UILabel!
    @IBOutlet weak var tableView: UITableView!

    
    final let TVCELL_NAME_LABEL_TAG = 100
    final let TVCELL_FLAG_ICON_TAG = 101
    static var _singleton: ShopViewController?
    var countries:[MCountry] = Array()
    var timerForShowScrollIndicator: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = view.frame.size.height * 0.08
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //fetchServerData()
        startTimerForShowScrollIndicator()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        stopTimerForShowScrollIndicator()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func onLanguageChangeNotification(notification: Notification) {
        labelShop.text = "shop plan".localizedString()
        labelPackageContent.text = "package description contents".localizedString()
        
        tableView.reloadData()
    }
    
    override func onMainTabChangeNotification(notification: Notification) {        
        fetchServerData()
    }

    @IBAction func refreshClicked(_ sender: AnyObject) {
        fetchServerData()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    /// Show always scroll indicator in table view
    func showScrollIndicatorsInContacts() {
        UIView.animate(withDuration: 0.001, animations: {
            self.tableView.flashScrollIndicators()
        }) 
    }
    
    /// Start timer for always show scroll indicator in table view
    func startTimerForShowScrollIndicator() {
        self.timerForShowScrollIndicator = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.showScrollIndicatorsInContacts), userInfo: nil, repeats: true)
    }
    
    /// Stop timer for always show scroll indicator in table view
    func stopTimerForShowScrollIndicator() {
        self.timerForShowScrollIndicator?.invalidate()
        self.timerForShowScrollIndicator = nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ShopServerTableCell") {
            let countryInfo = countries[indexPath.row] as MCountry
            
            let imgCountryFlag = cell.viewWithTag(TVCELL_FLAG_ICON_TAG) as! UIImageView
            imgCountryFlag.image = UIImage(named: Country.getFlagName(countryInfo.name))
            
            let lblCountryName = cell.viewWithTag(TVCELL_NAME_LABEL_TAG) as! UILabel
            if Localize.isChinese() { // chinese
                lblCountryName.text = countries[indexPath.row].alias_zh
            } else {
                lblCountryName.text = countries[indexPath.row].alias_en
            }
            
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ServerClusterViewController") as! ServerClusterViewController
        vc.country = countries[indexPath.row]        
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func updateUIFromService(_ data:Data?) {
        countries.removeAll()
        
        if data != nil {
            let array = NSDataUtils.nsdataToJSON(data!) as? NSArray
            if (array != nil) {
                for item in array! {
                    let country = MCountry(data: item as! NSDictionary)
                    countries.append(country)
                }
            }
        }
        
        tableView.reloadData()
    }
    
    func fetchServerData() {
        if AppPref.getServiceUrl() == "" { return }
        
        showProgreeHUD()
        let request = WSAPI.getAlamofireManager().request(WSAPI.Path.Countries.url,
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
                self.updateUIFromService(nil)
            }
        })
    }   
}
