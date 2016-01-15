//
//  Employee.swift
//  mySQLswift
//
//  Created by Peter Balsamo on 12/24/15.
//  Copyright © 2015 Peter Balsamo. All rights reserved.
//

import UIKit
import Parse

class Employee: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    let navColor = UIColor(red: 0.64, green: 0.54, blue: 0.50, alpha: 1.0)
    let labelColor = UIColor(red: 0.31, green: 0.23, blue: 0.17, alpha: 1.0)
    let labelColor1 = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0)
    let searchScope = ["name","city","phone","active"]
    
    @IBOutlet weak var tableView: UITableView?

    var _feedItems : NSMutableArray = NSMutableArray()
    var _feedheadItems : NSMutableArray = NSMutableArray()
    var filteredString : NSMutableArray = NSMutableArray()

    var pasteBoard = UIPasteboard.generalPasteboard()
    var refreshControl: UIRefreshControl!
    
    var searchController = UISearchController!()
    var resultsController: UITableViewController!
    var users:[[String:AnyObject]]!
    var foundUsers:[[String:AnyObject]]!
    var userDetails:[String:AnyObject]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleButton: UIButton = UIButton(frame: CGRectMake(0, 0, 100, 32))
        titleButton.setTitle("myEmployee", forState: UIControlState.Normal)
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
        
        users = []
        foundUsers = []
        resultsController = UITableViewController(style: .Plain)
        resultsController.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "UserFoundCell")
        resultsController.tableView.dataSource = self
        resultsController.tableView.delegate = self
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "newData")
        let searchButton = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: "searchButton:")
        let buttons:NSArray = [addButton,searchButton]
        self.navigationItem.rightBarButtonItems = buttons as? [UIBarButtonItem]
        
        parseData()
        
        self.refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = navColor
        refreshControl.tintColor = UIColor.whiteColor()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refreshData:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView!.addSubview(refreshControl)
        
    }
    
    override func viewWillAppear(animated: Bool) {
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
    
    // MARK: - refresh
    
    func refreshData(sender:AnyObject)
    {
        parseData()
        self.refreshControl?.endRefreshing()
    }
    
    // MARK: - Button
    
    func newData() {
        
        self.performSegueWithIdentifier("newemploySegue", sender: self)
        
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
        
        if tableView == self.tableView{
            cellIdentifier = "Cell"
        } else {
            cellIdentifier = "UserFoundCell"
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! CustomTableCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        let myLabel1:UILabel = UILabel(frame: CGRectMake(tableView.frame.size.width - 85, 0, 75, 32))
        myLabel1.backgroundColor = labelColor1
        myLabel1.textColor = UIColor.whiteColor()
        myLabel1.textAlignment = NSTextAlignment.Center
        myLabel1.layer.masksToBounds = true
        myLabel1.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
        cell.addSubview(myLabel1)
        
        cell.LeadsubtitleLabel!.textColor = UIColor.grayColor()
        
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad {
            cell.LeadtitleLabel!.font = UIFont (name: "HelveticaNeue", size: 20)
            cell.LeadsubtitleLabel!.font = UIFont (name: "HelveticaNeue", size: 16)
            myLabel1.font = UIFont (name: "HelveticaNeue", size: 16)

        } else {
            cell.LeadtitleLabel!.font = UIFont (name: "HelveticaNeue", size: 20)
            cell.LeadsubtitleLabel!.font = UIFont (name: "HelveticaNeue", size: 16)
            myLabel1.font = UIFont (name: "HelveticaNeue", size: 16)
        }
        
        if (tableView == self.tableView) {
            
            cell.LeadtitleLabel!.text = String(format: "%@ %@ %@", (_feedItems[indexPath.row] .valueForKey("First") as? String)!,
                (_feedItems[indexPath.row] .valueForKey("Last") as? String)!,
                (_feedItems[indexPath.row] .valueForKey("Company") as? String)!)
            cell.LeadsubtitleLabel!.text = _feedItems[indexPath.row] .valueForKey("City") as? String
            var numNo:Int? = _feedItems[indexPath.row] .valueForKey("EmployeeNo")as? Int
            if numNo == nil {
                numNo = 0
            }
            myLabel1.text = "\(numNo!)"
            
        } else {

            cell.LeadtitleLabel!.text = String(format: "%@ %@ %@", (filteredString[indexPath.row] .valueForKey("First") as? String)!, (filteredString[indexPath.row] .valueForKey("Last") as? String)!, (filteredString[indexPath.row] .valueForKey("Company") as? String)!)
            cell.LeadsubtitleLabel!.text = filteredString[indexPath.row] .valueForKey("City") as? String
            var numNo:Int? = filteredString[indexPath.row] .valueForKey("EmployeeNo")as? Int
            if numNo == nil {
                numNo = 0
            }
            myLabel1.text = "\(numNo!)"
            
        }
        
        let myLabel:UILabel = UILabel(frame: CGRectMake(10, 10, 50, 50))
        myLabel.backgroundColor = labelColor
        myLabel.textColor = UIColor.whiteColor()
        myLabel.textAlignment = NSTextAlignment.Center
        myLabel.layer.masksToBounds = true
        myLabel.text = "Page"
        myLabel.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
        myLabel.layer.cornerRadius = 25.0
        myLabel.userInteractionEnabled = true
        cell.addSubview(myLabel)
        
        /*
        let imageName : UIImage = UIImage(named: "Thumb Up.png")!
        cell.imageView?.image = imageName
        cell.imageView!.userInteractionEnabled = true
        cell.imageView!.tag = indexPath.row */
        
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
        myLabel1.text = String(format: "%@%d", "Employ\n", _feedItems.count)
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
            
            let query = PFQuery(className:"Employee")
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
        
        foundUsers.removeAll()
        for user in users {
            let userName:String! = user["name"] as? String
            if userName.localizedCaseInsensitiveContainsString(searchController.searchBar.text!) {
                foundUsers.append(user)
                self.resultsController.tableView.reloadData()
            }
        }
    }
    
    func parseData() {
        
        let query = PFQuery(className:"Employee")
        query.limit = 100;
        query.orderByAscending("createdAt")
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
        
        let query1 = PFQuery(className:"Employee")
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
    
    // MARK: - Segues
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if tableView == resultsController.tableView {
            userDetails = foundUsers[indexPath.row]
            //self.performSegueWithIdentifier("PushDetailsVC", sender: self)
        } else {
            self.performSegueWithIdentifier("employdetailSegue", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "employdetailSegue" {
            
            let formatter = NSNumberFormatter()
            
            let controller = segue.destinationViewController as? LeadDetail
            controller!.formController = "Employee"
            let indexPath = self.tableView!.indexPathForSelectedRow!.row
            controller?.objectId = _feedItems[indexPath] .valueForKey("objectId") as? String
            
            var LeadNo:Int? = _feedItems[indexPath] .valueForKey("EmployeeNo") as? Int
            formatter.numberStyle = .NoStyle
            if LeadNo == nil {
                LeadNo = 0
            }
            controller?.leadNo =  formatter.stringFromNumber(LeadNo!)
            
            controller?.date = _feedItems[indexPath] .valueForKey("Email") as? String
            controller?.name = String(format: "%@ %@ %@", (_feedItems[indexPath]
                .valueForKey("First") as? String)!, (_feedItems[indexPath]
                .valueForKey("Last") as? String)!, (_feedItems[indexPath]
                .valueForKey("Company") as? String)!)
            controller?.address = _feedItems[indexPath] .valueForKey("Street") as? String
            controller?.city = _feedItems[indexPath] .valueForKey("City") as? String
            controller?.state = _feedItems[indexPath] .valueForKey("State") as? String
            controller?.zip = _feedItems[indexPath] .valueForKey("Zip") as? String
            controller?.amount = _feedItems[indexPath] .valueForKey("Title") as? String
            controller?.tbl11 = _feedItems[indexPath] .valueForKey("HomePhone") as? String
            controller?.tbl12 = _feedItems[indexPath] .valueForKey("WorkPhone") as? String
            controller?.tbl13 = _feedItems[indexPath] .valueForKey("CellPhone") as? String
            controller?.tbl14 = _feedItems[indexPath] .valueForKey("SS") as? String
            controller?.tbl15 = _feedItems[indexPath] .valueForKey("Middle") as? String
            controller?.tbl21 = _feedItems[indexPath] .valueForKey("Email") as? String
            controller?.tbl22 = _feedItems[indexPath] .valueForKey("Department") as? String
            controller?.tbl23 = _feedItems[indexPath] .valueForKey("Title") as? String
            controller?.tbl24 = _feedItems[indexPath] .valueForKey("Manager") as? String
            controller?.tbl25 = _feedItems[indexPath] .valueForKey("Country") as? String
        
            let dateUpdated = _feedItems[indexPath] .valueForKey("updatedAt") as! NSDate
            let dateFormat = NSDateFormatter()
            dateFormat.dateFormat = "MMM dd yy"
            controller?.tbl16 = NSString(format: "%@", dateFormat.stringFromDate(dateUpdated)) as String
            
            controller?.tbl26 = _feedItems[indexPath] .valueForKey("First") as? String
            controller?.tbl27 = _feedItems[indexPath] .valueForKey("Company") as? String
            controller?.custNo = _feedItems[indexPath] .valueForKey("Last") as? String
            controller?.comments = _feedItems[indexPath] .valueForKey("Comments") as? String
            controller?.active = _feedItems[indexPath] .valueForKey("Active") as? String
            controller?.l11 = "Home"; controller?.l12 = "Work"
            controller?.l13 = "Mobile"; controller?.l14 = "Social"
            controller?.l15 = "Middle"; controller?.l21 = "Email"
            controller?.l22 = "Department"; controller?.l23 = "Title"
            controller?.l24 = "Manager"; controller?.l25 = "Country"
            controller?.l16 = "Last Updated"; controller?.l26 = "First"
            controller?.l1datetext = "Email:"
            controller?.lnewsTitle = "Employee News: Health benifits cancelled immediately, ineffect starting today."
            
        }
        
        if segue.identifier == "newemploySegue" {
            let controller = segue.destinationViewController as? EditData
            controller!.formController = "Employee"
            controller!.statis = "New"
        }
        
    }
    
}
//-----------------------end------------------------------
