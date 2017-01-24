//
//  Settings.swift
//  Ordinem_iOS
//
//  Created by Drew Thomas on 1/24/17.
//  Copyright © 2017 Ordinem. All rights reserved.
//

import UIKit

class Settings: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    //NOT WORKING?!?
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Add Event", for: indexPath as IndexPath)
        cell.textLabel?.text = myarray[indexPath.item]
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myarray.count
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    let myarray = ["Add Event", "Manage Events", "Change Profile Image", "Log Out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
