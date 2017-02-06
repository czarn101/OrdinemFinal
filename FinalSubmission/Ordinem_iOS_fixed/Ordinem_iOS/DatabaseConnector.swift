//
//  DatabaseConnector.swift
//  Ordinem_iOS
//
//  Created by Shevis Johnson on 12/11/16.
//  Copyright © 2016 Ordinem. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

public class DatabaseConnector {
    
    var data : NSMutableData = NSMutableData()
    var dict: NSMutableDictionary = NSMutableDictionary()

    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func addUser(user: FIRUser, fname: String, lname: String, id: String, school: String, profileImage: String) {
        
        self.appDelegate.ref?.child("Chapman").child("Users").child(user.uid).setValue(["fname": fname,
                                                                       "lname": lname,
                                                                       "studentID": id,
                                                                       "school": school,
                                                                       "pointBalance": 0, "profileImage": profileImage])
    }
    
    func addOrg(user: FIRUser, orgName: String, orgType: String, id: String, school: String, profileImage: String) {
        

        self.appDelegate.ref?.child("Chapman").child("Organizations").child(user.uid).setValue(["orgName": orgName,
                                                                       "orgType": orgType,
                                                                       "schoolID": id,
                                                                       "school": school,
                                                                       "profileImage": profileImage
                                                                       ])

    }
    func addReward(user: FIRUser, rewardTitle: String,  pointCost: Int, closeDate: String, pickupLocation: String, prizeAmount: Int, raffleVWin: String, eventImage: String, addInfo: String, verified: Bool) {
        
        let cUser = FIRAuth.auth()!.currentUser
        
        
        //CUSER MAY OR MAY OR MAY NOT BE WRONG
        self.appDelegate.ref?.child("Chapman").child("rewards").child("\(cUser)").setValue(["rewardTitle": rewardTitle,
                                                                                            
                                                                       "pointCost": pointCost,
                                                                       "closeDate": closeDate,
                                                                       "pickupLocation": pickupLocation,
                                                                       "prizeAmount": prizeAmount,
                                                                       "raffleVWin":raffleVWin, "addInfo" : addInfo,
                                                                       "verified": verified
            ])
        
    }
    
    func addEvent(user: FIRUser, eventTitle: String, startDate: String, startTime: String, endDate: String, location: String, eventType: String, additionalInfo: String, eventImage: String, ptsForAttending: Int, verified: Bool) {
        

        let cUser = FIRAuth.auth()?.currentUser
        self.appDelegate.ref?.child("Chapman").child("Organizations").child("\(cUser)").child("events").childByAutoId().setValue(["eventTitle": eventTitle,
                                                                        "startDate": startDate,
                                                                        "startTime":startTime,
                                                                        "endDate": endDate,
                                                                        "location": location,
                                                                        "eventType": eventType,
                                                                        "additionalInfo":additionalInfo,
                                                                        "ptsForAttending" : ptsForAttending,
                                                                        "verified": verified,
                                                                        "orgID": user.uid
            ])
    }
    
