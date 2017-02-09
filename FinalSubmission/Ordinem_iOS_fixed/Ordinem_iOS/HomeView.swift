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
import Firebase
import FirebaseStorage

enum selectedScope:Int{
    case event = 0
    case host = 1
    case type = 2
    
    
}

class HomeView: UIViewController, UITableViewDelegate, UITableViewDataSource, QRCodeReaderViewControllerDelegate, UISearchBarDelegate {
    
    @IBOutlet var pointLabel: UILabel?
    @IBOutlet var nameLabel: UILabel?
    @IBOutlet var tableView: UITableView?
    
    
    
    func generateModelArray() -> [Event]{
        let modelAry = [Event]()
        
        return modelAry
        
    }

    let cellID = "cellID"
    
    var events = [Event]()
    
    func searchBarSetup(){
        let searchBar = UISearchBar(frame: CGRect(x:0,y:0,width:(UIScreen.main.bounds.width),height:70))
        searchBar.showsScopeBar = true
        searchBar.scopeButtonTitles = ["Event","Host","Type"]
        searchBar.selectedScopeButtonIndex = 0
        
        searchBar.delegate = self
        self.tableView?.tableHeaderView = searchBar
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        if searchText.isEmpty{
            
        }
        
    }
    
    
    //TODO
    func filterTableView(ind:Int,text:String){
        var x = events
        switch ind {
        case selectedScope.event.rawValue:
            x = x.filter({ (mod) -> Bool in
                return (mod.eventTitle?.contains(text))!
            })
            
        case selectedScope.host.rawValue:
            x = x.filter({ (mod) -> Bool in
                return (mod.orgHost?.contains(text))!
            })
        case selectedScope.type.rawValue:
            x = x.filter({ (mod) -> Bool in
                return (mod.eventType?.contains(text))!
            })

        default:
            print("no type")
        }
    }
    
    public var source: NSArray?
    
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
        loadContents(events: [["11","Test Event","Some random details.", "OGCoder club", "Jan 31st", "7:00 PM-9:00 PM", "My crib", "50"]])
        // Do any additional setup after loading the view, typically from a nib.
        fetchUser()
    }
    
    func fetchUser(){
        FIRDatabase.database().reference().child("Chapman").child("Organizaitons").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let event = Event()
                event.setValuesForKeys(dictionary)
                self.events.append(event)
                
                //Unsure about what the code right below does.. Just told I should do this
                //Just something to look at if it's something that'll cause trouble when running
                
                DispatchQueue.main.async {
                    self.tableView?.reloadData()
                }
            }
            
            
            
        }, withCancel: nil)
        
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
        return events.count
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
            
            let cell: EventCell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as! EventCell
            
            let event = events[indexPath.row]
            cell.eventName?.text = event.eventTitle
            //TODO
            cell.orgName?.text = event.orgHost
            cell.orgPic?.layer.cornerRadius = 33
            cell.orgPic?.layer.masksToBounds = true
            
            cell.eventPoints?.text = "Points: \(event.ptsForAttending)"
            cell.eventTime?.text = "\(event.endDate)-\(event.startTime)"
            
            //IMAGE INFORMATION
            if let profileImageUrl = event.eventImage{
                let url = URL(string: profileImageUrl)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                    if error != nil{
                        print(error!)
                        return
                    }
                    DispatchQueue.main.async {
                        cell.orgPic?.image = UIImage(data: data!)
                    }
                }).resume()

            }
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
