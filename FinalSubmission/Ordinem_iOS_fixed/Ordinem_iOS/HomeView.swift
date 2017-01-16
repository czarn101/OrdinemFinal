//
//  HomeView.swift
//  Ordinem_iOS
//
//  Created by Shevis Johnson on 12/12/16.
//  Copyright © 2016 Ordinem. All rights reserved.
//

import Foundation
import UIKit

class HomeView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var pointLabel: UILabel?
    @IBOutlet var nameLabel: UILabel?
    @IBOutlet var tableView: UITableView?
    
    @IBAction func logout(sender: UIButton) {
        self.performSegue(withIdentifier: "logout", sender: self)
    }
    
    private var source: NSArray?
    
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let dbc: DatabaseConnector = DatabaseConnector()
    
    func loadContents(events: NSArray) {
        print("Data recieved")
        print(events)
        source = events
        tableView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appDelegate.homeView = self
        pointLabel?.text = appDelegate.pointBalance
        nameLabel?.text = "Welcome, "+appDelegate.username!+"!"
        dbc.getEvents()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //code
        tableView.deselectRow(at: indexPath, animated: false)
        self.appDelegate.selectedEvent = self.source?[indexPath.row] as? NSArray
        self.performSegue(withIdentifier: "detail", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.source != nil {
            return (self.source?.count)!
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.source != nil {
            let cell: EventCell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as! EventCell
            cell.eventName?.text = (self.source?[indexPath.row] as! NSArray)[1] as? String
            //cell.eventDescription?.text = (self.source?[indexPath.row] as! NSArray)[2] as? String
            //cell.eventID = source?[indexPath.row][2] as? String
            cell.orgName?.text = (self.source?[indexPath.row] as! NSArray)[3] as? String
            //cell.eventDate?.text = (self.source?[indexPath.row] as! NSArray)[4] as? String
            cell.eventTime?.text = (self.source?[indexPath.row] as! NSArray)[5] as? String
            return cell
        } else {
            let cell: UITableViewCell = UITableViewCell()
            cell.textLabel?.text = "Loading..."
            cell.textLabel?.textAlignment = .center
            return cell
        }
    }
    
    @IBAction func backHome(segue: UIStoryboardSegue) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let destination: LoginView = segue.destination as? LoginView {
            destination.logout()
        }
        //code
    }
}
