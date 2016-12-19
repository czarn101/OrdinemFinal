//
//  EventCell.swift
//  Ordinem_iOS
//
//  Created by Shevis Johnson on 12/12/16.
//  Copyright © 2016 Ordinem. All rights reserved.
//

import Foundation
import UIKit

public class EventCell: UITableViewCell {
    @IBOutlet var eventName: UILabel?
    @IBOutlet var orgName: UILabel?
    @IBOutlet var eventDescription: UILabel?
    @IBOutlet var eventTime: UILabel?
    @IBOutlet var eventDate: UILabel?
    
    public var eventID: Int?
    public var orgID: Int?
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        //initialization code
    }
}
