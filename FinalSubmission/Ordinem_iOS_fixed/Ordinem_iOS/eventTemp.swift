//
//  eventTemp.swift
//  Ordinem_iOS
//
//  Created by Drew Thomas on 1/18/17.
//  Copyright © 2017 Ordinem. All rights reserved.
//

import UIKit

class eventTemp: UIViewController {

    
    @IBOutlet weak var date: UITextField!
    let datePicker = UIDatePicker()
    
    
    @IBOutlet weak var eDate: UITextField!
    
    
    @IBOutlet weak var location: UITextField!
    
    @IBOutlet weak var eventTitle: UITextField!
    
    @IBOutlet weak var eventType: UITextField!
    
    @IBOutlet weak var additionalInfo: UITextView!
    
    @IBOutlet weak var theScrollView: UIScrollView!
    
    
    func keyboardWillShow(notification:NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.theScrollView.contentInset
        
        
        contentInset.bottom = keyboardFrame.size.height
        self.theScrollView.contentInset = contentInset
        
        
    }
    
    
    func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.theScrollView.contentInset = contentInset
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
    
    
    func createDatePicker(){
        let toolBar1 = UIToolbar()
        toolBar1.sizeToFit()
        
        let toolBar2 = UIToolbar()
        toolBar2.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: date, action: #selector(donePressed))
        
        let doneButton2 = UIBarButtonItem(barButtonSystemItem: .done, target: eDate, action: #selector(donePressedd))
        
        toolBar1.setItems([doneButton], animated: false)
        toolBar2.setItems([doneButton2], animated: false)
        
        
        date.inputAccessoryView = toolBar1
        
        date.inputView = datePicker
        
        
        eDate.inputAccessoryView = toolBar2
            
        eDate.inputView = datePicker
        
    }
    
    
    func donePressed(){
        date.text = "\(datePicker.date)"
        self.view.endEditing(true)
    }
    func donePressedd(){
        date.text = "\(datePicker.date)"
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let toolBar = UIToolbar()
        
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        
        location.inputAccessoryView = toolBar
        eventTitle.inputAccessoryView = toolBar
        eventType.inputAccessoryView = toolBar
        additionalInfo.inputAccessoryView = toolBar

        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == date{
            eDate.becomeFirstResponder()
        }
        else if textField == eDate{
            location.becomeFirstResponder()
        }
        else if textField == location{
            eventTitle.becomeFirstResponder()
        }
        else if textField == eventTitle{
            eventType.becomeFirstResponder()
        }
        else if textField == eventType{
            additionalInfo.becomeFirstResponder()
        }
        else{
            additionalInfo.resignFirstResponder()
        }
        return true
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
