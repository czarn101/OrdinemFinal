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
    @IBOutlet var eventTime: UILabel?
    
    private var appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    @IBAction func backToDetails(segue: UIStoryboardSegue) {
        
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.eventTitle?.text = self.appDelegate.selectedEvent!["eventTitle"] as? String
        self.eventDescription?.text = self.appDelegate.selectedEvent!["additionalInfo"] as? String
        self.hostName?.text = self.appDelegate.selectedEvent!["orgName"] as? String
        self.eventDateTime?.text = self.appDelegate.selectedEvent!["startDate"] as? String
        self.eventTime?.text = (self.appDelegate.selectedEvent!["startTime"] as! String) + " - " + (self.appDelegate.selectedEvent!["endDate"] as! String)
        self.location?.text = self.appDelegate.selectedEvent!["location"] as? String
        self.points?.text = self.appDelegate.selectedEvent!["ptsForAttending"] as? String
        self.image.image = UIImage(data: NSData(contentsOf: URL(string: self.appDelegate.selectedEvent!["picURL"] as! String)!) as! Data)
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
