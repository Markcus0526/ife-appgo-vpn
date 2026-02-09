//
//  AGServerSelectionViewController.swift
//  AppGoX
//
//  Created by user on 17.10.26.
//  Copyright © 2017 appgo. All rights reserved.
//

import Cocoa
import Alamofire
import ProgressKit

class AGServerSelectionViewController: BaseViewController, NSTableViewDelegate, NSTableViewDataSource, SimplePingDelegate {

    @IBOutlet weak var vwTitleBar: NSView!
    @IBOutlet weak var lblTitle: NSTextField!
    
    @IBOutlet weak var tvServerList: NSTableView!
    
    @IBOutlet weak var vwButtons: NSView!
    @IBOutlet weak var btnApply: NSButton!
    @IBOutlet weak var btnRemove: NSButton!
    @IBOutlet weak var pgLoading: Crawler!
    
    private var selectionIndex: Int = -1
   
    var serverDelegate: ServerSelectedEvent!
    
    var services: [MService]!
    var curService: MService?
    
    var pingers: Dictionary<String, SimplePing>!
    var delays: Dictionary<String, Date>!
    var pingTimers: Dictionary<String, Timer>!
    
    var sentTimes: [TimeInterval]?
    var receivedTimes: [TimeInterval]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        pingers = Dictionary<String, SimplePing>()
        pingTimers = Dictionary<String, Timer>()
        delays = Dictionary<String, Date>()
        
        services = AppPref.getAvailableServices()
        curService = AppPref.getCurrentService()
        
        fetchServiceData()
        configureUI()        
    }
    
    override func onLanguageChangeNotification(notification: Notification) {
        lblTitle.stringValue = "choose server".localizedString()
    }
    
    @IBAction func onBackButtonClicked(_ sender: NSButton) {
        onApplyButtonClicked(sender)
    }
    
    @IBAction func onRemoveButtonClicked(_ sender: NSButton) {
    }
    
    @IBAction func onApplyButtonClicked(_ sender: NSButton) {
        if selectionIndex > -1 {
            AppPref.setCurrentService(service: self.services[selectionIndex])
            serverDelegate.serverSelectionDidChanged(service: self.curService)
            NotificationCenter.default.post(name: .SERVER_CHANGE, object: nil)
        }
        navigationController?.popViewControllerAnimated(true)
    }
    
    func updateUIFromService(data: Data?) {
        if data != nil {
            let array = NSDataUtils.nsdataToJSON(data: data!) as? NSArray
            if array != nil {
                var avaServices: [MService] = Array()
                services.removeAll()
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
        
        if services.count == 0 {
            curService = nil
        } else if curService != nil {
            for i in 0 ..< services.count {
                if services[i].server_ip == curService!.server_ip && services[i].server_port == curService?.server_port {
                    selectionIndex = i
                    break
                }
            }
        }
        
        AppPref.setAvailableServices(services: self.services)
        self.tvServerList.reloadData()
        
        NotificationCenter.default.post(name: .SERVER_LIST_CHANGE, object: nil)
    }

    private func configureUI() {
        vwTitleBar.setBackgroundColor(color: CGColor.agMainColor)
        
        vwButtons.setBackgroundColor(color: CGColor.agDarkGreyColor)
        configureApplyButton()
        
        tvServerList.selectionHighlightStyle = NSTableViewSelectionHighlightStyle.none
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
    
    // Table View Data Source, Table View Delegate
    func numberOfRows(in tableView: NSTableView) -> Int {
        return (services?.count)!
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let rowView: NSView = tableView.make(withIdentifier: "ServerTableCell", owner: self)!
        let serverName: NSTextField = rowView.viewWithTag(1) as! NSTextField
        let serverSpeed: NSTextField = rowView.viewWithTag(2) as! NSTextField
        let selectionStatus: NSImageView = rowView.viewWithTag(3) as! NSImageView
        let splitter: NSTextField = rowView.viewWithTag(4) as! NSTextField
        
        let service = services[row] as MService
        if Localize.isChinese() { // chinese
            serverName.stringValue = service.country_alias_zh
        } else {
            serverName.stringValue = service.country_alias_en
        }
        
        if service.delay == 0 {
            serverSpeed.stringValue = "-"
        } else if service.delay == -1 {
            serverSpeed.stringValue = "overtime".localizedString()
        }else {
            serverSpeed.stringValue = "\(service.delay)ms"
        }
        
        if row == selectionIndex {
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
        btnRemove.isEnabled = false
        
        sender.reloadData()
    }
        
    func fetchServiceData() {
        let access_token = AppPref.getAccessToken()
        let touristId = AppPref.getTouristId()//"iOS_592b89a7085052.59634168"
        let request: Alamofire.DataRequest?
        
        request = WSAPI.getAlamofireManager().request(WSAPI.Path.UserServices.url,
                                                      method: .get,
                                                      headers: ["Accept": WSAPI.HEADER_ACCEPT, "Content-Language": AppPref.getServiceLanguage(), "Authorization": "Bearer \(access_token)"])
        request!.responseData { response in
            DispatchQueue.main.async {
                self.pgLoading.animate = false
            }            
            let successResult = WSAPI.successResult(response: response.response)
            if successResult {
                let data = response.result.value
                self.updateUIFromService(data: data)
                self.pingServers()
            }
        }
    }
    
    func pingServers() {
        for i in 0 ..< self.services.count {
            createPinger(ipAddr: self.services[i].server_ip, serverIndex: i)
        }
    }
    
    // MARK: pinger delegate callback
    func createPinger(ipAddr:String, serverIndex index: Int) {
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
    
    func pingTimerAction(timer: Timer) {
        let ipAddr = timer.userInfo as! String
        
        for i in 0 ..< self.services.count {
            if self.services[i].server_ip == ipAddr && self.services[i].delay == 0 {
                self.services[i].delay = -1
                self.tvServerList.reloadData()
                
                break
            }
        }
        
        AppPref.setAvailableServices(services: self.services)
        
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
        //DebugPrint.dprint(String.init(format: "failed: %@", ChooseServerViewController.shortErrorFromError(error)))
        
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
        //DebugPrint.dprint(String.init(format: "#%u send failed: %@", sequenceNumber, ChooseServerViewController.shortErrorFromError(error)))
        
        pinger.stop()
    }
    
    func simplePing(_ pinger: SimplePing, didReceivePingResponsePacket packet: Data, sequenceNumber: UInt16) {
        //DebugPrint.dprint(String.init(format: "#%u received, size=%zu", sequenceNumber, packet.length))
        
        for (key, _) in self.pingers {
            if key == pinger.hostName {
                let oldDate = self.delays[pinger.hostName]!
                let delayTime = Int((Date().timeIntervalSince(oldDate as Date).truncatingRemainder(dividingBy: 1.0)) * 1000)
                
                for i in 0 ..< self.services.count {
                    if self.services[i].server_ip == pinger.hostName {
                        self.services[i].delay = delayTime
                        self.tvServerList.reloadData()
                        break
                    }
                }
                
                AppPref.setAvailableServices(services: self.services)
                
                break
            }
        }
    }
    
    func simplePing(_ pinger: SimplePing, didReceiveUnexpectedPacket packet: Data) {
        //DebugPrint.dprint(String.init(format: "unexpected packet, size=%zu", packet.length))
    }
}
