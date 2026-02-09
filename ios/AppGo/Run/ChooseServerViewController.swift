//
//  ChooseServerViewController.swift
//  AppGoPro
//
//  Created by Striver1 on 8/15/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

import UIKit
import Alamofire

class ChooseServerViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, SimplePingDelegate {
    
    final let TVCELL_FLAG_ICON_TAG = 100
    final let TVCELL_NAME_LABEL_TAG = 101
    final let TVCELL_DELAY_LABEL_TAG = 102
    final let TVCELL_CHECKED_TAG = 103
    
    @IBOutlet weak var qrcodeImage: UIImageView!
    @IBOutlet weak var qrcodeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelChooseServer: UILabel!
    @IBOutlet weak var labelEmpty: UILabel!
    
    var services: [MService]!
    var curService: MService?
    var delegate: RunUpdateEvent!
    var pingers: Dictionary<String, SimplePing>!
    var delays: Dictionary<String, Date>!
    var pingTimers: Dictionary<String, Timer>!
    var sentTimes: [TimeInterval]?
    var receivedTimes: [TimeInterval]?
    let ssUriPrefix = "ss://"
    let ssrUriPrefix = "ssr://"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (self.navigationController != nil) {
            self.navigationController!.setNavigationBarHidden(true, animated: false)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func onLanguageChangeNotification(notification: Notification) {
        labelChooseServer.text = "choose server".localizedString()
        labelEmpty.text = "purchase plan first".localizedString()
        
        // Do any additional setup after loading the view.
        services = Array()
        pingers = Dictionary<String, SimplePing>()
        pingTimers = Dictionary<String, Timer>()
        delays = Dictionary<String, Date>()
        
        tableView.rowHeight = view.frame.size.height * 0.08
        
        //fetchQRCodeSwitchData()
        fetchServiceData()
        
        tableView.reloadData()
    }
    
    override func onLoginChangeNotification(notification:Notification) {
        //fetchQRCodeSwitchData()
        fetchServiceData()
    }
    
    override func onPurchaseChangeNotification(notification:Notification) {
        //fetchQRCodeSwitchData()
        fetchServiceData()
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
        if curService != nil {
            for i in 0 ..< services.count {
                if services[i].server_ip == curService?.server_ip && services[i].server_port == curService?.server_port {
                    curService = services[i]
                    delegate.serverSelectionDidChanged(curService)                    
                    break
                }
            }
        } else {
            delegate.serverSelectionDidChanged(nil)
        }
        
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func onClickQRCode(_ sender: AnyObject) {
        if qrcodeImage.isHidden {
            return
        }
        
        if (self.navigationController != nil) {
            self.navigationController!.setNavigationBarHidden(false, animated: false)
        }
    }
    
    func updateUIFromService(_ data: Data?) {
        services.removeAll()
        if data != nil {
            let array = NSDataUtils.nsdataToJSON(data!) as? NSArray
            if (array != nil) {
                var avaServices: [MService] = Array()
                for item in array! {
                    let service = MService(data: item as! NSDictionary)
                    services.append(service)
                    
                    if CommonUtils.validService(service: service) {
                        avaServices.append(service)
                    }
                }
                AppPref.setAvailableServices(services: avaServices)
            }
        }
        if services.count > 0 {
            labelEmpty.isHidden = true
            tableView.isHidden = false
        } else {
            curService = nil
            labelEmpty.isHidden = false
            tableView.isHidden = true
        }
        
        tableView.reloadData()
    }
    
    func fetchServiceData() {
        let access_token = AppPref.getAccessToken()
        let touristId = AppPref.getTouristId()//"iOS_592b89a7085052.59634168"
        let request: Alamofire.DataRequest?
        
        showProgreeHUD()
        if AppPref.isLogined() {
            request = WSAPI.getAlamofireManager().request(WSAPI.Path.UserServices.url,
                                                          method: .get,
                                                          parameters: nil,
                                                          encoding: URLEncoding.default,
                                                          headers: ["Accept": WSAPI.HEADER_ACCEPT, "Authorization": "Bearer " + access_token, "Content-Language": AppPref.convertServiceLanguageCode()])
        } else {
            request = WSAPI.getAlamofireManager().request(WSAPI.Path.TouristServices.url,
                                                          method: .get,
                                                          parameters: nil,
                                                          encoding: URLEncoding.default,
                                                          headers: ["Accept": WSAPI.HEADER_ACCEPT, "Tourist-Id": touristId])
        }
        request!.responseData(completionHandler: { response in
            self.hideHUD()
            
            let successResult = WSAPI.successResult(response.response)
            if successResult {
                let data = response.result.value                
                self.updateUIFromService(data)
            } else {
                self.updateUIFromService(nil)
            }
            
            self.pingServers()
        })
    }
    
    func pingServers() {
        for i in 0 ..< self.services.count {
            createPinger(self.services[i].server_ip, serverIndex: i)
        }
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (services?.count)!
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
                labelDelay.text! = "-"
            } else if service.delay == -1 {
                labelDelay.text! = ""//overtime".localizedString()
            }else {
                labelDelay.text! = "\(service.delay)ms"
            }
            
            if curService != nil {
                if service.server_ip == curService?.server_ip && service.server_port == curService?.server_port {
                    ivChecked.isHidden = false
                } else {
                    ivChecked.isHidden = true
                }
            }            
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        curService = services[indexPath.row] as MService
        delegate.serverSelectionDidChanged(curService)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?  {
        // add the action button you want to show when swiping on tableView's cell , in this case add the delete button.
        let deleteAction = UITableViewRowAction(style: .default, title: "delete".localizedString(), handler: { (action , indexPath) -> Void in
            Alert.show(self, message: "\("do you remove this server?".localizedString())", confirmCallback: { [weak self] in
                if self!.services[indexPath.row].server_ip == self!.curService?.server_ip && self!.services[indexPath.row].server_port == self!.curService?.server_port {
                    Alert.show(self!, message: "\("can not remove default server.".localizedString())")
                    return
                } else {
                    self!.services.remove(at: indexPath.row)
                    tableView.reloadData()
                }
            }, cancelCallback: {})
        })
        
        return [deleteAction]
    }
    
    // MARK: pinger delegate callback
    func createPinger(_ ipAddr:String, serverIndex index: Int) {
        let pinger: SimplePing = SimplePing(hostName:ipAddr)
        pinger.addressStyle = .icmPv4
        
        pinger.delegate = self
        pingers.updateValue(pinger, forKey: ipAddr)
        delays.updateValue(Date(), forKey: ipAddr)
        
        self.services[index].delay = 0
        
        let timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(pingTimerAction), userInfo: ipAddr, repeats: true)
        pingTimers.updateValue(timer, forKey: ipAddr)
        
        pinger.start()
        
    }
    
    func pingTimerAction(_ timer: Timer) {
        let ipAddr = timer.userInfo as! String
        for i in 0 ..< self.services.count {
            if self.services[i].server_ip == ipAddr && self.services[i].delay == 0 {
                self.services[i].delay = -1
                self.tableView.reloadData()
                
                break
            }
        }
        
        if pingTimers[ipAddr] != nil {
            pingTimers[ipAddr]!.invalidate()
            pingTimers[ipAddr] = nil
        }
        if pingers[ipAddr] != nil {
            pingers[ipAddr]!.stop()
        }
        
        timer.invalidate()
    }
    
    func simplePing(_ pinger: SimplePing, didStartWithAddress address: Data) {
        //DebugPrint.dprint(String.init(format: "pinging %@", ChooseServerViewController.displayAddressForAddress(address)))
        
        // Send the first ping straight away.
        pinger.send(with: nil)
    }
    
    func simplePing(_ pinger: SimplePing, didFailWithError error: Error) {
        pinger.stop()
    }
    
    func simplePing(_ pinger: SimplePing, didSendPacket packet: Data, sequenceNumber: UInt16) {
        //DebugPrint.dprint(String.init(format: "#%u sent", sequenceNumber))
        
        for (key, _) in self.pingers {
            if key == pinger.hostName {
                self.delays.updateValue(Date(), forKey: pinger.hostName)
                break;
            }
        }
    }
    
    func simplePing(_ pinger: SimplePing, didFailToSendPacket packet: Data, sequenceNumber: UInt16, error: Error) {
        pinger.stop()
    }
    
    func simplePing(_ pinger: SimplePing, didReceivePingResponsePacket packet: Data, sequenceNumber: UInt16) {
        //DebugPrint.dprint(String.init(format: "#%u received, size=%zu", sequenceNumber, packet.length))
        
        for (key, _) in self.pingers {
            if key == pinger.hostName {
                let oldDate = self.delays[pinger.hostName]!
                let delayTime = Int((Date().timeIntervalSince(oldDate).divided(by: 1)) * 1000)
                for i in 0 ..< self.services.count {
                    if self.services[i].server_ip == pinger.hostName {
                        self.services[i].delay = delayTime
                        self.tableView.reloadData()
                        break
                    }
                }
                break
            }
        }
    }
    
    func simplePing(_ pinger: SimplePing, didReceiveUnexpectedPacket packet: Data) {
        //DebugPrint.dprint(String.init(format: "unexpected packet, size=%zu", packet.length))
    }
    
    func addServerByName(_ service: MService, defName: String) {
        var txtServerName: UITextField!
        
        let alertController = UIAlertController(title: "enter new server name".localizedString(), message: "", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "cancel".localizedString(), style: .cancel)
        alertController.addAction(cancelAction)
        
        let saveAction: UIAlertAction = UIAlertAction(title: "save".localizedString(), style: .default) { action -> Void in
            var servername = ""
            
            if (txtServerName.text?.count)! > 20 {
                servername = (txtServerName.text!.substring(to: txtServerName.text!.startIndex.advanced(by: 20)))
            } else {
                servername = txtServerName.text!
            }
            
            service.country_name = servername
            service.country_alias_en = servername
            service.country_alias_zh = servername
            
            self.services.append(service)
            self.tableView.reloadData()
        }
        alertController.addAction(saveAction)
        
        alertController.addTextField { textField -> Void in
            txtServerName = textField
            txtServerName!.placeholder = "server name".localizedString()
            txtServerName.text = defName
        }
        
        DispatchQueue.main.async(execute: {
            let topMostController = self.topMostController()
            topMostController.present(alertController, animated: true, completion: nil)
        })       
    }
    
    func addDefaultService() {
        
        let country = NSMutableDictionary()
        
        country[MService.KEY_ID] = 10000
        country[MService.KEY_NAME] = "127.0.0.1(Example)".localizedString()
        country[MService.KEY_NAME_EN] = "127.0.0.1(Example)".localizedString()
        country[MService.KEY_NAME_ZH] = "127.0.0.1(Example)".localizedString()
        
        let item = NSMutableDictionary()
        item[MService.KEY_COUNTRY] = country
        item[MService.KEY_METHOD] = "rc4-md5"
        item[MService.KEY_PORT] = 5000
        item[MService.KEY_PASSWORD] = "123456"
        item[MService.KEY_IP] = "127.0.0.1"
        
        
        item[MService.KEY_TRANSFER_ENABLE] = 1
        item[MService.KEY_UPLOAD] = 0
        item[MService.KEY_DOWNLOAD] = 0
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        item[MService.KEY_EXPIRE_TIME] = dateFormatter.string(from: Date())
        item[MService.KEY_DELAY] = 0
        
        let service = MService(data: item)
        
        var exist = false
        for s in self.services {
            if s.server_ip == service.server_ip && s.server_port == service.server_port {
                exist = true
            }
        }
        
        if exist == false {
            self.services.append(service)
        }
    }
    
    func topMostController() -> UIViewController {
        var topController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
        while (topController.presentedViewController != nil) {
            topController = topController.presentedViewController!
        }
        return topController
    }
}
