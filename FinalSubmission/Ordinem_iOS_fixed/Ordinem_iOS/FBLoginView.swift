//
//  FBLoginView.swift
//  Ordinem_iOS
//
//  Created by Shevis Johnson on 2/1/17.
//  Copyright © 2017 Ordinem. All rights reserved.
//

import Foundation
import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

public class FBLoginView: UIViewController, FBSDKLoginButtonDelegate {
    /**
     Sent to the delegate when the button was used to logout.
     - Parameter loginButton: The button that was clicked.
     */
    
    @IBOutlet var fbLoginButton: FBSDKLoginButton?
    
    public func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        //do nothing
    }

    
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBAction func backToFBLogin(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func goToSignup(_ sender: Any) {
        self.performSegue(withIdentifier: "toSignup", sender: self)
    }
    
    func toLogin() {
        self.performSegue(withIdentifier: "fbLogin", sender: self)
    }
    
    public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        FIRAuth.auth()?.signIn(with: credential) { (user, error2) in
            // ...
            if error2 != nil {
                // ...
                print(error2!.localizedDescription)
                return
            }
            print("successfully created new account")
            self.appDelegate.mainUser = user!
            self.appDelegate.username = "FB User"
            self.appDelegate.pointBalance = "0"
            self.toLogin()
        }
        // ...
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        //code
        self.fbLoginButton = FBSDKLoginButton()
        self.fbLoginButton!.readPermissions = ["public_profile", "email", "user_friends"]
        self.fbLoginButton!.delegate = self
        //loginButton.center = CGPoint(x: self.view.center.x, y: (self.view.center.y/2.0))
        //loginButton.
        //self.view.addSubview(loginButton)
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //code
    }
}
