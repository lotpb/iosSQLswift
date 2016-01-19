//
//  Customer.swift
//  mySQLswift
//
//  Created by Peter Balsamo on 12/13/15.
//  Copyright © 2015 Peter Balsamo. All rights reserved.
//

import UIKit
import Parse

class Customer: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    let navColor = UIColor(red: 0.21, green: 0.60, blue: 0.86, alpha: 1.0)
    let labelColor = UIColor(red: 0.20, green: 0.29, blue: 0.37, alpha: 1.0)
    let labelColor1 = UIColor(white:0.45, alpha:1.0)
    let buttonColor = UIColor.blueColor()
    let buttonColor1 = UIColor.blueColor()
    let searchScope = ["name","city","phone","date", "active"]
    
    @IBOutlet weak var tableView: UITableView?
    var _feedItems : NSMutableArray = NSMutableArray()
    var _feedheadItems : NSMutableArray = NSMutableArray()
    var filteredString : NSMutableArray = NSMutableArray()
    
    var searchController = UISearchController!()
    var resultsController: UITableViewController!
    var users:[[String:AnyObject]]!
    var foundUsers:[String] = []

    var userDetails:[String:AnyObject]!
    
    var refreshControl:UIRefreshControl!
    
    var objectIdLabel = String()
    var titleLabel = String()
    var dateLabel = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleButton: UIButton = UIButton(frame: CGRectMake(0, 0, 100, 32))
        titleButton.setTitle("myCustomer", forState: UIControlState.Normal)
        titleButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 25.0)
        titleButton.titleLabel?.textAlignment = NSTextAlignment.Center
        titleButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        titleButton.addTarget(self, action: Selector(), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.titleView = titleButton
        
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        self.tableView!.estimatedRowHeight = 89
        self.tableView!.rowHeight = UITableViewAutomaticDimension
        self.tableView!.backgroundColor = UIColor.clearColor()
        self.automaticallyAdjustsScrollViewInsets = false
        
        users = []
        foundUsers = []
        resultsController = UITableViewController(style: .Plain)
        resultsController.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "UserFoundCell")
        resultsController.tableView.dataSource = self
        resultsController.tableView.delegate = self
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "newData")
        let searchButton = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: Selector("searchButton:"))
        let buttons:NSArray = [addButton,searchButton]
        self.navigationItem.rightBarButtonItems = buttons as? [UIBarButtonItem]

        self.refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.clearColor()
        refreshControl.tintColor = UIColor.blackColor()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refreshData:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView!.addSubview(refreshControl)
        
        parseData()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        //self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = navColor
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnSwipe = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     // MARK:, // TODO: and // FIXME:
    
    // MARK: - refresh
    
    func refreshData(sender:AnyObject)
    {
        parseData()
        self.refreshControl?.endRefreshing()
    }
    
    // MARK: - Button
    
    func newData() {
        
        self.performSegueWithIdentifier("newcustSegue", sender: self)
        
    }
    
    // MARK: - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.tableView {
            return _feedItems.count
        }
        return foundUsers.count
        //return filteredString.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cellIdentifier: String!
        //var dic: [String:AnyObject]!
        
        if tableView == self.tableView {
            cellIdentifier = "Cell"
            //dic = self.users[indexPath.row]
        } else {
            cellIdentifier = "UserFoundCell"
            //dic = self.foundUsers[indexPath.row]
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! CustomTableCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        let myLabel1:UILabel = UILabel(frame: CGRectMake(tableView.frame.size.width - 105, 0, 95, 32))
        myLabel1.backgroundColor = labelColor1
        myLabel1.textColor = UIColor.whiteColor()
        myLabel1.textAlignment = NSTextAlignment.Center
        myLabel1.layer.masksToBounds = true
        myLabel1.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
        cell.addSubview(myLabel1)
        
        let myLabel2:UILabel = UILabel(frame: CGRectMake(tableView.frame.size.width - 105, 33, 95, 33))
        myLabel2.backgroundColor = UIColor.whiteColor()
        myLabel2.textColor = UIColor.blackColor()
        myLabel2.textAlignment = NSTextAlignment.Center
        myLabel2.layer.masksToBounds = true
        myLabel2.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
        cell.addSubview(myLabel2)
        
        cell.custsubtitleLabel!.textColor = UIColor.grayColor()
        
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad {
            
            cell.custtitleLabel!.font = UIFont (name: "HelveticaNeue", size: 20)
            cell.custsubtitleLabel!.font = UIFont (name: "HelveticaNeue", size: 16)
            cell.custreplyLabel.font = UIFont (name: "HelveticaNeue", size: 16)
            cell.custlikeLabel.font = UIFont (name: "HelveticaNeue-Medium", size: 16)
            myLabel1.font = UIFont (name: "HelveticaNeue", size: 16)
            myLabel2.font = UIFont (name: "HelveticaNeue-Medium", size: 16)
            
        } else {
            
            cell.custtitleLabel!.font = UIFont (name: "HelveticaNeue", size: 20)
            cell.custsubtitleLabel!.font = UIFont (name: "HelveticaNeue", size: 16)
            cell.custreplyLabel.font = UIFont (name: "HelveticaNeue", size: 16)
            cell.custlikeLabel.font = UIFont (name: "HelveticaNeue-Medium", size: 16)
            myLabel1.font = UIFont (name: "HelveticaNeue", size: 16)
            myLabel2.font = UIFont (name: "HelveticaNeue-Medium", size: 16)
        }
        
        if (tableView == self.tableView) {
            
            cell.custtitleLabel!.text = _feedItems[indexPath.row] .valueForKey("LastName") as? String
            cell.custsubtitleLabel!.text = _feedItems[indexPath.row] .valueForKey("City") as? String
            cell.custlikeLabel!.text = _feedItems[indexPath.row] .valueForKey("Rate") as? String
            myLabel1.text = _feedItems[indexPath.row] .valueForKey("Date") as? String
            
            var Amount:Int? = _feedItems[indexPath.row] .valueForKey("Amount")as? Int
            let formatter = NSNumberFormatter()
            formatter.numberStyle = .CurrencyStyle
            if Amount == nil {
                Amount = 0
            }
            myLabel2.text =  formatter.stringFromNumber(Amount!) //"\(Amount!)"
           
        } else {
            
            cell.custtitleLabel!.text = filteredString[indexPath.row] .valueForKey("LastName") as? String
            cell.custsubtitleLabel!.text = filteredString[indexPath.row] .valueForKey("City") as? String
            cell.custlikeLabel!.text = filteredString[indexPath.row] .valueForKey("Rate") as? String
            myLabel1.text = filteredString[indexPath.row] .valueForKey("Date") as? String
            myLabel2.text = filteredString[indexPath.row] .valueForKey("Amount") as? String
            
        }
        
        cell.custreplyButton.tintColor = UIColor.lightGrayColor()
        let replyimage : UIImage? = UIImage(named:"Commentfilled.png")!.imageWithRenderingMode(.AlwaysTemplate)
        cell.custreplyButton .setImage(replyimage, forState: .Normal)
        cell.custreplyButton .addTarget(self, action: "flagButton:", forControlEvents: UIControlEvents.TouchUpInside)
        
        cell.custlikeButton.tintColor = UIColor.lightGrayColor()
        let likeimage : UIImage? = UIImage(named:"Thumb Up.png")!.imageWithRenderingMode(.AlwaysTemplate)
        cell.custlikeButton .setImage(likeimage, forState: .Normal)
        cell.custlikeButton .addTarget(self, action: "buttonPress:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.custlikeButton .addTarget(self, action: "likeButton:", forControlEvents: UIControlEvents.TouchUpInside)
        
        cell.custreplyLabel.text! = ""
        
        if (_feedItems[indexPath.row] .valueForKey("Comments") as? String == nil) {
            cell.custreplyButton!.tintColor = UIColor.lightGrayColor()
        } else {
            cell.custreplyButton!.tintColor = buttonColor
        }
        
        if (_feedItems[indexPath.row] .valueForKey("Rate") as? String == "A" ) {
            cell.custlikeButton!.tintColor = buttonColor1
        } else {
            cell.custlikeButton!.tintColor = UIColor.lightGrayColor()
        }
        
        let myLabel:UILabel = UILabel(frame: CGRectMake(10, 10, 50, 50))
        myLabel.backgroundColor = labelColor
        myLabel.textColor = UIColor.whiteColor()
        myLabel.textAlignment = NSTextAlignment.Center
        myLabel.layer.masksToBounds = true
        //let firstChar = "\(text.characters.first!)" //Swift 2.1
        myLabel.text = "Page"
        myLabel.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
        myLabel.layer.cornerRadius = 25.0
        myLabel.userInteractionEnabled = true
        myLabel.tag = indexPath.row
        cell.addSubview(myLabel)
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("imgLoadSegue:"))
        myLabel.addGestureRecognizer(tap)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 90.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        //let vw = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.size.width, height: 0))
        let vw = UIView()
        vw.backgroundColor = navColor
        //self.tableView!.tableHeaderView = vw
        
        let myLabel1:UILabel = UILabel(frame: CGRectMake(10, 15, 50, 50))
        myLabel1.numberOfLines = 0
        myLabel1.backgroundColor = UIColor.whiteColor()
        myLabel1.textColor = UIColor.blackColor()
        myLabel1.textAlignment = NSTextAlignment.Center
        myLabel1.layer.masksToBounds = true
        myLabel1.text = String(format: "%@%d", "Cust\n", _feedItems.count)
        myLabel1.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
        myLabel1.layer.cornerRadius = 25.0
        myLabel1.userInteractionEnabled = true
        myLabel1.layer.borderColor = UIColor.lightGrayColor().CGColor
        myLabel1.layer.borderWidth = 1
        vw.addSubview(myLabel1)
        
        let separatorLineView1 = UIView(frame: CGRectMake(10, 75, 50, 2.5))
        separatorLineView1.backgroundColor = UIColor.whiteColor()
        vw.addSubview(separatorLineView1)
        
        let myLabel2:UILabel = UILabel(frame: CGRectMake(80, 15, 50, 50))
        myLabel2.numberOfLines = 0
        myLabel2.backgroundColor = UIColor.whiteColor()
        myLabel2.textColor = UIColor.blackColor()
        myLabel2.textAlignment = NSTextAlignment.Center
        myLabel2.layer.masksToBounds = true
        myLabel2.text = String(format: "%@%d", "Active\n", _feedheadItems.count)
        myLabel2.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
        myLabel2.layer.cornerRadius = 25.0
        myLabel2.userInteractionEnabled = true
        myLabel2.layer.borderColor = UIColor.lightGrayColor().CGColor
        myLabel2.layer.borderWidth = 1
        vw.addSubview(myLabel2)
        
        let separatorLineView2 = UIView(frame: CGRectMake(80, 75, 50, 2.5))
        separatorLineView2.backgroundColor = UIColor.whiteColor()
        vw.addSubview(separatorLineView2)
        
        let myLabel3:UILabel = UILabel(frame: CGRectMake(150, 15, 50, 50))
        myLabel3.numberOfLines = 0
        myLabel3.backgroundColor = UIColor.whiteColor()
        myLabel3.textColor = UIColor.blackColor()
        myLabel3.textAlignment = NSTextAlignment.Center
        myLabel3.layer.masksToBounds = true
        myLabel3.text = "Active"
        myLabel3.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
        myLabel3.layer.cornerRadius = 25.0
        myLabel3.userInteractionEnabled = true
        myLabel3.layer.borderColor = UIColor.lightGrayColor().CGColor
        myLabel3.layer.borderWidth = 1
        vw.addSubview(myLabel3)
        
        let separatorLineView3 = UIView(frame: CGRectMake(150, 75, 50, 2.5))
        separatorLineView3.backgroundColor = UIColor.whiteColor()
        vw.addSubview(separatorLineView3)
        
        return vw
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            let query = PFQuery(className:"Customer")
            query.whereKey("objectId", equalTo:(self._feedItems.objectAtIndex(indexPath.row) .valueForKey("objectId") as? String)!)
            
            let alertController = UIAlertController(title: "Delete", message: "Confirm Delete", preferredStyle: .Alert)
            
            let destroyAction = UIAlertAction(title: "Delete!", style: .Destructive) { (action) in
                
                query.findObjectsInBackgroundWithBlock({ (objects : [PFObject]?, error: NSError?) -> Void in
                    if error == nil {
                        for object in objects! {
                            object.deleteInBackground()
                            self.refreshData(self)
                        }
                    }
                })
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
                self.refreshData(self)
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(destroyAction)
            self.presentViewController(alertController, animated: true) {
            }
            
            _feedItems.removeObjectAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    // MARK: - localNotification
    
    override class func initialize() {
        
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            self.sendNotification()
        }
    }
    
    class func sendNotification() {
        
        let localNotification: UILocalNotification = UILocalNotification()
        localNotification.alertAction = "Membership Status"
        localNotification.alertBody = "Our system has detected that your membership is inactive."
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 10)
        localNotification.timeZone = NSTimeZone.localTimeZone()
        localNotification.category = "status"
        localNotification.userInfo = [ "cause": "inactiveMembership"]
        localNotification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
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
        searchController.searchBar.scopeButtonTitles = searchScope
        //tableView!.tableHeaderView = searchController.searchBar
        tableView!.tableFooterView = UIView(frame: CGRectZero)
        UISearchBar.appearance().barTintColor = navColor
        
        self.presentViewController(searchController, animated: true, completion: nil)
    }
    
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        self.foundUsers.removeAll(keepCapacity: false)
        
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[cd] %@", searchController.searchBar.text!)
        
        let array = (_feedItems as NSArray).filteredArrayUsingPredicate(searchPredicate)
        
        self.foundUsers = array as! [String]
        //print(self.foundUsers)
        dispatch_async(dispatch_get_main_queue()) {
            //self.resultsController.tableView.reloadData()
            self.searchController.resignFirstResponder()
        }
    }
    
    // MARK: - Parse
    
    func parseData() {
        
        let query = PFQuery(className:"Customer")
        query.limit = 1000;
        query.cachePolicy = PFCachePolicy.CacheThenNetwork
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                let temp: NSArray = objects! as NSArray
                self._feedItems = temp.mutableCopy() as! NSMutableArray
                self.tableView!.reloadData()
            } else {
                print("Error")
            }
        }
        
        let query1 = PFQuery(className:"Customer")
        query1.whereKey("Active", equalTo:1)
        query1.cachePolicy = PFCachePolicy.CacheThenNetwork
        //query1.orderByDescending("createdAt")
        query1.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                let temp: NSArray = objects! as NSArray
                self._feedheadItems = temp.mutableCopy() as! NSMutableArray
                self.tableView!.reloadData()
            } else {
                print("Error")
            }
        }
    }
    
    // MARK: - imgLoadSegue
    
    func imgLoadSegue(sender:UITapGestureRecognizer) {
        objectIdLabel = (_feedItems.objectAtIndex((sender.view!.tag)) .valueForKey("objectId") as? String)!
        dateLabel = (_feedItems.objectAtIndex((sender.view!.tag)) .valueForKey("Date") as? String)!
        titleLabel = (_feedItems.objectAtIndex((sender.view!.tag)) .valueForKey("LastName") as? String)!
        self.performSegueWithIdentifier("custuserSeque", sender: self)
    }
    
    // MARK: - Segues
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if tableView == resultsController.tableView {
            userDetails = filteredString[indexPath.row] as! [String : AnyObject]
            //self.performSegueWithIdentifier("PushDetailsVC", sender: self)
        } else {
            self.performSegueWithIdentifier("custdetailSegue", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "custdetailSegue" {
            
            let formatter = NSNumberFormatter()
            
            let controller = segue.destinationViewController as? LeadDetail
            controller!.formController = "Customer"
            let indexPath = self.tableView!.indexPathForSelectedRow!.row
            controller?.objectId = _feedItems[indexPath] .valueForKey("objectId") as? String
            
            var CustNo:Int? = _feedItems[indexPath] .valueForKey("CustNo") as? Int
            formatter.numberStyle = .NoStyle
            if CustNo == nil {
                CustNo = 0
            }
            controller?.custNo =  formatter.stringFromNumber(CustNo!)
            
            var LeadNo:Int? = _feedItems[indexPath] .valueForKey("LeadNo") as? Int
            formatter.numberStyle = .NoStyle
            if LeadNo == nil {
                LeadNo = 0
            }
            controller?.leadNo =  formatter.stringFromNumber(LeadNo!)
            
            controller?.date = _feedItems[indexPath] .valueForKey("Date") as? String
            controller?.name = _feedItems[indexPath] .valueForKey("LastName") as? String
            controller?.address = _feedItems[indexPath] .valueForKey("Address") as? String
            controller?.city = _feedItems[indexPath] .valueForKey("City") as? String
            controller?.state = _feedItems[indexPath] .valueForKey("State") as? String
            
            var Zip:Int? = _feedItems[indexPath] .valueForKey("Zip")as? Int
            formatter.numberStyle = .NoStyle
            if Zip == nil {
                Zip = 0
            }
            controller?.zip =  formatter.stringFromNumber(Zip!)
            
            var Amount:Int? = _feedItems[indexPath] .valueForKey("Amount")as? Int
            formatter.numberStyle = .DecimalStyle
            if Amount == nil {
                Amount = 0
            }
            controller?.amount =  formatter.stringFromNumber(Amount!)
            
            controller?.tbl11 = _feedItems[indexPath] .valueForKey("Contractor") as? String
            controller?.tbl12 = _feedItems[indexPath] .valueForKey("Phone") as? String
            controller?.tbl13 = _feedItems[indexPath] .valueForKey("First") as? String
            controller?.tbl14 = _feedItems[indexPath] .valueForKey("Spouse") as? String
            controller?.tbl15 = _feedItems[indexPath] .valueForKey("Email") as? String
            controller?.tbl21 = _feedItems[indexPath] .valueForKey("Start") as? String
            
            var SalesNo:Int? = _feedItems[indexPath] .valueForKey("SalesNo")as? Int
            formatter.numberStyle = .NoStyle
            if SalesNo == nil {
                SalesNo = 0
            }
            controller?.tbl22 = formatter.stringFromNumber(SalesNo!)
            
            var JobNo:Int? = _feedItems[indexPath] .valueForKey("JobNo")as? Int
            formatter.numberStyle = .NoStyle
            if JobNo == nil {
                JobNo = 0
            }
            controller?.tbl23 = formatter.stringFromNumber(JobNo!)
            
            var AdNo:Int? = _feedItems[indexPath] .valueForKey("ProductNo")as? Int
            formatter.numberStyle = .NoStyle
            if AdNo == nil {
                AdNo = 0
            }
            controller?.tbl24 = formatter.stringFromNumber(AdNo!)
            
            var Quan:Int? = _feedItems[indexPath] .valueForKey("Quan")as? Int
            formatter.numberStyle = .NoStyle
            if Quan == nil {
                Quan = 0
            }
            controller?.tbl25 = formatter.stringFromNumber(Quan!)
            
            let dateUpdated = _feedItems[indexPath] .valueForKey("updatedAt") as! NSDate
            let dateFormat = NSDateFormatter()
            dateFormat.dateFormat = "MMM dd yy"
            controller?.tbl16 = NSString(format: "%@", dateFormat.stringFromDate(dateUpdated)) as String
            
            controller?.tbl26 = _feedItems[indexPath] .valueForKey("Rate") as? String
            controller?.complete = _feedItems[indexPath] .valueForKey("Completion") as? String
            controller?.photo = _feedItems[indexPath] .valueForKey("Photo") as? String
            controller?.comments = _feedItems[indexPath] .valueForKey("Comments") as? String
            
            var Active:Int? = _feedItems[indexPath] .valueForKey("Active")as? Int
            formatter.numberStyle = .NoStyle
            if Active == nil {
                Active = 0
            }
            controller?.active = formatter.stringFromNumber(Active!)
            
            controller?.l11 = "Contractor"; controller?.l12 = "Phone"
            controller?.l13 = "First"; controller?.l14 = "Spouse"
            controller?.l15 = "Email"; controller?.l21 = "Start date"
            controller?.l22 = "Salesman"; controller?.l23 = "Job"
            controller?.l24 = "Product"; controller?.l25 = "Quan"
            controller?.l16 = "Last Updated"; controller?.l26 = "Rate"
            controller?.l1datetext = "Sale Date:"
            controller?.lnewsTitle = "Customer News: Check out or new line of fabulous windows and siding."
        }
        
        if segue.identifier == "custuserSeque" {
            let controller = segue.destinationViewController as? LeadUserController
            controller!.formController = "Customer"
            controller!.objectId = objectIdLabel
            controller!.postBy = titleLabel
            controller!.leadDate = dateLabel
        }
        
        if segue.identifier == "newcustSegue" {
            let controller = segue.destinationViewController as? EditData
            controller!.formController = "Customer"
            controller!.statis = "New"
        }
        
    }
    
}
//-----------------------end------------------------------


