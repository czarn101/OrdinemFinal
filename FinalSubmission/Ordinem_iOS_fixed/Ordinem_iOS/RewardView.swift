//
//  RewardView.swift
//  Ordinem_iOS
//
//  Created by Shevis Johnson on 1/18/17.
//  Copyright © 2017 Ordinem. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage

extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}



public class RewardView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    private var source: NSArray?
    
    
    
    @IBOutlet weak var prizeName: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var label4Slider: UILabel!
    
    
    
    var c = ""
    var r = ""
    
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let dbc: DatabaseConnector = DatabaseConnector()

    
    @IBAction func cashout(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func actionSlider(_ sender: UISlider) {
        
        
        
        let currentValue = Int(slider.value)
        let value = Double(currentValue)
        let current = Double(value/10).roundTo(places: 2)
        let v = (String(format:"%.02f", current))
        label4Slider.text = "\(currentValue) pts = $\(v)"
        
        c = String(currentValue)
        r = String(current)
    }
    
    

    @IBOutlet weak var theScrollView: UIScrollView!
    
    @IBOutlet weak var rewardName: UILabel!
    
    @IBOutlet weak var rewardType: UILabel!
    
    @IBOutlet weak var points: UILabel!
    
    @IBOutlet weak var result: UILabel!
    
    @IBOutlet weak var password: UITextField!
    
    
    @IBAction func checkClick(_ sender: UIButton) {
        getPrizeInfo()
    }
    
    func loadContents(events: NSArray) {
        print("Data recieved")
        print(events)
        source = events
        tableView?.reloadData()
    }
    
    
    
    func getPrizeInfo(){
        rewardName = prizeName
        
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.appDelegate.rewardView = self
        //NEED EQUIVALENT OF DBC.GETEVENTS
        //dbc.getEvents()
        
        fetchUser()


    }
    
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //code
    }
    
    
    func fetchUser(){
        FIRDatabase.database().reference().child("Chapman").child("Admin").observe(.childAdded, with: { (snapshot) in
            
            if (snapshot.value as? [String: AnyObject]) != nil{

                
                //Unsure about what the code right below does.. Just told I should do this
                //Just something to look at if it's something that'll cause trouble when running
                
                DispatchQueue.main.async {
                    self.tableView?.reloadData()
                }
            }
            
            
            
        }, withCancel: nil)
        
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //code
        tableView.deselectRow(at: indexPath, animated: false)
        self.appDelegate.selectedReward = self.source?[indexPath.row] as? NSArray
        self.performSegue(withIdentifier: "detail", sender: self)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RewardCell = tableView.dequeueReusableCell(withIdentifier: "RewardCell") as! RewardCell

        if self.source != nil {
            let cell: RewardCell = tableView.dequeueReusableCell(withIdentifier: "RewardCell") as! RewardCell
            return cell
        } else {
            
            let cell: RewardCell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as! RewardCell
            
            cell.rewardImage?.layer.cornerRadius = 33
            cell.rewardImage?.layer.masksToBounds = true
            //need reward image
            
            }
            return cell
    }
    }
    


