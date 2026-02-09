//
//  PurchaseViewController.swift
//  AppGoPro
//
//  Created by rbvirakf on 12/15/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

import UIKit
import Alamofire
import PassKit
import StoreKit


class PurchaseViewController: BaseViewController,  PKPaymentAuthorizationViewControllerDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver {

    final let TVCELL_PAY_ICON_TAG = 100
    final let TVCELL_PAY_LABEL_TAG = 101
    final let TVCELL_CHECKED_TAG = 102
    
    @IBOutlet weak var labelPurshase: UILabel!
    @IBOutlet weak var labelDuration: UILabel!
    @IBOutlet weak var labelTransfer: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelServr: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var buttonPay1: UIButton!
    @IBOutlet weak var buttonPay2: UIButton!
    @IBOutlet weak var buttonPay3: UIButton!
    @IBOutlet weak var buttonOrder: UIButton!
    @IBOutlet weak var viewPayMethod: UIView!
    @IBOutlet weak var viewPayMethodDesc: UIView!
    @IBOutlet weak var labelComment: UILabel!
    
    var package: MPackage!
    var country: MCountry!
    var curPayment: Int = 0
    var iapProduct = SKProduct()
    var iapRequest: SKProductsRequest?
    var switchOn: Bool = false
    var tradeNo: String = ""
    var fee: Float = 0.0
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
        
