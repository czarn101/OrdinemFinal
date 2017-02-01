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

public class DatabaseConnector {
    
    var data : NSMutableData = NSMutableData()
    var dict: NSMutableDictionary = NSMutableDictionary()

    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func addUser(user: FIRUser, fname: String, lname: String, id: String, school: String) {
        self.appDelegate.ref?.child("users").child(user.uid).setValue(["fname": fname,
                                                                       "lname": lname,
                                                                       "studentID": id,
                                                                       "school": school,
                                                                       "pointBalance": 0])
    }
    
    func addOrg(user: FIRUser, orgName: String, orgType: String, id: String, school: String) {
        self.appDelegate.ref?.child("orgs").child(user.uid).setValue(["orgName": orgName,
                                                                       "orgType": orgType,
                                                                       "schoolID": id,
                                                                       "school": school
                                                                       ])

    }
    func addReward(user: FIRUser, awardTitle: String, pointCost: Int, closeDate: String, pickupLocation: String, prizeAmount: Int, raffleVWin: String, addInfo: String, verified: Bool) {
        self.appDelegate.ref?.child("awards").child(user.uid).setValue(["awardTitle": awardTitle,
                                                                       "pointCost": pointCost,
                                                                       "closeDate": closeDate,
                                                                       "pickupLocation": pickupLocation,
                                                                       "prizeAmount": prizeAmount,
                                                                       "raffleVWin":raffleVWin, "addInfo" : addInfo,
                                                                       "verified": verified
            ])
        
    }
    
    func addEvent(user: FIRUser, eventTitle: String, startDate: Date, endDate: Date, location: String, eventType: String, additionalInfo: String, ptsForAttending: Int, verified: Bool) {
        self.appDelegate.ref?.child("awards").child(user.uid).setValue(["eventTitle": eventTitle,
                                                                        "startDate": startDate,
                                                                        "endDate": endDate,
                                                                        "location": location,
                                                                        "eventType": eventType,
                                                                        "additionalInfo":additionalInfo, "ptsForAttending" : ptsForAttending,
                                                                        "verified": verified
            ])
        
    }
    
    
    func getEvents() {
        let myUrl = URL(string: "http://ordinem.ddns.net/api.php/events")!
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
