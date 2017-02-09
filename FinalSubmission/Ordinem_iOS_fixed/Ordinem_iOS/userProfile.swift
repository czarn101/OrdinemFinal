//
//  userProfile.swift
//  Ordinem_iOS
//
//  Created by Drew Thomas on 2/9/17.
//  Copyright © 2017 Ordinem. All rights reserved.
//

import UIKit

class userProfile: UIViewController, UITabBarDelegate {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var firstAndLast: UILabel!
    
    
    @IBOutlet weak var orgButtonItem: UITabBarItem!
    @IBOutlet weak var rewardButtonItem: UITabBarItem!
    
    @IBOutlet weak var profileButtonItem: UITabBarItem!
    


    func handleButts(){
        if rewardButtonItem.isEnabled{
            performSegue(withIdentifier: "rewardView", sender: self)
        }
        else if orgButtonItem.isEnabled{
            performSegue(withIdentifier: "rewardView", sender: self)
        }
        
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
