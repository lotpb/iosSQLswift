//
//  BlogNewController.swift
//  mySQLswift
//
//  Created by Peter Balsamo on 12/14/15.
//  Copyright © 2015 Peter Balsamo. All rights reserved.
//

import UIKit
import Parse

class BlogNewController: UIViewController, UITextViewDelegate {
    
    let ipadtitle = UIFont.systemFontOfSize(18, weight: UIFontWeightLight)
    let ipadsubject = UIFont.systemFontOfSize(20, weight: UIFontWeightLight)
    
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var Share: UIButton?
    @IBOutlet weak var Update: UIButton?
    @IBOutlet weak var Like: UIButton?
    @IBOutlet weak var myDatePicker: UIDatePicker?
    @IBOutlet weak var toolBar: UIToolbar?
    @IBOutlet weak var subject: UITextView?
    @IBOutlet weak var imageBlog: UIImageView?
    @IBOutlet weak var placeholderlabel: UILabel?
    
    var objectId : NSString?
    var msgNo : NSString?
    var postby : NSString?
    var msgDate : NSString?
    var rating : NSString?
    var liked : NSString?
    var replyId : NSString?
    
    var textcontentobjectId : NSString?
    var textcontentmsgNo : NSString?
    var textcontentdate : NSString?
    var textcontentpostby : NSString?
    var textcontentsubject : NSString?
    var textcontentrating : NSString?
    
    var formStatus : NSString?
    var activeImage : UIImageView? //star

  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleButton: UIButton = UIButton(frame: CGRectMake(0, 0, 100, 32))
        titleButton.setTitle("New Message", forState: UIControlState.Normal)
        titleButton.titleLabel?.font = Font.navlabel
        titleButton.titleLabel?.textAlignment = NSTextAlignment.Center
        titleButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        titleButton.addTarget(self, action: Selector(), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.titleView = titleButton
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        subject?.delegate = self
        self.tableView!.backgroundColor =  UIColor(white:0.90, alpha:1.0)

        /*
        if let split = self.splitViewController {
        let controllers = split.viewControllers
        self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        } */
        
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad {
            self.subject!.font = ipadsubject
        } else {
            self.subject!.font = Font.Blog.cellsubject
        }
        
        let query:PFQuery = PFUser.query()!
        query.whereKey("username",  equalTo:self.textcontentpostby!)
        query.cachePolicy = PFCachePolicy.CacheThenNetwork
        query.getFirstObjectInBackgroundWithBlock {(object: PFObject?, error: NSError?) -> Void in
            if error == nil {
                if let imageFile = object!.objectForKey("imageFile") as? PFFile {
                    imageFile.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                        self.imageBlog?.image = UIImage(data: imageData!)
                    }
                }
            }
        }
        
        self.imageBlog!.clipsToBounds = true
        self.imageBlog!.layer.cornerRadius = 5
        self.imageBlog!.contentMode = UIViewContentMode.ScaleToFill
        
        if ((self.formStatus == "New") || (self.formStatus == "Reply")) {
            
            self.Update!.hidden = true
            self.placeholderlabel!.textColor = UIColor.lightGrayColor()

            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateString = dateFormatter.stringFromDate((NSDate()) as NSDate)
            self.msgDate = dateString
            
            self.rating = "4"
            self.postby =  self.textcontentpostby
            
        } else if ((self.formStatus == "None")) { //set in BlogEdit
            
            self.Share!.hidden = true
            self.placeholderlabel!.hidden = true
            self.objectId = self.textcontentobjectId
            self.msgNo = self.textcontentmsgNo
            self.msgDate = self.textcontentdate
            self.subject!.text = self.textcontentsubject as? String
            self.postby = self.textcontentpostby
            self.rating = self.textcontentrating
        }
        
        if (self.formStatus == "New") {
            self.placeholderlabel!.text = "Share an idea?"
        } else if (self.formStatus == "Reply") {
            self.placeholderlabel!.hidden = true
            self.subject!.text = self.textcontentsubject as? String
            self.subject!.becomeFirstResponder()
            self.subject!.userInteractionEnabled = true
            
            /*
            //not working below
            NSString *text = [self.subject.text stringByAppendingString:@" "];//add space end of string
            NSString *a = @"@";
            NSString *searchby = [a stringByAppendingString:self.textcontentpostby];
            NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:text];
            [str addAttribute: NSForegroundColorAttributeName value:BLUECOLOR range:[text rangeOfString:searchby]];
            self.subject.attributedText = str; */
        }
        
