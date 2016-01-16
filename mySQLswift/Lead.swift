//
//  Lead.swift
//  mySQLswift
//
//  Created by Peter Balsamo on 12/8/15.
//  Copyright © 2015 Peter Balsamo. All rights reserved.
//

import UIKit
import Parse

class Lead: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    let navColor = UIColor(red: 0.09, green: 0.62, blue: 0.93, alpha: 1.0)
    let labelColor = UIColor(red: 0.02, green: 0.36, blue: 0.53, alpha: 1.0)
    let labelColor1 = UIColor(white:0.45, alpha:1.0)
    let searchScope = ["name","city","phone","date", "active"]
    
    @IBOutlet weak var tableView: UITableView?
    
    var _feedItems : NSMutableArray = NSMutableArray()
    var _feedheadItems : NSMutableArray = NSMutableArray()
    var filteredString : NSMutableArray = NSMutableArray()
  
    var pasteBoard = UIPasteboard.generalPasteboard()
    var refreshControl: UIRefreshControl!
    
    var searchController = UISearchController!()
    var resultsController: UITableViewController!
    var foundUsers = [String]()
    
    var objectIdLabel = String()
    var titleLabel = String()
    var dateLabel = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleButton: UIButton = UIButton(frame: CGRectMake(0, 0, 100, 32))
        titleButton.setTitle("myLeads", forState: UIControlState.Normal)
        titleButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 25.0)
        titleButton.titleLabel?.textAlignment = NSTextAlignment.Center
        titleButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        titleButton.addTarget(self, action: Selector(), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.titleView = titleButton

        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        self.tableView!.rowHeight = 65
        //self.tableView!.estimatedRowHeight = 110
        //self.tableView!.rowHeight = UITableViewAutomaticDimension
        self.tableView!.backgroundColor = UIColor(white:0.90, alpha:1.0)
        self.automaticallyAdjustsScrollViewInsets = false
        
        //users = []
        foundUsers = []
        resultsController = UITableViewController(style: .Plain)
        resultsController.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "UserFoundCell")
        resultsController.tableView.dataSource = self
        resultsController.tableView.delegate = self
        
        //self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "newData")
        let searchButton = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: "searchButton:")
        let buttons:NSArray = [addButton,searchButton]
        self.navigationItem.rightBarButtonItems = buttons as? [UIBarButtonItem]
        
        parseData()
        
        self.refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.clearColor()
        refreshControl.tintColor = UIColor.blackColor()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refreshData:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView!.addSubview(refreshControl)
        
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
    
    // MARK: - Refresh
    
    func refreshData(sender:AnyObject) {
        
        parseData()
        self.refreshControl?.endRefreshing()
    }
    
    // MARK: - Button
    
    func newData() {
        self.performSegueWithIdentifier("newleadSegue", sender: self)
    }
    
    // MARK: - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.tableView {
        //if (self.searchController.active) {
            //return foundUsers.count
            return _feedItems.count
            //return filteredString.count
        } else {
            //return _feedItems.count
            //return foundUsers.count
            return filteredString.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cellIdentifier: String!
        
        if tableView == self.tableView{
            cellIdentifier = "Cell"

        } else {
            cellIdentifier = "UserFoundCell"

        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! CustomTableCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        let myLabel1:UILabel = UILabel(frame: CGRectMake(tableView.frame.size.width - 105, 0, 95, 32))
        myLabel1.backgroundColor = labelColor1 //UIColor(white:0.45, alpha:1.0)
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
        
        cell.LeadsubtitleLabel!.textColor = UIColor.grayColor()
        
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad {
            cell.LeadtitleLabel!.font = UIFont (name: "HelveticaNeue", size: 20)
            cell.LeadsubtitleLabel!.font = UIFont (name: "HelveticaNeue", size: 16)
            myLabel1.font = UIFont (name: "HelveticaNeue", size: 16)
            myLabel2.font = UIFont (name: "HelveticaNeue-Medium", size: 16)
        } else {
            cell.LeadtitleLabel!.font = UIFont (name: "HelveticaNeue", size: 20)
            cell.LeadsubtitleLabel!.font = UIFont (name: "HelveticaNeue", size: 16)
            myLabel1.font = UIFont (name: "HelveticaNeue", size: 16)
            myLabel2.font = UIFont (name: "HelveticaNeue-Medium", size: 16)
        }
        
        if (tableView == self.tableView) {
        //if !(self.searchController.active) {
            
            cell.LeadtitleLabel!.text = _feedItems[indexPath.row] .valueForKey("LastName") as? String
            cell.LeadsubtitleLabel!.text = _feedItems[indexPath.row] .valueForKey("City") as? String
            myLabel1.text = _feedItems[indexPath.row] .valueForKey("Date") as? String
            myLabel2.text = _feedItems[indexPath.row] .valueForKey("CallBack") as? String
            
        } else {
            //cell.LeadtitleLabel!.text = foundUsers[indexPath.row]
            cell.LeadtitleLabel!.text = filteredString[indexPath.row] .valueForKey("LastName") as? String
            cell.LeadsubtitleLabel!.text = filteredString[indexPath.row] .valueForKey("City") as? String
            myLabel1.text = filteredString[indexPath.row] .valueForKey("Date") as? String
            myLabel2.text = filteredString[indexPath.row] .valueForKey("CallBack") as? String
        }
        
        let myLabel:UILabel = UILabel(frame: CGRectMake(10, 10, 50, 50))
        myLabel.backgroundColor = labelColor //UIColor(red: 0.02, green: 0.36, blue: 0.53, alpha: 1.0)
        myLabel.textColor = UIColor.whiteColor()
        myLabel.textAlignment = NSTextAlignment.Center
        myLabel.layer.masksToBounds = true
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
        
        let vw = UIView()
        vw.backgroundColor = navColor
        tableView.tableHeaderView = vw
        
        let myLabel1:UILabel = UILabel(frame: CGRectMake(10, 15, 50, 50))
        myLabel1.numberOfLines = 0
        myLabel1.backgroundColor = UIColor.whiteColor()
        myLabel1.textColor = UIColor.blackColor()
        myLabel1.textAlignment = NSTextAlignment.Center
        myLabel1.layer.masksToBounds = true
        myLabel1.text = String(format: "%@%d", "Leads\n", _feedItems.count)
        myLabel1.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
        myLabel1.layer.cornerRadius = 25.0
        myLabel1.userInteractionEnabled = true
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
            let query = PFQuery(className:"Leads")
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
    
    // MARK: - Content Menu
    
    func tableView(tableView: UITableView, shouldShowMenuForRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
    }
    
    func tableView(tableView: UITableView, canPerformAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        
        if (action == Selector("copy:")) {
            return true
        }
        return false
    }
    
    func tableView(tableView: UITableView, performAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        pasteBoard.string = cell!.textLabel?.text
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
        
        /*
        let searchString = self.searchController.searchBar.text
        let selectedScopeButtonIndex = self.searchController.searchBar.selectedScopeButtonIndex
        self.foundUsers(searchString, scope: selectedScopeButtonIndex)
        self.tableView!.reloadData() */
        
        /*
        self.foundUsers.removeAll(keepCapacity: false)
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (self._feedItems as NSArray).filteredArrayUsingPredicate(searchPredicate)
        self.foundUsers = array as! [String]
        self.resultsController.tableView.reloadData() */
        
        let firstNameQuery = PFQuery(className:"Leads")
        firstNameQuery.whereKey("First", containsString: searchController.searchBar.text)
        
        let lastNameQuery = PFQuery(className:"Leads")
        lastNameQuery.whereKey("LastName", matchesRegex: "(?i)\(searchController.searchBar.text)")
        
        let query = PFQuery.orQueryWithSubqueries([firstNameQuery, lastNameQuery])
        
        query.findObjectsInBackgroundWithBlock { (results:[PFObject]?, error:NSError?) -> Void in

            if error != nil {
                
                let myAlert = UIAlertController(title:"Alert", message:error?.localizedDescription, preferredStyle:UIAlertControllerStyle.Alert)
                
                let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                
                myAlert.addAction(okAction)
                
                self.presentViewController(myAlert, animated: true, completion: nil)
                
                return
            }
            
            if let objects = results {
                
                self.foundUsers.removeAll(keepCapacity: false)
                
                for object in objects {
                    let firstName = object.objectForKey("First") as! String
                    let lastName = object.objectForKey("LastName") as! String
                    let fullName = firstName + " " + lastName
                    
                    self.foundUsers.append(fullName)
                    print(fullName)
                    //self.filteredString = self.foundUsers
                    //self.filteredString = self.foundUsers.mutableCopy() as! NSMutableArray
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.resultsController.tableView.reloadData()
                    self.searchController.resignFirstResponder()
                    
                }
            }
        }
    }

    // MARK: - Parse

    func parseData() {
        
        let query = PFQuery(className:"Leads")
        query.limit = 1000
        query.orderByDescending("createdAt")
        query.cachePolicy = PFCachePolicy.CacheThenNetwork
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                let temp: NSArray = objects! as NSArray
                self._feedItems = temp.mutableCopy() as! NSMutableArray
                self.tableView!.reloadData()
            } else {
                print("Error")
            }
        }
        
        let query1 = PFQuery(className:"Leads")
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
        self.performSegueWithIdentifier("leaduserSegue", sender: self)
    }
    
    // MARK: - Segues
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if tableView == resultsController.tableView {
            //userDetails = foundUsers[indexPath.row]
            //self.performSegueWithIdentifier("PushDetailsVC", sender: self)
        } else {
            self.performSegueWithIdentifier("showDetail2", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showDetail2" {
            
            let formatter = NSNumberFormatter()
            
            let controller = segue.destinationViewController as? LeadDetail
            controller!.formController = "Leads"
            let indexPath = self.tableView!.indexPathForSelectedRow!.row
            controller?.objectId = _feedItems[indexPath] .valueForKey("objectId") as? String
            
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
            
            controller?.tbl11 = _feedItems[indexPath] .valueForKey("CallBack") as? String
            controller?.tbl12 = _feedItems[indexPath] .valueForKey("Phone") as? String
            controller?.tbl13 = _feedItems[indexPath] .valueForKey("First") as? String
            controller?.tbl14 = _feedItems[indexPath] .valueForKey("Spouse") as? String
            controller?.tbl15 = _feedItems[indexPath] .valueForKey("Email") as? String
            controller?.tbl21 = _feedItems[indexPath] .valueForKey("AptDate") as? String
            
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
            
            var AdNo:Int? = _feedItems[indexPath] .valueForKey("AdNo")as? Int
            formatter.numberStyle = .NoStyle
            if AdNo == nil {
                AdNo = 0
            }
            controller?.tbl24 = formatter.stringFromNumber(AdNo!)
            
            var Active:Int? = _feedItems[indexPath] .valueForKey("Active")as? Int
            formatter.numberStyle = .NoStyle
            if Active == nil {
                Active = 0
            }
            controller?.tbl25 = formatter.stringFromNumber(Active!)
            
            let dateUpdated = _feedItems[indexPath] .valueForKey("updatedAt") as! NSDate
            let dateFormat = NSDateFormatter()
            dateFormat.dateFormat = "MMM dd yy"
            controller?.tbl16 = NSString(format: "%@", dateFormat.stringFromDate(dateUpdated)) as String
            
            controller?.tbl26 = _feedItems[indexPath] .valueForKey("Photo") as? String
            controller?.comments = _feedItems[indexPath] .valueForKey("Coments") as? String
            controller?.active = formatter.stringFromNumber(Active!)
            controller?.l11 = "Call Back"; controller?.l12 = "Phone"
            controller?.l13 = "First"; controller?.l14 = "Spouse"
            controller?.l15 = "Email"; controller?.l21 = "Apt Date"
            controller?.l22 = "Salesman"; controller?.l23 = "Job"
            controller?.l24 = "Advertiser"; controller?.l25 = "Active"
            controller?.l16 = "Last Updated"; controller?.l26 = "Photo"
            controller?.l1datetext = "Lead Date:"
            controller?.lnewsTitle = "Customer News: Company to expand to a new web advertising directive this week."
        }
        
        if segue.identifier == "leaduserSegue" {
            let controller = segue.destinationViewController as? LeadUserController
            controller!.formController = "Leads"
            controller!.objectId = objectIdLabel
            controller!.postBy = titleLabel
            controller!.leadDate = dateLabel
        }
        
        if segue.identifier == "newleadSegue" {
            let controller = segue.destinationViewController as? EditData
            controller!.formController = "Leads"
            controller!.statis = "New"
        }
        
    }
    
}
//-----------------------end------------------------------

