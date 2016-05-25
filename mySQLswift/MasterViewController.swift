//
//  MasterViewController.swift
//  mySQLswift
//
//  Created by Peter Balsamo on 12/8/15.
//  Copyright © 2015 Peter Balsamo. All rights reserved.
//

import UIKit
import Parse
import AVFoundation
//import SwiftKeychainWrapper
//import iAd
//import EventKitUI

class MasterViewController: UITableViewController, UISplitViewControllerDelegate, UISearchResultsUpdating, WeatherGetterDelegate {

  //var detailViewController: DetailViewController? = nil
    
    var menuItems:NSMutableArray = ["Snapshot","Leads","Customers","Vendors","Employee","Advertising","Product","Job","Salesman","Show Detail","Music","YouTube","Spot Beacon","Transmit Beacon","Contacts"]
    var currentItem = "Snapshot"
    
    var player : AVAudioPlayer! = nil
    var photoImage: UIImageView!
    var objects = [AnyObject]()
    
    var searchController: UISearchController!

    var resultsController: UITableViewController!
    var foundUsers = [String]()
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var resultsWeatherYQL:NSDictionary? = nil
    
    var weather: WeatherGetter!
    var tempweather: String!
    var tempDescript: String!
    
    //@IBOutlet weak var cityTextField: UITextField!
    

    //var tempYQL : String!
     //var store = EKEventStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleButton: UIButton = UIButton(frame: CGRectMake(0, 0, 100, 32))
        titleButton.setTitle("Main Menu", forState: UIControlState.Normal)
        titleButton.titleLabel?.font = Font.navlabel
        titleButton.titleLabel?.textAlignment = NSTextAlignment.Center
        titleButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        titleButton.addTarget(self, action: Selector(), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.titleView = titleButton
        
        self.tableView!.backgroundColor = UIColor.blackColor()
        
        foundUsers = []
        resultsController = UITableViewController(style: .Plain)
        resultsController.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "UserFoundCell")
        resultsController.tableView.dataSource = self
        resultsController.tableView.delegate = self
        
        let searchButton = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: #selector(MasterViewController.searchButton))
        let addButton = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: #selector(MasterViewController.actionButton))
        let buttons:NSArray = [addButton, searchButton]
        self.navigationItem.rightBarButtonItems = buttons as? [UIBarButtonItem]
        
        
        // MARK: - SplitView
        
        /*
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        } */

        self.splitViewController?.delegate = self //added
        self.splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.Automatic //added
        
        // MARK: - Sound
        
        if (defaults.boolForKey("soundKey"))  {
            playSound()
        }
        
        // MARK: - iAd
        
        if (defaults.boolForKey("iadKey"))  {
            canDisplayBannerAds = true
        } else {
            canDisplayBannerAds = false
        }
        
        
     // MARK: - Login
 
        let userId:String = defaults.stringForKey("usernameKey")!
        let userpassword:String = defaults.stringForKey("passwordKey")!
        
        //Keychain
        
        //KeychainWrapper.accessGroup = "group.TheLightGroup"
        if KeychainWrapper.setString(userId, forKey: "usernameKey") && KeychainWrapper.setString(userpassword, forKey: "passwordKey") {
            print("Keychain successful")
        } else {
            print("Keychain failed")
        }
        
        
        //Parse
        
        PFUser.logInWithUsernameInBackground(userId, password:userpassword) { (user, error) -> Void in
        }
        
        
        // MARK: - YQL
        
        //self.updateYahoo()
        self.versionCheck()
        
        // MARK: - Weather
        
