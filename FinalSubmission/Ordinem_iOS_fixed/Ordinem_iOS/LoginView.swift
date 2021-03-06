//
//  ViewController.swift
//  Ordinem_iOS
//
//  Created by Shevis Johnson on 12/11/16.
//  Copyright © 2016 Ordinem. All rights reserved.
//

import UIKit

class LoginView: UIViewController, UITextFieldDelegate {
    
    //LOGIN PAGE
    
    @IBOutlet var emailStr: UILabel?
    @IBOutlet var passStr: UILabel?
    @IBOutlet var emailField: UITextField?
    @IBOutlet var passField: UITextField?
    @IBOutlet var loginButton: UIButton?
    @IBOutlet var createButton: UIButton?
    @IBOutlet var tapView: UIView?
    @IBOutlet var loadingMon: UIActivityIndicatorView?
    //@IBOutlet var accountType: UISwitch?
    @IBOutlet var accountTitle: UILabel?
    
    let dbc: DatabaseConnector = DatabaseConnector()
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBAction func login() {
        if checkFields() {
            loadingMon?.isHidden = false
            loadingMon?.startAnimating()
            //dbc.userLogin(email: (emailField?.text)!, password: (passField?.text)!)
            appDelegate.username = "Demo"
            loginSuccess()
        } else {
            print("Incorrect Username/Password")
        }
    }
    
    @IBAction func toggleAccountType(sender: UISwitch) {
        if sender.isOn {
            accountTitle?.text = "Student Login Portal"
            appDelegate.isOrg = false
        } else {
            accountTitle?.text = "Organization Login Portal"
            appDelegate.isOrg = true
        }
    }
    
    func loginSuccess() {
        print("Success")
        loadingMon?.isHidden = true
        loadingMon?.stopAnimating()
        performSegue(withIdentifier: "login", sender: self)
    }
    
    func loginFailure() {
        print("Failure")
        loadingMon?.isHidden = true
        loadingMon?.stopAnimating()
        emailStr?.text = "Email* (Invalid)"
        passStr?.text = "Password* (Invalid)"
    }
    


    
    func checkFields() -> Bool {
        if (emailField?.text?.isEmpty)! {
            emailStr?.text = "Email* (Required)"
            return false
        } else if (passField?.text?.isEmpty)! {
            passStr?.text = "Password* (Required)"
            return false
        } else if !(isValidEmail(testStr: (emailField?.text)!)) {
            emailStr?.text = "Email* (Invalid)"
            return false
        } else {
            return true
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }

    func doneClicked(){
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let toolBar = UIToolbar()
        
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        
        emailField!.inputAccessoryView = toolBar
        passField!.inputAccessoryView = toolBar
        
        
        
        appDelegate.loginView = self
        loadingMon?.isHidden = true
        tapView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func dismissKeyboard() {
        emailField?.resignFirstResponder()
        passField?.resignFirstResponder()
    }
    
    func logout() {
        appDelegate.setLoginState(state: false, email: nil, password: nil)
        self.loadingMon?.hidesWhenStopped = true
        self.loadingMon?.stopAnimating()
        self.emailField?.text = ""
        self.passField?.text = ""
    }
    
    @IBAction func backToLogging(segue: UIStoryboardSegue) {
        
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField{
            passField!.becomeFirstResponder()
        }
        else{
            passField!.resignFirstResponder()
        }
        return true
        }


}

