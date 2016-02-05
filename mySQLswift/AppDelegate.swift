//
//  AppDelegate.swift
//  mySQLswift
//
//  Created by Peter Balsamo on 12/8/15.
//  Copyright © 2015 Peter Balsamo. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import ParseFacebookUtilsV4

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var backgroundSessionCompletionHandler: (() -> Void)?
    var window: UIWindow?
    var defaults = NSUserDefaults.standardUserDefaults()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // MARK: - Settings
        
        var itemDefaults = Dictionary<String,AnyObject>()
        itemDefaults["soundKey"] = false
        itemDefaults["parsedataKey"] = true
        itemDefaults["autolockKey"] = false
        itemDefaults["fetchKey"] = false
        itemDefaults["usernameKey"] = "Peter Balsamo"
        itemDefaults["passwordKey"] = "3911"
        itemDefaults["emailtitleKey"] = "mySQL"
        itemDefaults["emailmessageKey"] = "Program in Swift"

        
        defaults.registerDefaults(itemDefaults)
        defaults.synchronize()
        
        // MARK: - Parse
        
        if (defaults.boolForKey("parsedataKey"))  {
            
        Parse.setApplicationId("lMUWcnNfBE2HcaGb2zhgfcTgDLKifbyi6dgmEK3M", clientKey: "UVyAQYRpcfZdkCa5Jzoza5fTIPdELFChJ7TVbSeX")
        
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
            
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
            
        }

        // MARK: - prevent Autolock
        
        if (defaults.boolForKey("autolockKey"))  {
            UIApplication.sharedApplication().idleTimerDisabled = true
        }
        

        // MARK: - RegisterUserNotification
        
        let mySettings = UIUserNotificationSettings(forTypes: [.Badge, .Sound, .Alert], categories: nil);
        UIApplication.sharedApplication().registerUserNotificationSettings( mySettings)
        
        application.applicationIconBadgeNumber = 0
        
        
        // MARK: - Background Fetch
        
        //if (defaults.boolForKey("fetchKey"))  {
        
            UIApplication.sharedApplication().setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
       // }
        
        // MARK: - ApplicationIconBadgeNumber
        
        let notification = launchOptions?[UIApplicationLaunchOptionsLocalNotificationKey] as! UILocalNotification!
        if (notification != nil) {
            notification.applicationIconBadgeNumber = 0
        }
        
        
        // MARK: - Register login
        // FIXME:
        if ((defaults.boolForKey("registerKey")) || (defaults.boolForKey("loginKey"))) {
        //if (defaults.valueForKey("registerKey") == nil) || (defaults.valueForKey("loginKey") != nil) {
        //if PFUser.currentUser() == nil{
            
            // show main screen
            let storyboard :UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let LoginScreen = storyboard.instantiateViewControllerWithIdentifier("loginViewController")
            UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(LoginScreen, animated: true, completion: nil)
            
        } else {
            
            //show login screen
            let storyboard :UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let MainScreenNavigation = storyboard.instantiateViewControllerWithIdentifier("MasterViewController")
            UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(MainScreenNavigation, animated: true, completion: nil)
            
        }
        
        
        // MARK: - SplitViewController
        /*
        // Override point for customization after application launch.
        let splitViewController = self.window!.rootViewController as! UISplitViewController
        let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
        navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
        splitViewController.delegate = self */
        
        
        customizeAppearance()
        
        return true
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        
        application.applicationIconBadgeNumber = 0
        
    }

    
    // MARK: - Background Fetch
    
    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        //if (defaults.boolForKey("fetchKey")) {
        //if (defaults.valueForKey("fetchKey") != nil)  {
            print("########### Received Background Fetch ###########");
            
            let localNotification: UILocalNotification = UILocalNotification()
            localNotification.alertAction = "Background transfer service download!"
            localNotification.alertBody = "Background transfer service: Download complete!"
            localNotification.soundName = UILocalNotificationDefaultSoundName
            localNotification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
            UIApplication.sharedApplication().presentLocalNotificationNow(localNotification)
            
            completionHandler(UIBackgroundFetchResult.NewData)
       // }
    }
    
    // MARK: - Facebook
    
    func application(application: UIApplication, url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
            return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
     // MARK: - Music Controller
    
    func application(application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: () -> Void) {
        backgroundSessionCompletionHandler = completionHandler
    }
    
    // MARK:

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    // MARK: - Facebook

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        FBSDKAppEvents.activateApp()
    }
    
    // MARK:

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: - Split view

    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:UIViewController, ontoPrimaryViewController primaryViewController:UIViewController) -> Bool {
        
        /*
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? SnapshotController else { return false }
        
        if topAsDetailController.detailItem == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        } */
        
        return false
    }
    
    // MARK - App Theme Customization
    
    private func customizeAppearance() {
        
        //UIApplication.sharedApplication().networkActivityIndicatorVisible = true //Activity Status Bar
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        UINavigationBar.appearance().barTintColor = UIColor.blackColor()
        UINavigationBar.appearance().tintColor = UIColor.grayColor()
        UINavigationBar.appearance().translucent = false
        
        UITabBar.appearance().barTintColor = UIColor.blackColor()
        UITabBar.appearance().tintColor = UIColor.whiteColor()
        UITabBar.appearance().translucent = false
        
        UIToolbar.appearance().barTintColor = UIColor(white:0.45, alpha:1.0)
        UIToolbar.appearance().tintColor = UIColor.whiteColor()
        
        UISearchBar.appearance().barTintColor = UIColor.blackColor()
        UISearchBar.appearance().tintColor = UIColor.whiteColor()
        UITextField.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self]).tintColor = UIColor.grayColor()
    }
    
    

}

// MARK: CLLocationManagerDelegate - Beacons
extension AppDelegate: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        if let _ = region as? CLBeaconRegion {
            let notification = UILocalNotification()
            notification.alertBody = "Are you forgetting something?"
            notification.soundName = "Default"
            UIApplication.sharedApplication().presentLocalNotificationNow(notification)
        }
    }
}

