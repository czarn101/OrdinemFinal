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
        self.facebookLogin()
        // ...
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
        let loginButtonFrame: CGRect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100)
        self.fbLoginButton = FBSDKLoginButton.init(frame: loginButtonFrame)
        //(0.1836266259*self.view.frame.width)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        //code
        //self.appDelegate.fbLoginButton = self.fbLoginButton
        
        self.fbLoginButton!.readPermissions = ["public_profile", "email", "user_friends"]
        self.fbLoginButton!.delegate = self
        
        let tempConst: NSLayoutConstraint = NSLayoutConstraint(item: self.fbLoginButton!, attribute: .height, relatedBy: .equal, toItem: self.fbLoginButton, attribute: .height, multiplier: 0, constant: 50)
        
        self.fbLoginButton?.addConstraint(tempConst)
        
        if (FBSDKAccessToken.current() != nil) {
            self.facebookLogin()
        }
        //loginButton.center = CGPoint(x: self.view.center.x, y: (self.view.center.y/2.0))
        //loginButton.
        //self.view.addSubview(loginButton)
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //code
    }
}
