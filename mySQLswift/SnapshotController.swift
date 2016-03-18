//
//  SnapshotController.swift
//  mySQLswift
//
//  Created by Peter Balsamo on 12/21/15.
//  Copyright © 2015 Peter Balsamo. All rights reserved.
//

import UIKit
import Parse
import EventKit

class SnapshotController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let celltitle1 = UIFont.systemFontOfSize(18, weight: UIFontWeightRegular)
    let cellsubtitle = UIFont.systemFontOfSize(16, weight: UIFontWeightRegular)

    @IBOutlet weak var tableView: UITableView!
    
    var selectedImage : UIImage!
    var eventStore: EKEventStore!
    var reminders: [EKReminder]!

    var selectedObjectId : NSString!
    var selectedTitle : NSString!
    var selectedName : NSString!
    var selectedCreate : NSString!
    var selectedEmail : NSString!
    var selectedPhone : NSString!
    var imageDetailurl : NSString!
    var resultDateDiff : NSString!
    
    var selectedState : NSString!
    var selectedZip : NSString!
    var selectedAmount : NSString!
    var selectedComments : NSString!
    var selectedActive : NSString!

    var selected11 : NSString!
    var selected12 : NSString!
    var selected13 : NSString!
    var selected14 : NSString!
    var selected15 : NSString!
    var selected16 : NSString!
    var selected21 : NSString!
    var selected22 : NSString!
    var selected23 : NSString!
    var selected24 : NSString!
    var selected25 : NSString!
    var selected26 : NSString!
    var selected27 : NSString!
    
    var maintitle : UILabel!
    var datetitle : UILabel!

    var _feedItems : NSMutableArray = NSMutableArray() //news
    var _feedItems2 : NSMutableArray = NSMutableArray() //job
    var _feedItems3 : NSMutableArray = NSMutableArray() //user
    var _feedItems4 : NSMutableArray = NSMutableArray() //salesman
    var _feedItems5 : NSMutableArray = NSMutableArray() //employee
    var _feedItems6 : NSMutableArray = NSMutableArray() //blog
    var refreshControl: UIRefreshControl!
    
    //var filteredString : NSMutableArray = NSMutableArray()
    //var objects = [AnyObject]()
    //let searchController = UISearchController(searchResultsController: nil)
    
    var imageObject :PFObject!
    var imageFile :PFFile!
    
    //below has nothing
    var detailItem: AnyObject? { //dont delete for splitview
        didSet {
            // Update the view.
            //self.configureView()
        }
    }
    
    
    func configureView() {
        /*
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
        if let label = self.detailDescriptionLabel {
        label.text = detail.description
        }
        } */
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleButton: UIButton = UIButton(frame: CGRectMake(0, 0, 100, 32))
        titleButton.setTitle("mySnapshot", forState: UIControlState.Normal)
        titleButton.titleLabel?.font = Font.navlabel
        titleButton.titleLabel?.textAlignment = NSTextAlignment.Center
        titleButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        titleButton.addTarget(self, action: Selector(), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.titleView = titleButton
        
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        self.tableView!.estimatedRowHeight = 100
        self.tableView!.rowHeight = UITableViewAutomaticDimension
        self.tableView!.backgroundColor = UIColor(white:0.90, alpha:1.0)
        self.tableView!.tableFooterView = UIView(frame: .zero)
        
        let searchButton = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: Selector())
        let buttons:NSArray = [searchButton]
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
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad {
            self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        } else {
            self.navigationController?.navigationBar.barTintColor = UIColor(white:0.45, alpha:1.0)
        }
        self.eventStore = EKEventStore()
        self.reminders = [EKReminder]()
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
    
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if (collectionView.tag == 0) {
            return CGSize(width: 150, height: 130)
        } else if (collectionView.tag == 1) {
            return CGSize(width: 150, height: 130)
        } else if (collectionView.tag == 2) {
            return CGSize(width: 120, height: 130)
        }
        return CGSize(width: 90, height: 130)
    }
    
    /*
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
    //let frame : CGRect = self.view.frame
    //let margin  = (frame.width - 90 * 3) / 6.0
    return UIEdgeInsetsMake(0, 10, 0, 50) // margin between cells
    } */
    

    // MARK: - Table View
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        let result:CGFloat = 140
        if (indexPath.section == 0) {
        
            switch (indexPath.row % 4)
            {
            case 0:
                return 44
            case 2:
                return 44
            default:
                return result
            }
        } else if (indexPath.section == 1) {
            let result:CGFloat = 100
            switch (indexPath.row % 4)
            {
            case 0:
                return 44
            default:
                return result
            }
        } else if (indexPath.section == 2) {
            let result:CGFloat = 100
            switch (indexPath.row % 4)
            {
            case 0:
                return 44
            default:
                return result
            }
        } else if (indexPath.section == 3) {
            
            switch (indexPath.row % 4)
            {
            case 0:
                return 44
            case 2:
                return 44
            default:
                return result
            }
        } else if (indexPath.section == 4) {
            
            switch (indexPath.row % 4)
            {
            case 0:
                return 44
            default:
                return result
            }
        } else if (indexPath.section == 5) {
            
            switch (indexPath.row % 4)
            {
            case 0:
                return 44
            default:
                return result
            }
        } else if (indexPath.section == 6) {
    
            switch (indexPath.row % 4)
            {
            case 0:
            return 44
            default:
            return result
            }
        } else if (indexPath.section == 7) {
            let result:CGFloat = 100
            switch (indexPath.row % 4)
            {
            case 0:
                return 44
            default:
                return result
            }
        } else if (indexPath.section == 8) {
            let result:CGFloat = 100
            switch (indexPath.row % 4)
            {
            case 0:
                return 44
            default:
                return result
            }
        }
        return 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 9
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (section == 0) {
            return 3
        } else if (section == 3) {
            return 3
        }
        return 2
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        return CGFloat.min
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CustomTableCell
        
        cell.collectionView.delegate = nil
        cell.collectionView.dataSource = nil
        cell.collectionView.backgroundColor = UIColor.whiteColor()
        
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad {
            cell.textLabel!.font = Font.Snapshot.celltitle
            cell.snaptitleLabel.font = cellsubtitle
            cell.snapdetailLabel.font = celltitle1
        } else {
            cell.textLabel!.font = Font.Snapshot.celltitle
            cell.snaptitleLabel.font = cellsubtitle
            cell.snapdetailLabel.font = celltitle1
        }
        
        cell.accessoryType = UITableViewCellAccessoryType.None
        cell.textLabel?.text = ""
        
        cell.snaptitleLabel?.numberOfLines = 1
        cell.snaptitleLabel?.text = ""
        cell.snaptitleLabel?.textColor = UIColor.lightGrayColor()
        
        cell.snapdetailLabel?.numberOfLines = 3
        cell.snapdetailLabel?.text = ""
        cell.snapdetailLabel?.textColor = UIColor.blackColor()
        //cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        if (indexPath.section == 0) {
            
            if (indexPath.row == 0) {
                
                cell.textLabel!.text = String(format: "%@%d", "Top News ", _feedItems.count)
                cell.selectionStyle = UITableViewCellSelectionStyle.Gray
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                
                return cell
                
            } else if (indexPath.row == 1) {
                
                cell.collectionView.delegate = self
                cell.collectionView.dataSource = self
                cell.collectionView.tag = 0
                
                return cell
                
            } else if (indexPath.row == 2) {
                
                cell.textLabel!.text = "myNews"
                
                return cell
            }
            
        } else if (indexPath.section == 1) {
            
            if (indexPath.row == 0) {
                
                cell.textLabel!.text = "Top News Story"
                
                return cell
                
            } else if (indexPath.row == 1) {
                
                /*
                let date1 = (_feedItems.firstObject? .valueForKey("createdAt") as? NSDate)!
                let date2 = NSDate()
                let diffDateComponents = NSCalendar.currentCalendar().components([NSCalendarUnit.Day], fromDate: date1, toDate: date2, options: NSCalendarOptions.init(rawValue: 0))
                cell.snaptitleLabel?.text  = String(format: "%@, %d%@" , (_feedItems.firstObject? .valueForKey("newsDetail") as? String)!, diffDateComponents.day," days ago" ) */
                
                cell.collectionView.backgroundColor = UIColor.clearColor()
                cell.snaptitleLabel?.text  = _feedItems.firstObject? .valueForKey("newsDetail") as? String
                cell.snapdetailLabel?.text = _feedItems.firstObject? .valueForKey("newsTitle") as? String
                
                return cell
            }
            
        }  else if (indexPath.section == 2) {
            
            if (indexPath.row == 0) {
                
                cell.textLabel!.text = "Top Blog Story"
                cell.selectionStyle = UITableViewCellSelectionStyle.Gray
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                
                return cell
            } else if (indexPath.row == 1) {
                
                cell.collectionView.backgroundColor = UIColor.clearColor()
                cell.snaptitleLabel?.text = _feedItems6.firstObject? .valueForKey("PostBy") as? String
                cell.snapdetailLabel?.text = _feedItems6.firstObject? .valueForKey("Subject") as? String
                
                return cell
            }
            
        } else if (indexPath.section == 3) {
            
            if (indexPath.row == 0) {
                
                cell.textLabel!.text = String(format: "%@%d", "Top Jobs ", _feedItems2.count)
                cell.selectionStyle = UITableViewCellSelectionStyle.Gray
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                
                return cell
                
            } else if (indexPath.row == 1) {
                
                cell.collectionView.delegate = self
                cell.collectionView.dataSource = self
                cell.collectionView.tag = 1
                
                return cell
            }
            
        } else if (indexPath.section == 4) {
            
            if (indexPath.row == 0) {
                
                cell.textLabel!.text = String(format: "%@%d", "Top Users ", _feedItems3.count)
                cell.selectionStyle = UITableViewCellSelectionStyle.Gray
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                
                return cell
                
            } else if (indexPath.row == 1) {
                
                cell.collectionView.delegate = self
                cell.collectionView.dataSource = self
                cell.collectionView.tag = 2
                
                return cell
                
            } else if (indexPath.row == 2) {
                
                cell.textLabel!.text = "myUser"
                
                return cell
            }
            
        } else if (indexPath.section == 5) {
            
            if (indexPath.row == 0) {
                
                cell.textLabel!.text = String(format: "%@%d", "Top Salesman ", _feedItems4.count)
                cell.selectionStyle = UITableViewCellSelectionStyle.Gray
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                
                return cell
                
            } else if (indexPath.row == 1) {
                
                cell.collectionView.delegate = self
                cell.collectionView.dataSource = self
                cell.collectionView.tag = 3
                
                return cell
            }
            
        } else if (indexPath.section == 6) {
            
            if (indexPath.row == 0) {
                
                cell.textLabel!.text = String(format: "%@%d", "Top Employee ", _feedItems5.count)
                cell.selectionStyle = UITableViewCellSelectionStyle.Gray
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                
                return cell
                
            } else if (indexPath.row == 1) {
                
                cell.collectionView.delegate = self
                cell.collectionView.dataSource = self
                cell.collectionView.tag = 4
                
                return cell
            }
            
        } else if (indexPath.section == 7) {
            
            if (indexPath.row == 0) {
                
                cell.textLabel!.text = "Top Notification"
                cell.selectionStyle = UITableViewCellSelectionStyle.Gray
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                
                return cell
            } else if (indexPath.row == 1) {
                
                cell.collectionView.backgroundColor = UIColor.clearColor()
                
                let localNotification = UILocalNotification()
                if (UIApplication.sharedApplication().scheduledLocalNotifications!.count == 0) {
                    cell.snapdetailLabel?.text = "You have no pending notifications :)"
                } else {
                    cell.snaptitleLabel?.text = localNotification.fireDate?.description
                    cell.snapdetailLabel?.text = localNotification.alertBody
                }
                
                return cell
            }
            
        }  else if (indexPath.section == 8) {
            
            if (indexPath.row == 0) {
                
                cell.textLabel!.text = "Top Calender Event"
                cell.selectionStyle = UITableViewCellSelectionStyle.Gray
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                
                return cell
            } else if (indexPath.row == 1) {
                
                cell.collectionView.backgroundColor = UIColor.clearColor()
                
                if (reminders.count == 0) {
                    cell.snapdetailLabel?.text = "You have no pending events :)"
                    
                } else {
                    
                    let reminder:EKReminder! = self.reminders![0]
                    cell.snapdetailLabel?.text = reminder!.title
                    
                    let formatter:NSDateFormatter = NSDateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    if let dueDate = reminder.dueDateComponents?.date{
                        cell.snaptitleLabel?.text = formatter.stringFromDate(dueDate)
                    }
                }
                
                return cell
            }
        }
        
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section:Int)->Int
    {
        if (collectionView.tag == 0) {
            return _feedItems.count
        } else if (collectionView.tag == 1) {
            return _feedItems2.count
        } else if (collectionView.tag == 2) {
            return _feedItems3.count
        } else if (collectionView.tag == 3) {
            return _feedItems4.count
        } else if (collectionView.tag == 4) {
            return _feedItems5.count
        }
        return 1
    }

    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath:NSIndexPath)->UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CollectionViewCell
        
        let myLabel1:UILabel = UILabel(frame: CGRectMake(0, 110, cell.bounds.size.width, 20))
        myLabel1.backgroundColor = UIColor.whiteColor()
        myLabel1.textColor = UIColor.blackColor()
        myLabel1.textAlignment = NSTextAlignment.Center
        myLabel1.clipsToBounds = true
        myLabel1.font = Font.headtitle
        //myLabel1.adjustsFontSizeToFitWidth = true
        
        if (collectionView.tag == 0) {
            
            let imageObject = _feedItems.objectAtIndex(indexPath.row) as! PFObject
            let imageFile = imageObject.objectForKey("imageFile") as? PFFile
            
            cell.loadingSpinner!.hidden = false
            cell.loadingSpinner!.startAnimating()
            
            imageFile!.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                
                cell.user2ImageView!.backgroundColor = UIColor.blackColor()
                cell.user2ImageView?.image = UIImage(data: imageData!)
                cell.loadingSpinner!.stopAnimating()
                cell.loadingSpinner!.hidden = true
            }
            
            myLabel1.text = _feedItems[indexPath.row] .valueForKey("newsTitle") as? String
            cell.addSubview(myLabel1)
            
            return cell
            
        } else if (collectionView.tag == 1) {
            
            let imageObject = _feedItems2.objectAtIndex(indexPath.row) as! PFObject
            let imageFile = imageObject.objectForKey("imageFile") as? PFFile
            
            cell.loadingSpinner!.hidden = false
            cell.loadingSpinner!.startAnimating()
            
            imageFile!.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                
                cell.user2ImageView!.backgroundColor = UIColor.blackColor()
                cell.user2ImageView?.image = UIImage(data: imageData!)
                cell.loadingSpinner!.stopAnimating()
                cell.loadingSpinner!.hidden = true
            }
            
            myLabel1.text = _feedItems2[indexPath.row] .valueForKey("imageGroup") as? String
            cell.addSubview(myLabel1)
            
            
            return cell
            
        } else if (collectionView.tag == 2) {
            
            let imageObject = _feedItems3.objectAtIndex(indexPath.row) as! PFObject
            let imageFile = imageObject.objectForKey("imageFile") as? PFFile
            
            cell.loadingSpinner!.hidden = false
            cell.loadingSpinner!.startAnimating()
            
            imageFile!.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                
                cell.user2ImageView!.backgroundColor = UIColor.blackColor()
                cell.user2ImageView?.image = UIImage(data: imageData!)
                cell.loadingSpinner!.stopAnimating()
                cell.loadingSpinner!.hidden = true
            }
            
            myLabel1.text = _feedItems3[indexPath.row] .valueForKey("username") as? String
            cell.addSubview(myLabel1)
            
            
            return cell
            
        } else if (collectionView.tag == 3) {
            
            let imageObject = _feedItems4.objectAtIndex(indexPath.row) as! PFObject
            let imageFile = imageObject.objectForKey("imageFile") as? PFFile
            
            cell.loadingSpinner!.hidden = false
            cell.loadingSpinner!.startAnimating()
            
            imageFile!.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                
                cell.user2ImageView!.backgroundColor = UIColor.blackColor()
                cell.user2ImageView?.image = UIImage(data: imageData!)
                cell.loadingSpinner!.stopAnimating()
                cell.loadingSpinner!.hidden = true
            }
            
            myLabel1.text = _feedItems4[indexPath.row] .valueForKey("Salesman") as? String
            cell.addSubview(myLabel1)
            
            return cell
        } else if (collectionView.tag == 4) {
            
            let imageObject = _feedItems5.objectAtIndex(indexPath.row) as! PFObject
            let imageFile = imageObject.objectForKey("imageFile") as? PFFile
            
            cell.loadingSpinner!.hidden = false
            cell.loadingSpinner!.startAnimating()
            
            imageFile!.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                
                cell.user2ImageView!.backgroundColor = UIColor.blackColor()
                cell.user2ImageView?.image = UIImage(data: imageData!)
                cell.loadingSpinner!.stopAnimating()
                cell.loadingSpinner!.hidden = true
            }
            
            myLabel1.text = String(format: "%@ %@ %@ ", (_feedItems5[indexPath.row] .valueForKey("First") as? String)!, (_feedItems5[indexPath.row] .valueForKey("Last") as? String)!, (_feedItems5[indexPath.row] .valueForKey("Company") as? String)!)
            cell.addSubview(myLabel1)
            
            return cell
        }
        
        return cell
    }
    
    
    // MARK: - Parse
    
    func parseData() {
        
        let query = PFQuery(className:"Newsios")
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
        
        let query2 = PFQuery(className:"jobPhoto")
        query2.cachePolicy = PFCachePolicy.CacheThenNetwork
        query2.orderByDescending("createdAt")
        query2.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                let temp: NSArray = objects! as NSArray
                self._feedItems2 = temp.mutableCopy() as! NSMutableArray
                self.tableView!.reloadData()
            } else {
                print("Error")
            }
        }
        
        let query3 = PFUser.query()
        query3!.cachePolicy = PFCachePolicy.CacheThenNetwork
        query3!.orderByDescending("createdAt")
        query3!.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                let temp: NSArray = objects! as NSArray
                self._feedItems3 = temp.mutableCopy() as! NSMutableArray
                self.tableView!.reloadData()
            } else {
                print("Error")
            }
        }
        
        let query4 = PFQuery(className:"Salesman")
        query4.cachePolicy = PFCachePolicy.CacheThenNetwork
        query4.orderByAscending("Salesman")
        query4.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                let temp: NSArray = objects! as NSArray
                self._feedItems4 = temp.mutableCopy() as! NSMutableArray
                self.tableView!.reloadData()
            } else {
                print("Error")
            }
        }
        
        let query5 = PFQuery(className:"Employee")
        query5.cachePolicy = PFCachePolicy.CacheThenNetwork
        query5.orderByAscending("createdAt")
        query5.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                let temp: NSArray = objects! as NSArray
                self._feedItems5 = temp.mutableCopy() as! NSMutableArray
                self.tableView!.reloadData()
            } else {
                print("Error")
            }
        }
        
        let query6 = PFQuery(className:"Blog")
        query6.whereKey("ReplyId", equalTo:NSNull())
        query6.cachePolicy = PFCachePolicy.CacheThenNetwork
        query6.orderByDescending("createdAt")
        query6.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                let temp: NSArray = objects! as NSArray
                self._feedItems6 = temp.mutableCopy() as! NSMutableArray
                self.tableView!.reloadData()
            } else {
                print("Error")
            }
        }
        //self.tableView!.reloadData()
    }
    
    // MARK: - Segues
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        if (collectionView.tag == 0) {
            
            imageObject = _feedItems.objectAtIndex(indexPath.row) as! PFObject
            imageFile = imageObject.objectForKey("imageFile") as? PFFile
            imageFile!.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                
                self.selectedImage = UIImage(data: imageData!)
                self.selectedObjectId = self._feedItems[indexPath.row] .valueForKey("objectId") as? String
                self.selectedTitle = self._feedItems[indexPath.row] .valueForKey("newsTitle") as? String
                self.selectedEmail = self._feedItems[indexPath.row] .valueForKey("newsDetail") as? String
                self.selectedPhone = self._feedItems[indexPath.row] .valueForKey("storyText") as? String
                self.imageDetailurl = self.imageFile.url
                
                let date1 = (self._feedItems[indexPath.row] .valueForKey("createdAt") as? NSDate)!
                let date2 = NSDate()
                let diffDateComponents = NSCalendar.currentCalendar().components([NSCalendarUnit.Day], fromDate: date1, toDate: date2, options: NSCalendarOptions.init(rawValue: 0))
                self.resultDateDiff = String(format: "%d%@" , diffDateComponents.day," days ago" )
                self.selectedCreate = self.resultDateDiff
                
                self.performSegueWithIdentifier("snapuploadSegue", sender:self)
            }
        } else if (collectionView.tag == 1) {
            
            imageObject = _feedItems2.objectAtIndex(indexPath.row) as! PFObject
            imageFile = imageObject.objectForKey("imageFile") as? PFFile
            imageFile!.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                
                self.selectedImage = UIImage(data: imageData!)
                self.selectedTitle = self._feedItems2[indexPath.row] .valueForKey("imageGroup") as? String
            self.performSegueWithIdentifier("snapuploadSegue", sender:self)
            }
            
        } else if (collectionView.tag == 2) {
            
            imageObject = _feedItems3.objectAtIndex(indexPath.row) as! PFObject
            imageFile = imageObject.objectForKey("imageFile") as? PFFile
            imageFile!.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                
                self.selectedImage = UIImage(data: imageData!)
                self.selectedObjectId = self._feedItems3[indexPath.row] .valueForKey("objectId") as? String
                self.selectedName = self._feedItems3[indexPath.row] .valueForKey("username") as? String
                self.selectedEmail = self._feedItems3[indexPath.row] .valueForKey("email") as? String
                self.selectedPhone = self._feedItems3[indexPath.row] .valueForKey("phone") as? String
                
                let updated:NSDate = (self._feedItems3[(indexPath.row)] .valueForKey("createdAt") as? NSDate)!
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MMM dd, yyyy"
                let createString = dateFormatter.stringFromDate(updated)
                self.selectedCreate = createString
                
                self.performSegueWithIdentifier("userdetailSegue", sender:self)
            }
        } else if (collectionView.tag == 3) {
            
            imageObject = _feedItems4.objectAtIndex(indexPath.row) as! PFObject
            imageFile = imageObject.objectForKey("imageFile") as? PFFile
            imageFile!.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                
                self.selectedImage = UIImage(data: imageData!)
                self.selectedObjectId = self._feedItems4[indexPath.row] .valueForKey("objectId") as? String
                self.selectedEmail = self._feedItems4[indexPath.row] .valueForKey("SalesNo") as? String
                self.selectedPhone = self._feedItems4[indexPath.row] .valueForKey("Active") as? String
                self.selectedTitle = self._feedItems4[indexPath.row] .valueForKey("Salesman") as? String
                
                self.performSegueWithIdentifier("snapuploadSegue", sender:self)
            }
        } else if (collectionView.tag == 4) {
            
            imageObject = _feedItems4.objectAtIndex(indexPath.row) as! PFObject
            imageFile = imageObject.objectForKey("imageFile") as? PFFile
            imageFile!.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                
                //self.selectedImage = UIImage(data: imageData!)
                self.selectedObjectId = self._feedItems5[indexPath.row] .valueForKey("objectId") as? String
                self.selectedPhone = self._feedItems5[indexPath.row] .valueForKey("EmployeeNo") as? String
                self.selectedCreate = self._feedItems5[indexPath.row] .valueForKey("Email") as? String
                
                self.selectedName = self._feedItems5[indexPath.row] .valueForKey("SalesNo") as? String
                
                self.selectedTitle = self._feedItems5[indexPath.row] .valueForKey("Last") as? String
                self.selectedEmail = self._feedItems5[indexPath.row] .valueForKey("Street") as? String
                self.imageDetailurl = self._feedItems5[indexPath.row] .valueForKey("City") as? String
                self.selectedState = self._feedItems5[indexPath.row] .valueForKey("State") as? String
                self.selectedZip = self._feedItems5[indexPath.row] .valueForKey("Zip") as? String
                
                self.selectedAmount = self._feedItems5[indexPath.row] .valueForKey("Title") as? String
                self.selected11 = self._feedItems5[indexPath.row] .valueForKey("HomePhone") as? String
                self.selected12 = self._feedItems5[indexPath.row] .valueForKey("WorkPhone") as? String
                self.selected13 = self._feedItems5[indexPath.row] .valueForKey("CellPhone") as? String
                self.selected14 = self._feedItems5[indexPath.row] .valueForKey("SS") as? String
                self.selected15 = self._feedItems5[indexPath.row] .valueForKey("Middle") as? String
                
                self.selected21 = self._feedItems5[indexPath.row] .valueForKey("Email") as? String
                self.selected22 = self._feedItems5[indexPath.row] .valueForKey("Department") as? String
                self.selected23 = self._feedItems5[indexPath.row] .valueForKey("Title") as? String
                self.selected24 = self._feedItems5[indexPath.row] .valueForKey("Manager") as? String
                self.selected25 = self._feedItems5[indexPath.row] .valueForKey("Country") as? String
                
                self.selected16 = String(self._feedItems5[indexPath.row] .valueForKey("updatedAt") as? NSDate)
                self.selected26 = self._feedItems5[indexPath.row] .valueForKey("First") as? String
                self.selected27 = self._feedItems5[indexPath.row] .valueForKey("Company") as? String
                self.selectedComments = self._feedItems5[indexPath.row] .valueForKey("Comments") as? String
                self.selectedActive = self._feedItems5[indexPath.row] .valueForKey("Active") as? String
                
                self.performSegueWithIdentifier("snapemployeeSegue", sender:self)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "snapuploadSegue" {
            
            let VC = segue.destinationViewController as? NewsDetailController
            VC!.objectId = self.selectedObjectId
            VC!.newsTitle = self.selectedTitle
            VC!.newsDetail = self.selectedEmail
            VC!.newsDate = self.selectedCreate
            VC!.newsStory = self.selectedPhone
            VC!.image = self.selectedImage
            VC!.imageDetailurl = self.imageDetailurl
            
        } else if segue.identifier == "userdetailSegue" {
            
            let VC = segue.destinationViewController as? UserDetailController
            VC!.objectId = self.selectedObjectId
            VC!.username = self.selectedName
            VC!.create = self.selectedCreate
            VC!.email = self.selectedEmail
            VC!.phone = self.selectedPhone
            VC!.userimage = self.selectedImage
            
        } else if segue.identifier == "snapemployeeSegue" {
            
            let VC = segue.destinationViewController as? LeadDetail
            VC!.formController = "Employee"
            VC!.objectId = self.selectedObjectId as String
            VC!.leadNo = self.selectedPhone as String
            VC!.date = self.selectedCreate as String
            VC!.name = self.selectedName as String
            VC!.custNo = self.selectedTitle as String
            VC!.address = self.selectedEmail as String
            VC!.city = self.imageDetailurl as String
            VC!.state = self.selectedState as String
            VC!.zip = self.selectedZip as String
            VC!.amount = self.selectedAmount as String
            VC!.tbl11 = self.selected11
            VC!.tbl12 = self.selected12
            VC!.tbl13 = self.selected13
            VC!.tbl14 = self.selected14
            VC!.tbl15 = self.selected15
            VC!.tbl21 = self.selected21
            VC!.tbl22 = self.selected22
            VC!.tbl23 = self.selected23
            VC!.tbl24 = self.selected24
            VC!.tbl25 = self.selected25
            VC!.tbl16 = self.selected16
            VC!.tbl26 = self.selected26
            VC!.tbl27 = self.selected27
            VC!.comments = self.selectedComments
            VC!.active = self.selectedActive
            
            VC!.l11 = "Home"; VC!.l12 = "Work"
            VC!.l13 = "Mobile"; VC!.l14 = "Social"
            VC!.l15 = "Middle "; VC!.l21 = "Email"
            VC!.l22 = "Department"; VC!.l23 = "Title"
            VC!.l24 = "Manager"; VC!.l25 = "Country"
            VC!.l16 = "Last Updated"; VC!.l26 = "First"
            VC!.l1datetext = "Email:"
            VC!.lnewsTitle = Config.NewsEmploy
        }
        
    }
    
    
}
//-----------------------end------------------------------

