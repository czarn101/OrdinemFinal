//
//  AppDelegate.swift
//  Ordinem_iOS
//
//  Created by Shevis Johnson on 12/11/16.
//  Copyright © 2016 Ordinem. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import FBSDKLoginKit
import Stripe
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var autoLogin: AutoLoginView?
    var loginView: LoginView?
    var homeView: HomeView?
    
    var rewardView: RewardView?
    

    var username: String?
    var pointBalance: String?
    
    var selectedEvent: NSArray?
    var selectedReward: NSArray?
    
    var shouldAutoLogin: Bool = true

    var mainUser: FIRUser?
    var ref: FIRDatabaseReference?
    var storage: FIRStorageReference?
    var isOrg: Bool?
    
    var fbLoginManager: FBSDKLoginManager?
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        PlistManager.sharedInstance.startPlistManager()
        
        FIRApp.configure()
        ref = FIRDatabase.database().reference()
        storage = FIRStorage.storage().reference()
        isOrg = false
        //test publishKey
        STPPaymentConfiguration.shared().publishableKey = "pk_test_5lzFaXyZ9a32h55v8Ar3pc5T"
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let handled: Bool = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        return handled
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func setLoginState(state: Bool, email: String?, password: String?) {
        PlistManager.sharedInstance.saveValue(value: state as AnyObject, forKey: "LoggedIn")
        if state {
            PlistManager.sharedInstance.saveValue(value: email! as AnyObject, forKey: "Email")
            PlistManager.sharedInstance.saveValue(value: password! as AnyObject, forKey: "Password")
            //print("Values saved")
        } else {
            PlistManager.sharedInstance.saveValue(value: "" as AnyObject, forKey: "Email")
            PlistManager.sharedInstance.saveValue(value: "" as AnyObject, forKey: "Password")
        }
    }
    
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
}

