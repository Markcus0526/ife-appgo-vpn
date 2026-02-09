//
//  AGShopViewController.swift
//  AppGoX
//
//  Created by user on 17.10.26.
//  Copyright © 2017 appgo. All rights reserved.
//

import Cocoa
import Alamofire
import ProgressKit
import StoreKit

class AGShopViewController: BaseViewController {

    @IBOutlet weak var vwTitleBar: NSView!
    @IBOutlet weak var lblTitle: NSTextField!
    @IBOutlet weak var lblShopItemTitle: NSTextField!
    @IBOutlet weak var lblShopItem: NSTextField!
    @IBOutlet weak var lblServer: NSTextField!
    @IBOutlet weak var vwServerName: NSView!
    @IBOutlet weak var lblServerName: NSTextField!
    @IBOutlet weak var lblDataQuote: NSTextField!
    @IBOutlet weak var vwDataQuote: NSView!
    @IBOutlet weak var lblDataQuoteStatus: NSTextField!
    @IBOutlet weak var lblExpire: NSTextField!
    @IBOutlet weak var lblExpireDates: NSTextField!
    @IBOutlet weak var lblPrice: NSTextField!
    @IBOutlet weak var lblPriceValue: NSTextField!
    @IBOutlet weak var lblPaymentMethodTitle: NSTextField!
    @IBOutlet weak var btnPay1: NSButton!
    @IBOutlet weak var btnPay2: NSButton!
    @IBOutlet weak var btnPay3: NSButton!
    @IBOutlet weak var btnBuyNow: NSButton!
    @IBOutlet weak var tvServerList: NSTableView!
    @IBOutlet weak var lblDescTitle: NSTextField!
    @IBOutlet weak var lblDesc: NSTextField!
    @IBOutlet weak var pgLoading: Crawler!
    @IBOutlet weak var serverListContainerHeightConstraint: NSLayoutConstraint!
    
    private var dataQuotaMenu: NSMenu!
    
    var curCountry: MCountry? = nil
    var countries: [MCountry] = [MCountry].init()
    
    var curPackage: MPackage? = nil
    var packages:[MPackage] = [MPackage].init()
    
    var curPayment: Int = 0
    var tradeNo: String = ""
    var fee: Float = 0.0
    
    var disablePayTimer: Timer?
    var disableUIEvent: Bool = false
    
    var onAlipay = false
    var onAlipayGlobal = false
    var onItunes = false
    var onAcoin = false
    var paymentCount = 0
    
    var TAG_ALIPAY = 101
    var TAG_ALIPAY_GLOBAL = 102
    var TAG_ITUNES = 103
    var TAG_ACOIN = 104
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        fetchServiceData()
        if AppPref.isLogined() {
            fetchItunesSwitchData()
        } else {
            curPayment = TAG_ITUNES
            self.lblPaymentMethodTitle.stringValue = ""
            self.btnBuyNow.isEnabled = true
        }
        
