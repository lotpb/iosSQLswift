//
//  Blog.swift
//  mySQLswift
//
//  Created by Peter Balsamo on 12/8/15.
//  Copyright © 2015 Peter Balsamo. All rights reserved.
//

import UIKit
import Parse

class Blog: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let navColor = UIColor.redColor()
    let borderbtnColor = UIColor.lightGrayColor().CGColor
    //let labelColor1 = UIColor(white:0.45, alpha:1.0)
    let buttonColor = UIColor.redColor()
    let searchScope = ["subject", "date", "rating", "postby"]
    
    @IBOutlet weak var tableView: UITableView?
    
    var _feedItems : NSMutableArray = NSMutableArray()
    var _feedheadItems : NSMutableArray = NSMutableArray()
    var filteredString : NSMutableArray = NSMutableArray()
    
    var buttonView: UIView?
    var likeButton: UIButton?
    var refreshControl: UIRefreshControl!
    let searchController = UISearchController(searchResultsController: nil)
    var parseObject:PFObject?
    var isReplyClicked = true
    var posttoIndex: NSString?
    var userIndex: NSString?
    var titleLabel = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleButton: UIButton = UIButton(frame: CGRectMake(0, 0, 100, 32))
        titleButton.setTitle("myBlog", forState: UIControlState.Normal)
        titleButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 25.0)
        titleButton.titleLabel?.textAlignment = NSTextAlignment.Center
        titleButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        titleButton.addTarget(self, action: Selector(), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.titleView = titleButton
        
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        self.tableView!.estimatedRowHeight = 110
        self.tableView!.rowHeight = UITableViewAutomaticDimension
        self.tableView!.backgroundColor =  UIColor(white:0.90, alpha:1.0)
        self.tableView!.contentInset = UIEdgeInsetsMake(64.0, 0.0, 0.0, 0.0)

        //self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action:"newButton:")
        let searchButton = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action:"searchButton:")
        let buttons:NSArray = [addButton,searchButton]
        self.navigationItem.rightBarButtonItems = buttons as? [UIBarButtonItem]

        /*
        if let split = self.splitViewController {
           let controllers = split.viewControllers
           self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        } */
        
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
        refreshData(self)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = navColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - refresh
    
    func refreshData(sender:AnyObject) {
        parseData()
        self.refreshControl?.endRefreshing()
    }
    
    // MARK: - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.active {
            return filteredString.count
        }
        else {
            return _feedItems.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! CustomTableCell!
        
        if cell == nil {
            cell = CustomTableCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad {
            cell.blogtitleLabel.font = UIFont (name: "HelveticaNeue-Medium", size: 18)
            cell.blogsubtitleLabel.font = UIFont (name: "HelveticaNeue-Light", size: 18)
            cell.blogmsgDateLabel.font = UIFont (name: "HelveticaNeue-Light", size: 16)
            cell.numLabel.font = UIFont (name: "HelveticaNeue-Bold", size: 16)
            cell.commentLabel.font = UIFont (name: "HelveticaNeue-Bold", size: 16)
        } else {
            cell.blogtitleLabel.font = UIFont (name: "HelveticaNeue-Medium", size: 17)
            cell.blogsubtitleLabel.font = UIFont (name: "HelveticaNeue-Light", size: 17)
            cell.blogmsgDateLabel.font = UIFont (name: "HelveticaNeue-Light", size: 14)
            cell.numLabel.font = UIFont (name: "HelveticaNeue-Bold", size: 16)
            cell.commentLabel.font = UIFont (name: "HelveticaNeue-Bold", size: 16)
        }
        
        let query:PFQuery = PFUser.query()!
        query.whereKey("username",  equalTo:self._feedItems[indexPath.row] .valueForKey("PostBy") as! String)
        query.cachePolicy = PFCachePolicy.CacheThenNetwork
        query.getFirstObjectInBackgroundWithBlock {(object: PFObject?, error: NSError?) -> Void in
            if error == nil {
                if let imageFile = object!.objectForKey("imageFile") as? PFFile {
                    imageFile.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                        cell.blogImageView?.image = UIImage(data: imageData!)
                    }
                }
            }
        } 
        
        cell.blogImageView?.contentMode = UIViewContentMode.ScaleToFill
        cell.blogImageView?.clipsToBounds = true
        cell.blogImageView?.layer.cornerRadius = (cell.blogImageView?.frame.size.width)! / 2
        cell.blogImageView?.layer.borderColor = UIColor.lightGrayColor().CGColor
        cell.blogImageView?.layer.borderWidth = 0.5
        cell.blogImageView?.userInteractionEnabled = true
        cell.blogImageView?.tag = indexPath.row
        
        let tap = UITapGestureRecognizer(target: self, action:Selector("imgLoadSegue:"))
        cell.blogImageView.addGestureRecognizer(tap)
        
        let dateStr = _feedItems[indexPath.row] .valueForKey("MsgDate") as? String
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date:NSDate = dateFormatter.dateFromString(dateStr!)as NSDate!
        dateFormatter.dateFormat = "MMM-dd"

        if searchController.active {
            cell.blogtitleLabel?.text = filteredString[indexPath.row] .valueForKey("PostBy") as? String
            cell.blogsubtitleLabel?.text = filteredString[indexPath.row] .valueForKey("Subject") as? String
            cell.blogmsgDateLabel?.text = filteredString[indexPath.row] .valueForKey("MsgDate") as? String
            cell.numLabel?.text = filteredString[indexPath.row] .valueForKey("Liked") as? String
            cell.commentLabel?.text = filteredString[indexPath.row] .valueForKey("CommentCount") as? String
        } else {
            cell.blogtitleLabel?.text = _feedItems[indexPath.row] .valueForKey("PostBy") as? String
            cell.blogsubtitleLabel?.text = _feedItems[indexPath.row] .valueForKey("Subject") as? String
            cell.blogmsgDateLabel?.text = dateFormatter.stringFromDate(date)as String!
            
            var Liked:Int? = _feedItems[indexPath.row] .valueForKey("Liked")as? Int
            if Liked == nil {
                Liked = 0
            }
            cell.numLabel?.text = "\(Liked!)"
            
            var CommentCount:Int? = _feedItems[indexPath.row] .valueForKey("CommentCount")as? Int
            if CommentCount == nil {
                CommentCount = 0
            }
            cell.commentLabel?.text = "\(CommentCount!)"
        }

        cell.replyButton.tintColor = UIColor.lightGrayColor()
        let replyimage : UIImage? = UIImage(named:"Commentfilled.png")!.imageWithRenderingMode(.AlwaysTemplate)
        cell.replyButton .setImage(replyimage, forState: .Normal)
        cell.replyButton .addTarget(self, action: "replyButton:", forControlEvents: UIControlEvents.TouchUpInside)
        
        cell.likeButton.tintColor = UIColor.lightGrayColor()
        let likeimage : UIImage? = UIImage(named:"Thumb Up.png")!.imageWithRenderingMode(.AlwaysTemplate)
        cell.likeButton .setImage(likeimage, forState: .Normal)
        //cell.likeButton .addTarget(self, action: "buttonPress:", forControlEvents: UIControlEvents.TouchDown)
        cell.likeButton .addTarget(self, action: "likeButton:", forControlEvents: UIControlEvents.TouchUpInside)

        cell.flagButton.tintColor = UIColor.lightGrayColor()
        let reportimage : UIImage? = UIImage(named:"Flag.png")!.imageWithRenderingMode(.AlwaysTemplate)
        cell.flagButton .setImage(reportimage, forState: .Normal)
        cell.flagButton .addTarget(self, action: "flagButton:", forControlEvents: UIControlEvents.TouchUpInside)
  
        cell.actionBtn.tintColor = UIColor.lightGrayColor()
        let actionimage : UIImage? = UIImage(named:"Upload50.png")!.imageWithRenderingMode(.AlwaysTemplate)
        cell.actionBtn .setImage(actionimage, forState: .Normal)
        cell.actionBtn .addTarget(self, action: "share:", forControlEvents: UIControlEvents.TouchUpInside)
        
        if !(cell.numLabel.text! == "0") {
            cell.numLabel.textColor = buttonColor
        } else {
            cell.numLabel.text! = ""
        }
        
        if !(cell.commentLabel.text! == "0") {
            cell.commentLabel.textColor = UIColor.lightGrayColor()
        } else {
            cell.commentLabel.text! = ""
        }
        
        if (cell.commentLabel.text! == "") {
            cell.replyButton.tintColor = UIColor.lightGrayColor()
        } else {
            cell.replyButton.tintColor = buttonColor
        }

        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if !searchController.active {
            return 90.0
        } else {
            return 0.0
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()
        vw.backgroundColor = navColor
        //tableView.tableHeaderView = vw
        
        let myLabel1:UILabel = UILabel(frame: CGRectMake(10, 15, 50, 50))
        myLabel1.numberOfLines = 0
        myLabel1.backgroundColor = UIColor.whiteColor()
        myLabel1.textColor = UIColor.blackColor()
        myLabel1.textAlignment = NSTextAlignment.Center
        myLabel1.layer.masksToBounds = true
        myLabel1.text = String(format: "%@%d", "Blog\n", _feedItems.count)
        myLabel1.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
        myLabel1.layer.cornerRadius = 25.0
        myLabel1.layer.borderColor = borderbtnColor
        myLabel1.layer.borderWidth = 1
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
        myLabel2.text = String(format: "%@%d", "Likes\n", _feedheadItems.count)
        myLabel2.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
        myLabel2.layer.cornerRadius = 25.0
        myLabel2.layer.borderColor = borderbtnColor
        myLabel2.layer.borderWidth = 1
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
        myLabel3.layer.borderColor = borderbtnColor
        myLabel3.layer.borderWidth = 1
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
            
            let query = PFQuery(className:"Blog")
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
    
    // MARK: - Button
    
    func newButton(sender: AnyObject) {
        
        isReplyClicked = false
        self.performSegueWithIdentifier("blognewSegue", sender: self)
    }
    
    func likeButton(sender:UIButton) {

        likeButton?.selected = true
        sender.tintColor = UIColor.redColor()
        let hitPoint = sender.convertPoint(CGPointZero, toView: self.tableView)
        let indexPath = self.tableView!.indexPathForRowAtPoint(hitPoint)
        
        let query = PFQuery(className:"Blog")
        query.whereKey("objectId", equalTo:(_feedItems.objectAtIndex((indexPath?.row)!) .valueForKey("objectId") as? String)!)
        query.getFirstObjectInBackgroundWithBlock {(object: PFObject?, error: NSError?) -> Void in
            if error == nil {
                object!.incrementKey("Liked")
                object!.saveInBackground()
            }
        }
    }
    
    func replyButton(sender:UIButton) {
 
        isReplyClicked = true
        let hitPoint = sender.convertPoint(CGPointZero, toView: self.tableView)
        let indexPath = self.tableView!.indexPathForRowAtPoint(hitPoint)
        
        posttoIndex = _feedItems.objectAtIndex((indexPath?.row)!) .valueForKey("PostBy") as? String
        userIndex = _feedItems.objectAtIndex((indexPath?.row)!) .valueForKey("objectId") as? String
        self.performSegueWithIdentifier("blognewSegue", sender: self)
    }
    
    func share(sender: AnyObject) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let email = UIAlertAction(title: "Email this Message", style: .Default) { (alert: UIAlertAction!) -> Void in
            NSLog("You pressed button one")
        }
        
        let sms = UIAlertAction(title: "SMS this Message", style: .Default) { (alert: UIAlertAction!) -> Void in
            NSLog("You pressed button two")
        }
        
        let follow = UIAlertAction(title: "Follow", style: .Default) { (alert: UIAlertAction!) -> Void in
            NSLog("You pressed button one")
        }
        
        let block = UIAlertAction(title: "Block this Message", style: .Default) { (alert: UIAlertAction!) -> Void in
            NSLog("You pressed button two")
        }
        
        let report = UIAlertAction(title: "Report this User", style: .Destructive) { (alert: UIAlertAction!) -> Void in
            NSLog("You pressed button one")
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { (alert: UIAlertAction!) -> Void in
            NSLog("You pressed button one")
        }
        
        alert.addAction(email)
        alert.addAction(sms)
        alert.addAction(follow)
        alert.addAction(block)
        alert.addAction(report)
        alert.addAction(cancel)
        presentViewController(alert, animated: true, completion:nil)
    }
    
    // MARK: - Search
    
    func searchButton(sender: AnyObject) {
        //UIApplication.sharedApplication().statusBarHidden = true
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.showsBookmarkButton = false
        searchController.searchBar.showsCancelButton = true
        searchController.searchBar.placeholder = "Search here..."
        searchController.searchBar.sizeToFit()
        searchController.searchBar.searchBarStyle = UISearchBarStyle.Prominent
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = true
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.scopeButtonTitles = searchScope
        searchController.searchBar.barTintColor = navColor
        tableView!.tableFooterView = UIView(frame: CGRectZero)
        self.presentViewController(searchController, animated: true, completion: nil)
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        /*filteredString = candies.filter({( candy : Candy) -> Bool in
            let categoryMatch = (scope == "All") || (candy.category == scope)
            return categoryMatch && candy.name.lowercaseString.containsString(searchText.lowercaseString)
        })
        tableView!.reloadData() */
    }
    
    // MARK: - Parse
    
    func parseData() {
        
        let query = PFQuery(className:"Blog")
        query.limit = 1000
        query.whereKey("ReplyId", equalTo:NSNull())
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
        
        let query1 = PFQuery(className:"Blog")
        query1.limit = 1000
        query1.whereKey("Rating", equalTo:"5")
        query1.cachePolicy = PFCachePolicy.CacheThenNetwork
        query1.orderByDescending("createdAt")
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
        titleLabel = (_feedItems.objectAtIndex((sender.view!.tag)) .valueForKey("PostBy") as? String)!
        self.performSegueWithIdentifier("bloguserSegue", sender: self)
    }
    
    // MARK: - Segues
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.performSegueWithIdentifier("blogeditSegue", sender: self)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "blogeditSegue" {
            
            let VC = segue.destinationViewController as? BlogEditController
            let myIndexPath = self.tableView!.indexPathForSelectedRow!.row
            VC!.objectId = _feedItems[myIndexPath] .valueForKey("objectId") as? String
            VC!.msgNo = _feedItems[myIndexPath] .valueForKey("MsgNo") as? String
            VC!.postby = _feedItems[myIndexPath] .valueForKey("PostBy") as? String
            VC!.subject = _feedItems[myIndexPath] .valueForKey("Subject") as? String
            VC!.msgDate = _feedItems[myIndexPath] .valueForKey("MsgDate") as? String
            VC!.rating = _feedItems[myIndexPath] .valueForKey("Rating") as? String
            VC!.liked = _feedItems[myIndexPath] .valueForKey("Liked") as? String
            VC!.replyId = _feedItems[myIndexPath] .valueForKey("ReplyId") as? String
        }
        if segue.identifier == "blognewSegue" {
            
            let VC = segue.destinationViewController as? BlogNewController
            
            if isReplyClicked == true {
                VC!.formStatus = "Reply"
                VC!.textcontentsubject = String(format:"@%@", posttoIndex!)
                VC!.textcontentpostby = PFUser.currentUser()!.valueForKey("username") as! String
                VC!.replyId = String(format:"%@", userIndex!)
            } else {
                VC!.formStatus = "New"
                VC!.textcontentpostby = PFUser.currentUser()!.username
            }
        }
        if segue.identifier == "bloguserSegue" {
                let controller = segue.destinationViewController as? LeadUserController
                controller!.formController = "Blog"
                controller!.postBy = titleLabel
        }
    }
    
}

    // MARK: - UISearchBar Delegate
extension Blog: UISearchBarDelegate {

    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

extension Blog: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
} 
