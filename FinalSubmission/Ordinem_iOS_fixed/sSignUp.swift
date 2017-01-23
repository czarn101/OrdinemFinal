//
//  sSignUp.swift
//  Ordinem_iOS
//
//  Created by Drew Thomas on 1/20/17.
//  Copyright © 2017 Ordinem. All rights reserved.
//

import UIKit

class sSignUp: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate  {
    
    @IBOutlet weak var fName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var studentID: UITextField!
    @IBOutlet weak var school: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var verifyPwd: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var imagePicked: UIImageView!
    
    
    @IBAction func openPhotoLibraryButton(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)

        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        imagePicked.image = image
        self.dismiss(animated: true, completion: nil);
    }
    
    
    
    func keyboardWillShow(notification:NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.scrollView.contentInset = contentInset
    }

    func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        
        self.scrollView.contentInset = contentInset
    }
    
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
        
        
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return list[row]
    }
    

    
    func doneClicked(){
        view.endEditing(true)
    }
    
    var list = ["Chapman"]
    var picker1 = UIPickerView()
    
    var types = ["Academic/Professional", "Civic Engagement","Diversity/ Cultural","Greek","Honor Society","Sport", "Leisure", "Recreational","Religious/Spiritual"]
    
    var picker2 = UIPickerView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker1.tag = 0
        picker2.tag = 1
        
        picker1.delegate = self
        picker1.dataSource = self
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let toolBar = UIToolbar()
        
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)

        school.inputView = picker1
        // Do any additional setup after loading the view.
        
        fName.inputAccessoryView = toolBar
        lastName.inputAccessoryView = toolBar
        studentID.inputAccessoryView = toolBar
        school.inputAccessoryView = toolBar
        email.inputAccessoryView = toolBar
        password.inputAccessoryView = toolBar
        verifyPwd.inputAccessoryView = toolBar
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        fName.delegate = self
        lastName.delegate = self
        studentID.delegate = self
        school.delegate = self
        email.delegate = self
        password.delegate = self
        verifyPwd.delegate = self
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.fName{
            self.lastName!.becomeFirstResponder()
        }
        else if textField == self.lastName{
            self.studentID!.becomeFirstResponder()
        }
        else if textField == self.studentID{
            self.school!.becomeFirstResponder()
        }
        else if textField == self.school{
            self.email!.becomeFirstResponder()
        }
        else if textField == self.email{
            self.password!.becomeFirstResponder()
        }
        else if textField == self.password{
            self.verifyPwd!.becomeFirstResponder()
        }
        else{
            self.verifyPwd!.resignFirstResponder()
        }
        return true
    }
}
