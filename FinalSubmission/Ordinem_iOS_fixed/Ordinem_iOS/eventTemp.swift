//
//  eventTemp.swift
//  Ordinem_iOS
//
//  Created by Drew Thomas on 1/18/17.
//  Copyright © 2017 Ordinem. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage


class eventTemp: UIViewController,
    UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UITextViewDelegate {

    
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let dbc: DatabaseConnector = DatabaseConnector()
    
    
    @IBAction func complete(_ sender: UIButton) {
        handleSet()
    }
    
    func handleSet(){
        if checkFields(){
            self.appDelegate.mainUser = FIRAuth.auth()!.currentUser

            let cUser = self.appDelegate.mainUser
            
            var profileImageUrl = ""
            
            //IMAGE INFORMATION
            let imageName = NSUUID().uuidString
            let storageRef = FIRStorage.storage().reference().child("profile_Image").child("\(imageName).png")
            
            if let uploadData = UIImagePNGRepresentation(self.imagePicked.image!){
                storageRef.put(uploadData, metadata: nil, completion: {
                    (metadata, error) in
                    if error != nil{
                        print(error.debugDescription)
                        return
                    }
                    else{
                        profileImageUrl = (metadata?.downloadURL()?.absoluteString)!
                    }
                    
                })
            }

            self.dbc.addEvent(user: cUser!, eventTitle: eventTitle!.text!, startDate: date!.text!, startTime: timeOfEvent, endDate: eDate!.text!, location: location!.text!, eventType: eventType!.text!, additionalInfo: additionalInfo!.text!, eventImage: profileImageUrl, ptsForAttending: Int(stepper.value), verified: false)
        }
    }
    
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
    
    var timeOfEvent = ""
    
    func donePressed(){
        
        
        picker1.delegate = self
        picker1.dataSource = self
        
        //Formatting
        //Date will always be referenced at the start- cannot exceed past midnight
        if date.endEditing(true){
        let dateFormatter = DateFormatter()
        let timeFormatter = DateFormatter()
    
        dateFormatter.dateStyle = .long
        timeFormatter.timeStyle = .medium
        
        date.text = dateFormatter.string(from: datePicker.date)
        timeOfEvent = timeFormatter.string(from: datePicker.date)
        }
        else{
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .none
            dateFormatter.timeStyle = .medium
            
            eDate.text = dateFormatter.string(from: datePickerr.date)
            self.view.endEditing(true)
        }

    }
    

    @IBAction func createEvent(segue: UIStoryboardSegue) {
        
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
    
    
    func checkFields() -> Bool {
        if "" == self.eventTitle.text {
            let alert = UIAlertController(title: "Alert", message: "Please Enter Event Title", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        else if "" == self.eventType.text {
            let alert = UIAlertController(title: "Alert", message: "Please Select Event Type", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        else if "" == self.date.text {
            let alert = UIAlertController(title: "Alert", message: "Please Enter Start Time", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        else if "" == self.eDate.text {
            let alert = UIAlertController(title: "Alert", message: "Please Enter the End Time", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        else if "" == self.location.text {
            let alert = UIAlertController(title: "Alert", message: "Please Enter The Location of the Event", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        } else {
            return true
        }
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
