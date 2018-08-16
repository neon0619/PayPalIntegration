//
//  ViewController.swift
//  PayPal Test
//
//  Created by Siva Ganesh on 14/09/15.
//  Copyright (c) 2015 Siva Ganesh. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PayPalPaymentDelegate {

    // For PayPal integration, we need to follow these steps
    // 1. Add Paypal config. in AppDelegate
    // 2. Create PayPal object
    // 3. Declare payment configurations
    // 4. Implement PayPalPaymentDelegate
    // 5. Add payment items and related details
    
    
    var payPalConfig = PayPalConfiguration()
    
    var environment:String = PayPalEnvironmentSandbox {
        willSet(newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
    }
    
    var acceptCreditCards: Bool = true {
        didSet {
            payPalConfig.acceptCreditCards = acceptCreditCards
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        payPalConfig.acceptCreditCards = acceptCreditCards
        payPalConfig.merchantName = "Totep Industries"
        payPalConfig.merchantPrivacyPolicyURL = NSURL(string: "https://www.sivaganesh.com/privacy.html")! as URL
        payPalConfig.merchantUserAgreementURL = NSURL(string: "https://www.sivaganesh.com/useragreement.html")! as URL
        payPalConfig.languageOrLocale = NSLocale.preferredLanguages[0]
        payPalConfig.payPalShippingAddressOption = .payPal
        
        PayPalMobile.preconnect(withEnvironment: environment)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    // PayPalPaymentDelegate
    
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController!) {
        print("PayPal Payment Cancelled")
        paymentViewController?.dismiss(animated: true, completion: nil)
    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController!, didComplete completedPayment: PayPalPayment!) {
        
        print("PayPal Payment Success !")
        paymentViewController?.dismiss(animated: true, completion: { () -> Void in
            // send completed confirmaion to your server
            print("Here is your proof of payment:\n\n\(completedPayment.confirmation!)\n\nSend this to your server for confirmation and fulfillment.")
        })
    }

    
    @IBAction func payPressed(_ sender: Any) {
        
        // Process Payment once the pay button is clicked.
        
        let item1 = PayPalItem(name: "Siva Ganesh Test Item", withQuantity: 1, withPrice: NSDecimalNumber(string: "50.00"), withCurrency: "USD", withSku: "SivaGanesh-0001")
        
        
        let items: Array = [item1]
        let subtotal = PayPalItem.totalPrice(forItems: items)
        
        
        // Optional: include payment details
        let shipping = NSDecimalNumber(string: "0.00")
        let tax = NSDecimalNumber(string: "0.00")
        let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: shipping, withTax: tax)


        let total = subtotal?.adding(shipping).adding(tax)

        let payment = PayPalPayment(amount: total, currencyCode: "USD", shortDescription: "FanzPlay Game Details", intent: .sale)
        

        payment?.items = items
        payment?.paymentDetails = paymentDetails
        
        print("PSymntrytesddf == \(String(describing: paymentDetails))")
    

        if (payment?.processable)! {

            let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
            present(paymentViewController!, animated: true, completion: nil)

            print("Processable TRUE")
        }
        else {

            print("Payment not processalbe: \(String(describing: payment))")
        }
        
    }
    
}

