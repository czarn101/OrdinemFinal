//
//  eventTemp.swift
//  Ordinem_iOS
//
//  Created by Drew Thomas on 1/18/17.
//  Copyright © 2017 Ordinem. All rights reserved.
//

import UIKit

class eventTemp: UIViewController,
    UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UITextViewDelegate {

    
    @IBOutlet weak var date: UITextField!
    let datePicker = UIDatePicker()
    
    @IBOutlet weak var eDate: UITextField!
    
    
    @IBOutlet weak var location: UITextField!
    
    @IBOutlet weak var eventTitle: UITextField!
    
    @IBOutlet weak var eventType: UITextField!
    
    @IBOutlet weak var additionalInfo: UITextView!
    
    @IBOutlet weak var theScrollView: UIScrollView!
    
    
    @IBOutlet weak var stepper: UIStepper!
    
    @IBOutlet weak var label4Stepper: UILabel!
    
    @IBAction func stepperPressed(_ sender: UIStepper) {
        let currentValue = Int(stepper.value)
        label4Stepper.text = String(currentValue)
        
    }
    
    @IBOutlet weak var imagePicked: UIImageView!
    
    @IBAction func buttonPressed(_ sender: UIButton) {
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
        
    var list = ["Competitive", "Career Development", "Conference", "Educational", "Promotional", "Fundraising", "Other"]
    var picker1 = UIPickerView()

    @available(iOS 2.0, *)
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    @available(iOS 2.0, *)
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
            return list.count

    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        eventType.text = list[row]
        
        
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return list[row]
    }
    

    
    
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
        super.viewDidLoad()
        
        picker1.delegate = self
        picker1.dataSource = self
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let toolBar = UIToolbar()
        
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        
        
        date.inputAccessoryView = toolBar
        eDate.inputAccessoryView = toolBar
        location.inputAccessoryView = toolBar
        eventTitle.inputAccessoryView = toolBar
        eventType.inputAccessoryView = toolBar
        additionalInfo.inputAccessoryView = toolBar

        date.delegate = self
        eDate.delegate = self
        location.delegate = self
        eventTitle.delegate = self
        eventType.delegate = self
        additionalInfo.delegate = self


        // Do any additional setup after loading the view.
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == date!{
            eDate!.becomeFirstResponder()
        }
        else if textField == eDate!{
            location!.becomeFirstResponder()
        }
        else if textField == location!{
            eventTitle!.becomeFirstResponder()
        }
        else if textField == eventTitle!{
            eventType!.becomeFirstResponder()
        }
        else if textField == eventType!{
            additionalInfo!.becomeFirstResponder()
        }
        else{
            additionalInfo!.resignFirstResponder()
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