    func getEvents() {
        let myUrl = URL(string: "http://ordinem.ddns.net/api.php/events")!
        let request = NSMutableURLRequest(url:myUrl)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            do {
                
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                if let parseJSON = json{
                    if let students = parseJSON["events"] as? NSDictionary {
                        if let records = students["records"] as? NSArray {
                            
                            if var dataPressed: [[String]] = (records as? [Any]) as? [[String]] {
                                var urlStr: String = "http://ordinem.ddns.net/api.php/organizations/"
                                
                                var added: [String] = []
                                
                                for i in 0...records.count-1 {
                                    let newElement: String = (records[i] as! NSArray)[3] as! String
                                    if added.contains(newElement) != true {
                                        urlStr += ((records[i] as! NSArray)[0] as! String) + ","
                                        added.append(newElement)
                                    }
                                }
                                
                                let oneResult: Bool = (added.count == 1)
                                
                                urlStr.remove(at: urlStr.index(before: urlStr.endIndex))
                                print("url for orgs: \(urlStr)")
                                let myUrl = URL(string: urlStr)!
                                let request = NSMutableURLRequest(url:myUrl);
                                request.httpMethod = "GET";
                                
                                let task2 = URLSession.shared.dataTask(with: request as URLRequest) {
                                    data2, response2, error2 in
                                    
                                    if error2 != nil {
                                        print(error!.localizedDescription)
                                        return
                                    }
                                    
                                    do {
                                        if oneResult {
                                            print("one result")
                                            let json2 = try JSONSerialization.jsonObject(with: data2!, options: .mutableContainers) as? NSDictionary
                                            if let parseJSON2 = json2{
                                                print("and that result is \(parseJSON2["orgName"] as! String)")
                                                for j in 0...records.count-1 {
                                                    dataPressed[j][3] = parseJSON2["orgName"] as! String
                                                }
                                            }
                                        } else {
                                            let json2 = try JSONSerialization.jsonObject(with: data2!, options: .mutableContainers) as? NSArray
                                            if let parseJSON2 = json2{
                                                var orgNames: [String:String] = [:]
                                                for k in 0...parseJSON2.count-1 {
                                                    let orgName: String = (parseJSON2[k] as! NSDictionary)["orgName"] as! String
                                                    let orgID: String = (parseJSON2[k] as! NSDictionary)["orgID"] as! String
                                                    orgNames[orgID] = orgName
                                                }
                                                for j in 0...records.count-1 {
                                                    let orgName: String = orgNames[dataPressed[j][0]]!
                                                    dataPressed[j][3] = orgName
                                                }
                                            }
                                        }
                                        DispatchQueue.main.async {
                                            print("loaded org names")
                                            print(dataPressed[0][0])
                                            self.appDelegate.homeView?.loadContents(events: dataPressed as NSArray)
                                        }
                                    } catch let error as NSError {
                                        print(error.localizedDescription)
                                    }
                                }
                                task2.resume()
                            }
                        } else {
                            print("Error 1")
                        }
                    } else {
                        print("Error 2")
                    }
                } else {
                   print("Error 3")
                    //print(error)
                }
            }
            catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func userLogin(email: String, password: String) {
        
        let myUrl = URL(string: "http://ordinem.ddns.net/api.php/students?filter[]=email,eq,"+email+"&filter[]=password,eq,"+password+"&satisfy=all")!
        let request = NSMutableURLRequest(url:myUrl);
        request.httpMethod = "GET";
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            do {
                
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary 
                
                if let parseJSON = json{
                    if let students = parseJSON["students"] as? NSDictionary {
                        if let records = students["records"] as? NSArray {
                            if records.count > 0 {
                                DispatchQueue.main.async {
                                    self.appDelegate.username = (records[0] as! NSArray)[1] as? String
                                    self.appDelegate.pointBalance = (records[0] as! NSArray)[8] as? String
                                }
                                self.loginSuccess(email: email, password: password)
                            } else {
                                self.loginFailure()
                            }
                        } else {
                            self.loginFailure()
                        }
                    } else {
                        self.loginFailure()
                    }
                } else {
                    self.loginFailure()
                    //print(error)
                }
            }
            catch let error as NSError {
                print(error.localizedDescription)
                self.loginFailure()
            }
        }
        task.resume()
        
    }
    
