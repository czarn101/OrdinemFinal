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



public class RewardView: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let cellID = "cellID"
    
    var rewards = [Reward]()
    
    private var source: NSArray?
    
    
    
    @IBOutlet weak var prizeName: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var label4Slider: UILabel!
    
    
    @IBOutlet weak var rewardButtonItem: UITabBarItem!
    
    @IBOutlet weak var orgButtonItem: UITabBarItem!
    
    @IBOutlet weak var profileButtonItem: UITabBarItem!
    
    
    
    
    func handleButts(){
        if profileButtonItem.isEnabled{
            performSegue(withIdentifier: "profileSegue", sender: self)
        }
        else if orgButtonItem.isEnabled{
            performSegue(withIdentifier: "rewardView", sender: self)
        }
        
    }
    
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
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let reward = Reward()
                reward.setValuesForKeys(dictionary)
                self.rewards.append(reward)
                
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
        return rewards.count
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.source != nil {
            let cell: RewardCell = tableView.dequeueReusableCell(withIdentifier: "RewardCell") as! RewardCell
            return cell
        } else {
            
            let cell: RewardCell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as! RewardCell
            
            let reward = rewards[indexPath.row]
            cell.rewardName?.text = reward.rewardTitle
            cell.rewardType?.text = reward.raffleVWin
            cell.amountLeft?.text = "\(reward.prizeAmount)"
            cell.costForReward?.text = "\(reward.pointCost)"
            
            cell.rewardImage?.layer.cornerRadius = 33
            cell.rewardImage?.layer.masksToBounds = true
            //need reward image
            
            if let profileImageUrl = reward.eventImage{
                let url = URL(string: profileImageUrl)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                    if error != nil{
                        print(error!)
                        return
                    }
                    DispatchQueue.main.async {
                        cell.rewardImage?.image = UIImage(data: data!)
                    }
                }).resume()
                
            }
            cell.textLabel?.textAlignment = .center
            return cell
        }
    }
    

    
    
}
