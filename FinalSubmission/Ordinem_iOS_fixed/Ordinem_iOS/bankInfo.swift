//
//  bankInfo.swift
//  Ordinem_iOS
//
//  Created by Drew Thomas on 1/30/17.
//  Copyright © 2017 Ordinem. All rights reserved.
//

import UIKit
import Stripe



class bankInfo: UIViewController, STPPaymentCardTextFieldDelegate {

 
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var cardNumberTextField: UITextField!
    
    @IBOutlet weak var expireDateTextField: UITextField!
    
    @IBOutlet weak var cvcTextField: UITextField!
    
    @IBAction func donate(sender: AnyObject) {
        
        // Initiate the card
        
        let cardParams = STPCardParams()
        // Split the expiration date to extract Month & Year
        if self.expireDateTextField.text?.isEmpty == false {
            let expirationDate = self.expireDateTextField.text?.components(separatedBy: "/")
            let expMonth = UInt((expirationDate?[0])!)
            let expYear = UInt((expirationDate?[1])!)
            

            // Send the card info to Strip to get the token
            cardParams.number = self.cardNumberTextField.text
            cardParams.cvc = self.cvcTextField.text
            cardParams.expMonth = expMonth!
            cardParams.expYear = expYear!
            
        }

        var underlyingError: NSError?
        if underlyingError != nil {
            self.spinner.stopAnimating()
            self.handleError(error: underlyingError!)
            return
        }

        STPAPIClient.shared().createToken(withCard: cardParams, completion: { (token, error) -> Void in
            
            if error != nil {
                self.handleError(error: error! as NSError)
                return
            } 
            
            self.postStripeToken(token: token!)
        })
    }
    
    @IBOutlet weak var amountTextField: UITextField!
    func postStripeToken(token: STPToken) {
        
        let URL = "http://localhost/donate/payment.php"
        let params = ["stripeToken": token.tokenId,
                      "amount": Int(self.amountTextField.text!)!,
                      "currency": "usd",
                      "description": self.amountTextField.text!] as [String : Any]
        
        let manager = AFHTTPRequestOperationManager()
        manager.POST(URL, parameters: params, success: { (operation, responseObject) -> Void in
            
            if let response = responseObject as? [String: String] {
                UIAlertView(title: response["status"],
                            message: response["message"],
                            delegate: nil,
                            cancelButtonTitle: "OK").show()
            }
            
        }) { (operation, error) -> Void in
            self.handleError(error!)
        }
    }


    func handleError(error: NSError) {
        UIAlertView(title: "Please Try Again",
                    message: error.localizedDescription,
                    delegate: nil,
                    cancelButtonTitle: "OK").show()
        
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