    func getRewardName() -> String {
        var ret = ""
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("Chapman").child("Organizations").child("rewards").child("\(uid!)").observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject]{
                ret = dictionary["rewardTitle"] as! String
            }
            
        }
            , withCancel: nil)
        return ret
    }
    
    func getRewardPointCost() -> String {
        var ret = ""
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("Chapman").child("Organizations").child("\(uid!)").child("events").observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject]{
                ret = dictionary["pointCost"] as! String
            }
            
        }
            , withCancel: nil)
        return ret
    }
    
    func getRewardPointCloseDate() -> String {
        var ret = ""
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("Chapman").child("Organizations").child("\(uid!)").child("events").observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject]{
                ret = dictionary["closeDate"] as! String
            }
            
        }
            , withCancel: nil)
        return ret
    }
    
    func getRewardPickupLocation() -> String {
        var ret = ""
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("Chapman").child("Organizations").child("\(uid!)").child("events").observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject]{
                ret = dictionary["pickupLocation"] as! String
            }
            
        }
            , withCancel: nil)
        return ret
    }
    
    func getRewardPrizeAmountLocation() -> String {
        var ret = ""
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("Chapman").child("Organizations").child("\(uid!)").child("events").observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject]{
                ret = dictionary["prizeAmount"] as! String
            }
            
        }
            , withCancel: nil)
        return ret
    }
    
    func getRewardraffleVWin() -> String {
        var ret = ""
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("Chapman").child("Organizations").child("\(uid!)").child("events").observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject]{
                ret = dictionary["raffleVWin"] as! String
            }
            
        }
            , withCancel: nil)
        return ret
    }
    
    func getRewardaddInfo() -> String {
        var ret = ""
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("Chapman").child("Organizations").child("\(uid!)").child("events").observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject]{
                ret = dictionary["addInfo"] as! String
            }
            
        }
            , withCancel: nil)
        return ret
    }
    
    
    func getRewardverified() -> String {
        var ret = ""
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("Chapman").child("Organizations").child("\(uid!)").child("events").observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject]{
                ret = dictionary["verified"] as! String
            }
            
        }
            , withCancel: nil)
        return ret
    }
    
    func getEventeventTitle() -> String {
        var ret = ""
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("Chapman").child("Organizations").child("\(uid)").child("events").observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject]{
                ret = dictionary["eventTitle"] as! String
            }
            
        }
            , withCancel: nil)
        return ret
    }
    
    func getEventstartDate() -> String {
        var ret = ""
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("Chapman").child("Organizations").child("\(uid)").child("events").observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject]{
                ret = dictionary["startDate"] as! String
            }
            
        }
            , withCancel: nil)
        return ret
    }
    
    func getEventstartTime() -> String {
        var ret = ""
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("Chapman").child("Organizations").child("\(uid)").child("events").observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject]{
                ret = dictionary["startTime"] as! String
            }
            
        }
            , withCancel: nil)
        return ret
    }
    
    func getEventendDate() -> String {
        var ret = ""
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("Chapman").child("Organizations").child("\(uid)").child("events").observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject]{
                ret = dictionary["endDate"] as! String
            }
            
        }
            , withCancel: nil)
        return ret
    }

    func getEventlocation() -> String {
        var ret = ""
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("Chapman").child("Organizations").child("\(uid)").child("events").observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject]{
                ret = dictionary["location"] as! String
            }
            
        }
            , withCancel: nil)
        return ret
    }
    
    func getEventeventType() -> String {
        var ret = ""
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("Chapman").child("Organizations").child("\(uid)").child("events").observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject]{
                ret = dictionary["eventType"] as! String
            }
            
        }
            , withCancel: nil)
        return ret
    }
    
    func getEventadditionalInfo() -> String {
        var ret = ""
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("Chapman").child("Organizations").child("\(uid)").child("events").observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject]{
                ret = dictionary["additionalInfo"] as! String
            }
            
        }
            , withCancel: nil)
        return ret
    }

    func getEventptsForAttending() -> Int {
        var ret = 0
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("Chapman").child("Organizations").child("\(uid)").child("events").observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject]{
                ret = dictionary["ptsForAttending"] as! Int
            }
            
        }
            , withCancel: nil)
        return ret
    }
    
    func getEventverified() -> Bool {
        var ret = false
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("Chapman").child("Organizations").child("\(uid)").child("events").observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject]{
                ret = dictionary["ptsForAttending"] as! Bool
            }
            
        }
            , withCancel: nil)
        return ret
    }
    
    func getEventorgID() -> Bool {
        var ret = false
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("Chapman").child("Organizations").child("\(uid)").child("events").observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject]{
                ret = dictionary["orgID"] as! Bool
            }
            
        }
            , withCancel: nil)
        return ret
    }
    
    func loginSuccess(email: String, password: String) {
        DispatchQueue.main.async {
            if (self.appDelegate.shouldAutoLogin) {
                print("Auto logging in")
                self.appDelegate.autoLogin?.loginSuccess(email: email, password: password)
            } else {
                print("Manually logging in")
                self.appDelegate.setLoginState(state: true, email: email, password: password)
                self.appDelegate.loginView?.loginSuccess()
            }
        }
    }
    
    
    func loginFailure() {
        DispatchQueue.main.async {
            if (self.appDelegate.shouldAutoLogin) {
                self.appDelegate.autoLogin?.loginFailure()
            } else {
                self.appDelegate.loginView?.loginFailure()
            }
        }
    }
    
}
