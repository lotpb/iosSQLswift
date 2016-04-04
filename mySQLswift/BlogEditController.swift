//
//  BlogEditViewController.swift
//  mySQLswift
//
//  Created by Peter Balsamo on 12/14/15.
//  Copyright © 2015 Peter Balsamo. All rights reserved.
//

import UIKit
import Parse

class BlogEditController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let ipadtitle = UIFont.systemFontOfSize(20, weight: UIFontWeightBold)
    let ipadsubtitle = UIFont.systemFontOfSize(12, weight: UIFontWeightLight)
    let ipaddate = UIFont.systemFontOfSize(18, weight: UIFontWeightLight)
    
    let replyipadtitle = UIFont.systemFontOfSize(16, weight: UIFontWeightBold)
    let replyipadsubtitle = UIFont.systemFontOfSize(16, weight: UIFontWeightRegular)
    let replyipaddate = UIFont.systemFontOfSize(16, weight: UIFontWeightBold)
    let replyipadlabel = UIFont.systemFontOfSize(16, weight: UIFontWeightRegular)
    
    let replytitle = UIFont.systemFontOfSize(14, weight: UIFontWeightBold)
    let replysubtitle = UIFont.systemFontOfSize(14, weight: UIFontWeightRegular)
    let replydate = UIFont.systemFontOfSize(14, weight: UIFontWeightBold)
    let replylabel = UIFont.systemFontOfSize(14, weight: UIFontWeightRegular)
    
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var listTableView: UITableView?
    @IBOutlet weak var toolBar: UIToolbar?
    @IBOutlet weak var Like: UIButton?
    @IBOutlet weak var update: UIButton?
    
    var replylikeButton: UIButton?
    
    var _feedItems : NSMutableArray = NSMutableArray()
    var _feedItems1 : NSMutableArray = NSMutableArray()
    var refreshControl: UIRefreshControl!
    var filteredString : NSMutableArray = NSMutableArray()
    var objects = [AnyObject]()
 
    var objectId : NSString?
    var msgNo : NSString?
    var postby : NSString?
    var subject : NSString?
    var msgDate : NSString?
    var rating : NSString?
    var replyId : NSString?
    var liked : Int?
    var activityViewController:UIActivityViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        let titleButton: UIButton = UIButton(frame: CGRectMake(0, 0, 100, 32))
        titleButton.setTitle("Edit Message", forState: UIControlState.Normal)
        titleButton.titleLabel?.font = Font.navlabel
        titleButton.titleLabel?.textAlignment = NSTextAlignment.Center
        titleButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        titleButton.addTarget(self, action: Selector(), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.titleView = titleButton
        
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        self.tableView!.estimatedRowHeight = 110
        self.tableView!.rowHeight = UITableViewAutomaticDimension
        self.tableView!.backgroundColor =  UIColor.whiteColor()
        
        self.listTableView!.delegate = self
        self.listTableView!.dataSource = self
        self.listTableView!.estimatedRowHeight = 75
        self.listTableView!.rowHeight = UITableViewAutomaticDimension
        self.listTableView!.tableFooterView = UIView(frame: .zero)

        self.view.backgroundColor = UIColor.lightGrayColor()
        self.toolBar!.translucent = false
        self.toolBar!.barTintColor = UIColor.whiteColor()
        
        let topBorder = CALayer()
        let width = CGFloat(2.0)
        topBorder.borderColor = UIColor.lightGrayColor().CGColor
        topBorder.frame = CGRect(x: 0, y: 0, width:  self.view.frame.size.width, height: 0.5)
        topBorder.borderWidth = width
        self.toolBar!.layer.addSublayer(topBorder)
        self.toolBar!.layer.masksToBounds = true
        
        let bottomBorder = CALayer()
        let width1 = CGFloat(2.0)
        bottomBorder.borderColor = UIColor.lightGrayColor().CGColor
        bottomBorder.frame = CGRect(x: 0, y: self.toolBar!.frame.size.height-1, width:self.view.frame.size.width, height: 0.5)
        bottomBorder.borderWidth = width1
        self.toolBar!.layer.addSublayer(bottomBorder)
        self.toolBar!.layer.masksToBounds = true
        
        if (self.liked == nil) {
            self.Like!.tintColor = UIColor.lightGrayColor()
        } else {
            self.Like!.tintColor = Color.Blog.buttonColor
        }
        let replyimage : UIImage? = UIImage(named:"Thumb Up.png")!.imageWithRenderingMode(.AlwaysTemplate)
        self.Like!.setImage(replyimage, forState: .Normal)
        self.Like!.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        
        self.update!.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        
        let actionButton = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: #selector(BlogEditController.shareButton(_:)))
        let trashButton = UIBarButtonItem(barButtonSystemItem: .Trash, target: self, action: #selector(BlogEditController.deleteButton(_:)))
        let buttons:NSArray = [actionButton,trashButton]
        self.navigationItem.rightBarButtonItems = buttons as? [UIBarButtonItem]
        
        parseData()
        
        self.refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.clearColor()
        refreshControl.tintColor = UIColor.blackColor()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(BlogEditController.refreshData(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView!.addSubview(refreshControl)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshData(sender:AnyObject) {
        
        parseData()
        self.refreshControl?.endRefreshing()
    }

    
    // MARK: - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (tableView == self.tableView) {
            return 1
        } else {
            return _feedItems1.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView == self.tableView {
            
            var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! CustomTableCell!
            
            if cell == nil {
                cell = CustomTableCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad {
                
                cell.titleLabel!.font = ipadtitle
                cell.subtitleLabel!.font = ipadsubtitle
                cell.msgDateLabel.font = ipaddate
                
            } else {
                
                cell.titleLabel!.font = Font.Blog.celltitle
                cell.subtitleLabel!.font = Font.Blog.cellsubtitle
                cell.msgDateLabel.font = Font.Blog.celldate
            }
            
            let query:PFQuery = PFUser.query()!
            query.whereKey("username",  equalTo:self.postby!)
            query.limit = 1
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
            
            let dateStr = self.msgDate
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date:NSDate = dateFormatter.dateFromString((dateStr)! as String)!
            dateFormatter.dateFormat = "MM/dd/yy, h:mm a"
            
            cell.titleLabel!.text = self.postby as? String
            cell.subtitleLabel!.text = self.subject as? String
            cell.msgDateLabel.text = dateFormatter.stringFromDate((date) as NSDate)
            
            return cell
        }
        else { //-----------------------listViewTable---------------------------
            
            var cell = tableView.dequeueReusableCellWithIdentifier("ReplyCell") as! CustomTableCell!
            
            let query:PFQuery = PFUser.query()!
            query.whereKey("username",  equalTo: self._feedItems1[indexPath.row] .valueForKey("PostBy") as! String)
            query.limit = 1
            query.cachePolicy = PFCachePolicy.CacheThenNetwork
            query.getFirstObjectInBackgroundWithBlock {(object: PFObject?, error: NSError?) -> Void in
                if error == nil {
                    if let imageFile = object!.objectForKey("imageFile") as? PFFile {
                        imageFile.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                            cell.replyImageView?.image = UIImage(data: imageData!)
                        }
                    }
                }
            }
            
            if cell == nil {
                cell = CustomTableCell(style: UITableViewCellStyle.Default, reuseIdentifier: "ReplyCell")
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.replydateLabel.textColor = UIColor.grayColor()
            
            if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad {
                
                cell.replytitleLabel!.font = replyipadtitle
                cell.replysubtitleLabel!.font = replyipadsubtitle
                cell.replynumLabel!.font = replyipaddate
                cell.replydateLabel!.font = replyipadlabel
                
            } else {
                
                cell.replytitleLabel!.font = replytitle
                cell.replysubtitleLabel!.font = replysubtitle
                cell.replynumLabel.font = replydate
                cell.replydateLabel.font = replylabel
            }

            let date1 = _feedItems1[indexPath.row] .valueForKey("createdAt") as? NSDate
            let date2 = NSDate()
            let diffDateComponents = NSCalendar.currentCalendar().components([NSCalendarUnit.Day], fromDate: date1!, toDate: date2, options: NSCalendarOptions.init(rawValue: 0))
            
            cell.replytitleLabel!.text = _feedItems1[indexPath.row] .valueForKey("PostBy") as? String
            cell.replysubtitleLabel!.text = _feedItems1[indexPath.row] .valueForKey("Subject") as? String
            cell.replydateLabel!.text = String(format: "%d%@", diffDateComponents.day," days ago" )
            var Liked:Int? = _feedItems1[indexPath.row] .valueForKey("Liked") as? Int
            if Liked == nil {
                Liked = 0
            }
            cell.replynumLabel!.text = "\(Liked!)"
            
            cell.replylikeButton.tintColor = UIColor.lightGrayColor()
            let replyimage : UIImage? = UIImage(named:"Thumb Up.png")!.imageWithRenderingMode(.AlwaysTemplate)
            cell.replylikeButton .setImage(replyimage, forState: .Normal)
            cell.replylikeButton .addTarget(self, action: #selector(BlogEditController.likeButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
            if !(cell.replynumLabel.text == "0") {
                cell.replynumLabel.textColor = UIColor.redColor()
            } else {
                cell.replynumLabel.text? = ""
            }

            return cell
        } 
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
    
    // MARK: - Button
    
    @IBAction func updateButton(sender: UIButton) {
        
        self.performSegueWithIdentifier("blogeditSegue", sender: self)
    }
    
    func likeButton(sender:UIButton) {
        
        self.replylikeButton?.selected = true
        sender.tintColor = UIColor.redColor()
        let hitPoint = sender.convertPoint(CGPointZero, toView: self.listTableView)
        let indexPath = self.listTableView!.indexPathForRowAtPoint(hitPoint)
        
        let query = PFQuery(className:"Blog")
        query.whereKey("objectId", equalTo:(_feedItems1.objectAtIndex((indexPath?.row)!) .valueForKey("objectId") as? String)!)
        query.getFirstObjectInBackgroundWithBlock {(object: PFObject?, error: NSError?) -> Void in
            if error == nil {
                object!.incrementKey("Liked")
                object!.saveInBackground()
            }
        }
    }
    
    func shareButton(sender: UIButton) {
        
        let activityViewController = UIActivityViewController (
            activityItems: [self.subject! as NSString],
            applicationActivities: nil)
        
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    func deleteButton(sender: UIButton) {
        
        let query = PFQuery(className:"Blog")
        query.whereKey("objectId", equalTo:self.objectId!)
        
        let alertController = UIAlertController(title: "Delete", message: "Confirm Delete", preferredStyle: .Alert)
        
        let destroyAction = UIAlertAction(title: "Delete!", style: .Destructive) { (action) in
            query.findObjectsInBackgroundWithBlock({ (objects : [PFObject]?, error: NSError?) -> Void in
                if error == nil {
                    for object in objects! {
                        object.deleteInBackground()
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                }
            })
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
        return
        }
        alertController.addAction(cancelAction)
        alertController.addAction(destroyAction)
        self.presentViewController(alertController, animated: true) {
        }
    }
    
    // MARK: - Parse
    
    func parseData() {
        
        let query1 = PFQuery(className:"Blog")
        query1.whereKey("ReplyId", equalTo:self.objectId!)
        query1.cachePolicy = PFCachePolicy.CacheThenNetwork
        query1.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                let temp: NSArray = objects! as NSArray
                self._feedItems1 = temp.mutableCopy() as! NSMutableArray
                self.listTableView!.reloadData()
            } else {
                print("Error")
            }
        }
        
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "blogeditSegue" {
            
            let VC = segue.destinationViewController as? BlogNewController
            VC!.formStatus = "None"
            VC!.textcontentobjectId = self.objectId
            VC!.textcontentmsgNo = self.msgNo
            VC!.textcontentpostby = self.postby
            VC!.textcontentsubject = self.subject
            VC!.textcontentdate = self.msgDate
            VC!.textcontentrating = self.rating
            VC!.liked = self.liked
        }
        
    }
}
