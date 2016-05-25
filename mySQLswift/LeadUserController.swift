//
//  LeadUserController.swift
//  mySQLswift
//
//  Created by Peter Balsamo on 1/2/16.
//  Copyright © 2016 Peter Balsamo. All rights reserved.
//

import UIKit
import Parse

class LeadUserController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cellHeadtitle = UIFont.systemFontOfSize(20, weight: UIFontWeightBold)
    let cellHeadsubtitle = UIFont.systemFontOfSize(18, weight: UIFontWeightLight)
    let cellHeadlabel = UIFont.systemFontOfSize(18, weight: UIFontWeightRegular)
    
    let ipadtitle = UIFont.systemFontOfSize(20, weight: UIFontWeightRegular)
    let ipadsubtitle = UIFont.systemFontOfSize(16, weight: UIFontWeightRegular)
    let ipadlabel = UIFont.systemFontOfSize(16, weight: UIFontWeightRegular)
    
    let cellsubtitle = UIFont.systemFontOfSize(16, weight: UIFontWeightRegular)
    let celllabel = UIFont.systemFontOfSize(16, weight: UIFontWeightRegular)
    let headtitle = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
    
    @IBOutlet weak var tableView: UITableView?

    var _feedItems : NSMutableArray = NSMutableArray()
    var _feedheadItems : NSMutableArray = NSMutableArray()
    var filteredString : NSMutableArray = NSMutableArray()
    var objects = [AnyObject]()
    var pasteBoard = UIPasteboard.generalPasteboard()
    var refreshControl: UIRefreshControl!
    
    var emptyLabel : UILabel?
    var objectId : NSString?
    var leadDate : NSString?
    var postBy : NSString?
    var comments : NSString?
    
    var formController : NSString?
    
    //var selectedImage : UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleButton: UIButton = UIButton(frame: CGRectMake(0, 0, 100, 32))
        titleButton.setTitle(formController as? String, forState: UIControlState.Normal)
        titleButton.titleLabel?.font = Font.navlabel
        titleButton.titleLabel?.textAlignment = NSTextAlignment.Center
        titleButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        titleButton.addTarget(self, action: Selector(), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.titleView = titleButton
        
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        self.tableView!.estimatedRowHeight = 110
        self.tableView!.rowHeight = UITableViewAutomaticDimension
        self.tableView!.backgroundColor = UIColor.whiteColor()
        tableView!.tableFooterView = UIView(frame: .zero)
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.parseData()
        
        //self.selectedImage = UIImage(named:"profile-rabbit-toy.png")
        if (self.formController == "Blog") {
        self.comments = "90 percent of my picks made $$$. The stock whisper has traded over 1000 traders worldwide"
        }
        
        let shareButton = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: Selector())
        let buttons:NSArray = [shareButton]
        self.navigationItem.rightBarButtonItems = buttons as? [UIBarButtonItem]
        
        self.refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.clearColor()
        refreshControl.tintColor = UIColor.blackColor()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(LeadUserController.refreshData), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView!.addSubview(refreshControl)
        
        emptyLabel = UILabel(frame: self.view.bounds)
        emptyLabel!.textAlignment = NSTextAlignment.Center
        emptyLabel!.textColor = UIColor.lightGrayColor()
        emptyLabel!.text = "You have no customer data :)"
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //navigationController?.hidesBarsOnSwipe = true
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = UIColor(white:0.45, alpha:1.0)

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //navigationController?.hidesBarsOnSwipe = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - refresh
    
    func refreshData(sender:AnyObject)
    {
        self.tableView!.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    // MARK: - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.tableView {
            return _feedItems.count
        }
        //return foundUsers.count
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cellIdentifier: String!
        
        if tableView == self.tableView {
            cellIdentifier = "Cell"
        } else {
            cellIdentifier = "UserFoundCell"
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! CustomTableCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.blogsubtitleLabel!.textColor = UIColor.grayColor()
        
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad {
            cell.blogtitleLabel!.font = ipadtitle
            cell.blogsubtitleLabel!.font = ipadsubtitle
            cell.blogmsgDateLabel!.font = ipadlabel
            cell.commentLabel!.font = ipadlabel
        } else {
            cell.blogtitleLabel!.font = Font.celltitle
            cell.blogsubtitleLabel!.font = cellsubtitle
            cell.blogmsgDateLabel!.font = celllabel
            cell.commentLabel!.font = celllabel

        }
        
        let dateStr : String
        let dateFormatter = NSDateFormatter()
        
        if (self.formController == "Blog") {
            dateStr = (_feedItems[indexPath.row] .valueForKey("MsgDate") as? String)!
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        } else {
            dateStr = (_feedItems[indexPath.row] .valueForKey("Date") as? String)!
            dateFormatter.dateFormat = "yyyy-MM-dd"
        }
    
        let date:NSDate = dateFormatter.dateFromString(dateStr)as NSDate!
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
        if (self.formController == "Blog") {
            
            cell.blogtitleLabel!.text = _feedItems[indexPath.row] .valueForKey("PostBy") as? String
            cell.blogsubtitleLabel!.text = _feedItems[indexPath.row] .valueForKey("Subject") as? String
            cell.blogmsgDateLabel!.text = dateFormatter.stringFromDate(date)as String!
            var CommentCount:Int? = _feedItems[indexPath.row] .valueForKey("CommentCount")as? Int
            if CommentCount == nil {
                CommentCount = 0
            }
            cell.commentLabel?.text = "\(CommentCount!)"
            
        } else {
            
            let formatter = NSNumberFormatter()
            formatter.numberStyle = .CurrencyStyle
            cell.blogtitleLabel!.text = _feedItems[indexPath.row] .valueForKey("LastName") as? String
            cell.blogsubtitleLabel!.text = _feedItems[indexPath.row] .valueForKey("City") as? String
            cell.blogmsgDateLabel!.text = dateFormatter.stringFromDate(date)as String!
            var CommentCount:Int? = _feedItems[indexPath.row] .valueForKey("Amount")as? Int
            if CommentCount == nil {
                CommentCount = 0
            }
            cell.commentLabel?.text = formatter.stringFromNumber(CommentCount!)
        }
        
        cell.actionBtn.tintColor = UIColor.lightGrayColor()
        let imagebutton : UIImage? = UIImage(named:"Upload50.png")!.imageWithRenderingMode(.AlwaysTemplate)
        cell.actionBtn .setImage(imagebutton, forState: .Normal)
        //actionBtn .addTarget(self, action: "shareButton:", forControlEvents: UIControlEvents.TouchUpInside)
        
        cell.replyButton.tintColor = UIColor.lightGrayColor()
        let replyimage : UIImage? = UIImage(named:"Commentfilled.png")!.imageWithRenderingMode(.AlwaysTemplate)
        cell.replyButton .setImage(replyimage, forState: .Normal)
        //cell.replyButton .addTarget(self, action: "replyButton:", forControlEvents: UIControlEvents.TouchUpInside)
        
        if !(cell.commentLabel.text! == "0") {
            cell.commentLabel.textColor = UIColor.lightGrayColor()
        } else {
            cell.commentLabel.text! = ""
        }
        
        if (cell.commentLabel.text! == "") {
            cell.replyButton.tintColor = UIColor.lightGrayColor()
        } else {
            cell.replyButton.tintColor = UIColor.redColor()
        }
        
        let myLabel:UILabel = UILabel(frame: CGRectMake(10, 10, 50, 50))
        if (self.formController == "Leads") {
            myLabel.text = "Cust"
        } else if (self.formController == "Customer") {
            myLabel.text = "Lead"
        } else if (self.formController == "Blog") {
            myLabel.text = "Blog"
        }
        myLabel.backgroundColor = UIColor(red: 0.02, green: 0.75, blue: 1.0, alpha: 1.0)
        myLabel.textColor = UIColor.whiteColor()
        myLabel.textAlignment = NSTextAlignment.Center
        myLabel.layer.masksToBounds = true
        myLabel.font = headtitle
        myLabel.layer.cornerRadius = 25.0
        myLabel.userInteractionEnabled = true
        cell.addSubview(myLabel)
        
        /*
        cell.blog2ImageView?.image = self.selectedImage
        cell.blog2ImageView!.userInteractionEnabled = true
        //cell.blog2ImageView!.contentMode = UIViewContentModeScaleToFill
        cell.blog2ImageView!.clipsToBounds = true
        //cell.blog2ImageView!.contentMode = uiv */
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 180.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let vw = UIView()
        vw.backgroundColor = UIColor(white:0.90, alpha:1.0)
        //tableView.tableHeaderView = vw
        
        let myLabel4:UILabel = UILabel(frame: CGRectMake(10, 70, self.tableView!.frame.size.width-20, 50))
        let myLabel5:UILabel = UILabel(frame: CGRectMake(10, 105, self.tableView!.frame.size.width-20, 50))
        let myLabel6:UILabel = UILabel(frame: CGRectMake(10, 140, self.tableView!.frame.size.width-20, 50))
        
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad {
            myLabel4.font = cellHeadtitle
            myLabel5.font = cellHeadsubtitle
            myLabel6.font = cellHeadlabel
        } else {
            myLabel4.font = cellHeadtitle
            myLabel5.font = cellHeadsubtitle
            myLabel6.font = cellHeadlabel
        }
        
        let myLabel1:UILabel = UILabel(frame: CGRectMake(10, 15, 50, 50))
        myLabel1.numberOfLines = 0
        myLabel1.backgroundColor = UIColor.whiteColor()
        myLabel1.textColor = UIColor.blackColor()
        myLabel1.textAlignment = NSTextAlignment.Center
        myLabel1.layer.masksToBounds = true
        myLabel1.text = String(format: "%@%d", "Count\n", _feedItems.count)
        myLabel1.font = headtitle
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
        myLabel2.font = headtitle
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
        myLabel3.font = headtitle
        myLabel3.layer.cornerRadius = 25.0
        myLabel3.userInteractionEnabled = true
        vw.addSubview(myLabel3)
        
        myLabel4.numberOfLines = 1
        myLabel4.backgroundColor = UIColor.clearColor()
        myLabel4.textColor = UIColor.blackColor()
        myLabel4.layer.masksToBounds = true
        myLabel4.text = self.postBy as? String
        vw.addSubview(myLabel4)
        
        myLabel5.numberOfLines = 0
        myLabel5.backgroundColor = UIColor.clearColor()
        myLabel5.textColor = UIColor.blackColor()
        myLabel5.layer.masksToBounds = true
        myLabel5.text = self.comments as? String
        vw.addSubview(myLabel5)
        
        if (self.formController == "Leads") || (self.formController == "Customer") {
            var dateStr = self.leadDate as? String
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let date:NSDate = dateFormatter.dateFromString(dateStr!) as NSDate!
            dateFormatter.dateFormat = "MMM dd, yyyy"
            dateStr = dateFormatter.stringFromDate(date)as String!
        
            var newString6 : String
            if (self.formController == "Leads") {
                newString6 = String(format: "%@%@", "Lead since ", dateStr!)
                myLabel6.text = newString6
            } else if (self.formController == "Customer") {
                newString6 = String(format: "%@%@", "Customer since ", dateStr!)
                myLabel6.text = newString6
            } else if (self.formController == "Blog") {
                newString6 = String(format: "%@%@", "Member since ", (self.leadDate as? String)!)
                myLabel6.text = newString6
            }
        }
    
        myLabel6.numberOfLines = 1
        myLabel6.backgroundColor = UIColor.clearColor()
        myLabel6.textColor = UIColor.blackColor()
        myLabel6.layer.masksToBounds = true
        //myLabel6.text = newString6
        vw.addSubview(myLabel6)
        
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
        
        if (action == #selector(NSObject.copy(_:))) {
            return true
        }
        return false
    }
    
    func tableView(tableView: UITableView, performAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        pasteBoard.string = cell!.textLabel?.text
    }
    
    // MARK: - Parse
    
    func parseData() {
        
        if (self.formController == "Leads") {
            let query = PFQuery(className:"Customer")
            query.limit = 1000
            query.whereKey("LastName", equalTo:self.postBy!)
            query.cachePolicy = PFCachePolicy.CacheThenNetwork
            query.orderByDescending("createdAt")
            query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil {
                    let temp: NSArray = objects! as NSArray
                    self._feedItems = temp.mutableCopy() as! NSMutableArray
                    
                    if (self._feedItems.count == 0) {
                        self.tableView!.addSubview(self.emptyLabel!)
                    } else {
                        self.emptyLabel!.removeFromSuperview()
                    }
                    
                    self.tableView!.reloadData()
                } else {
                    print("Error")
                }
            }
            
            let query1 = PFQuery(className:"Leads")
            query1.limit = 1
            query1.whereKey("objectId", equalTo:self.objectId!)
            query1.cachePolicy = PFCachePolicy.CacheThenNetwork
            query1.orderByDescending("createdAt")
            query1.getFirstObjectInBackgroundWithBlock {(object: PFObject?, error: NSError?) -> Void in
                if error == nil {
                    self.comments = object!.objectForKey("Coments") as! String
                    self.leadDate = object!.objectForKey("Date") as! String
                    self.tableView!.reloadData()
                } else {
                    print("Error")
                }
            }
        } else if (self.formController == "Customer") {
            
            let query = PFQuery(className:"Leads")
            query.limit = 1000
            query.whereKey("LastName", equalTo:self.postBy!)
            query.cachePolicy = PFCachePolicy.CacheThenNetwork
            query.orderByDescending("createdAt")
            query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil {
                    let temp: NSArray = objects! as NSArray
                    self._feedItems = temp.mutableCopy() as! NSMutableArray
                    
                    if (self._feedItems.count == 0) {
                        self.tableView!.addSubview(self.emptyLabel!)
                    } else {
                        self.emptyLabel!.removeFromSuperview()
                    }
                    
                    self.tableView!.reloadData()
                } else {
                    print("Error")
                }
            }
            
            let query1 = PFQuery(className:"Customer")
            query1.limit = 1
            query1.whereKey("objectId", equalTo:self.objectId!)
            query1.cachePolicy = PFCachePolicy.CacheThenNetwork
            query1.orderByDescending("createdAt")
            query1.getFirstObjectInBackgroundWithBlock {(object: PFObject?, error: NSError?) -> Void in
                if error == nil {
                    self.comments = object!.objectForKey("Comments") as! String
                    self.leadDate = object!.objectForKey("Date") as! String
                    self.tableView!.reloadData()
                } else {
                    print("Error")
                }
            }
        } else if (self.formController == "Blog") {
            
            let query = PFQuery(className:"Blog")
            query.limit = 1000
            query.whereKey("PostBy", equalTo:self.postBy!)
            query.cachePolicy = PFCachePolicy.CacheThenNetwork
            query.orderByDescending("createdAt")
            query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil {
                    let temp: NSArray = objects! as NSArray
                    self._feedItems = temp.mutableCopy() as! NSMutableArray
                    
                    if (self._feedItems.count == 0) {
                        self.tableView!.addSubview(self.emptyLabel!)
                    } else {
                        self.emptyLabel!.removeFromSuperview()
                    }
                    
                    self.tableView!.reloadData()
                } else {
                    print("Error")
                }
            }
            
            let query1:PFQuery = PFUser.query()!
            query1.whereKey("username",  equalTo:self.postBy!)
            query1.limit = 1
            query1.cachePolicy = PFCachePolicy.CacheThenNetwork
            query1.getFirstObjectInBackgroundWithBlock {(object: PFObject?, error: NSError?) -> Void in
                if error == nil {
                    
                    self.postBy = object!.objectForKey("username") as! String
                    /*
                    let dateStr = (object!.objectForKey("createdAt") as? NSDate)!
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "MMM dd, yyyy"
                    let createAtString = dateFormatter.stringFromDate(dateStr)as String!
                    self.leadDate = createAtString */

                    /*
                    if let imageFile = object!.objectForKey("imageFile") as? PFFile {
                        imageFile.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                            self.selectedImage = UIImage(data: imageData!)
                            self.tableView!.reloadData()
                        }
                    } */
                }
            }
            
        }
    }
    
    // MARK: - Segues
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
}
