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

    
    
    @IBOutlet weak var buyButton: UIButton!
    
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        print("Card number: \(textField.cardParams.number) Exp Month: \(textField.cardParams.expMonth) Exp Year: \(textField.cardParams.expYear) CVC: \(textField.cardParams.cvc)")
        self.buyButton.isEnabled = textField.isValid
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let paymentField = STPPaymentCardTextField(frame: CGRect(x: 30, y: 100, width:300, height: 44))
        paymentField.delegate = self
        self.view.addSubview(paymentField)

        
        
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
