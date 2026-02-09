//
//  NotificationViewController.swift
//  AppGoPro
//
//  Created by Striver1 on 8/15/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

import UIKit
import Alamofire


class NotificationViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var labelNotification: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl: UIRefreshControl!
    var pushes:[MPush] = Array()
    
    final let TVCELL_TITLE_LABEL_TAG = 101
    final let TVCELL_CONTENT_LABEL_TAG = 102
    final let TVCELL_DATE_LABLE_TAG = 103
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        refreshControl = UIRefreshControl()
        //tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(NotificationViewController.refreshPushData(_:)), for: UIControlEvents.valueChanged)
        
        fetchPushData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func onLanguageChangeNotification(notification: Notification) {
        labelNotification.text = "notifications".localizedString()
    }
    
    @IBAction func onClickBack(_ sender: AnyObject) {
        navigationController?.popViewController(animated: true)
    }

    func refreshPushData(_ sender:AnyObject) {
        fetchPushData()
    }
    
    func updateUIFromService(_ data:Data?) {
        pushes.removeAll()
        if data != nil {
            let json = NSDataUtils.nsdataToJSON(data!) as! NSDictionary
            
            let array = json["data"] as? NSArray
            if (array != nil) {
                for item in array! {
                    let push = MPush(data: item as! NSDictionary)
                    pushes.append(push)
                }
                let push = MPush(data: array![0] as! NSDictionary)
                AppPref.setNotificationTime(date: push.updatedat)
            }
            
            AppPref.setBadgeVisible(visible: false)
            NotificationCenter.default.post(name: .APNS_RECEIVE, object: nil)
        }
        
        tableView.reloadData()
    }
    
    func fetchPushData() {
        showProgreeHUD()
        let request = WSAPI.getAlamofireManager().request(WSAPI.Path.Notifications.url,
                                                      method: .get,
                                                      parameters: ["page": 1, "per_page": 15],
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
            
            self.refreshControl.endRefreshing()
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
        return pushes.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableCell") {
            let pushInfo = pushes[indexPath.row] as MPush
            
            let lblTitle = cell.viewWithTag(TVCELL_TITLE_LABEL_TAG) as! UILabel
            lblTitle.text = pushInfo.title
            let lblContent = cell.viewWithTag(TVCELL_CONTENT_LABEL_TAG) as! UILabel
            lblContent.text = pushInfo.content
            let lblDate = cell.viewWithTag(TVCELL_DATE_LABLE_TAG) as! UILabel
            lblDate.text = pushInfo.updatedat
            
            cell.layoutIfNeeded()
            
            return cell
        }

        return UITableViewCell()
    }
}
