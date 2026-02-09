//
//  AGNotificationViewController.swift
//  AppGoX
//
//  Created by user on 17.11.10.
//  Copyright © 2017 appgo. All rights reserved.
//

import Cocoa
import ProgressKit
import Alamofire

class AGNotificationViewController: BaseViewController {

    @IBOutlet weak var vwTitleBar: NSView!
    @IBOutlet weak var lblTitle: NSTextField!
    @IBOutlet weak var tvNotifications: NSTableView!
    @IBOutlet weak var scrollView: NSScrollView!
    @IBOutlet weak var pgLoading: Crawler!
    
    var pushes: [MPush] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        fetchServiceData()
        
        configureUI()
    }
    
    @IBAction func onBackButtonClicked(_ sender: NSButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func updateUIFromService(data: Data?) {
        if data != nil {
            let json = NSDataUtils.nsdataToJSON(data: data!)
            let array = json?["data"] as? NSArray
            if array != nil {
                pushes.removeAll()
                for item in array! {
                    let push = MPush(data: item as! NSDictionary)
                    pushes.append(push)
                }
            }
        }
        
        tvNotifications.reloadData()
    }
    
    private func configureUI() {
        vwTitleBar.setBackgroundColor(color: CGColor.agMainColor)
        view.setBackgroundColor(color: CGColor.white)
        lblTitle.stringValue = "notifications".localizedString()
        tvNotifications.selectionHighlightStyle = NSTableViewSelectionHighlightStyle.none
    }
    
    func fetchServiceData() {
        let request = WSAPI.getAlamofireManager().request(WSAPI.Path.Notifications.url,
                                                                            method: .get,
                                                                            parameters: ["page": 1, "per_page": 15],
                                                                            headers: ["Accept": WSAPI.HEADER_ACCEPT, "Content-Language": AppPref.getServiceLanguage()])
        request.responseData { response in
            DispatchQueue.main.async {
                self.pgLoading.animate = false
            }            
            let successResult = WSAPI.successResult(response: response.response)
            if successResult {
                let data = response.result.value
                self.updateUIFromService(data: data)
            }
        }
    }
}

extension AGNotificationViewController: NSTableViewDataSource, NSTableViewDelegate {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return pushes.count
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return heightForNotification(notification: pushes[row])
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell: NSView = tableView.make(withIdentifier: "NotificationsTableCell", owner: self)!
        
        let notification: MPush = pushes[row]
        
        let txtTitle: NSTextField = cell.viewWithTag(1) as! NSTextField
        let txtContent: NSTextField = cell.viewWithTag(2) as! NSTextField
        let txtDate: NSTextField = cell.viewWithTag(3) as! NSTextField
        let txtSplitter = cell.viewWithTag(4)
        
        txtTitle.stringValue = notification.title
        txtContent.stringValue = notification.content
        txtDate.stringValue = notification.updatedat
        txtSplitter?.isHidden = (row == tableView.numberOfRows - 1)
        
        return cell
    }
    
    func heightForNotification(notification: MPush) -> CGFloat {
        let width = (view.frame.width - (scrollView.verticalScroller?.frame.width)!) * 0.9
        var txtTitle, txtContent, txtDate: NSTextField
        
        txtTitle = NSTextField.init()
        txtContent = NSTextField.init()
        txtDate = NSTextField.init()
        
        txtTitle.font = NSFont.systemFont(ofSize: 17)
        txtContent.font = NSFont.systemFont(ofSize: 13)
        txtDate.font = NSFont.systemFont(ofSize: 12)

        txtTitle.stringValue = notification.title
        txtContent.stringValue = notification.content
        txtDate.stringValue = notification.updatedat
        
        let heightForTitle: CGFloat = (txtTitle.cell?.cellSize(forBounds: NSRect.init(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude)).height)!
        let heightForContent: CGFloat = (txtContent.cell?.cellSize(forBounds: NSRect.init(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude)).height)!
        let heightForDate: CGFloat = (txtDate.cell?.cellSize(forBounds: NSRect.init(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude)).height)!
        
        return 5 + heightForTitle + 5 + heightForContent + 5 + heightForDate + 5 + 1 - 10
    }
}
