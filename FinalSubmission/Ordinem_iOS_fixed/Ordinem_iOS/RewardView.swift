//
//  RewardView.swift
//  Ordinem_iOS
//
//  Created by Shevis Johnson on 1/18/17.
//  Copyright © 2017 Ordinem. All rights reserved.
//

import Foundation
import UIKit

public class RewardView: UIViewController {
    
    
    
    @IBOutlet weak var prizeName: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var label4Slider: UILabel!
    
    var c = ""
    var r = ""
    
    @IBAction func actionSlider(_ sender: UISlider) {
        
        let currentValue = Int(slider.value)
        let current = currentValue/10
        let rounded = (round(Double(current/100))*100)
        label4Slider.text = "\(currentValue) pts = $\(Double(rounded))"
        
        c = String(currentValue)
        r = String(rounded)
    }
    

    
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
        points.text = c
        result.text = r
        
        
        
        
        
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //code
    }
}
