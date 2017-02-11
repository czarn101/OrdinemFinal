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

public class FBLoginView: UIViewController {
    /**
     Sent to the delegate when the button was used to logout.
     - Parameter loginButton: The button that was clicked.
     */
    
    @IBOutlet var fbLoginButton: UIButton?

    
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
        self.facebookLogin()
        // ...
    }
    
    @IBAction func loginButtonPressed(sender: UIButton) {
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: self.parent, handler: { (result, error) -> Void in
            if error != nil {
                print(error!.localizedDescription)
            } else if result!.isCancelled {
                print("Cancelled")
            } else {
                self.facebookLogin()
            }
        })
    }
    
    func facebookLogin() {
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
            self.appDelegate.username = user!.displayName
            self.appDelegate.pointBalance = "0"
            self.toLogin()
        }
    }
    
    public override func loadView() {
        super.loadView()
        //(0.1836266259*self.view.frame.width)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        //code
        //self.appDelegate.fbLoginButton = self.fbLoginButton
        //loginButton.center = CGPoint(x: self.view.center.x, y: (self.view.center.y/2.0))
        //loginButton.
        //self.view.addSubview(loginButton)
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //code
    }
}
