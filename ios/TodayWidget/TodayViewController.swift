//
//  TodayViewController.swift
//  TodayWidget
//
//  Created by LEI on 4/12/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

import UIKit
import NotificationCenter
import CocoaAsyncSocket
import Alamofire
import NetworkExtension

//private let kCurrentGroupCellIndentifier = "kCurrentGroupIndentifier"

class TodayViewController: UIViewController, NCWidgetProviding, GCDAsyncSocketDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var labelUsage: UILabel!
    @IBOutlet weak var labelUsageValue: UILabel!
    @IBOutlet weak var viewNetworkUsageBackground: UIView!
    @IBOutlet weak var usageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonConnect: UIButton!
    @IBOutlet weak var switchConnect: UISwitch!
    @IBOutlet weak var buttonNotice: UIButton!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewMask: UIView!
    @IBOutlet weak var viewSelItem: UIView!
    @IBOutlet weak var imageSelServer: UIImageView!
    @IBOutlet weak var labelSelServer: UILabel!
    @IBOutlet weak var labelSelSpeed: UILabel!
 
    
    final let TVCELL_FLAG_ICON_TAG = 100
    final let TVCELL_NAME_LABEL_TAG = 101
    final let TVCELL_DELAY_LABEL_TAG = 102
    final let TVCELL_CHECKED_TAG = 103
    final let TRANSFER_MAX = 60 * 10
    
    var services: [MService] = Array()
    var curService: MService?
    var compactHeight: CGFloat = 0
    var transferPeriod: Int = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOSApplicationExtension 10.0, *) {
            self.extensionContext?.widgetLargestAvailableDisplayMode = NCWidgetDisplayMode.expanded
        } else {
            // Fallback on earlier versions
        }
        
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func onClickConnect(_ sender: UIButton) {
        AppPref.setCurrentService(service: curService)
        AppPref.setTodayLaunch(state: true)
        let vpnStatus = NEVPNStatus(rawValue: AppPref.getVpnStatus())!
        if vpnStatus == .disconnected {
            self.extensionContext?.open(URL(string: "AppGo://on")!, completionHandler: nil)
        } else if vpnStatus == .connected {
            self.extensionContext?.open(URL(string: "AppGo://off")!, completionHandler: nil)
        }
    }
    
    @IBAction func onClickMask(_ sender: UIButton) {
        //extensionContext?.open(URL(string: "AppGo://on")!, completionHandler: nil)
    }
    
    @available(iOSApplicationExtension 10.0, *)
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize){
        if (activeDisplayMode == NCWidgetDisplayMode.compact) {
            self.preferredContentSize = maxSize
            
            if services.count > 0 {
                self.viewMask.isHidden = true
                self.viewMain.isHidden = false
                
                self.viewSelItem.isHidden = false
                self.tableView.isHidden = true
            } else {
                self.viewMask.isHidden = false
                self.viewMain.isHidden = true
            }
            
        } else {
            if services.count > 0 {
                self.preferredContentSize = CGSize(width: maxSize.width, height: 70 + CGFloat(services.count * 40))
                
                self.viewMask.isHidden = true
                self.viewMain.isHidden = false
                
                self.viewSelItem.isHidden = true
                self.tableView.isHidden = false
            } else {
                self.preferredContentSize = CGSize(width: maxSize.width, height: 110)
                
                self.viewMask.isHidden = false
                self.viewMain.isHidden = true
            }
        }
        
        updateUI()
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        var inset = defaultMarginInsets
        inset.bottom = 0
        return inset
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }

    func updateUI() {
        let langCode = AppPref.getCurLanguageCode()
        if langCode == "" {
            AppPref.setCurLanguageCode(langID: Localize.currentLanguage())
        }
        AppInfo.deviceUUID = AppPref.getDeviceUUID()
        if AppInfo.deviceUUID == "" {
            AppInfo.deviceUUID = (UIDevice.current.identifierForVendor?.uuidString.replacingOccurrences(of: "-", with: ""))!
            
            AppPref.setDeviceUUID(deviceUUID: AppInfo.deviceUUID)
        }
        
        services = AppPref.getAvailableServices()
        curService = AppPref.getCurrentService()
        if curService == nil && services.count > 0 {
            curService = services[0]
            AppPref.setCurrentService(service: curService)
        }
        
        labelUsage.text = "data quota".localizedString()
        buttonNotice.setTitle("please select vpn server.".localizedString(), for: .normal)
        
        if services.count > 0 && curService != nil {
            buttonConnect.isEnabled = true
            
            // network usage
            let usage = Int64(curService!.upload) + Int64(curService!.download)
            let total = Int64(curService!.transfer_enable)
            labelUsageValue.text! = String.init(format: "%@ / %@", CommonUtils.humanReadableByteCount(usage, needFloat: true), CommonUtils.humanReadableByteCount(total, needFloat: false))
            usageWidthConstraint.constant = CGFloat(usage) * self.viewNetworkUsageBackground.frame.width / CGFloat(total)
            
            if viewSelItem.isHidden == false {
                imageSelServer.image = UIImage(named: Country.getFlagName(self.curService!.country_name))
                if Localize.isChinese() { // chinese
                    labelSelServer.text = curService?.country_alias_zh
                } else {
                    labelSelServer.text = curService?.country_alias_en
                }
                if curService!.delay == 0 {
                    labelSelSpeed.text! = ""
                } else if self.curService!.delay == -1 {
                    labelSelSpeed.text! = ""//overtime".localizedString()
                }else {
                    labelSelSpeed.text! = "\(self.curService!.delay)ms"
                }
            }
            
        } else {
            self.buttonConnect.isEnabled = false
            self.labelUsageValue.text = ""
            self.usageWidthConstraint.constant = 0
        }
        
        let vpnStatus = NEVPNStatus(rawValue: AppPref.getVpnStatus())!
        if vpnStatus == .connected {
            self.buttonConnect.isEnabled = true
            self.switchConnect.isOn = true
            self.switchConnect.isEnabled = true
            self.tableView.allowsSelection = false
        } else if vpnStatus == .disconnecting {
            self.buttonConnect.isEnabled = false
            self.switchConnect.isEnabled = false
            self.tableView.allowsSelection = false
        } else if vpnStatus == .connecting {
            self.buttonConnect.isEnabled = false
            self.switchConnect.isEnabled = false
            self.tableView.allowsSelection = false
        } else if vpnStatus == .disconnected {
            self.buttonConnect.isEnabled = true
            self.switchConnect.isOn = false
            self.switchConnect.isEnabled = true
            self.tableView.allowsSelection = true
        }
        
        tableView.reloadData()        
        view.layoutIfNeeded()
    }

    // MARK: UITableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseServerTableCell") {
            let imageFlag = cell.viewWithTag(TVCELL_FLAG_ICON_TAG) as! UIImageView
            let labelCountryName = cell.viewWithTag(TVCELL_NAME_LABEL_TAG) as! UILabel
            let labelDelay = cell.viewWithTag(TVCELL_DELAY_LABEL_TAG) as! UILabel
            let ivChecked = cell.viewWithTag(TVCELL_CHECKED_TAG) as! UIImageView
            
            let service = services[indexPath.row] as MService
            
            imageFlag.image = UIImage(named: Country.getFlagName(service.country_name))
            
            if Localize.isChinese() { // chinese
                labelCountryName.text = service.country_alias_zh
            } else {
                labelCountryName.text = service.country_alias_en
            }
            
            if service.delay == 0 {
                labelDelay.text! = ""
            } else if service.delay == -1 {
                labelDelay.text! = ""//overtime".localizedString()
            }else {
                labelDelay.text! = "\(service.delay)ms"
            }
            
            if curService != nil {
                if service.country_id == curService!.country_id {
                    ivChecked.isHidden = false
                    //cell.selected = true
                } else {
                    ivChecked.isHidden = true
                }
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
            curService = services[indexPath.row]
            AppPref.setCurrentService(service: curService)
            
            for othercell in tableView.visibleCells {
                let ivChecked = othercell.viewWithTag(TVCELL_CHECKED_TAG) as! UIImageView
                
                if (cell != othercell) {
                    ivChecked.isHidden = true
                }
            }
            
            updateUI()
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let ivChecked = cell.viewWithTag(TVCELL_CHECKED_TAG) as! UIImageView
            ivChecked.isHidden = true
        }
    }
}

