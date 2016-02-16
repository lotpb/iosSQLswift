//
//  NewEditData.swift
//  mySQLswift
//
//  Created by Peter Balsamo on 1/9/16.
//  Copyright © 2016 Peter Balsamo. All rights reserved.
//

import UIKit
import Parse

class NewEditData: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var tableView: UITableView?
    
    var formController : NSString?
    var formStatus : NSString?
    
    var objectId : NSString?
    var active : NSString?
    var frm11 : NSString?
    var frm12 : NSString?
    var frm13 : NSString?
    
    var salesNo : UITextField!
    var salesman : UITextField!
    var textframe: UITextField!
    
    var image : UIImage!
    var activeImage: UIImageView?
    
    var objects = [AnyObject]()
    var pasteBoard = UIPasteboard.generalPasteboard()
    var refreshControl: UIRefreshControl!
    
    var searchController: UISearchController!
    var resultsController: UITableViewController!
    var foundUsers = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleButton: UIButton = UIButton(frame: CGRectMake(0, 0, 100, 32))
        titleButton.setTitle(String(format: "%@ %@", self.formStatus!, self.formController!), forState: UIControlState.Normal)
        titleButton.titleLabel?.font = Font.navlabel
        titleButton.titleLabel?.textAlignment = NSTextAlignment.Center
        titleButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        titleButton.addTarget(self, action: Selector(), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.titleView = titleButton
        
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        //self.tableView!.rowHeight = 65
        self.tableView!.estimatedRowHeight = 110
        self.tableView!.rowHeight = UITableViewAutomaticDimension
        self.tableView!.backgroundColor = UIColor(white:0.90, alpha:1.0)
        self.automaticallyAdjustsScrollViewInsets = false
        //tableView!.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        //tableView!.tableFooterView = UIView(frame: .zero)
        
        //users = []
        foundUsers = []
        resultsController = UITableViewController(style: .Plain)
        resultsController.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "UserFoundCell")
        resultsController.tableView.dataSource = self
        resultsController.tableView.delegate = self
        
        //self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "updateData")
        let buttons:NSArray = [saveButton]
        self.navigationItem.rightBarButtonItems = buttons as? [UIBarButtonItem]

        self.refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.clearColor()
        refreshControl.tintColor = UIColor.blackColor()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refreshData:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView!.addSubview(refreshControl)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //navigationController?.hidesBarsOnSwipe = true
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = UIColor.brownColor()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //navigationController?.hidesBarsOnSwipe = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Refresh
    
    func refreshData(sender:AnyObject) {
        self.tableView!.reloadData()
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
        
        if formStatus == "New" {
            return 2
        } else if (formStatus == "Edit") &&  (formStatus == "New") {
            return 4
        } else {
            return 3
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if indexPath.row == 3 {
            return 100
        }
        return 44
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let CellIdentifier: String = "Cell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier)! as UITableViewCell

        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        textframe = UITextField(frame:CGRect(x: 130, y: 7, width: 175, height: 30))
        activeImage = UIImageView(frame:CGRect(x: 130, y: 10, width: 18, height: 22))
        
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad {
            
            self.salesman!.font = Font.celltitle
            self.salesNo!.font = Font.celltitle
        } else {
            
            self.salesman?.font = Font.celltitle
            self.salesNo?.font = Font.celltitle
        }
        
        if (indexPath.row == 0) {
            
            let theSwitch = UISwitch(frame:CGRectZero);
            theSwitch.addTarget(self, action: "changeSwitch:", forControlEvents: .ValueChanged);
            theSwitch.onTintColor = UIColor(red:0.0, green:122.0/255.0, blue:1.0, alpha: 1.0)
            theSwitch.tintColor = UIColor.lightGrayColor()

            if self.frm11 == "Active" {
                theSwitch.on = true
                //theSwitch.setOn(true, animated: false);
                self.active = (self.frm11 as? String)!
                self.activeImage!.image = UIImage(named:"iosStar.png")
                cell.textLabel!.text = "Active"
            } else {
                theSwitch.on = false
                //theSwitch.setOn(false, animated: false);
                self.active = ""
                self.activeImage!.image = UIImage(named:"iosStarNA.png")
                cell.textLabel!.text = "Inactive"
            }

            self.activeImage?.contentMode = UIViewContentMode.ScaleAspectFill
            cell.addSubview(theSwitch)
            cell.accessoryView = theSwitch
            cell.contentView.addSubview(activeImage!)
            
        } else if (indexPath.row == 1) {
            
            self.salesman = textframe
            self.salesman!.adjustsFontSizeToFitWidth = true
            if self.frm13 == nil {
                
                self.salesman!.text = ""
                
            } else {
                
                self.salesman!.text = self.frm13 as? String
            }
            
            if (formController == "Salesman") {
                self.salesman.placeholder = "Salesman"
                cell.textLabel!.text = "Salesman"
            }
                
            else if (formController == "Product") {
                self.salesman.placeholder = "Product"
                cell.textLabel!.text = "Product"
            }
                
            else if (formController == "Advertising") {
                self.salesman.placeholder = "Advertiser"
                cell.textLabel!.text = "Advertiser"
            }
                
            else if (formController == "Job") {
                self.salesman.placeholder = "Description"
                cell.textLabel!.text = "Description"
            }
            
            cell.contentView.addSubview(self.salesman!)
            
        } else if (indexPath.row == 2) {
   
            self.salesNo = textframe

            if self.frm12 == nil {
                self.salesNo?.text = ""
            } else {
                self.salesNo?.text = self.frm12 as? String
            }
            
            if (formController == "Salesman") {
                self.salesNo.placeholder = "SalesNo"
                cell.textLabel!.text = "SalesNo"
            }
                
            else if (formController == "Product") {
                self.salesNo.placeholder = "ProductNo"
                cell.textLabel!.text = "ProductNo"
            }
                
            else if (formController == "Advertising") {
                self.salesNo?.placeholder = "AdNo"
                cell.textLabel!.text = "AdNo"
            }
                
            else if (formController == "Job") {
                self.salesNo.placeholder = "JobNo"
                cell.textLabel!.text = "JobNo"
            }
            
            cell.contentView.addSubview(self.salesNo)
            
        } else if (indexPath.row == 3) {
            
            if (formController == "Salesman") {
                cell.textLabel!.text = ""
                cell.imageView!.image = self.image
            }
                
            else if (formController == "Product") {
                cell.textLabel!.text = ""
            }
                
            else if (formController == "Advertising") {
                cell.textLabel!.text = ""
            }
                
            else if (formController == "Job") {
                cell.textLabel!.text = ""
            }
            
        }
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            objects.removeAtIndex(indexPath.row)
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
        searchController.searchBar.scopeButtonTitles = ["name", "city", "phone", "date", "active"]
        //tableView!.tableHeaderView = searchController.searchBar
        tableView!.tableFooterView = UIView(frame: .zero)
        UISearchBar.appearance().barTintColor = UIColor.brownColor()
        
        self.presentViewController(searchController, animated: true, completion: nil)
    }
    
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        /*
        self.foundUsers.removeAll(keepCapacity: false)
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (self._feedItems as NSArray).filteredArrayUsingPredicate(searchPredicate)
        self.foundUsers = array as! [String]
        self.resultsController.tableView.reloadData() */
    }
    
    // MARK: - Update Data
    
    func updateData() {
        
        if (self.formController == "Salesman") {
            
            if (self.formStatus == "Edit") { //Edit Salesman
                
                let query = PFQuery(className:"Salesman")
                query.whereKey("objectId", equalTo:self.objectId!)
                query.getFirstObjectInBackgroundWithBlock {(updateblog: PFObject?, error: NSError?) -> Void in
                    if error == nil {
                        updateblog!.setObject(self.salesNo.text ?? NSNull(), forKey:"SalesNo")
                        updateblog!.setObject(self.salesman.text ?? NSNull(), forKey:"Salesman")
                        updateblog!.setObject(self.active ?? NSNull(), forKey:"Active")

                        updateblog!.saveEventually()
                        self.tableView!.reloadData()
                        
                        let alert = UIAlertController(title: "Upload Complete", message: "Successfully updated the data", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in })
                        
                        alert.addAction(okAction)
                        self.presentViewController(alert, animated: true, completion: nil)
                        
                    } else {
                        
                        let alert = UIAlertController(title: "Upload Failure", message: "Failure updated the data", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in })
                        
                        alert.addAction(okAction)
                        self.presentViewController(alert, animated: true, completion: nil)
                        
                    }
                }
                self.navigationController?.popToRootViewControllerAnimated(true)
                
            } else { //Save Salesman
                
                let saveblog:PFObject = PFObject(className:"Salesman")
                saveblog.setObject(self.salesNo.text ?? NSNull(), forKey:"SalesNo")
                saveblog.setObject(self.salesman.text ?? NSNull(), forKey:"Salesman")
                saveblog.setObject(self.active ?? NSNull(), forKey:"Active")
                
                PFACL.setDefaultACL(PFACL(), withAccessForCurrentUser: true)
                
                saveblog.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                    if success == true {
                        
                        let alert = UIAlertController(title: "Upload Complete", message: "Successfully updated the data", preferredStyle: UIAlertControllerStyle.Alert)
                        let alertActionTrue = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in })
                        
                        alert.addAction(alertActionTrue)
                        self.navigationController?.popViewControllerAnimated(true)
                        self.presentViewController(alert, animated: true, completion: nil)
                        
                    } else {
                        
                        let alert = UIAlertController(title: "Upload Failure", message: "Failure updated the data", preferredStyle: UIAlertControllerStyle.Alert)
                        let alertActionTrue = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in })
                        
                        alert.addAction(alertActionTrue)
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
            }
            
        } else  if (self.formController == "Job") {
            
            if (self.formStatus == "Edit") { //Edit Job
                
                let query = PFQuery(className:"Job")
                query.whereKey("objectId", equalTo:self.objectId!)
                query.getFirstObjectInBackgroundWithBlock {(updateblog: PFObject?, error: NSError?) -> Void in
                    if error == nil {
                        updateblog!.setObject(self.salesNo.text ?? NSNull(), forKey:"JobNo")
                        updateblog!.setObject(self.salesman.text ?? NSNull(), forKey:"Description")
                        updateblog!.setObject(self.active ?? NSNull(), forKey:"Active")
                        
                        updateblog!.saveEventually()
                        self.tableView!.reloadData()
                        
                        let alert = UIAlertController(title: "Upload Complete", message: "Successfully updated the data", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        let alertActionTrue = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in })
                        
                        alert.addAction(alertActionTrue)
                        self.presentViewController(alert, animated: true, completion: nil)
                        
                    } else {
                        
                        let alert = UIAlertController(title: "Upload Failure", message: "Failure updated the data", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        let alertActionTrue = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in })
                        
                        alert.addAction(alertActionTrue)
                        self.presentViewController(alert, animated: true, completion: nil)
                        
                    }
                }
                self.navigationController?.popToRootViewControllerAnimated(true)
    
            } else { //Save Job
                
                let saveblog:PFObject = PFObject(className:"Job")

                saveblog.setObject(self.salesNo.text ?? NSNull(), forKey:"JobNo")
                saveblog.setObject(self.salesman.text ?? NSNull(), forKey:"Description")
                saveblog.setObject(self.active ?? NSNull(), forKey:"Active")
                
                PFACL.setDefaultACL(PFACL(), withAccessForCurrentUser: true)
                
                saveblog.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                    if success == true {
                        
                        let alert = UIAlertController(title: "Upload Complete", message: "Successfully updated the data", preferredStyle: UIAlertControllerStyle.Alert)
                        let alertActionTrue = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in })
                        
                        alert.addAction(alertActionTrue)
                        self.navigationController?.popViewControllerAnimated(true)
                        self.presentViewController(alert, animated: true, completion: nil)
                        
                    } else {
                        
                        let alert = UIAlertController(title: "Upload Failure", message: "Failure updated the data", preferredStyle: UIAlertControllerStyle.Alert)
                        let alertActionTrue = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in })
                        
                        alert.addAction(alertActionTrue)
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
                
            }
            
        } else  if (self.formController == "Product") {
            
            if (self.formStatus == "Edit") { //Edit Products
                
                let query = PFQuery(className:"Product")
                query.whereKey("objectId", equalTo:self.objectId!)
                query.getFirstObjectInBackgroundWithBlock {(updateblog: PFObject?, error: NSError?) -> Void in
                    if error == nil {
                        updateblog!.setObject(self.salesNo.text ?? NSNull(), forKey:"ProductNo")
                        updateblog!.setObject(self.salesman.text ?? NSNull(), forKey:"Products")
                        updateblog!.setObject(self.active ?? NSNull(), forKey:"Active")
                        
                        updateblog!.saveEventually()
                        self.tableView!.reloadData()
                        
                        let alert = UIAlertController(title: "Upload Complete", message: "Successfully updated the data", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        let alertActionTrue = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in })
                        
                        alert.addAction(alertActionTrue)
                        self.presentViewController(alert, animated: true, completion: nil)
                        
                    } else {
                        
                        let alert = UIAlertController(title: "Upload Failure", message: "Failure updated the data", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        let alertActionTrue = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in })
                        
                        alert.addAction(alertActionTrue)
                        self.presentViewController(alert, animated: true, completion: nil)
                        
                    }
                }
                self.navigationController?.popToRootViewControllerAnimated(true)
                
            } else { //Save Products
                
                let saveblog:PFObject = PFObject(className:"Product")
                saveblog.setObject(self.salesNo.text ?? NSNull(), forKey:"ProductNo")
                saveblog.setObject(self.salesman.text ?? NSNull(), forKey:"Products")
                saveblog.setObject(self.active ?? NSNull(), forKey:"Active")
                
                PFACL.setDefaultACL(PFACL(), withAccessForCurrentUser: true)
                
                saveblog.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                    if success == true {
                        
                        let alert = UIAlertController(title: "Upload Complete", message: "Successfully updated the data", preferredStyle: UIAlertControllerStyle.Alert)
                        let alertActionTrue = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in })
                        
                        alert.addAction(alertActionTrue)
                        self.navigationController?.popViewControllerAnimated(true)
                        self.presentViewController(alert, animated: true, completion: nil)
                        
                    } else {
                        
                        let alert = UIAlertController(title: "Upload Failure", message: "Failure updated the data", preferredStyle: UIAlertControllerStyle.Alert)
                        let alertActionTrue = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in })
                        
                        alert.addAction(alertActionTrue)
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
            }
            
        } else if (self.formController == "Advertising") {
            
            if (self.formStatus == "Edit") { //Edit Advertising
                
                let query = PFQuery(className:"Advertising")
                query.whereKey("objectId", equalTo:self.objectId!)
                query.getFirstObjectInBackgroundWithBlock {(updateblog: PFObject?, error: NSError?) -> Void in
                    if error == nil {
                        updateblog!.setObject(self.salesNo.text ?? NSNull(), forKey:"AdNo")
                        updateblog!.setObject(self.salesman.text ?? NSNull(), forKey:"Advertiser")
                        updateblog!.setObject(self.active ?? NSNull(), forKey:"Active")
                        
                        updateblog!.saveEventually()
                        self.tableView!.reloadData()
                        
                        let alert = UIAlertController(title: "Upload Complete", message: "Successfully updated the data", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        let alertActionTrue = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in })
                        
                        alert.addAction(alertActionTrue)
                        self.presentViewController(alert, animated: true, completion: nil)
                        
                    } else {
                        
                        let alert = UIAlertController(title: "Upload Failure", message: "Failure updated the data", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        let alertActionTrue = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in })
                        
                        alert.addAction(alertActionTrue)
                        self.presentViewController(alert, animated: true, completion: nil)
                        
                    }
                }
                self.navigationController?.popToRootViewControllerAnimated(true)
                
            } else { //Save Advertising
                
                let saveblog:PFObject = PFObject(className:"Advertising")
                saveblog.setObject(self.salesNo.text ?? NSNull(), forKey:"AdNo")
                saveblog.setObject(self.salesman.text ?? NSNull(), forKey:"Advertiser")
                saveblog.setObject(self.active ?? NSNull(), forKey:"Active")
                
                PFACL.setDefaultACL(PFACL(), withAccessForCurrentUser: true)
                
                saveblog.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                    if success == true {
                        
                        let alert = UIAlertController(title: "Upload Complete", message: "Successfully updated the data", preferredStyle: UIAlertControllerStyle.Alert)
                        let alertActionTrue = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in })
                        
                        alert.addAction(alertActionTrue)
                        self.navigationController?.popViewControllerAnimated(true)
                        self.presentViewController(alert, animated: true, completion: nil)
                        
                    } else {
                        
                        let alert = UIAlertController(title: "Upload Failure", message: "Failure updated the data", preferredStyle: UIAlertControllerStyle.Alert)
                        let alertActionTrue = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in })
                        
                        alert.addAction(alertActionTrue)
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
            }
            
        }
        
    }
    
}
