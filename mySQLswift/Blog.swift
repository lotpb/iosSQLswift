//
//  Blog.swift
//  mySQLswift
//
//  Created by Peter Balsamo on 12/8/15.
//  Copyright © 2015 Peter Balsamo. All rights reserved.
//

import UIKit
//import Firebase
import Parse
import Social

class Blog: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let searchScope = ["subject", "date", "rating", "postby"]
    
    @IBOutlet weak var tableView: UITableView?

    var _feedItems : NSMutableArray = NSMutableArray()
    var _feedheadItems : NSMutableArray = NSMutableArray()
    var filteredString : NSMutableArray = NSMutableArray()
    
    var buttonView: UIView?
    var likeButton: UIButton?
    var refreshControl: UIRefreshControl!
    let searchController = UISearchController(searchResultsController: nil)

    var isReplyClicked = true
    var posttoIndex: NSString?
    var userIndex: NSString?
    var titleLabel = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleLabel = UILabel(frame: CGRectMake(0, 0, 100, view.frame.height))
        titleLabel.text = "myBlog"
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = Font.navlabel
        titleLabel.textAlignment = NSTextAlignment.Center
        navigationItem.titleView = titleLabel
        
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        self.tableView!.estimatedRowHeight = 110
        self.tableView!.rowHeight = UITableViewAutomaticDimension
        self.tableView!.backgroundColor =  UIColor(white:0.90, alpha:1.0)
        
        // get rid of black bar underneath navbar
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarMetrics: .Default)
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action:#selector(Blog.newButton))
        let searchButton = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action:#selector(Blog.searchButton))
        let buttons:NSArray = [addButton,searchButton]
        self.navigationItem.rightBarButtonItems = buttons as? [UIBarButtonItem]

        /*
        if let split = self.splitViewController {
           let controllers = split.viewControllers
           self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        } */
        
        parseData()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.backgroundColor = Color.Blog.navColor
        self.refreshControl.tintColor = UIColor.whiteColor()
        let attributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: attributes)
        //self.refreshControl.attributedTitle = NSAttributedString(string: "Last updated on \(NSDate())", attributes: attributes)
        self.refreshControl.addTarget(self, action: #selector(Blog.refreshData), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView!.addSubview(refreshControl)

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad {
            self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        } else {
            self.navigationController?.navigationBar.barTintColor = Color.Blog.navColor
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        refreshData(self)
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
            return _feedItems.count ?? 0
            //return messages.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! CustomTableCell!
        
        if cell == nil {
            cell = CustomTableCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        }
        
        //let message = messages[indexPath.row]
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad {
            
            cell.blogtitleLabel!.font =  Font.Blog.celltitle
            cell.blogsubtitleLabel!.font =  Font.Blog.cellsubtitle
            cell.blogmsgDateLabel.font = Font.Blog.celldate
            cell.numLabel.font = Font.Blog.cellLabel
            cell.commentLabel.font = Font.Blog.cellLabel
            
        } else {
            
            cell.blogtitleLabel!.font =  Font.Blog.celltitle
            cell.blogsubtitleLabel!.font =  Font.Blog.cellsubtitle
            cell.blogmsgDateLabel.font = Font.Blog.celldate
            cell.numLabel.font = Font.Blog.cellLabel
            cell.commentLabel.font = Font.Blog.cellLabel
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
        
        cell.blogImageView?.layer.cornerRadius = (cell.blogImageView?.frame.size.width)! / 2
        cell.blogImageView?.layer.borderColor = UIColor.lightGrayColor().CGColor
        cell.blogImageView?.layer.borderWidth = 0.5
        cell.blogImageView?.layer.masksToBounds = true
        cell.blogImageView?.userInteractionEnabled = true
        cell.blogImageView?.contentMode = .ScaleAspectFill
        cell.blogImageView?.tag = indexPath.row
        
        let tap = UITapGestureRecognizer(target: self, action:#selector(Blog.imgLoadSegue))
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
        cell.replyButton .addTarget(self, action: #selector(Blog.replyButton), forControlEvents: UIControlEvents.TouchUpInside)
        
        cell.likeButton.tintColor = UIColor.lightGrayColor()
        let likeimage : UIImage? = UIImage(named:"Thumb Up.png")!.imageWithRenderingMode(.AlwaysTemplate)
        cell.likeButton .setImage(likeimage, forState: .Normal)
        cell.likeButton .addTarget(self, action: #selector(Blog.likeButton), forControlEvents: UIControlEvents.TouchUpInside)

        cell.flagButton.tintColor = UIColor.lightGrayColor()
        let reportimage : UIImage? = UIImage(named:"Flag.png")!.imageWithRenderingMode(.AlwaysTemplate)
        cell.flagButton .setImage(reportimage, forState: .Normal)
        cell.flagButton .addTarget(self, action: #selector(Blog.flagButton), forControlEvents: UIControlEvents.TouchUpInside)
  
        cell.actionBtn.tintColor = UIColor.lightGrayColor()
        let actionimage : UIImage? = UIImage(named:"nav_more_icon.png")!.imageWithRenderingMode(.AlwaysTemplate)
        cell.actionBtn .setImage(actionimage, forState: .Normal)
        cell.actionBtn .addTarget(self, action: #selector(Blog.showShare), forControlEvents: UIControlEvents.TouchUpInside)
        
        if !(cell.numLabel.text! == "0") {
            cell.numLabel.textColor = Color.Blog.buttonColor
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
            cell.replyButton.tintColor = Color.Blog.buttonColor
        }

        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Phone {
            return 90.0
        } else {
            return 0.0
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()
        vw.backgroundColor = Color.Blog.navColor
        //tableView.tableHeaderView = vw
        
        let myLabel1:UILabel = UILabel(frame: CGRectMake(10, 15, 50, 50))
        myLabel1.numberOfLines = 0
        myLabel1.backgroundColor = UIColor.whiteColor()
        myLabel1.textColor = UIColor.blackColor()
        myLabel1.textAlignment = NSTextAlignment.Center
        myLabel1.layer.masksToBounds = true
        myLabel1.text = String(format: "%@%d", "Blog\n", _feedItems.count)
        myLabel1.font = Font.headtitle
        myLabel1.layer.cornerRadius = 25.0
        myLabel1.layer.borderColor = Color.Blog.borderbtnColor
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
        myLabel2.font = Font.headtitle
        myLabel2.layer.cornerRadius = 25.0
        myLabel2.layer.borderColor = Color.Blog.borderbtnColor
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
        myLabel3.text = String(format: "%@%d", "Events\n", 3)
        myLabel3.font = Font.headtitle
        myLabel3.layer.cornerRadius = 25.0
        myLabel3.layer.borderColor = Color.Blog.borderbtnColor
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
    
    func flagButton(sender:UIButton) {
        

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
        searchController.searchBar.barTintColor = Color.Blog.navColor
        tableView!.tableFooterView = UIView(frame: .zero)
        self.presentViewController(searchController, animated: true, completion: nil)
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
 
    }
    
    // MARK: - Parse
    
    //var messages = [Message]()
    
    func parseData() {
        /*
        let ref = FIRDatabase.database().reference().child("iosBlog").child("results")
        ref.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            
            print(snapshot)
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = Message()
                message.setValuesForKeysWithDictionary(dictionary)
                self.messages.append(message)
                
                
                //this will crash because of background thread, so lets call this on dispatch_async main thread
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView!.reloadData()
                })
            }
            
            }, withCancelBlock: nil) */
        
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
    
    // MARK: - AlertController
    
    func showShare(sender:UIButton) {
        
        let hitPoint = sender.convertPoint(CGPointZero, toView: self.tableView)
        let indexPath = self.tableView!.indexPathForRowAtPoint(hitPoint)
        let socialText = self._feedItems[indexPath!.row] .valueForKey("Subject") as? String
        
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            let tweetAction = UIAlertAction(title: "Share on Twitter", style: UIAlertActionStyle.Default) { (action) -> Void in
                
                if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
                    let twitterComposeVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                    
                    if socialText!.characters.count <= 140 {
                        twitterComposeVC.setInitialText(socialText)
                    } else {
                        let index = socialText!.startIndex.advancedBy(140)
                        let subText = socialText!.substringToIndex(index)
                        twitterComposeVC.setInitialText("\(subText)")
                    }
                    
                    self.presentViewController(twitterComposeVC, animated: true, completion: nil)
                } else {
                    self.showAlertMessage("You are not logged in to your Twitter account.")
                }
            }
            
            let facebookPostAction = UIAlertAction(title: "Share on Facebook", style: UIAlertActionStyle.Default) { (action) -> Void in
                
                if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
                    let facebookComposeVC = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                    //facebookComposeVC.setInitialText(socialText)
                    //facebookComposeVC.addImage(detailImageView.image!)
                    facebookComposeVC.addURL(NSURL(string: "http://lotpb.github.io/UnitedWebPage/index.html"))
                    self.presentViewController(facebookComposeVC, animated: true, completion: nil)
                }
                else {
                    self.showAlertMessage("You are not connected to your Facebook account.")
                }
            }
            
            let moreAction = UIAlertAction(title: "More", style: UIAlertActionStyle.Default) { (action) -> Void in
                
                let activityViewController = UIActivityViewController(activityItems: [socialText!], applicationActivities: nil)
                //activityViewController.excludedActivityTypes = [UIActivityTypeMail]
                self.presentViewController(activityViewController, animated: true, completion: nil)
                
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
            let dismissAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel) { (action) -> Void in
            }
            actionSheet.addAction(follow)
            actionSheet.addAction(block)
            actionSheet.addAction(report)
            actionSheet.addAction(tweetAction)
            actionSheet.addAction(facebookPostAction)
            actionSheet.addAction(moreAction)
            actionSheet.addAction(dismissAction)
            
            self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func showAlertMessage(message: String!) {
        let alertController = UIAlertController(title: "EasyShare", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
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
            VC!.liked = _feedItems[myIndexPath] .valueForKey("Liked") as? Int
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
