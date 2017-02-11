//
//  AutoLoginView.swift
//  Ordinem_iOS
//
//  Created by Shevis Johnson on 12/12/16.
//  Copyright © 2016 Ordinem. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FBSDKLoginKit

class AutoLoginView: UIViewController {
    
    @IBOutlet var activityMon: UIActivityIndicatorView?
    @IBOutlet var internetLabel: UILabel?
    
    private let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    private let dbc: DatabaseConnector = DatabaseConnector()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityMon?.startAnimating()
        internetLabel?.alpha = 0
        appDelegate.autoLogin = self
        if appDelegate.isInternetAvailable() {
            self.checkLoginData()
        } else {
            alert(message: "Please connect to the internet to use this app.", title: "No Network Detected")
            activityMon?.stopAnimating()
            internetLabel?.alpha = 1
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginSuccess(email: String, password: String) {
        print("login success")
        //appDelegate.setLoginState(state: true, email: email, password: password)
        self.performSegue(withIdentifier: "autoLogin", sender: self)
    }
    
    func loginFailure() {
        print("login failure")
        self.performSegue(withIdentifier: "manualLogin", sender: self)
    }
    
    func checkLoginData() {
        let loggedIn: Bool = PlistManager.sharedInstance.getValueForKey(key: "LoggedIn") as! Bool
        if FBSDKAccessToken.current() != nil {
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            FIRAuth.auth()?.signIn(with: credential) { (user, error2) in
                // ...
                if error2 != nil {
                    // ...
                    print(error2!.localizedDescription)
                    return
                }
                print("successfully logged in with facebook")
                self.appDelegate.mainUser = user!
                self.performSegue(withIdentifier: "autoLogin", sender: self)
            }
        } else if loggedIn {
            let email = PlistManager.sharedInstance.getValueForKey(key: "Email") as! String
            let password = PlistManager.sharedInstance.getValueForKey(key: "Password") as! String
            FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error2) in
                // ...
                if error2 != nil {
                    // ...
                    print(error2!.localizedDescription)
                    return
                }
                print("successfully logged in with email")
                self.appDelegate.mainUser = user!
                self.performSegue(withIdentifier: "autoLogin", sender: self)
            }
        } else {
            self.performSegue(withIdentifier: "manualLogin", sender: self)
        }

    }
    
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
