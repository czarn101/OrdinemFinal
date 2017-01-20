//
//  HomeView.swift
//  Ordinem_iOS
//
//  Created by Shevis Johnson on 12/12/16.
//  Copyright © 2016 Ordinem. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class HomeView: UIViewController, UITableViewDelegate, UITableViewDataSource, QRCodeReaderViewControllerDelegate {
    
    @IBOutlet var pointLabel: UILabel?
    @IBOutlet var nameLabel: UILabel?
    @IBOutlet var tableView: UITableView?
    

    
    private var source: NSArray?
    
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let dbc: DatabaseConnector = DatabaseConnector()
    
    func loadContents(events: NSArray) {
        print("Data recieved")
        print(events)
        source = events
        tableView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appDelegate.homeView = self
        pointLabel?.text = appDelegate.pointBalance
        nameLabel?.text = "Welcome, "+appDelegate.username!+"!"
        dbc.getEvents()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //code
        tableView.deselectRow(at: indexPath, animated: false)
        self.appDelegate.selectedEvent = self.source?[indexPath.row] as? NSArray
        self.performSegue(withIdentifier: "detail", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.source != nil {
            return (self.source?.count)!
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.source != nil {
            let cell: EventCell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as! EventCell
            cell.eventName?.text = (self.source?[indexPath.row] as! NSArray)[1] as? String
            //cell.eventDescription?.text = (self.source?[indexPath.row] as! NSArray)[2] as? String
            //cell.eventID = source?[indexPath.row][2] as? String
            cell.orgName?.text = (self.source?[indexPath.row] as! NSArray)[3] as? String
            //cell.eventDate?.text = (self.source?[indexPath.row] as! NSArray)[4] as? String
            cell.eventTime?.text = (self.source?[indexPath.row] as! NSArray)[4] as? String
            return cell
        } else {
            let cell: UITableViewCell = UITableViewCell()
            cell.textLabel?.text = "Loading..."
            cell.textLabel?.textAlignment = .center
            return cell
        }
    }
    
    @IBAction func backHome(segue: UIStoryboardSegue) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let destination: LoginView = segue.destination as? LoginView {
            destination.logout()
        }
        //code
    }
    
    // Good practice: create the reader lazily to avoid cpu overload during the
    // initialization and each time we need to scan a QRCode
    public lazy var readerVC = QRCodeReaderViewController(builder: QRCodeReaderViewControllerBuilder {
        $0.reader = QRCodeReader(metadataObjectTypes: [AVMetadataObjectTypeQRCode], captureDevicePosition: .back)
    })
    
    @IBAction func scanAction(_ sender: AnyObject) {
        // Retrieve the QRCode content
        // By using the delegate pattern
        readerVC.delegate = self
        
        // Or by using the closure pattern
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            print(result!)
        }
        
        // Presents the readerVC as modal form sheet
        readerVC.modalPresentationStyle = .formSheet
        present(readerVC, animated: true, completion: nil)
    }
    
    // MARK: - QRCodeReaderViewController Delegate Methods
    
    public func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }
    
    //This is an optional delegate method, that allows you to be notified when the user switches the cameraName
    //By pressing on the switch camera button
    public func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        if let cameraName = newCaptureDevice.device.localizedName {
            print("Switching capturing to: \(cameraName)")
        }
    }
    
    public func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }

    
}
