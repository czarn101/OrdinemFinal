//
//  DetailView.swift
//  Ordinem_iOS
//
//  Created by Shevis Johnson on 12/14/16.
//  Copyright © 2016 Ordinem. All rights reserved.
//

import Foundation
import UIKit

public class DetailView: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet var eventTitle: UILabel?
    @IBOutlet var eventDescription: UITextView?
    @IBOutlet var hostName: UILabel?
    @IBOutlet var eventDateTime: UILabel?
    @IBOutlet var location: UILabel?
    @IBOutlet var points: UILabel?
    @IBOutlet var qr_code: UIImageView?
    
    private var appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.eventTitle?.text = self.appDelegate.selectedEvent![1] as? String
        self.eventDescription?.text = self.appDelegate.selectedEvent![2] as? String
        self.hostName?.text = self.appDelegate.selectedEvent![3] as? String
        self.eventDateTime?.text = (self.appDelegate.selectedEvent![4] as! String) + " " + (self.appDelegate.selectedEvent![5] as! String)
        self.location?.text = self.appDelegate.selectedEvent![6] as? String
        self.points?.text = self.appDelegate.selectedEvent![7] as? String
        if self.appDelegate.isOrg! {
            let qrCode = QRCode(eventTitle!.text!)
            qr_code?.image = qrCode!.image!
            qr_code?.alpha = 1
        }
        //code
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //code
    }
}
