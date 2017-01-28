//
//  orgDetails.swift
//  Ordinem_iOS
//
//  Created by Drew Thomas on 1/27/17.
//  Copyright © 2017 Ordinem. All rights reserved.
//

import UIKit

class orgDetails: UIViewController {

    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var orgName: UILabel!
    
    @IBOutlet weak var orgType: UILabel!
    
    @IBOutlet weak var firstAndLast: UILabel!
    
    @IBOutlet weak var email: UILabel!
    
    @IBOutlet weak var studentID: UILabel!
    
    @IBAction func accepted(_ sender: UIButton) {
    }
    

    @IBAction func rejected(_ sender: UIButton) {
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