        weather = WeatherGetter(delegate: self)
        let cityTextField = "Massapequa"
        weather.getWeather(cityTextField)
    
        
    }

    override func viewWillAppear(animated: Bool) {
        //self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        
    }
    
    override class func initialize() {
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            //versionCheck()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - UISplitViewControllerDelegate
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool { //added
        
        return true
    }
    
    
    func didGetWeather(weather: Weather) {
        
        dispatch_async(dispatch_get_main_queue()) {
            
            self.tempweather = "\(Int(round(weather.tempFahrenheit)))" //weather.city
            print(self.tempweather)
            self.tempDescript = weather.weatherDescription
            print(self.tempDescript)
            //self.temperatureLabel.text = "\(Int(round(weather.tempFahrenheit)))°"
            /*self.cloudCoverLabel.text = "\(weather.cloudCover)%"
             self.windLabel.text = "\(weather.windSpeed) m/s"
             
             if let rain = weather.rainfallInLast3Hours {
             self.rainLabel.text = "\(rain) mm"
             }
             else {
             self.rainLabel.text = "None"
             }
             
             self.humidityLabel.text = "\(weather.humidity)%" */
        }
    }
    
    func didNotGetWeather(error: NSError) {
        
         dispatch_async(dispatch_get_main_queue()) {
         self.simpleAlert("Can't get the weather", message: "The weather service isn't responding.")
         }
         print("didNotGetWeather error: \(error)")
    }

    
    // MARK: - Button
    
    func actionButton(sender: AnyObject) {
 
        let alertController = UIAlertController(title:nil, message:nil, preferredStyle: .ActionSheet)
        
        let setting = UIAlertAction(title: "Settings", style: .Default, handler: { (action) -> Void in
            let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
            UIApplication.sharedApplication().openURL(settingsUrl!)
        })
        let buttonTwo = UIAlertAction(title: "Users", style: .Default, handler: { (action) -> Void in
            self.performSegueWithIdentifier("userSegue", sender: self)
        })
        let buttonThree = UIAlertAction(title: "Notification", style: .Default, handler: { (action) -> Void in
            self.performSegueWithIdentifier("notificationSegue", sender: self)
        })
        let buttonFour = UIAlertAction(title: "Membership Card", style: .Default, handler: { (action) -> Void in
            self.performSegueWithIdentifier("codegenSegue", sender: self)
        })
        let buttonSocial = UIAlertAction(title: "Social", style: .Default, handler: { (action) -> Void in
            self.performSegueWithIdentifier("socialSegue", sender: self)
        })
        let buttonFive = UIAlertAction(title: "Logout", style: .Default, handler: { (action) -> Void in
            PFUser.logOut()
            self.performSegueWithIdentifier("showLogin", sender: self)
        })
        let buttonCancel = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
            //print("Cancel Button Pressed")
        }
        
        alertController.addAction(setting)
        alertController.addAction(buttonTwo)
        alertController.addAction(buttonThree)
        alertController.addAction(buttonFour)
        alertController.addAction(buttonSocial)
        alertController.addAction(buttonFive)
        alertController.addAction(buttonCancel)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.barButtonItem = sender as? UIBarButtonItem
        }
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func statButton() {
        
        self.performSegueWithIdentifier("statisticSegue", sender: self)
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.tableView {
            return menuItems.count
        }
        return foundUsers.count
        //return filteredString.count
        
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cellIdentifier: String!
        
        if tableView == self.tableView{
            cellIdentifier = "Cell"
        } else {
            cellIdentifier = "UserFoundCell"
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad {
            
            cell.textLabel!.font = Font.celltitle
            
        } else {
            
            cell.textLabel!.font = Font.celltitle
        }
        
        if (tableView == self.tableView) {
            
            cell.textLabel!.text = menuItems[indexPath.row] as? String
            
        } else {
            
            cell.textLabel!.text = self.foundUsers[indexPath.row]
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Phone {
            return 135.0
        } else {
            return 0.0
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let vw = UIView()
        //vw.backgroundColor = UIColor(red: 0.02, green: 0.36, blue: 0.53, alpha: 1.0)
        tableView.tableHeaderView = vw
        
        photoImage = UIImageView(frame:CGRectMake(0, 0, tableView.tableHeaderView!.frame.size.width, 135))
        photoImage!.image = UIImage(named:"IMG_1133New.jpg")
        photoImage!.clipsToBounds = true
        photoImage!.contentMode = UIViewContentMode.ScaleAspectFill
        vw.addSubview(photoImage!)
        
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
        visualEffectView.frame = photoImage.bounds
        photoImage.addSubview(visualEffectView)

        let myLabel1:UILabel = UILabel(frame: CGRectMake(10, 15, 60, 60))
        myLabel1.numberOfLines = 0
        myLabel1.backgroundColor = UIColor.whiteColor()
        myLabel1.textColor = UIColor.blackColor()
        myLabel1.textAlignment = NSTextAlignment.Center
        myLabel1.layer.masksToBounds = true
        myLabel1.text = String(format: "%@%d", "COUNT\n", menuItems.count)
        myLabel1.font = Font.headtitle
        myLabel1.layer.cornerRadius = 30.0
        myLabel1.userInteractionEnabled = true
        vw.addSubview(myLabel1)
        
        let separatorLineView1 = UIView(frame: CGRectMake(10, 85, 60, 3.5))
        separatorLineView1.backgroundColor = UIColor.greenColor()
        vw.addSubview(separatorLineView1)
        
        let myLabel2:UILabel = UILabel(frame: CGRectMake(85, 15, 60, 60))
        myLabel2.numberOfLines = 0
        myLabel2.backgroundColor = UIColor.whiteColor()
        myLabel2.textColor = UIColor.blackColor()
        myLabel2.textAlignment = NSTextAlignment.Center
        myLabel2.layer.masksToBounds = true
        myLabel2.text = String(format: "%@%d", "NASDAQ\n", menuItems.count)
        myLabel2.font = Font.headtitle
        myLabel2.layer.cornerRadius = 30.0
        myLabel2.userInteractionEnabled = true
        vw.addSubview(myLabel2)
        
        let separatorLineView2 = UIView(frame: CGRectMake(85, 85, 60, 3.5))
        separatorLineView2.backgroundColor = UIColor.redColor()
        vw.addSubview(separatorLineView2)
        
        let myLabel3:UILabel = UILabel(frame: CGRectMake(160, 15, 60, 60))
        myLabel3.numberOfLines = 0
        myLabel3.backgroundColor = UIColor.whiteColor()
        myLabel3.textColor = UIColor.blackColor()
        myLabel3.textAlignment = NSTextAlignment.Center
        myLabel3.layer.masksToBounds = true
        myLabel3.text = String(format: "%@%d", "S&P 500\n", menuItems.count)

        myLabel3.font = Font.headtitle
        myLabel3.layer.cornerRadius = 30.0
        myLabel3.userInteractionEnabled = true
        vw.addSubview(myLabel3)
        
        let separatorLineView3 = UIView(frame: CGRectMake(160, 85, 60, 3.5))
        separatorLineView3.backgroundColor = UIColor.redColor()
        vw.addSubview(separatorLineView3)
        
        let myLabel4:UILabel = UILabel(frame: CGRectMake(10, 100, 280, 20))
        myLabel4.textColor = UIColor.greenColor()
        myLabel4.text = String(format: "%@ %d", "Today's Weather:", "\(self.tempDescript)°")
        myLabel4.font = Font.headtitle
        vw.addSubview(myLabel4)
        
        let statButton:UIButton = UIButton(frame: CGRectMake(tableView.frame.size.width-100, 95, 90, 30))
        statButton.setTitle("Statistics", forState: .Normal)
        statButton.backgroundColor = Color.MGrayColor
        statButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        statButton.addTarget(self, action:#selector(MasterViewController.statButton), forControlEvents: UIControlEvents.TouchUpInside)
        statButton.layer.cornerRadius = 15.0
        statButton.layer.borderColor = UIColor.blackColor().CGColor
        statButton.layer.borderWidth = 1.0
        vw.addSubview(statButton)
        
        return vw
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    
     // MARK: - playSound
    
    func playSound() {
        
        let audioPath = NSBundle.mainBundle().pathForResource("MobyDick", ofType: "mp3")
        do {
            player = try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: audioPath!))
        }
        catch {
            self.simpleAlert("Alert", message: "Something bad happened. Try catching specific errors to narrow things down")
        }
        player.play()
        
    }
    
    // MARK: - Search
    
    func searchButton(sender: AnyObject) {
        
        searchController = UISearchController(searchResultsController: resultsController)
        searchController.searchBar.searchBarStyle = .Prominent
        searchController.searchResultsUpdater = self
        searchController.searchBar.showsBookmarkButton = false
        searchController.searchBar.showsCancelButton = true
        searchController.searchBar.placeholder = "Search here..."
        searchController.searchBar.sizeToFit()
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = true
        searchController.hidesNavigationBarDuringPresentation = true
        //tableView!.tableHeaderView = searchController.searchBar
        tableView!.tableFooterView = UIView(frame: .zero)
        UISearchBar.appearance().barTintColor = UIColor.blackColor()
        self.presentViewController(searchController, animated: true, completion: nil)
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        self.foundUsers.removeAll(keepCapacity: false)
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (self.menuItems as NSArray).filteredArrayUsingPredicate(searchPredicate)
        self.foundUsers = array as! [String]
        self.resultsController.tableView.reloadData()
    }
    
    
    // MARK: - upDate
    
    func versionCheck() {
        
        let query = PFQuery(className:"Version")
        //query.cachePolicy = PFCachePolicy.CacheThenNetwork
        query.getFirstObjectInBackgroundWithBlock {(object: PFObject?, error: NSError?) -> Void in
            
            let versionId = object?.objectForKey("VersionId") as! String?
            if (versionId != self.defaults.stringForKey("versionKey")) {
                
                dispatch_async(dispatch_get_main_queue()) {
                self.simpleAlert("New Version!!", message: "A new version of app is available to download")
                }
            }
        }
    }
    

    func updateYahoo() {
        
        resultsWeatherYQL = YQL.query("select * from weather.forecast where woeid=2446726")
        //print(resultsYQL)
        
        /*
        let YQLresults = resultsWeatherYQL!
            .objectForKey("query")!
            .objectForKey("results")!
            .objectForKey("channel")!
            .objectForKey("item")!
            .objectForKey("condition")!
        let YQLtext = YQLresults.objectForKey("text") as! String
        let YQLtemp = YQLresults.objectForKey("temp")as! String
        
        print("Todays Weather: \(YQLtext) \(YQLtemp)") */
        
        /*
        let stockresults = YQL.query("select * from yahoo.finance.quote where symbol in (\"^IXIC\",\"SPY\")")
        print(stockresults) */
        
    }

    
    // MARK: - Segues
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            currentItem = menuItems[selectedIndexPath.row] as! String
        }
        
        if tableView == resultsController.tableView {
            //userDetails = foundUsers[indexPath.row]
            //self.performSegueWithIdentifier("PushDetailsVC", sender: self)
        } else {
            
            if (currentItem == "Snapshot") {
                self.performSegueWithIdentifier("snapshotSegue", sender: self)
            } else if (currentItem == "Leads") {
                self.performSegueWithIdentifier("showleadSegue", sender: self)
            } else if (currentItem == "Customers") {
                self.performSegueWithIdentifier("showcustSegue", sender: self)
            } else if (currentItem == "Vendors") {
                self.performSegueWithIdentifier("showvendSegue", sender: self)
            } else if (currentItem == "Employee") {
                self.performSegueWithIdentifier("showemployeeSegue", sender: self)
            } else if (currentItem == "Advertising") {
                self.performSegueWithIdentifier("showadSegue", sender: self)
            } else if (currentItem == "Product") {
                self.performSegueWithIdentifier("showproductSegue", sender: self)
            } else if (currentItem == "Job") {
                self.performSegueWithIdentifier("showjobSegue", sender: self)
            } else if (currentItem == "Salesman") {
                self.performSegueWithIdentifier("showsalesmanSegue", sender: self)
            } else if (currentItem == "Show Detail") {
                self.performSegueWithIdentifier("showDetail", sender: self)
            } else if (currentItem == "Music") {
                self.performSegueWithIdentifier("musicSegue", sender: self)
            } else if (currentItem == "YouTube") {
                self.performSegueWithIdentifier("youtubeSegue", sender: self)
            } else if (currentItem == "Spot Beacon") {
                self.performSegueWithIdentifier("spotbeaconSegue", sender: self)
            } else if (currentItem == "Transmit Beacon") {
                self.performSegueWithIdentifier("transmitbeaconSegue", sender: self)
            } else if (currentItem == "Contacts") {
                self.performSegueWithIdentifier("contactSegue", sender: self)
            }
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }

}

