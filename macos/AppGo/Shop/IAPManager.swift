//
//  IAPManager.swift
//  AppGo
//
//  Created by administrator on 13/12/2018.
//  Copyright © 2018 AppGo. All rights reserved.
//

import StoreKit

public typealias ProductIdentifier = String

class IAPManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    static let shared = IAPManager()
    
    var productsRequest: SKProductsRequest?
    var refreshReceiptRequeset: SKReceiptRefreshRequest?
    var requestProductsCompletionHandler: (([SKProduct]) -> Void)?
    var purchaseProductCompletionHandler: ((Bool, SKPaymentTransaction) -> Void)?
    var refreshReceiptCompletionHandler: ((Bool) -> Void)?
    
    func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    func startObserving() {
        SKPaymentQueue.default().add(self)
    }
    
    func stopObserving() {
        SKPaymentQueue.default().remove(self)
    }
    
    func requestProducts(productIdentifiers: Set<ProductIdentifier>, completion: @escaping ([SKProduct]) -> Void ) {
        requestProductsCompletionHandler = completion
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest?.delegate = self
        productsRequest?.start()
    }
    
    func purchaseProduct(product: SKProduct, completion: @escaping (Bool, SKPaymentTransaction) -> Void) {
        purchaseProductCompletionHandler = completion
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    // In most cases, all your app needs to do is refresh its receipt and deliver the products in its receipt. The refreshed receipt contains a record of the user’s purchases in this app, on this device or any other device. (https://developer.apple.com/library/content/documentation/NetworkingInternet/Conceptual/StoreKitGuide/Chapters/Restoring.html)
    
    func refreshReceipt(completion: @escaping (Bool) -> Void) {
        refreshReceiptCompletionHandler = completion
        refreshReceiptRequeset = SKReceiptRefreshRequest()
        refreshReceiptRequeset?.delegate = self
        refreshReceiptRequeset?.start()
    }
    
    //MARK - SKProductsRequestDelegate
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if response.products.count > 0 {
            let products = response.products
            requestProductsCompletionHandler?(products)
        }
    }
    
    //MARK - SKPaymentTransactionObserver
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch (transaction.transactionState) {
            case .purchased:
                complete(transaction: transaction)
                break
            case .failed:
                fail(transaction: transaction)
                break
            case .restored:
                restore(transaction: transaction)
                break
            case .deferred:
                break
            case .purchasing:
                break
            }
        }
    }
    
    //MARK - SKRequestDelegate
    
    func requestDidFinish(_ request: SKRequest) {
        refreshReceiptCompletionHandler?(true)
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        refreshReceiptCompletionHandler?(false)
    }
    
    private func complete(transaction: SKPaymentTransaction) {
        print("complete...")
        SKPaymentQueue.default().finishTransaction(transaction)
        purchaseProductCompletionHandler?(true, transaction)
    }
    
    private func restore(transaction: SKPaymentTransaction) {
        guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
        
        print("restore... \(productIdentifier)")
        SKPaymentQueue.default().finishTransaction(transaction)
        purchaseProductCompletionHandler?(true, transaction)
    }
    
    private func fail(transaction: SKPaymentTransaction) {
        print("fail...")
        if let transactionError = transaction.error as NSError? {
            if transactionError.code != SKError.paymentCancelled.rawValue {
                print("Transaction Error: \(String(describing: transaction.error?.localizedDescription))")
            }
        }
        SKPaymentQueue.default().finishTransaction(transaction)
        purchaseProductCompletionHandler?(false, transaction)
    }
}
