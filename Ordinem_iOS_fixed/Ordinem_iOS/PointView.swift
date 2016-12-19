//
//  PointView.swift
//  Ordinem_iOS
//
//  Created by Shevis Johnson on 12/18/16.
//  Copyright © 2016 Ordinem. All rights reserved.
//

import Foundation
import UIKit

public class PointView: UIViewController {
    
    @IBOutlet var pointBal: UILabel?
    
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.pointBal?.text = appDelegate.pointBalance
        //code
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //code
    }
}
