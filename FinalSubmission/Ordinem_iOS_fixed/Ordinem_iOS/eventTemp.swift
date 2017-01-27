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
    
    
    @IBOutlet weak var eDate: UITextField!
    
    
    @IBOutlet weak var location: UITextField!
    
    @IBOutlet weak var eventTitle: UITextField!
    
    @IBOutlet weak var eventType: UITextField!
    
    @IBOutlet weak var additionalInfo: UITextField!
    
    
    
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
        
    var list = ["Competitive", "Career Development", "Conference", "Educational","Entertainment", "Promotional", "Fundraising", "Other"]
    
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
    

    
    let datePicker = UIDatePicker()
    let datePickerr = UIDatePicker()
    
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
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        datePickerr.datePickerMode = .time

        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        
        toolBar.setItems([doneButton], animated: false)

     
        date.inputAccessoryView = toolBar
        
        date.inputView = datePicker
       
        eDate.inputAccessoryView = toolBar
            
        eDate.inputView = datePickerr
        
    }
    
    
    func donePressed(){
        
        
        picker1.delegate = self
        picker1.dataSource = self
        
        //Formatting
        if date.endEditing(true){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .medium
        
        date.text = dateFormatter.string(from: datePicker.date)
        }
        else{
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .none
            dateFormatter.timeStyle = .medium
            
            eDate.text = dateFormatter.string(from: datePickerr.date)
            self.view.endEditing(true)
        }

    }
    

    @IBAction func backHome(segue: UIStoryboardSegue) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker1.delegate = self
        picker1.dataSource = self
        
        eventType.inputView = picker1
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let toolBar = UIToolbar()
        
        toolBar.sizeToFit()
        
        createDatePicker()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        
        

        location.inputAccessoryView = toolBar
        eventTitle.inputAccessoryView = toolBar
        eventType.inputAccessoryView = toolBar
        additionalInfo.inputAccessoryView = toolBar

        
        location.delegate = self
        eventTitle.delegate = self
        additionalInfo.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)

        // Do any additional setup after loading the view.
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == eventTitle!{
            date!.becomeFirstResponder()
        }
        else if textField == date!{
            eDate!.becomeFirstResponder()
        }
        else if textField == eDate!{
            location!.becomeFirstResponder()
        }
        else if textField == location!{
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
