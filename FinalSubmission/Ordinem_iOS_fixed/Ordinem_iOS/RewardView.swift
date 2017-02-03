//
//  RewardView.swift
//  Ordinem_iOS
//
//  Created by Shevis Johnson on 1/18/17.
//  Copyright © 2017 Ordinem. All rights reserved.
//

import Foundation
import UIKit

extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}



public class RewardView: UIViewController {
    
    
    
    @IBOutlet weak var prizeName: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var label4Slider: UILabel!
    
    
    
    var c = ""
    var r = ""
    
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
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
    
    
    
    
    func getPrizeInfo(){
        rewardName = prizeName
        
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()


    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //code
    }
}
