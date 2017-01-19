//
//  SignUp.swift
//  Ordinem_iOS
//
//  Created by Drew Thomas on 1/18/17.
//  Copyright © 2017 Ordinem. All rights reserved.
//

import UIKit

class SignUp: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var fName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var studentID: UITextField!
    @IBOutlet weak var school: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var verifyPwd: UITextField!
    
    
    @IBOutlet weak var orgName: UITextField!
    @IBOutlet weak var orgType: UITextField!
    @IBOutlet weak var orgID: UITextField!
    @IBOutlet weak var skewl: UITextField!
    @IBOutlet weak var sEmail: UITextField!
    @IBOutlet weak var sPassword: UITextField!
    @IBOutlet weak var vPassword: UITextField!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    
    @IBOutlet weak var theScrollView: UIScrollView!
    
    func keyboardWillShow(notification:NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.theScrollView.contentInset
        var contentInset2:UIEdgeInsets = self.scrollView.contentInset

        contentInset.bottom = keyboardFrame.size.height
        self.theScrollView.contentInset = contentInset
        contentInset2.bottom = keyboardFrame.size.height
        self.scrollView.contentInset = contentInset2
    }
    
    func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.theScrollView.contentInset = contentInset
        self.scrollView.contentInset = contentInset
    }
    
    
    var list = ["Chapman"]
    var picker1 = UIPickerView()
    
    var types = ["Academic/Professional", "Civic Engagement","Diversity/ Cultural","Greek","Honor Society","Sport", "Leisure", "Recreational","Religious/Spiritual"]
    
    var picker2 = UIPickerView()
    
    
    @available(iOS 2.0, *)
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    
    @available(iOS 2.0, *)
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if pickerView.tag == 0{
            return list.count
        }
        else{
            return types.count
        }
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        school.text = list[row]
        skewl.text = list[row]
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return list[row]
    }
    
    
    func closekeyboard() {
        self.view.endEditing(true)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        closekeyboard()
    }
    
    func doneClicked(){
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker1.tag = 0
        picker2.tag = 1
        
        picker1.delegate = self
        picker1.dataSource = self
        school.inputView = picker1
        skewl.inputView = picker1
        
        picker2.delegate = self
        picker2.dataSource = self
        orgType.inputView = picker2
        
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let toolBar = UIToolbar()
        
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        
        fName.inputAccessoryView = toolBar
        lastName.inputAccessoryView = toolBar
        studentID.inputAccessoryView = toolBar
        school.inputAccessoryView = toolBar
        email.inputAccessoryView = toolBar
        password.inputAccessoryView = toolBar
        verifyPwd.inputAccessoryView = toolBar

        
        orgName.inputAccessoryView = toolBar
        orgType.inputAccessoryView = toolBar
        orgID.inputAccessoryView = toolBar
        skewl.inputAccessoryView = toolBar
        sEmail.inputAccessoryView = toolBar
        sPassword.inputAccessoryView = toolBar
        vPassword.inputAccessoryView = toolBar
        


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == fName{
            lastName.becomeFirstResponder()
        }
        else if textField == lastName{
            studentID.becomeFirstResponder()
        }
        else if textField == studentID{
            school.becomeFirstResponder()
        }
        else if textField == school{
            email.becomeFirstResponder()
        }
        else if textField == email{
            password.becomeFirstResponder()
        }
        else if textField == password{
            verifyPwd.becomeFirstResponder()
        }
        else{
            verifyPwd.resignFirstResponder()
        }
        
        if textField == orgName{
            orgType.becomeFirstResponder()
        }
        else if textField == orgType{
            orgID.becomeFirstResponder()
        }
        else if textField == orgID{
            skewl.becomeFirstResponder()
        }
        else if textField == skewl{
            sEmail.becomeFirstResponder()
        }
        else if textField == sEmail{
            sPassword.becomeFirstResponder()
        }
        else if textField == sPassword{
            vPassword.becomeFirstResponder()
        }
        else{
            vPassword.resignFirstResponder()
        }
        return true
    }

}
