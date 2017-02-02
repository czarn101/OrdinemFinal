//
//  newReward.swift
//  Ordinem_iOS
//
//  Created by Drew Thomas on 1/22/17.
//  Copyright © 2017 Ordinem. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class newReward: UIViewController,
    UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate  {

    
    @IBOutlet weak var imagePicked: UIImageView!
    
    @IBOutlet weak var awardTitle: UITextField!
    @IBOutlet weak var costInPts: UITextField!
    @IBOutlet weak var closureDate: UITextField!
    @IBOutlet weak var pickupLocation: UITextField!
    @IBOutlet weak var totalPrizes: UITextField!
    @IBOutlet weak var winOrRaffle: UITextField!
    
    @IBOutlet weak var addInfo: UITextView!
    
    @IBOutlet weak var theScrollView: UIScrollView!
    
    @IBAction func complete(_ sender: UIButton) {
        if checkFields(){
            handleSet()
        }
    }
    
    func handleSet(){
        let ref = FIRDatabase.database().reference().child("Rewards")
        let childRef = ref.childByAutoId()
        let values = ["Title":awardTitle, "Point Cost":costInPts,"End Date":closureDate, "Location":pickupLocation, "Prize Number  Offered":totalPrizes,"Win vs Raffle": winOrRaffle, "Additional Info":addInfo, "Verified":false] as [String : Any]
        childRef.updateChildValues(values)
    }
    
    @IBAction func openCameraButton(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    


    @IBAction func newReward(segue: UIStoryboardSegue) {
        
    }
    
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
        
        var contentInset:UIEdgeInsets = self.theScrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.theScrollView.contentInset = contentInset
    }
    
    var list = ["Auto-win", "Raffle"]
    var picker1 = UIPickerView()

    @available(iOS 2.0, *)
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    
    @available(iOS 2.0, *)
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return list.count
        
    }
    
    @IBAction func backHome(segue: UIStoryboardSegue) {
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        winOrRaffle.text = list[row]
        
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

    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
         
            return list[row]

    }

    func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.theScrollView.contentInset = contentInset
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        picker1.delegate = self
        picker1.dataSource = self
        
        winOrRaffle.inputView = picker1
        
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let toolBar = UIToolbar()
        
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        awardTitle.inputAccessoryView = toolBar
        costInPts.inputAccessoryView = toolBar
        closureDate.inputAccessoryView = toolBar
        pickupLocation.inputAccessoryView = toolBar
        totalPrizes.inputAccessoryView = toolBar
        winOrRaffle.inputAccessoryView = toolBar
        


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == awardTitle{
            costInPts.becomeFirstResponder()
        }
        else if textField == costInPts{
            closureDate.becomeFirstResponder()
        }
        else if textField == closureDate{
            pickupLocation.becomeFirstResponder()
        }
        else if textField == pickupLocation{
            totalPrizes.becomeFirstResponder()
        }
        else if textField == totalPrizes{
            winOrRaffle.becomeFirstResponder()
        }
        else if textField == winOrRaffle{
            addInfo.becomeFirstResponder()
        }
        else{
            addInfo.resignFirstResponder()
        }
        
        
        return true
    }

    func checkFields() -> Bool {
        if "" == self.awardTitle.text {
            let alert = UIAlertController(title: "Alert", message: "Please Enter Reward Title", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        else if "" == self.costInPts.text {
            let alert = UIAlertController(title: "Alert", message: "Please Cost in Points", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        else if "" == self.closureDate.text {
            let alert = UIAlertController(title: "Alert", message: "Please Enter Closure Date", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        else if "" == self.pickupLocation.text {
            let alert = UIAlertController(title: "Alert", message: "Please Enter Pickup Location", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        else if "" == self.totalPrizes.text {
            let alert = UIAlertController(title: "Alert", message: "Please Enter The Total Prizes Offered", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        else if "" == self.winOrRaffle.text {
            let alert = UIAlertController(title: "Alert", message: "Please Select Win or Raffle", preferredStyle: UIAlertControllerStyle.alert)
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
