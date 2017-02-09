//
//  ProfileView.swift
//  Ordinem_iOS
//
//  Created by Shevis Johnson on 2/8/17.
//  Copyright © 2017 Ordinem. All rights reserved.
//

import Foundation
import UIKit

class ProfileView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var name: UILabel?
    @IBOutlet var profPic: UIImageView?
    @IBOutlet var pointLabel: UILabel?
    
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        name?.text = appDelegate.username
        //code
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //code
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //code
        tableView.deselectRow(at: indexPath, animated: false)
        //self.appDelegate.selectedEvent = self.source?[indexPath.row] as? NSArray
        //self.performSegue(withIdentifier: "detail", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return events.count
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell()
        return cell
    }
    
}