        viewPayMethod.isHidden = true
        viewPayMethodDesc.isHidden = true
    }
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
        
        buttonOrder.layer.borderWidth = 1.0
        buttonOrder.layer.borderColor = Color.BackBlue.cgColor
        buttonOrder.layer.backgroundColor = Color.BackBlue.cgColor
        buttonOrder.layer.cornerRadius = buttonOrder.frame.size.height / 2
        
        updatePaymentState()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        SKPaymentQueue.default().remove(self)
    }
    
    override func onLanguageChangeNotification(notification: Notification) {
        labelPurshase.text = "purchase".localizedString()
        labelDuration.text! = String.init(format: "duration: %d days".localizedString(), package.duration)
        labelServr.text = String.init(format: "server: %@".localizedString(), Country.getCountryName(country.name, locale: AppPref.getCurLanguageCode()))
        labelTransfer.text! = String.init(format: "transfer: %@".localizedString(), CommonUtils.humanReadableByteCount(Int64(package!.transfer), needFloat: false))
        labelPrice.text! = "price: ¥ ".localizedString() + String(package!.price) + "rmb".localizedString()
        labelDescription.text = "select payment method".localizedString()
        buttonOrder.setTitle("pay now".localizedString(), for: .normal)        
        labelComment.text = "purchase comment".localizedString()
    }
    
    override func onLoginChangeNotification(notification:Notification) {
        updatePaymentState()
    }
    
    override func onMainTabChangeNotification(notification: Notification) {
        updatePaymentState()
    }
    
    override func onPaymentResultNotification(notification: Notification) {
        if let status = notification.userInfo?["status"] as? Bool {
            if status {
                Alert.show(self, message: "\("paid successfully.".localizedString())", confirmCallback: { [weak self] in
                    NotificationCenter.default.post(name: .PURCHASE_CHANGE, object: nil, userInfo: ["status": true])
                    self!.popToShopViewController()
                })
            } else {
                Alert.show(self, message: "\("payment did not succeed.".localizedString())")
            }
        }
    }
    
    @IBAction func onClickBack(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickPay1(_ sender: AnyObject) {
        buttonPay1.isSelected = true
        buttonPay2.isSelected = false
        buttonPay3.isSelected = false
        curPayment = sender.tag
    }
    
    @IBAction func onClickPay2(_ sender: AnyObject) {
        buttonPay2.isSelected = true
        buttonPay1.isSelected = false
        buttonPay3.isSelected = false
        curPayment = sender.tag
    }
    
    @IBAction func onClickPay3(_ sender: AnyObject) {
        buttonPay3.isSelected = true
        buttonPay1.isSelected = false
        buttonPay2.isSelected = false
        curPayment = sender.tag
    }
    
    @IBAction func onClickOrder(_ sender: UIButton) {
        var payment = ""
        if curPayment == TAG_ALIPAY {
            payment = "alipay"
        } else if curPayment == TAG_ALIPAY_GLOBAL {
            payment = "globalAlipayApp"
        } else if curPayment == TAG_ITUNES {
            payment = "itunes"
        } else if curPayment == TAG_ACOIN {
            payment = "acoin"
        }
        
        if curPayment == TAG_ALIPAY || curPayment == TAG_ALIPAY_GLOBAL || curPayment == TAG_ACOIN {
            showProgreeHUD()
            
            let access_token = AppPref.getAccessToken()
            let request = WSAPI.getAlamofireManager().request(WSAPI.Path.Cart.url,
                                                              method: .post,
                                                              parameters: ["payment_method": payment, "package_id": package!.id],
                                                              encoding: URLEncoding.default,
                                                              headers: ["Accept": WSAPI.HEADER_ACCEPT, "Content-Language": AppPref.convertServiceLanguageCode(), "Authorization": "Bearer \(access_token)"])           
            request.responseData(completionHandler: { response in
                self.hideHUD()
                
                let successResult = WSAPI.successResult(response.response)
                if successResult {
                    let json = NSDataUtils.nsdataToJSON(response.result.value!)
                    if json != nil {
                        if self.curPayment == self.TAG_ALIPAY || self.curPayment == self.TAG_ALIPAY_GLOBAL {
                            self.payWithAlipay(json as! NSDictionary)
                        } else {
                            self.payWithACoin(json as! NSDictionary)
                        }
                    } else {
                        Alert.show(self, data: response.data)
                    }
                } else {
                    Alert.show(self, data: response.data)
                }
            })
        } else if curPayment == TAG_ITUNES {
            if AppPref.isLogined() {
                showProgreeHUD()
                
                let access_token = AppPref.getAccessToken()
                let request = WSAPI.getAlamofireManager().request(WSAPI.Path.Cart.url,
                                                                  method: .post,
                                                                  parameters: ["payment_method": payment, "package_id": package!.id],
                                                                  encoding: URLEncoding.default,
                                                                  headers: ["Accept": WSAPI.HEADER_ACCEPT, "Content-Language": AppPref.convertServiceLanguageCode(), "Authorization": "Bearer \(access_token)"])
                request.responseData(completionHandler: { response in
                    self.hideHUD()
                    
                    let successResult = WSAPI.successResult(response.response)
                    if successResult {
                        let json = NSDataUtils.nsdataToJSON(response.result.value!)
                        if json != nil {
                            self.payWithITunes(json as! NSDictionary)
                        } else {
                            Alert.show(self, data: response.data)
                        }
                    } else {
                        Alert.show(self, data: response.data)
                    }
                })
            } else {
                showProgreeHUD()
                
                let tourist_id = AppPref.getTouristId()
                let request = WSAPI.getAlamofireManager().request(WSAPI.Path.TouristCart.url,
                                                                  method: .post,
                                                                  parameters: ["payment_method": payment, "package_id": package!.id],
                                                                  encoding: URLEncoding.default,
                                                                  headers: ["Accept": WSAPI.HEADER_ACCEPT, "Content-Language": AppPref.convertServiceLanguageCode(), "Tourist-Id": tourist_id])
                request.responseData(completionHandler: { response in
                    self.hideHUD()
                    
                    let successResult = WSAPI.successResult(response.response)
                    if successResult {
                        let json = NSDataUtils.nsdataToJSON(response.result.value!)
                        if json != nil {
                            self.payWithITunes(json as! NSDictionary)
                        } else {
                            Alert.show(self, data: response.data)
                        }
                    } else {
                        Alert.show(self, data: response.data)
                    }
                })
            }
        }
    }
    
    func updatePaymentState() {
        self.buttonPay1.isHidden = true
        self.buttonPay2.isHidden = true
        self.buttonPay3.isHidden = true
        self.buttonOrder.isEnabled = false
        
        if AppPref.isLogined() {
            fetchItunesSwitchData()
        } else {
            curPayment = TAG_ITUNES
            self.labelDescription.text = ""
            buttonOrder.isEnabled = true
        }
    }
    
    func fetchItunesSwitchData() {
        let request = WSAPI.getAlamofireManager().request(WSAPI.Path.ItunesSwitch.url,
                                                          method: .get,
                                                          parameters: nil,
                                                          encoding: URLEncoding.default,
                                                          headers: ["Accept": WSAPI.HEADER_ACCEPT, "Content-Language": AppPref.convertServiceLanguageCode()])
        
        request.responseData { response in
            let successResult = WSAPI.successResult(response.response)
            if successResult {
                let json = NSDataUtils.nsdataToJSON(response.result.value!)
                if json != nil {
                    if json!["content"] as! String? == "on" {
                        self.curPayment = self.TAG_ITUNES
                        self.labelDescription.text = ""
                        self.buttonOrder.isEnabled = true
                    } else {
                        self.fetchPaySwitchData()
                    }
                }
            }
        }
    }
    
    func fetchPaySwitchData() {
        let access_token = AppPref.getAccessToken()
        let request = WSAPI.getAlamofireManager().request(WSAPI.Path.PaySwitch.url,
                                                          method: .get,
                                                          parameters: nil,
                                                          encoding: URLEncoding.default,
                                                          headers: ["Accept": WSAPI.HEADER_ACCEPT, "Content-Language": AppPref.convertServiceLanguageCode(), "Authorization": "Bearer \(access_token)"])
    
        request.responseData { response in
            self.onItunes = true
            self.paymentCount = 1
            
            let successResult = WSAPI.successResult(response.response)
            if successResult {
                let json = NSDataUtils.nsdataToJSON(response.result.value!)
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
                /*self.paymentCount = 3
                self.onAlipayGlobal = true
                self.onItunes = true
                self.onAcoin = true*/
                
            }
            self.setPaymentMethod()
        }
    }
    
    private func setPaymentMethod() {
        viewPayMethodDesc.isHidden = false
        viewPayMethod.isHidden = false
        
        if paymentCount == 1 {
            if onAlipay {
                buttonPay2.setImage(UIImage(named: "ic_alipay_gray.png"), for: .normal)
                buttonPay2.setImage(UIImage(named: "ic_alipay.png"), for: .selected)
                buttonPay2.tag = TAG_ALIPAY
                curPayment = TAG_ALIPAY
            } else if onAlipayGlobal {
                buttonPay2.setImage(UIImage(named: "ic_alipay_gray.png"), for: .normal)
                buttonPay2.setImage(UIImage(named: "ic_alipay.png"), for: .selected)
                buttonPay2.tag = TAG_ALIPAY_GLOBAL
                curPayment = TAG_ALIPAY_GLOBAL
            } else if onItunes {
                buttonPay2.setImage(UIImage(named: "ic_applepay_gray.png"), for: .normal)
                buttonPay2.setImage(UIImage(named: "ic_applepay.png"), for: .selected)
                buttonPay2.tag = TAG_ITUNES
                curPayment = TAG_ITUNES
            } else if onAcoin {
                buttonPay2.setImage(UIImage(named: "ic_acoin_gray.png"), for: .normal)
                buttonPay2.setImage(UIImage(named: "ic_acoin.png"), for: .selected)
                buttonPay2.tag = TAG_ACOIN
                curPayment = TAG_ACOIN
            }
            buttonPay2.isHidden = false
            buttonPay2.isSelected = true
            buttonOrder.isEnabled = true
        } else if paymentCount == 2 {
            if onAlipay && onAlipayGlobal {
                buttonPay1.setImage(UIImage(named: "ic_alipay_gray.png"), for: .normal)
                buttonPay1.setImage(UIImage(named: "ic_alipay.png"), for: .selected)
                buttonPay1.tag = TAG_ALIPAY
                buttonPay3.setImage(UIImage(named: "ic_alipay_gray.png"), for: .normal)
                buttonPay3.setImage(UIImage(named: "ic_alipay.png"), for: .selected)
                buttonPay3.tag = TAG_ALIPAY_GLOBAL
                curPayment = TAG_ALIPAY
            } else if onAlipay && onItunes {
                buttonPay1.setImage(UIImage(named: "ic_alipay_gray.png"), for: .normal)
                buttonPay1.setImage(UIImage(named: "ic_alipay.png"), for: .selected)
                buttonPay1.tag = TAG_ALIPAY
                buttonPay3.setImage(UIImage(named: "ic_applepay_gray.png"), for: .normal)
                buttonPay3.setImage(UIImage(named: "ic_applepay.png"), for: .selected)
                buttonPay3.tag = TAG_ITUNES
                curPayment = TAG_ALIPAY
            } else if onAlipay && onAcoin {
                buttonPay1.setImage(UIImage(named: "ic_alipay_gray.png"), for: .normal)
                buttonPay1.setImage(UIImage(named: "ic_alipay.png"), for: .selected)
                buttonPay1.tag = TAG_ALIPAY
                buttonPay3.setImage(UIImage(named: "ic_acoin_gray.png"), for: .normal)
                buttonPay3.setImage(UIImage(named: "ic_acoin.png"), for: .selected)
                buttonPay3.tag = TAG_ACOIN
                curPayment = TAG_ALIPAY
            } else if onAlipayGlobal && onItunes {
                buttonPay1.setImage(UIImage(named: "ic_alipay_gray.png"), for: .normal)
                buttonPay1.setImage(UIImage(named: "ic_alipay.png"), for: .selected)
                buttonPay1.tag = TAG_ALIPAY_GLOBAL
                buttonPay3.setImage(UIImage(named: "ic_applepay_gray.png"), for: .normal)
                buttonPay3.setImage(UIImage(named: "ic_applepay.png"), for: .selected)
                buttonPay3.tag = TAG_ITUNES
                curPayment = TAG_ALIPAY_GLOBAL
            } else if onAlipayGlobal && onAcoin {
                buttonPay1.setImage(UIImage(named: "ic_alipay_gray.png"), for: .normal)
                buttonPay1.setImage(UIImage(named: "ic_alipay.png"), for: .selected)
                buttonPay1.tag = TAG_ALIPAY_GLOBAL
                buttonPay3.setImage(UIImage(named: "ic_acoin_gray.png"), for: .normal)
                buttonPay3.setImage(UIImage(named: "ic_acoin.png"), for: .selected)
                buttonPay3.tag = TAG_ACOIN
                curPayment = TAG_ALIPAY_GLOBAL
            } else if onItunes && onAcoin {
                buttonPay1.setImage(UIImage(named: "ic_applepay_gray.png"), for: .normal)
                buttonPay1.setImage(UIImage(named: "ic_applepay.png"), for: .selected)
                buttonPay1.tag = TAG_ITUNES
                buttonPay3.setImage(UIImage(named: "ic_acoin_gray.png"), for: .normal)
                buttonPay3.setImage(UIImage(named: "ic_acoin.png"), for: .selected)
                buttonPay3.tag = TAG_ACOIN
                curPayment = TAG_ITUNES
            }
            buttonPay1.isHidden = false
            buttonPay3.isHidden = false
            buttonPay1.isSelected = true
            buttonOrder.isEnabled = true
        } else if paymentCount == 3 {
            if onAlipay && onAlipayGlobal && onItunes {
                buttonPay1.setImage(UIImage(named: "ic_alipay_gray.png"), for: .normal)
                buttonPay1.setImage(UIImage(named: "ic_alipay.png"), for: .selected)
                buttonPay1.tag = TAG_ALIPAY
                buttonPay2.setImage(UIImage(named: "ic_alipay_gray.png"), for: .normal)
                buttonPay2.setImage(UIImage(named: "ic_alipay.png"), for: .selected)
                buttonPay2.tag = TAG_ALIPAY_GLOBAL
                buttonPay3.setImage(UIImage(named: "ic_applepay_gray.png"), for: .normal)
                buttonPay3.setImage(UIImage(named: "ic_applepay.png"), for: .selected)
                buttonPay3.tag = TAG_ITUNES
                curPayment = TAG_ALIPAY
            } else if onAlipay && onAlipayGlobal && onAcoin {
                buttonPay1.setImage(UIImage(named: "ic_alipay_gray.png"), for: .normal)
                buttonPay1.setImage(UIImage(named: "ic_alipay.png"), for: .selected)
                buttonPay1.tag = TAG_ALIPAY
                buttonPay2.setImage(UIImage(named: "ic_alipay_gray.png"), for: .normal)
                buttonPay2.setImage(UIImage(named: "ic_alipay.png"), for: .selected)
                buttonPay2.tag = TAG_ALIPAY_GLOBAL
                buttonPay3.setImage(UIImage(named: "ic_acoin_gray.png"), for: .normal)
                buttonPay3.setImage(UIImage(named: "ic_acoin.png"), for: .selected)
                buttonPay3.tag = TAG_ACOIN
                curPayment = TAG_ALIPAY
            } else if onAlipay && onItunes && onAcoin {
                buttonPay1.setImage(UIImage(named: "ic_alipay_gray.png"), for: .normal)
                buttonPay1.setImage(UIImage(named: "ic_alipay.png"), for: .selected)
                buttonPay1.tag = TAG_ALIPAY
                buttonPay2.setImage(UIImage(named: "ic_applepay_gray.png"), for: .normal)
                buttonPay2.setImage(UIImage(named: "ic_applepay.png"), for: .selected)
                buttonPay2.tag = TAG_ITUNES
                buttonPay3.setImage(UIImage(named: "ic_acoin_gray.png"), for: .normal)
                buttonPay3.setImage(UIImage(named: "ic_acoin.png"), for: .selected)
                buttonPay3.tag = TAG_ACOIN
                curPayment = TAG_ALIPAY
            } else if onAlipayGlobal && onItunes && onAcoin {
                buttonPay1.setImage(UIImage(named: "ic_alipay_gray.png"), for: .normal)
                buttonPay1.setImage(UIImage(named: "ic_alipay.png"), for: .selected)
                buttonPay1.tag = TAG_ALIPAY_GLOBAL
                buttonPay2.setImage(UIImage(named: "ic_applepay_gray.png"), for: .normal)
                buttonPay2.setImage(UIImage(named: "ic_applepay.png"), for: .selected)
                buttonPay2.tag = TAG_ITUNES
                buttonPay3.setImage(UIImage(named: "ic_acoin_gray.png"), for: .normal)
                buttonPay3.setImage(UIImage(named: "ic_acoin.png"), for: .selected)
                buttonPay3.tag = TAG_ACOIN
                curPayment = TAG_ALIPAY_GLOBAL
            }
            
            buttonPay1.isHidden = false
            buttonPay2.isHidden = false
            buttonPay3.isHidden = false
            buttonPay1.isSelected = true
            buttonOrder.isEnabled = true
        }
    }
    
    // MARK: AliPay
    func payWithAlipay(_ json: NSDictionary) {
        self.tradeNo = json["trade_no"] as! String
        self.fee = json["fee"] as! Float
        let url = json["url"] as! String?
        //let url = urlencode.stringByRemovingPercentEncoding!
        
        var keyDic = Dictionary<String, String>()
        let params = url?.components(separatedBy: "&")
        for value in params! {
            let key = value.components(separatedBy: "=")
            if key.count == 2 {
                keyDic[key[0]] = key[1]
            }
        }
        
        AlipaySDK.defaultService().payOrder(url, fromScheme: kAppScheme, callback: { (resultDic) -> Void in
            let result = resultDic as! NSDictionary
            let status = result.object(forKey: "resultStatus") as! String
            if Int(status) == 9000 {
                NotificationCenter.default.post(name: .PAYMENT_RESULT, object: nil, userInfo: ["status": true])
            } else {
                NotificationCenter.default.post(name: .PAYMENT_RESULT, object: nil, userInfo: ["status": false])
            }
        })
    }
    
    // MARK: ACoin
    func payWithACoin(_ json: NSDictionary) {
        tradeNo = json["trade_no"] as! String
        fee = json["fee"] as! Float
        
        showProgreeHUD()
        
        let access_token = AppPref.getAccessToken()
        let request = WSAPI.getAlamofireManager().request(WSAPI.Path.PayValidateACoin.url,
                                                          method: .post,
                                                          parameters: ["trade_no": tradeNo, "fee": fee],
                                                          encoding: URLEncoding.default,
                                                          headers: ["Accept": WSAPI.HEADER_ACCEPT, "Content-Language": AppPref.convertServiceLanguageCode(), "Authorization": "Bearer \(access_token)"])
        request.responseData(completionHandler: { response in
            self.hideHUD()
            
            let successResult = WSAPI.successResult(response.response)
            if successResult {
                Alert.show(self, message: "it paid off successfully.".localizedString(), confirmCallback: { [weak self] in
                    NotificationCenter.default.post(name: .PURCHASE_CHANGE, object: nil)
                    self!.popToShopViewController()
                    })
            } else {
                Alert.show(self, data: response.data)
            }
        })
    }
    
    // MARK: iTunes
    func payWithITunes(_ json: NSDictionary) {
        tradeNo = json["trade_no"] as! String
        fee = json["fee"] as! Float
        
        if SKPaymentQueue.canMakePayments() {
            self.showProgreeHUD("waiting for payment.".localizedString())
            buttonOrder.isEnabled = false
            
            let productID:NSSet = NSSet(objects: package!.apple_product_id)
            iapRequest = SKProductsRequest(productIdentifiers:  productID as! Set<String>)
            iapRequest!.delegate = self
            iapRequest!.start()
        } else {
            Alert.show(self, message: "you can't use In-app purchase.".localizedString())
        }
        
        SKPaymentQueue.default().add(self)
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        let products = response.products
        
        if products.count > 0 {
            buttonOrder.isEnabled = true
            
            for p in products {
                iapProduct = p
                
                let pay = SKPayment(product: self.iapProduct)
                SKPaymentQueue.default().add(self)
                SKPaymentQueue.default().add(pay as SKPayment)
                
                break
            }
        } else {
            self.labelDescription.text = ""//iap product id".localizedString()
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        //DebugPrint.dprint("add paymnet")
        
        for transaction:AnyObject in transactions {
            let trans = transaction as! SKPaymentTransaction
            
            switch trans.transactionState {
                
            case .purchased:
                DebugPrint.dprint("buy, ok unlock iap here")
                queue.finishTransaction(trans)
                self.hideHUD()
                
                updateitunesPayResult(trans)
                break;
                
            case .failed:
                DebugPrint.dprint("buy error")                
                queue.finishTransaction(trans)
                self.hideHUD()
                break;
                
            case .restored:
                break;
                
            case .purchasing:
                break;
                
            default:
                DebugPrint.dprint("default")
                break;
                
            }
        }
        
    }
    
    func finishTransaction(_ trans:SKPaymentTransaction) {
        //DebugPrint.dprint("finish trans")
        
        SKPaymentQueue.default().finishTransaction(trans)
    }
    
    
    func receiptData(_ appStoreReceiptURL : URL?) -> Data? {
        
        guard let receiptURL = appStoreReceiptURL,
            let receipt = try? Data(contentsOf: receiptURL) else {
                return nil
        }
        
        let receiptData = receipt.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        let requestContents = ["receipt-data" : receiptData]
        let requestData = NSDataUtils.nsdataFromJSON(requestContents as AnyObject)
        
        return requestData
    }
    
    func validateReceiptInternal(_ appStoreReceiptURL : URL?, isProd: Bool , onCompletion: @escaping (Int?) -> Void) {
        
        let serverURL = isProd ? "https://buy.itunes.apple.com/verifyReceipt" : "https://sandbox.itunes.apple.com/verifyReceipt"
        
        guard let receiptData = receiptData(appStoreReceiptURL),
            let url = URL(string: serverURL)  else {
                onCompletion(nil)
                return
        }
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = receiptData
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {
            data, response, error in
            guard let data = data, error == nil else {
                onCompletion(nil)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions(rawValue: UInt(0)))
                DebugPrint.dprint("validate receipt: \(json)")
                
                if let jsondata = json as? [String: Any], let statusCode = jsondata["status"] as? Int {
                    onCompletion(statusCode)
                } else {
                    onCompletion(nil)
                }                
            }
            catch let error {
                print(error)
                onCompletion(nil)
            }
        }) 
        task.resume()
    }
    
    func validateReceipt(_ appStoreReceiptURL : URL?, onCompletion: @escaping (Bool) -> Void) {
        
        validateReceiptInternal(appStoreReceiptURL, isProd: WSAPI.IS_PRODUCT) { (statusCode: Int?) -> Void in
            guard let status = statusCode else {
                onCompletion(false)
                return
            }
            
            // This receipt is from the test environment, but it was sent to the production environment for verification.
            if status == 21007 {
                self.validateReceiptInternal(appStoreReceiptURL, isProd: false) { (statusCode: Int?) -> Void in
                    guard let statusValue = statusCode else {
                        onCompletion(false)
                        return
                    }
                    
                    // 0 if the receipt is valid
                    if statusValue == 0 {
                        onCompletion(true)
                    } else {
                        onCompletion(false)
                    }
                    
                }
                
                // 0 if the receipt is valid
            } else if status == 0 {
                onCompletion(true)
            } else {
                onCompletion(false)
            }
        }
    }
    
    func updateitunesPayResult(_ trans: SKPaymentTransaction) {
        
        guard let receiptURL = Bundle.main.appStoreReceiptURL,
            let receipt = try? Data(contentsOf: receiptURL) else {
                Alert.show(self, message: "\("failed to pay with In app purchase.".localizedString())")
                return
        }
        
        let receiptData = receipt.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        let tradenoHash = ((trans.transactionIdentifier)!+"@appgogo.cn").sha1()
        
        showProgreeHUD()
        
        let request = WSAPI.getAlamofireManager().request(WSAPI.Path.PayValidateItunes.url,
                                                          method: .post,
                                                          parameters: ["trade_no": self.tradeNo, "receipt": receiptData, "hash_check": tradenoHash],
                                                          encoding: URLEncoding.default,
                                                          headers: ["Accept": WSAPI.HEADER_ACCEPT, "Content-Language": AppPref.convertServiceLanguageCode()])
        request.responseData(completionHandler: { response in
            self.hideHUD()
            
            let successResult = WSAPI.successResult(response.response)
            if successResult {
                NotificationCenter.default.post(name: .PURCHASE_CHANGE, object: nil)
                self.popToShopViewController()
            } else {
                Alert.show(self, data: response.data)
            }
        })
    }
    
    func popToShopViewController() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: ApplePay
    func payWithApplepay(_ trade_no: String, fee: String) {
        //PKPaymentButton//自带样式按钮
        //判断是否支持苹果支付
        if !PKPaymentAuthorizationViewController.canMakePayments() {
            Alert.show(self, message: "this device can't support apple payment.".localizedString())
            return
        }

        var paystring: [String]
        //目前判断 visa卡 MasterCard  银联卡 （银联卡 iOS9.2开始支持）
        if #available(iOS 9.2, *) {
            paystring = [PKPaymentNetwork.visa.rawValue,PKPaymentNetwork.chinaUnionPay.rawValue,PKPaymentNetwork.masterCard.rawValue]
        } else {
            Alert.show(self, message: "you have not possible bank card.".localizedString())
            return
        }
        
        if !PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paystring as! [PKPaymentNetwork]) {
            Alert.show(self, message: "you have not possible bank card.".localizedString())
            return
        }
        
        //可打开卡包
        //        let pk = PKPassLibrary()
        //        if #available(iOS 8.3, *) {
        //            pk.openPaymentSetup()
        //        }
        
        //创建一个支付请求
        let request = PKPaymentRequest()
        //配置支付请求
        //配置商家id
        request.merchantIdentifier = AppInfo.merchantID
        //配置货币代码 以及国家代码（中国的）
        request.currencyCode = "CNY"
        request.countryCode = "CN"
        
        //配置请求支持的支付网络，支持的卡片
        request.supportedNetworks = paystring as! [PKPaymentNetwork]
        
        //配置商户处理方式
        request.merchantCapabilities = PKMerchantCapability.capabilityEMV
 
        //配置购买商品的列表
        let price = NSDecimalNumber.init(string: fee)
        let item = PKPaymentSummaryItem.init(label: "AppGo", amount: price)
        //        let item1:PKPaymentSummaryItem = PKPaymentSummaryItem.init(label: "商品名称", amount: price1, type: PKPaymentSummaryItemType.Final)
       
        request.paymentSummaryItems = [item]
        
        //是否显示发票收货地址 显示哪些选项
        request.requiredBillingAddressFields = PKAddressField()
        //是否显示快递地址 显示哪些选项
        request.requiredShippingAddressFields = PKAddressField()

        //添加一些附加数据
        request.applicationData = trade_no.data(using: String.Encoding.utf8)
        
        //验证用户的支付授权
        let paymentAuthorizationVC = PKPaymentAuthorizationViewController.init(paymentRequest: request)
        paymentAuthorizationVC.delegate = self
        self.present(paymentAuthorizationVC, animated: true, completion: nil)
        
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        print("\(payment.token)")
        completion(.success)
    }
}