        configureUI()
    }
    
    override func onLanguageChangeNotification(notification: Notification) {
        lblTitle.stringValue = "shop".localizedString()
        
        lblShopItemTitle.stringValue = "package description".localizedString()
        
        lblServer.stringValue = "server".localizedString()
        lblDataQuote.stringValue = "transfer".localizedString()
        lblExpire.stringValue = "duration".localizedString()
        
        lblPrice.stringValue = "price".localizedString()
        
        lblPaymentMethodTitle.stringValue = "select payment method".localizedString()
        
        lblDescTitle.stringValue = "attention:".localizedString()
        lblDesc.stringValue = "cluster attention content".localizedString()
        
        configureBuyNowButton()
    }
    
    @IBAction func onBackButtonClicked(_ sender: NSButton) {
        if disableUIEvent {return}
        
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func onServerNameButtonClicked(_ sender: NSButton) {
        if disableUIEvent {return}
        
        setServerTableViewVisibility(isVisible: serverListContainerHeightConstraint.constant == 0)
    }
    
    @IBAction func onDataQuoteButtonClicked(_ sender: NSButton) {
        if disableUIEvent {return}
        
        dataQuotaMenu.popUp(positioning: dataQuotaMenu.item(at: 0), at: NSPoint.init(x: 125, y: 365), in: view)
    }
    
    @IBAction func onPay1ButtonClicked(_ sender: NSButton) {
        if disableUIEvent {return}
        
        btnPay1.state = NSOnState
        btnPay2.state = NSOffState
        btnPay3.state = NSOffState
        curPayment = sender.tag
    }
    
    @IBAction func onPay2ButtonClicked(_ sender: NSButton) {
        if disableUIEvent {return}
        
        btnPay1.state = NSOffState
        btnPay2.state = NSOnState
        btnPay3.state = NSOffState
        curPayment = sender.tag
    }
    
    @IBAction func onPay3ButtonClicked(_ sender: NSButton) {
        if disableUIEvent {return}
        
        btnPay1.state = NSOffState
        btnPay2.state = NSOffState
        btnPay3.state = NSOnState
        curPayment = sender.tag
    }
    
    @IBAction func onBuyNowButtonClicked(_ sender: NSButton) {
        if disableUIEvent {return}
        
        buyNow();
    }
    
    @IBAction func onServerTableViewAction(_ sender: NSTableView) {
        if disableUIEvent {return}
        
        self.curCountry = countries[sender.selectedRow]
        configureUI()
        
        fetchServiceDataWithCluster()
    }
    
    @IBAction func onTableViewOutsideButtonClicked(_ sender: NSButton) {
        if disableUIEvent {return}
        
        setServerTableViewVisibility(isVisible: false)
    }
    
    private func configureBuyNowButton() {
        let titleString: String = "buy now".localizedString()
        let title: NSMutableAttributedString = NSMutableAttributedString.init(string: titleString)
        title.addAttribute(NSForegroundColorAttributeName, value: NSColor.init(cgColor: CGColor.agWhiteColor), range: NSRange.init(location: 0, length: titleString.count))
        
        let style: NSMutableParagraphStyle = NSMutableParagraphStyle.init()
        style.alignment = NSCenterTextAlignment
        title.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSRange.init(location: 0, length: titleString.count))
        
        let font: NSFont = NSFont.systemFont(ofSize: 15)
        title.addAttribute(NSFontAttributeName, value: font, range: NSRange.init(location: 0, length: titleString.count))
        
        btnBuyNow.attributedTitle = title
    }
    
    func updateUIFromService(data: Data?) {
        if data != nil {
            let array = NSDataUtils.nsdataToJSON(data: data!) as? NSArray
            if array != nil {
                countries.removeAll()
                for item in array! {
                    let country = MCountry(data: item as! NSDictionary)
                    countries.append(country)
                }
            }
        }
        
        if countries.count > 0 {
            curCountry = countries[0]
            configureUI()
            
            fetchServiceDataWithCluster()
        }
        
        self.tvServerList.reloadData()
    }
    
    func updateQuotaUIFromService(data: Data?) {
        packages.removeAll()
        
        let curLangCode = AppPref.getCurLanguageCode()
        if data != nil {
            let array = NSDataUtils.nsdataToJSON(data: data!) as? NSArray
            if array != nil {
                dataQuotaMenu = NSMenu()
                
                for item in array! {
                    let package = MPackage(data: item as! NSDictionary)
                    packages.append(package)
                    
                    let quota = CommonUtils.humanReadableByteCount(bytes: Int64(package.transfer), needFloat: false)
                    let menuItem = NSMenuItem(title: quota, action: #selector(onDataQuoteMenuItemSelected(sender:)), keyEquivalent: String(package.id))
                    menuItem.target = self
                    dataQuotaMenu.addItem(menuItem)
                }
                
                if packages.count > 0 {
                    lblDataQuoteStatus.stringValue = CommonUtils.humanReadableByteCount(bytes: Int64(packages[0].transfer), needFloat: false)
                    lblExpireDates.stringValue = String.init(format: "%ddays".localizedString(), packages[0].duration)
                    if curLangCode == "en" {
                        lblPriceValue.stringValue = "$" + String(packages[0].usd_price) + " USD"
                    } else {
                        lblPriceValue.stringValue = "¥" + String(packages[0].price) + " CNY"
                    }
                    curPackage = packages[0]
                }
            }
        }
    }
    
    private func configureUI() {
        setServerTableViewVisibility(isVisible: false)
        view.setBackgroundColor(color: CGColor.white)
        vwTitleBar.setBackgroundColor(color: CGColor.agMainColor)
        
        UIHelper.sharedInstance().applyViewWhiteRoundedRectStyle(view: vwServerName)
        UIHelper.sharedInstance().applyViewWhiteRoundedRectStyle(view: vwDataQuote)
        
        if curCountry != nil {
            if Localize.isChinese() { // chinese
                lblServerName.stringValue = curCountry!.alias_zh
            } else {
                lblServerName.stringValue = curCountry!.alias_en
            }
            
            if curCountry!.description != "" {
                var fullNameArr = curCountry!.description.components(separatedBy: " | ")
                if Localize.isChinese() {
                    lblShopItem.stringValue = fullNameArr[0]
                } else {
                    lblShopItem.stringValue = fullNameArr[1]
                }
            } else {
                lblShopItem.stringValue = ""
            }
        } else {
            lblShopItem.stringValue = ""
            lblServerName.stringValue = ""
            lblDataQuoteStatus.stringValue = ""
            lblExpireDates.stringValue = ""
            lblPriceValue.stringValue = ""
        }
    }
    
    private func setServerTableViewVisibility(isVisible: Bool) {
        if isVisible {
            serverListContainerHeightConstraint.constant = 520
        } else {
            serverListContainerHeightConstraint.constant = 0
        }
    }
    
    private func setPaymentMethod() {
        if paymentCount == 1 {
            if onAlipay {
                btnPay2.image = NSImage.init(named: "ic_alipay_normal")
                btnPay2.alternateImage = NSImage.init(named: "ic_alipay_selected")
                
                btnPay2.tag = TAG_ALIPAY
                curPayment = TAG_ALIPAY
            } else if onAlipayGlobal {
                btnPay2.image = NSImage.init(named: "ic_alipay_normal")
                btnPay2.alternateImage = NSImage.init(named: "ic_alipay_selected")
                btnPay2.tag = TAG_ALIPAY_GLOBAL
                curPayment = TAG_ALIPAY_GLOBAL
            } else if onItunes {
                btnPay2.image = NSImage.init(named: "ic_applepay_normal")
                btnPay2.alternateImage = NSImage.init(named: "ic_applepay_selected")
                btnPay2.tag = TAG_ITUNES
                curPayment = TAG_ITUNES
            } else if onAcoin {
                btnPay2.image = NSImage.init(named: "ic_acoin_normal")
                btnPay2.alternateImage = NSImage.init(named: "ic_acoin_selected")
                btnPay2.tag = TAG_ACOIN
                curPayment = TAG_ACOIN
            }
            btnPay2.isHidden = false
            btnPay2.state = NSOnState
            btnBuyNow.isEnabled = true
        } else if paymentCount == 2 {
            if onAlipay && onAlipayGlobal {
                btnPay1.image = NSImage.init(named: "ic_alipay_normal")
                btnPay1.alternateImage = NSImage.init(named: "ic_alipay_selected")
                btnPay1.tag = TAG_ALIPAY
                btnPay3.image = NSImage.init(named: "ic_alipay_normal")
                btnPay3.alternateImage = NSImage.init(named: "ic_alipay_selected")
                btnPay3.tag = TAG_ALIPAY_GLOBAL
                curPayment = TAG_ALIPAY
            } else if onAlipay && onItunes {
                btnPay1.image = NSImage.init(named: "ic_alipay_normal")
                btnPay1.alternateImage = NSImage.init(named: "ic_alipay_selected")
                btnPay1.tag = TAG_ALIPAY
                btnPay3.image = NSImage.init(named: "ic_applepay_normal")
                btnPay3.alternateImage = NSImage.init(named: "ic_applepay_selected")
                btnPay3.tag = TAG_ITUNES
                curPayment = TAG_ALIPAY
            } else if onAlipay && onAcoin {
                btnPay1.image = NSImage.init(named: "ic_alipay_normal")
                btnPay1.alternateImage = NSImage.init(named: "ic_alipay_selected")
                btnPay1.tag = TAG_ALIPAY
                btnPay3.image = NSImage.init(named: "ic_acoin_normal")
                btnPay3.alternateImage = NSImage.init(named: "ic_acoin_selected")
                btnPay3.tag = TAG_ACOIN
                curPayment = TAG_ALIPAY
            } else if onAlipayGlobal && onItunes {
                btnPay1.image = NSImage.init(named: "ic_alipay_normal")
                btnPay1.alternateImage = NSImage.init(named: "ic_alipay_selected")
                btnPay1.tag = TAG_ALIPAY_GLOBAL
                btnPay3.image = NSImage.init(named: "ic_applepay_normal")
                btnPay3.alternateImage = NSImage.init(named: "ic_applepay_selected")
                btnPay3.tag = TAG_ITUNES
                curPayment = TAG_ALIPAY_GLOBAL
            } else if onAlipayGlobal && onAcoin {
                btnPay1.image = NSImage.init(named: "ic_alipay_normal")
                btnPay1.alternateImage = NSImage.init(named: "ic_alipay_selected")
                btnPay1.tag = TAG_ALIPAY_GLOBAL
                btnPay3.image = NSImage.init(named: "ic_acoin_normal")
                btnPay3.alternateImage = NSImage.init(named: "ic_acoin_selected")
                btnPay3.tag = TAG_ACOIN
                curPayment = TAG_ALIPAY_GLOBAL
            } else if onItunes && onAcoin {
                btnPay1.image = NSImage.init(named: "ic_applepay_normal")
                btnPay1.alternateImage = NSImage.init(named: "ic_applepay_selected")
                btnPay1.tag = TAG_ITUNES
                btnPay3.image = NSImage.init(named: "ic_acoin_normal")
                btnPay3.alternateImage = NSImage.init(named: "ic_acoin_selected")
                btnPay3.tag = TAG_ACOIN
                curPayment = TAG_ITUNES
            }
            btnPay1.isHidden = false
            btnPay3.isHidden = false
            btnPay1.state = NSOnState
            btnBuyNow.isEnabled = true
        } else if paymentCount == 3 {
            if onAlipay && onAlipayGlobal && onItunes {
                btnPay1.image = NSImage.init(named: "ic_alipay_normal")
                btnPay1.alternateImage = NSImage.init(named: "ic_alipay_selected")
                btnPay1.tag = TAG_ALIPAY
                btnPay2.image = NSImage.init(named: "ic_alipay_normal")
                btnPay2.alternateImage = NSImage.init(named: "ic_alipay_selected")
                btnPay2.tag = TAG_ALIPAY_GLOBAL
                btnPay3.image = NSImage.init(named: "ic_applepay_normal")
                btnPay3.alternateImage = NSImage.init(named: "ic_applepay_selected")
                btnPay3.tag = TAG_ITUNES
                curPayment = TAG_ALIPAY
            } else if onAlipay && onAlipayGlobal && onAcoin {
                btnPay1.image = NSImage.init(named: "ic_alipay_normal")
                btnPay1.alternateImage = NSImage.init(named: "ic_alipay_selected")
                btnPay1.tag = TAG_ALIPAY
                btnPay2.image = NSImage.init(named: "ic_alipay_normal")
                btnPay2.alternateImage = NSImage.init(named: "ic_alipay_selected")
                btnPay2.tag = TAG_ALIPAY_GLOBAL
                btnPay3.image = NSImage.init(named: "ic_acoin_normal")
                btnPay3.alternateImage = NSImage.init(named: "ic_acoin_selected")
                btnPay3.tag = TAG_ACOIN
                curPayment = TAG_ALIPAY
            } else if onAlipay && onItunes && onAcoin {
                btnPay1.image = NSImage.init(named: "ic_alipay_normal")
                btnPay1.alternateImage = NSImage.init(named: "ic_alipay_selected")
                btnPay1.tag = TAG_ALIPAY
                btnPay2.image = NSImage.init(named: "ic_applepay_normal")
                btnPay2.alternateImage = NSImage.init(named: "ic_applepay_selected")
                btnPay2.tag = TAG_ITUNES
                btnPay3.image = NSImage.init(named: "ic_acoin_normal")
                btnPay3.alternateImage = NSImage.init(named: "ic_acoin_selected")
                btnPay3.tag = TAG_ACOIN
                curPayment = TAG_ALIPAY
            } else if onAlipayGlobal && onItunes && onAcoin {
                btnPay1.image = NSImage.init(named: "ic_alipay_normal")
                btnPay1.alternateImage = NSImage.init(named: "ic_alipay_selected")
                btnPay1.tag = TAG_ALIPAY_GLOBAL
                btnPay2.image = NSImage.init(named: "ic_applepay_normal")
                btnPay2.alternateImage = NSImage.init(named: "ic_applepay_selected")
                btnPay2.tag = TAG_ITUNES
                btnPay3.image = NSImage.init(named: "ic_acoin_normal")
                btnPay3.alternateImage = NSImage.init(named: "ic_acoin_selected")
                btnPay3.tag = TAG_ACOIN
                curPayment = TAG_ALIPAY_GLOBAL
            }
            btnPay1.isHidden = false
            btnPay2.isHidden = false
            btnPay3.isHidden = false
            btnPay1.state = NSOnState
            btnBuyNow.isEnabled = true
        }
    }
    
    func onDataQuoteMenuItemSelected(sender: NSMenuItem) {
        let curLangCode = AppPref.getCurLanguageCode()
        for package in packages {
            if String(package.id) == sender.keyEquivalent {
                curPackage = package
                
                lblDataQuoteStatus.stringValue = CommonUtils.humanReadableByteCount(bytes: Int64(curPackage!.transfer), needFloat: false)
                lblExpireDates.stringValue = String.init(format: "%ddays".localizedString(), curPackage!.duration)
                if curLangCode == "en" {
                    lblPriceValue.stringValue = "$" + String(curPackage!.usd_price) + " USD"
                } else {
                    lblPriceValue.stringValue = "¥" + String(curPackage!.price) + " CNY"
                }
                
                btnBuyNow.isEnabled = true
                break
            }
        }
    }
    
    func fetchItunesSwitchData() {
        let request = WSAPI.getAlamofireManager().request(WSAPI.Path.ItunesSwitch.url,
                                                          method: .get,
                                                          headers: ["Accept": WSAPI.HEADER_ACCEPT,
                                                                    "Content-Language": AppPref.getServiceLanguage()])
        
        request.responseData { response in
            let successResult = WSAPI.successResult(response: response.response)
            if successResult {
                let json = NSDataUtils.nsdataToJSON(data: response.result.value!)
                if json != nil {
                    if json!["content"] as! String? == "on" {
                        self.curPayment = self.TAG_ITUNES
                        self.lblPaymentMethodTitle.stringValue = ""
                        self.btnBuyNow.isEnabled = true
                    } else {
                        self.fetchPaySwitchData()
                    }
                }
            }
        }
    }
    
    func fetchPaySwitchData() {
        self.btnPay1.isHidden = true
        self.btnPay2.isHidden = true
        self.btnPay3.isHidden = true
        self.btnBuyNow.isEnabled = false
        
        let access_token = AppPref.getAccessToken()
        let request = WSAPI.getAlamofireManager().request(WSAPI.Path.PaySwitch.url,
                                                          method: .get,
                                                          headers: ["Accept": WSAPI.HEADER_ACCEPT,
                                                                    "Content-Language": AppPref.getServiceLanguage(),
                                                                    "Authorization": "Bearer \(access_token)"])
        
        request.responseData { response in
            DispatchQueue.main.async {
                self.pgLoading.animate = false
                self.btnBuyNow.isEnabled = true
            }
            let successResult = WSAPI.successResult(response: response.response)
            if successResult {
                let json = NSDataUtils.nsdataToJSON(data: response.result.value!)
                if json != nil {
                    if json!["alipay"] as! String? == "on" {
                        self.onAlipay = true
                        self.paymentCount += 1
                    }
                    if json!["global_alipay"] as! String? == "on" {
                        self.onAlipayGlobal = true
                        self.paymentCount += 1
                    }
                    if json!["itunes"] as! String? == "on" {
                        self.onItunes = true
                        self.paymentCount += 1
                    }
                    if json!["acoin"] as! String? == "on" {
                        self.onAcoin = true
                        self.paymentCount += 1
                    }
                }
                //self.paymentCount = 3
                //self.onAlipay = true
                //self.onAlipayGlobal = true
                //self.onItunes = true
                //self.onAcoin = true
                
            }
            self.setPaymentMethod()
        }
    }
    
    func buyNow() {
        var payment = ""
        if curPayment == TAG_ALIPAY {
            payment = "alipayWeb"
        } else if curPayment == TAG_ALIPAY_GLOBAL {
            payment = "globalAlipayWeb"
        } else if curPayment == TAG_ITUNES {
            payment = "itunes"
        } else if curPayment == TAG_ACOIN {
            payment = "acoin"
        }
        
        if curPayment == TAG_ALIPAY || curPayment == TAG_ALIPAY_GLOBAL || curPayment == TAG_ACOIN {
            self.pgLoading.animate = true
            self.btnBuyNow.isEnabled = false
            
            let access_token = AppPref.getAccessToken()
            let request = WSAPI.getAlamofireManager().request(WSAPI.Path.Cart.url,
                                                              method: .post,
                                                              parameters: ["payment_method": payment, "package_id": curPackage!.id],
                                                              headers: ["Accept": WSAPI.HEADER_ACCEPT, "Content-Language": AppPref.getServiceLanguage(), "Authorization": "Bearer \(access_token)"])
            
            request.responseData { response in
                DispatchQueue.main.async {
                    self.pgLoading.animate = false
                    self.btnBuyNow.isEnabled = true
                }
                let successResult = WSAPI.successResult(response: response.response)
                if successResult {
                    let json = NSDataUtils.nsdataToJSON(data: response.result.value!)
                    if json != nil {
                        if self.curPayment == self.TAG_ALIPAY || self.curPayment == self.TAG_ALIPAY_GLOBAL {
                            self.payWithAlipay(json: json as! NSDictionary)
                        } else {
                            self.payWithACoin(json: json as! NSDictionary)
                        }
                    } else {
                        Alert.show(data: response.data)
                    }
                } else {
                    Alert.show(data: response.data)
                }
            }
        } else if curPayment == TAG_ITUNES {
            if AppPref.isLogined() {
                self.pgLoading.animate = true
                self.btnBuyNow.isEnabled = false
                
                let access_token = AppPref.getAccessToken()
                let request = WSAPI.getAlamofireManager().request(WSAPI.Path.Cart.url,
                                                                  method: .post,
                                                                  parameters: ["payment_method": payment, "package_id": curPackage!.id],
                                                                  headers: ["Accept": WSAPI.HEADER_ACCEPT, "Content-Language": AppPref.getServiceLanguage(), "Authorization": "Bearer \(access_token)"])
                request.responseData { response in
                    DispatchQueue.main.async {
                        self.pgLoading.animate = false
                        self.btnBuyNow.isEnabled = true
                    }
                    let successResult = WSAPI.successResult(response: response.response)
                    if successResult {
                        let json = NSDataUtils.nsdataToJSON(data: response.result.value!)
                        if json != nil {
                            self.payWithITunes(json: json as! NSDictionary)
                        } else {
                            Alert.show(data: response.data)
                        }
                    } else {
                        Alert.show(data: response.data)
                    }
                }
            } else {
                self.pgLoading.animate = true
                self.btnBuyNow.isEnabled = false
                
                let tourist_id = AppPref.getTouristId()
                let request = WSAPI.getAlamofireManager().request(WSAPI.Path.TouristCart.url,
                                                                  method: .post,
                                                                  parameters: ["payment_method": curPayment, "package_id": curPackage!.id],
                                                                  headers: ["Accept": WSAPI.HEADER_ACCEPT, "Content-Language": AppPref.getServiceLanguage(), "Tourist-Id": tourist_id])
                request.responseData { response in
                    DispatchQueue.main.async {
                        self.pgLoading.animate = false
                        self.btnBuyNow.isEnabled = true
                    }
                    let successResult = WSAPI.successResult(response: response.response)
                    if successResult {
                        let json = NSDataUtils.nsdataToJSON(data: response.result.value!)
                        if json != nil {
                            self.payWithITunes(json: json as! NSDictionary)
                        } else {
                            Alert.show(data: response.data)
                        }
                    } else {
                        Alert.show(data: response.data)
                    }
                }
            }
        }
    }
    
    func fetchServiceData() {
        let request = WSAPI.getAlamofireManager().request(WSAPI.Path.Countries.url,
                                                          method: .get,
                                                          headers: ["Accept": WSAPI.HEADER_ACCEPT, "Content-Language": AppPref.getServiceLanguage()])
        request.responseData { response in
            DispatchQueue.main.async {
                self.pgLoading.animate = false
                self.btnBuyNow.isEnabled = true
            }
            let successResult = WSAPI.successResult(response: response.response)
            if successResult {
                let data = response.result.value
                self.updateUIFromService(data: data)
            }
        }
    }
    
    func fetchServiceDataWithCluster() {
        let request = WSAPI.getAlamofireManager().request(WSAPI.Path.CountryDetail(String(curCountry!.id)).url,
                                                          method: .get,
                                                          headers: ["Accept": WSAPI.HEADER_ACCEPT, "Content-Language": AppPref.getServiceLanguage()])
        request.responseData { response in
            DispatchQueue.main.async {
                self.pgLoading.animate = false
                self.btnBuyNow.isEnabled = true
            }
            let successResult = WSAPI.successResult(response: response.response)
            if successResult {
                let data = response.result.value
                self.updateQuotaUIFromService(data: data)
            } 
        }
    }
    
    // MARK: iTunes
    func payWithITunes(json: NSDictionary) {
        tradeNo = json["trade_no"] as! String
        fee = json["fee"] as! Float
        
        let canMakePayments = IAPManager.shared.canMakePayments()
        if canMakePayments {
            if self.curPackage!.mac_product_id.isEmpty { return }
            
            DispatchQueue.main.async {
                self.disableUIEvent = true
                self.pgLoading.animate = true
            }
            
            let productIdentifiers: Set = [self.curPackage!.mac_product_id] //Strings
            IAPManager.shared.requestProducts(productIdentifiers: productIdentifiers) { fetchedProducts in
                if fetchedProducts.count > 0 {
                    let product = fetchedProducts[0]
                    IAPManager.shared.purchaseProduct(product: product) { (purchaseStatus, transaction) in
                        if purchaseStatus == true {
                            self.updateitunesPayResult(trans: transaction)
                        } else {
                            if purchaseStatus == false {
                                DispatchQueue.main.async {
                                    self.disableUIEvent = false
                                    self.pgLoading.animate = false
                                    Alert.show(message: "you can't use In-app purchase.".localizedString())
                                }
                            }
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.disableUIEvent = false
                        self.pgLoading.animate = false
                        Alert.show(message: "you can't use In-app purchase.".localizedString())
                    }
                }
            }
        } else {
            Alert.show(message: "you can't use In-app purchase.".localizedString())
        }
    }
    
    func updateitunesPayResult(trans: SKPaymentTransaction) {
        guard let receiptURL = Bundle.main.appStoreReceiptURL,
            let receipt = NSData(contentsOf: receiptURL) else {
                DispatchQueue.main.async {
                    self.disableUIEvent = false
                    self.pgLoading.animate = false
                    Alert.show(message: "failed to pay with In app purchase.".localizedString())
                }                
                return
        }
        
        let receiptData = receipt.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        let tradenoHash = ((trans.transactionIdentifier)!+"@appgogo.cn").sha1()
        let request = WSAPI.getAlamofireManager().request(WSAPI.Path.PayValidateItunes.url,
                                                          method: .post,
                                                          parameters: ["trade_no": self.tradeNo, "receipt": receiptData, "hash_check": tradenoHash],
                                                          headers: ["Accept": WSAPI.HEADER_ACCEPT, "Content-Language": AppPref.getServiceLanguage()])
        request.responseData { response in
            DispatchQueue.main.async {
                self.disableUIEvent = false
                self.pgLoading.animate = false
            }
            let successResult = WSAPI.successResult(response: response.response)
            if successResult {
                NotificationCenter.default.post(name: .PURCHASE_CHANGE, object: nil)
                
                self.navigationController?.popViewControllerAnimated(true)
            } else {
                DispatchQueue.main.async {
                    Alert.show(data: response.data)
                }
            }
        }
    }

    
    // MARK: AliPay
    func payWithAlipay(json: NSDictionary) {
        //self.tradeNo = json["trade_no"] as! String
        //self.fee = json["fee"] as! Float
        let url = json["url"] as! String!
        //let url = urlencode.stringByRemovingPercentEncoding!

        if let url = URL(string: url!), NSWorkspace.shared().open(url) {
            DispatchQueue.main.async {
                self.btnBuyNow.isEnabled = false
            }
            disablePayTimer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(disablePayTimerAction), userInfo: nil, repeats: false)
        }
    }
    
    func disablePayTimerAction() {
        disablePayTimer?.invalidate()
        disablePayTimer = nil
        DispatchQueue.main.async {
            self.btnBuyNow.isEnabled = true
        }
    }
    
    
    // MARK: ACoin
    func payWithACoin(json: NSDictionary) {
        tradeNo = json["trade_no"] as! String
        fee = json["fee"] as! Float
        
        DispatchQueue.main.async {
            self.pgLoading.animate = true
            self.btnBuyNow.isEnabled = false
        }
        
        let access_token = AppPref.getAccessToken()
        let request = WSAPI.getAlamofireManager().request(WSAPI.Path.PayValidateACoin.url,
                                                          method: .post,
                                                          parameters: ["trade_no": tradeNo, "fee": fee],
                                                          headers: ["Accept": WSAPI.HEADER_ACCEPT, "Content-Language": AppPref.getServiceLanguage(), "Authorization": "Bearer \(access_token)"])
        request.responseData { response in
            DispatchQueue.main.async {
                self.pgLoading.animate = false
                self.btnBuyNow.isEnabled = true
            }
            
            let successResult = WSAPI.successResult(response: response.response)
            if successResult {
                Alert.show(message: "it paid off successfully.".localizedString(), confirmCallback: {
                    [weak self] in
                    
                    NotificationCenter.default.post(name: .PURCHASE_CHANGE, object: nil)
                    NotificationCenter.default.post(name: .PAY_CHANGE, object: nil)
                    
                    self!.navigationController?.popViewControllerAnimated(true)
                })
            } else {
                Alert.show(data: response.data)
            }
        }
    }
}

extension AGShopViewController: NSTableViewDataSource, NSTableViewDelegate {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellView: NSView = tableView.make(withIdentifier: "ServerTableViewCell", owner: self)!
        cellView.setBackgroundColor(color: CGColor.agLightBlueColor)
        let ivFlag: NSImageView = cellView.viewWithTag(1) as! NSImageView
        let lblServerName: NSTextField = cellView.viewWithTag(2) as! NSTextField
        
        let country = countries[row] as MCountry
        if Localize.isChinese() { // chinese
            lblServerName.stringValue = country.alias_zh
        } else {
            lblServerName.stringValue = country.alias_en
        }
        
        ivFlag.image = NSImage.init(named: Country.getFlagName(code: country.name))
        //ivFlag.image = NSImage.init(named: countryInfos[row].flag)
        
        let splitter = cellView.viewWithTag(3)
        splitter?.isHidden = row == tableView.numberOfRows - 1
        
        return cellView
    }
}