        self.Like!.tintColor = UIColor.whiteColor()
        let likeimage : UIImage? = UIImage(named:"Thumb Up.png")!.imageWithRenderingMode(.AlwaysTemplate)
        self.Like! .setImage(likeimage, forState: .Normal)
        self.Like!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        self.myDatePicker!.hidden = true
        self.myDatePicker!.addTarget(self, action: Selector("dataPickerChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad {
            cell.textLabel!.font = ipadtitle
            cell.detailTextLabel!.font = ipadtitle

        } else {
            cell.textLabel!.font = Font.Blog.cellsubtitle
            cell.detailTextLabel!.font = Font.Blog.cellsubtitle
        }
        
        if (indexPath.row == 0) {

            self.activeImage = UIImageView(frame:CGRectMake(tableView.frame.size.width-35, 10, 18, 22))
            self.activeImage!.contentMode = .ScaleAspectFit
            
            if (self.rating == "5" ) {
                self.activeImage!.image = UIImage(named:"iosStar.png")
                self.Like!.setTitle("unLike", forState: UIControlState.Normal)
            } else {
                self.activeImage!.image = UIImage(named:"iosStarNA.png")
                self.Like!.setTitle("Like", forState: UIControlState.Normal)
            }
    
            cell.textLabel!.text = self.postby as? String
            cell.detailTextLabel!.text = ""
            cell.contentView.addSubview(self.activeImage!)
  
        } else if (indexPath.row == 1) {
            
            cell.textLabel!.text = self.msgDate as? String
            cell.detailTextLabel!.text = "Date"
            
        }
        
        return cell
    }
    
    // MARK: - Button
    
    func like(sender:UIButton) {
        
        if(self.rating == "4") {
            self.Like!.setTitle("unLike", forState: UIControlState.Normal)
            self.Like!.highlighted = true
            //[self.Like setSelected:YES];
            sender.tintColor = UIColor.redColor()
            self.activeImage!.image = UIImage(named:"iosStar.png")
            self.rating = "5"
        } else {
            self.Like!.setTitle("Like", forState: UIControlState.Normal)
            self.Like!.highlighted = false
            //[self.Like setSelected:NO];
            sender.tintColor = UIColor.whiteColor()
            self.activeImage!.image = UIImage(named:"iosStarNA.png")
            self.rating = "4"
        }
        self.tableView!.reloadData()
    }
    
    func datePickerChanged(myDatePicker:UIDatePicker) {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        let strDate = dateFormatter.stringFromDate(myDatePicker.date)
        self.msgDate = strDate
    }
    
    
    // MARK: - textView delegate
    
    
    func textViewDidBeginEditing(textView:UITextView) {
        
        if subject!.text.isEmpty {
            placeholderlabel?.hidden = true
        }
    }
    
    func textViewDidEndEditing(textView:UITextView) {
        
        if subject!.text.isEmpty {
         placeholderlabel?.hidden = false
        }
    }
    
    func textViewDidChange(textView:UITextView) {
       /*
        if subject!.text.isEmpty == false {
            placeholderlabel?.hidden = true
            placeholderlabel?.text = ""
        } else {
            placeholderlabel!.text = "Share an idea?"
        } */
    }
    
    func doneBarButtonItemClicked() {
        /*
    // Dismiss the keyboard by removing it as the first responder.
    [self.subject resignFirstResponder];
    
    [self.navigationItem setRightBarButtonItem:nil animated:YES]; */
    }
    
    // MARK: - Navigation
    
    @IBAction func updateData(sender: UIButton) {
        
        let query = PFQuery(className:"Blog")
        query.whereKey("objectId", equalTo:self.objectId!)
        query.getFirstObjectInBackgroundWithBlock {(updateblog: PFObject?, error: NSError?) -> Void in
            if error == nil {
              //updateblog!.setObject(self.msgNo as Int, forKey:"MsgNo")
                updateblog!.setObject(self.msgDate!, forKey:"MsgDate")
                updateblog!.setObject(self.postby!, forKey:"PostBy")
                updateblog!.setObject(self.rating!, forKey:"Rating")
                updateblog!.setObject(self.subject!.text, forKey:"Subject")
                updateblog!.setObject(self.msgNo ?? NSNumber(integer:-1), forKey:"MsgNo")
                updateblog!.setObject(self.replyId ?? NSNull(), forKey:"ReplyId")
                updateblog!.saveEventually()
                
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
        //self.navigationController?.popViewControllerAnimated(true)

    }
    
    @IBAction func saveData(sender: UIButton) {
        
        let saveblog:PFObject = PFObject(className:"Blog")
        saveblog.setObject(self.msgDate!, forKey:"MsgDate")
        saveblog.setObject(self.postby!, forKey:"PostBy")
        saveblog.setObject(self.rating!, forKey:"Rating")
        saveblog.setObject(self.subject!.text, forKey:"Subject")
        saveblog.setObject(self.msgNo ?? NSNumber(integer:-1), forKey:"MsgNo")
        saveblog.setObject(self.replyId ?? NSNull(), forKey:"ReplyId")
        
        if self.formStatus == "Reply" {
            let query = PFQuery(className:"Blog")
            query.whereKey("objectId", equalTo:self.replyId!)
            query.getFirstObjectInBackgroundWithBlock {(updateReply: PFObject?, error: NSError?) -> Void in
                if error == nil {
                    updateReply!.incrementKey("CommentCount")
                    updateReply!.saveEventually()
                }
            }
        }
        
        // Set ACL permissions for added security
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
            //self.navigationController?.popToRootViewControllerAnimated(true)
            //self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
}
