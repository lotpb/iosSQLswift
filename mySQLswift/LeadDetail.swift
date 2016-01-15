//
//  LeadDetail.swift
//  mySQLswift
//
//  Created by Peter Balsamo on 12/10/15.
//  Copyright © 2015 Peter Balsamo. All rights reserved.
//

import UIKit
import Parse

class LeadDetail: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableData : NSMutableArray = NSMutableArray()
    var tableData2 : NSMutableArray = NSMutableArray()
    var tableData3 : NSMutableArray = NSMutableArray()
    var tableData4 : NSMutableArray = NSMutableArray()
    
    @IBOutlet weak var scrollWall: UIScrollView?
    
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var listTableView2: UITableView!
    @IBOutlet weak var newsTableView: UITableView!
    
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var labelNo: UILabel!
    @IBOutlet weak var labelname: UILabel!
    @IBOutlet weak var labelamount: UILabel!
    @IBOutlet weak var labeldate: UILabel!
    @IBOutlet weak var labeladdress: UILabel!
    @IBOutlet weak var labelcity: UILabel!
    @IBOutlet weak var following: UILabel!
    @IBOutlet weak var labeldatetext: UILabel!
    
    @IBOutlet weak var mySwitch: UISwitch!
    @IBOutlet weak var activebutton: UIButton!
    @IBOutlet weak var mapbutton: UIButton!
    
    var formController : String?
    
    var objectId : String?
    var custNo : String?
    var leadNo : String?
    var date : String?
    var name : String?
    var address : String?
    var city : String?
    var state : String?
    var zip : String?
    var amount : String?
    var tbl11 : NSString?
    var tbl12 : NSString?
    var tbl13 : NSString?
    var tbl14 : NSString?
    var tbl15 : NSString?
    var tbl16 : NSString?
    var tbl21 : NSString?
    var tbl22 : NSString?
    var tbl23 : NSString!
    var tbl24 : NSString?
    var tbl25 : NSString?
    var tbl26 : NSString?
    var tbl27 : NSString? //employee company
    var photo : NSString?
    var comments : NSString?
    var active : NSString?
    
    var t11 : NSString?
    var t12 : NSString?
    var t13 : NSString?
    var t14 : NSString?
    var t15 : NSString?
    var t16 : NSString?
    var t21 : NSString?
    var t22 : NSString?
    var t23 : NSString!
    var t24 : NSString?
    var t25 : NSString?
    var t26 : NSString?
    
    var l1datetext : NSString?
    var lnewsTitle : NSString?
    
    var l11 : String?
    var l12 : String?
    var l13 : String?
    var l14 : String?
    var l15 : String?
    var l16 : String?
    
    var l21 : NSString?
    var l22 : NSString?
    var l23 : NSString?
    var l24 : NSString?
    var l25 : NSString?
    var l26 : NSString?
    
    var p1 : NSString?
    var p12 : NSString?
    var complete : NSString?
    var salesman : NSString?
    var jobdescription : NSString?
    var advertiser : NSString?
    var dateInput : UITextField?
    var itemText : UITextField?
    
    var savedEventId : NSString?
    var getEmail : NSString?
    
    var photoImage: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleButton: UIButton = UIButton(frame: CGRectMake(0, 0, 100, 32))
        titleButton.setTitle("myDetails", forState: UIControlState.Normal)
        titleButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 25.0)
        titleButton.titleLabel?.textAlignment = NSTextAlignment.Center
        titleButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        titleButton.addTarget(self, action: Selector(), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.titleView = titleButton
        
        self.listTableView!.rowHeight = 30
        self.listTableView2!.rowHeight = 30
        self.newsTableView!.estimatedRowHeight = 100
        self.newsTableView!.rowHeight = UITableViewAutomaticDimension
        
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad {
            labelamount!.font = UIFont (name: "HelveticaNeue", size: 36)
            labelname!.font = UIFont (name: "HelveticaNeue-Light", size: 30)
            labeldate!.font = UIFont (name: "HelveticaNeue", size: 18)
            labeladdress!.font = UIFont (name: "HelveticaNeue-Light", size: 26)
            labelcity!.font = UIFont (name: "HelveticaNeue-Light", size: 26)
            mapbutton!.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 18)
            
        } else {
            
            labeladdress!.font = UIFont (name: "HelveticaNeue-Light", size: 20)
            labelcity!.font = UIFont (name: "HelveticaNeue-Light", size: 20)
            mapbutton!.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 18)
            
            if (self.formController == "Vendor" || self.formController == "Employee") {
                labelamount!.font = UIFont (name: "HelveticaNeue", size: 20)
                labeldate!.font = UIFont (name: "HelveticaNeue", size: 12)
            } else {
                labelamount!.font = UIFont (name: "HelveticaNeue", size: 36)
                labeldate!.font = UIFont (name: "HelveticaNeue", size: 16)
            }
            
            if self.formController == "Vendor" {
                labelname!.font = UIFont (name: "HelveticaNeue-Light", size: 18)
            } else {
                labelname!.font = UIFont (name: "HelveticaNeue-Light", size: 24)
            }
        }
        
        if (self.formController == "Leads") {
            if (self.tbl11 == "Sold") {
                self.mySwitch!.setOn(true, animated:true)
            } else {
                self.mySwitch!.setOn(false, animated:true)
            }
        }
        
        self.mySwitch!.onTintColor = UIColor(red:0.0, green:122.0/255.0, blue:1.0, alpha: 1.0)
        self.mySwitch!.tintColor = UIColor.lightGrayColor()

        photoImage = UIImageView(frame:CGRectMake(self.view.frame.size.width/2+15, 60, self.view.frame.size.width/2-25, 110))
        photoImage!.image = UIImage(named:"IMG_1133.jpg")
        photoImage!.clipsToBounds = true
        photoImage!.layer.borderColor = UIColor.lightGrayColor().CGColor
        photoImage!.layer.borderWidth = 1.0
        photoImage!.userInteractionEnabled = true
        self.mainView!.addSubview(photoImage!) 
        
        self.mapbutton!.backgroundColor = UIColor(red:0.0, green:122.0/255.0, blue:1.0, alpha: 1.0)
        self.mapbutton!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.mapbutton!.addTarget(self, action: "mapButton", forControlEvents: UIControlEvents.TouchUpInside)
        let btnLayer3: CALayer = self.mapbutton!.layer
        btnLayer3.masksToBounds = true
        btnLayer3.cornerRadius = 9.0
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editButton")
        let actionButton = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "actionButton:")
        let buttons:NSArray = [editButton,actionButton]
        self.navigationItem.rightBarButtonItems = buttons as? [UIBarButtonItem]
        
        parseData()
        followButton()
        refreshData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
     
        fieldData()
        refreshData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = UIColor(white:0.45, alpha:1.0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshData() {
        self.listTableView!.reloadData()
        self.listTableView2!.reloadData()
        self.newsTableView!.reloadData()
    }
    
    // MARK: - Button
    
    func editButton() {
        self.performSegueWithIdentifier("editFormSegue", sender: self)
    }
    
    func mapButton() {
        self.performSegueWithIdentifier("showmapSegue", sender: self)
    }
    
    func followButton() {
        
        if(self.active == "1") {
            self.following!.text = "Following"
            //self.active! = "1"
            let replyimage : UIImage? = UIImage(named:"iosStar.png")
            self.activebutton!.setImage(replyimage, forState: .Normal)
        } else {
            self.following!.text = "Follow"
            //self.active! = "0"
            let replyimage : UIImage? = UIImage(named:"iosStarNA.png")
            self.activebutton!.setImage(replyimage, forState: .Normal)
        }
    }
    
    func statButton() {
        self.performSegueWithIdentifier("statisticSegue", sender: self)
    }
    
    
    // MARK: - Tableview
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (tableView == self.listTableView) {
            return tableData.count
        } else if (tableView == self.listTableView2) {
            return tableData2.count
        } else if (tableView == self.newsTableView) {
            return 1
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (tableView == self.listTableView) {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
            /*
            let topBorder = CALayer()
            let width = CGFloat(2.0)
            topBorder.borderColor = UIColor.lightGrayColor().CGColor
            topBorder.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 0.5)
            topBorder.borderWidth = width
            cell.layer.addSublayer(topBorder)
            cell.layer.masksToBounds = true */
            
            if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad {
                cell.textLabel!.font = UIFont (name: "HelveticaNeue-Bold", size: 14)
                cell.detailTextLabel!.font = UIFont (name: "HelveticaNeue-Light", size: 14)
            } else {
                cell.textLabel!.font = UIFont (name: "HelveticaNeue-Bold", size: 12)
                cell.detailTextLabel!.font = UIFont (name: "HelveticaNeue-Light", size: 12)
            }
            
            cell.textLabel!.text = tableData4.objectAtIndex(indexPath.row) as? String
            cell.textLabel!.textColor = UIColor.blackColor()
            cell.detailTextLabel!.text = tableData.objectAtIndex(indexPath.row) as? String
            cell.detailTextLabel!.textColor = UIColor.blackColor()

            
            return cell
            
        } else if (tableView == self.listTableView2) {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
            /*
            let topBorder = CALayer()
            let width = CGFloat(2.0)
            topBorder.borderColor = UIColor.lightGrayColor().CGColor
            topBorder.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 0.5)
            topBorder.borderWidth = width
            cell.layer.addSublayer(topBorder)
            cell.layer.masksToBounds = true */

            
            if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad {
                cell.textLabel!.font = UIFont (name: "HelveticaNeue-Bold", size: 14)
                cell.detailTextLabel!.font = UIFont (name: "HelveticaNeue-Light", size: 14)
            } else {
                cell.textLabel!.font = UIFont (name: "HelveticaNeue-Bold", size: 12)
                cell.detailTextLabel!.font = UIFont (name: "HelveticaNeue-Light", size: 12)
            }
            
            cell.textLabel!.text = tableData3.objectAtIndex(indexPath.row) as? String
            cell.textLabel!.textColor = UIColor.blackColor()
            cell.detailTextLabel!.text = tableData2.objectAtIndex(indexPath.row) as? String
            cell.detailTextLabel!.textColor = UIColor.blackColor()

            
            return cell
            
        } else if (tableView == self.newsTableView) {
            
            var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! CustomTableCell!
            
            self.newsTableView!.tableFooterView = UIView(frame: CGRectZero)
            
            if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad {
                cell.leadtitleDetail!.font = UIFont (name: "HelveticaNeue-Medium", size: 20)
                cell.leadsubtitleDetail!.font = UIFont (name: "HelveticaNeue-Light", size: 18)
                cell.leadreadDetail!.font = UIFont (name: "HelveticaNeue", size: 18)
                cell.leadnewsDetail!.font = UIFont (name: "HelveticaNeue", size: 18)
            } else {
                cell.leadtitleDetail!.font = UIFont (name: "HelveticaNeue-Medium", size: 18)
                cell.leadsubtitleDetail!.font = UIFont (name: "HelveticaNeue-Light", size: 16)
                cell.leadreadDetail.font = UIFont (name: "HelveticaNeue", size: 16)
                cell.leadnewsDetail!.font = UIFont (name: "HelveticaNeue", size: 16)
            }
            
            let width = CGFloat(2.0)
            
            let topBorder = CALayer()
            topBorder.borderColor = UIColor.lightGrayColor().CGColor
            topBorder.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 0.5)
            topBorder.borderWidth = width
            cell.layer.addSublayer(topBorder)
            cell.layer.masksToBounds = true

            /*
            let bottomBorder = CALayer()
            bottomBorder.borderColor = UIColor.lightGrayColor().CGColor
            bottomBorder.frame = CGRect(x: 0, y: cell.frame.size.height+15, width:  self.view.frame.size.width, height: 0.5)
            bottomBorder.borderWidth = width
            cell.layer.addSublayer(bottomBorder)
            cell!.layer.masksToBounds = true */
            
            if cell == nil {
                cell = CustomTableCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
            }
            
            cell.leadtitleDetail.text = self.lnewsTitle as? String
            cell.leadtitleDetail.numberOfLines = 0
            cell.leadtitleDetail.textColor = UIColor.blackColor()
       
            /*
            let dateStr = self.date
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date1:NSDate = dateFormatter.dateFromString(dateStr!)! as NSDate
            let date2:NSDate = NSDate()
            let diffDateComponents = NSCalendar.currentCalendar().components([NSCalendarUnit.Day], fromDate: date1, toDate: date2, options: NSCalendarOptions.init(rawValue: 0))
            cell.leadsubtitleDetail.text = String(format: "%d%@", diffDateComponents.day," United News" )
            */
            
            cell.leadsubtitleDetail.text = "United News"
            cell.leadsubtitleDetail.textColor = UIColor.grayColor()
            
            cell.leadreadDetail.text = "Read more"
            cell.leadreadDetail.textColor = UIColor(red:0.0, green:122.0/255.0, blue:1.0, alpha: 1.0)
            
            cell.leadnewsDetail.text = self.comments as? String
            cell.leadnewsDetail.numberOfLines = 0
            cell.leadnewsDetail.textColor = UIColor.darkGrayColor()

            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    // MARK: - LoadFieldData
    
    func fieldData() {

        self.labelname!.adjustsFontSizeToFitWidth = true
        
        if self.leadNo != nil {
            self.labelNo.text = leadNo
        } else {
           self.labelNo.text = "None" 
        }
        if self.date != nil {
            self.labeldate.text = date
        }
        if self.l1datetext != nil {
            self.labeldatetext.text = l1datetext as? String
        }
        if self.name != nil {
            self.labelname.text = name
        }
        if self.address != nil {
            self.labeladdress.text = address
        }
        if self.city == nil {
            city = "City"
        }
        if self.state == nil {
            state = "State"
        }
        if self.zip == nil {
            zip = "Zip"
        }
        if self.city != nil {
            self.labelcity.text = String(format: "%@ %@ %@", city!, state!, zip!)
        } else {
            city = "City"
        }
        if self.amount != nil {
            labelamount.text = amount
        } else {
            amount = "None"
        }
        if self.photo != nil {
            p1 = self.photo
        } else {
            p1 = "None"
        }
        if self.tbl11 != nil {
            t11 = tbl11
        } else {
            t11 = "None"
        }
        if self.tbl12 != nil {
            t12 = self.tbl12
        } else {
            t12 = "None"
        }
        if self.tbl13 != nil {
            t13 = self.tbl13
        } else {
            t13 = "None"
        }
        if self.tbl14 != nil {
            t14 = self.tbl14
        } else {
            t14 = "None"
        }
        if self.tbl15 != nil {
            t15 = self.tbl15
        } else {
            t15 = "None"
        }
        if self.tbl16 != nil {
            t16 = self.tbl16
        } else {
            t16 = "None"
        }
        if self.tbl21 != nil {
            t21 = self.tbl21
        } else {
            t21 = "None"
        }
        if self.tbl25 != nil {
            t25 = self.tbl25
        } else {
            t25 = "None"
        }
        if self.tbl26 != nil {
            t26 = self.tbl26
        } else {
            t26 = "None"
        }
    
        if (self.formController == "Leads" || self.formController == "Customer") {
            
            if self.salesman != nil {
                t22 = self.salesman
            } else {
                t22 = "None"
            }
            
            if self.jobdescription != nil {
                t23 = self.jobdescription
            } else {
                t23 = "None"
            }
            
            if self.advertiser != nil {
                t24 = self.advertiser
            } else {
                t24 = "None"
            }
            
        } else {
            
            if self.tbl22 != nil {
                t22 = self.tbl22
            } else {
                t22 = "None"
            }
            
            if self.tbl23 != nil {
                t23 = self.tbl23
            } else {
                t23 = "None"
            }
            
            if self.tbl24 != nil {
                t24 = self.tbl24
            } else {
                t24 = "None"
            }
        }
        
        tableData = [t11!, t12!, t13!, t14!, t15!, t16!]
        
        tableData2 = [t21!, t22!, t23!, t24!, t25!, t26!]
        
        tableData4 = [l11!, l12!, l13!, l14!, l15!, l16!]
        
        tableData3 = [l21!, l22!, l23!, l24!, l25!, l26!]
    }
    
    // MARK: - Parse
    
    func parseData() {
        
        if (formController == "Leads" || formController == "Customer") {
            
            let query1 = PFQuery(className:"Salesman")
            query1.whereKey("SalesNo", equalTo:self.tbl22!)
            query1.cachePolicy = PFCachePolicy.CacheThenNetwork
            query1.getFirstObjectInBackgroundWithBlock {(object: PFObject?, error: NSError?) -> Void in
                if error == nil {
                    self.salesman = object!.objectForKey("Salesman") as? String
                }
            }
            
            let query = PFQuery(className:"Job")
            query.whereKey("JobNo", equalTo:self.tbl23!)
            query.cachePolicy = PFCachePolicy.CacheThenNetwork
            query.getFirstObjectInBackgroundWithBlock {(object: PFObject?, error: NSError?) -> Void in
                if error == nil {
                    self.jobdescription = object!.objectForKey("Description") as? String
                }
            }
        }
        
        if (self.formController == "Customer") {
            
            let query = PFQuery(className:"Product")
            query.whereKey("ProductNo", equalTo:self.tbl24!)
            query.cachePolicy = PFCachePolicy.CacheThenNetwork
            query.getFirstObjectInBackgroundWithBlock {(object: PFObject?, error: NSError?) -> Void in
                if error == nil {
                    self.advertiser = object!.objectForKey("Products") as? String
                }
            }
        }
        
        if (self.formController == "Leads") {
            
            let query = PFQuery(className:"Advertising")
            query.whereKey("AdNo", equalTo:self.tbl24!)
            query.cachePolicy = PFCachePolicy.CacheThenNetwork
            query.getFirstObjectInBackgroundWithBlock {(object: PFObject?, error: NSError?) -> Void in
                if error == nil {
                    self.advertiser = object!.objectForKey("Advertiser") as? String
                }
            }
        }
    }
    
    // MARK: - Actions
    
    func actionButton(sender: AnyObject) {
        
        let alertController = UIAlertController(title:nil, message:nil, preferredStyle: .ActionSheet)
        
        let addr = UIAlertAction(title: "Add Contact", style: .Default, handler: { (action) -> Void in
            //self.performSegueWithIdentifier("snapshotSegue", sender: self)
        })
        let cal = UIAlertAction(title: "Add Calender Event", style: .Default, handler: { (action) -> Void in
            //self.performSegueWithIdentifier("userSegue", sender: self)
        })
        let web = UIAlertAction(title: "Web Page", style: .Default, handler: { (action) -> Void in
            self.openurl()
        })
        let new = UIAlertAction(title: "Add Customer", style: .Default, handler: { (action) -> Void in
            //self.performSegueWithIdentifier("codegenSegue", sender: self)
        })
        let phone = UIAlertAction(title: "Call Phone", style: .Default, handler: { (action) -> Void in
            self.callPhone()
        })
        let email = UIAlertAction(title: "Send Email", style: .Default, handler: { (action) -> Void in
            //self.performSegueWithIdentifier("showLogin", sender: self)
        })
        let buttonCancel = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
            //print("Cancel Button Pressed")
        }
        
        alertController.addAction(phone)
        alertController.addAction(email)
        alertController.addAction(addr)
        if (formController == "Leads") {
            alertController.addAction(new)
        }
        if (formController == "Vendor") {
            alertController.addAction(web)
        }
        if !(formController == "Employee") {
            alertController.addAction(cal)
        }
        alertController.addAction(buttonCancel)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.barButtonItem = sender as? UIBarButtonItem
        }
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func callPhone() {
        
        let phoneNo : NSString?
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Phone {
            
            if (formController == "Vendors" || formController == "Employee") {
                phoneNo = t11!
            } else {
                phoneNo = t12!
            }
            if let phoneCallURL:NSURL = NSURL(string:"telprompt:\(phoneNo!)") {
                
                let application:UIApplication = UIApplication.sharedApplication()
                if (application.canOpenURL(phoneCallURL)) {
                    application.openURL(phoneCallURL);
                }
            } else {
                
                let alert = UIAlertController(title: "Alert", message: "Call facility is not available!!!", preferredStyle: UIAlertControllerStyle.Alert)
                let alertActionTrue = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in })
                
                alert.addAction(alertActionTrue)
                self .presentViewController(alert, animated: true, completion: nil)
                
            }
        } else {
            
            let alert = UIAlertController(title: "Alert", message: "Your device doesn't support this feature.", preferredStyle: UIAlertControllerStyle.Alert)
            let alertActionTrue = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in })
            
            alert.addAction(alertActionTrue)
            self .presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func openurl() {
        
        //if !(self.tbl26 == NSNull() && self.tbl26 != "0") {
        
        
        if let url = NSURL(string: "\(self.tbl26!)") {
            UIApplication.sharedApplication().openURL(url)
        }
        
        /*
        let stringWithPossibleURL: String = "\(self.tbl26!)"// Or another source of text
        print(stringWithPossibleURL)
        
        if let validURL: NSURL = NSURL(string: stringWithPossibleURL) {
            // Successfully constructed an NSURL; open it
            UIApplication.sharedApplication().openURL(validURL)
        } */
        
        
        else {
            // Initialization failed; alert the user
            let controller: UIAlertController = UIAlertController(title: "Invalid URL", message: "Please try again.", preferredStyle: .Alert)
            controller.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    // MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showmapSegue" {
            
            let controller = segue.destinationViewController as? MapView
            controller!.mapaddress = self.address
            controller!.mapcity = self.city
            controller!.mapstate = self.state
            controller!.mapzip = self.zip
            
        }
        
        if segue.identifier == "editFormSegue" {
            let controller = segue.destinationViewController as? EditData
            if (formController == "Leads") {
                controller!.formController = "Leads"
                controller!.statis = "Edit"
                controller!.objectId = self.objectId //Parse Only
                controller!.leadNo = self.leadNo
                controller!.frm11 = self.tbl13 //first
                controller!.frm12 = self.name
                controller!.frm13 = nil
                controller!.frm14 = self.address
                controller!.frm15 = self.city
                controller!.frm16 = self.state
                controller!.frm17 = self.zip
                controller!.frm18 = self.date
                controller!.frm19 = self.tbl21 //aptdate
                controller!.frm20 = self.tbl12 //phone
                controller!.frm21 = self.tbl22 //salesNo
                controller!.frm22 = self.tbl23 //jobNo
                controller!.frm23 = self.tbl24 //adNo
                controller!.frm24 = self.amount
                controller!.frm25 = self.tbl15 //email
                controller!.frm26 = self.tbl14 //spouse
                controller!.frm27 = self.tbl11 //callback
                controller!.frm28 = self.comments
                controller!.frm29 = self.photo
                controller!.frm30 = self.active
                controller!.saleNo = self.tbl22
                controller!.jobNo = self.tbl23
                controller!.adNo = self.tbl24
                
            } else if (formController == "Customer") {
                controller!.formController = "Customer"
                controller!.statis = "Edit"
                controller!.objectId = self.objectId //Parse Only
                controller!.custNo = self.custNo
                controller!.leadNo = self.leadNo
                controller!.frm11 = self.tbl13 //first
                controller!.frm12 = self.name
                controller!.frm13 = self.tbl11
                controller!.frm14 = self.address
                controller!.frm15 = self.city
                controller!.frm16 = self.state
                controller!.frm17 = self.zip
                controller!.frm18 = self.date
                controller!.frm19 = self.tbl26 //rate
                controller!.frm20 = self.tbl12 //phone
                controller!.frm21 = self.tbl22 //salesNo
                controller!.frm22 = self.tbl23 //jobNo
                controller!.frm23 = self.tbl24 //prodNo
                controller!.frm24 = self.amount
                controller!.frm25 = self.tbl15 //email
                controller!.frm26 = self.tbl14 //spouse
                controller!.frm27 = self.tbl25 //quan
                controller!.frm28 = self.comments
                controller!.frm29 = self.photo
                controller!.frm30 = self.active
                controller!.frm31 = self.tbl21
                controller!.frm32 = self.complete
                controller!.saleNo = self.tbl22
                controller!.jobNo = self.tbl23
                controller!.adNo = self.tbl24
                controller!.time = self.tbl16
              //controller!.frm33 = self.photo1
              //controller!.frm34 = self.photo2
                
            } else if (formController == "Vendor") {
                controller!.formController = "Vendor"
                controller!.statis = "Edit"
                controller!.objectId = self.objectId //Parse Only
                controller!.leadNo = self.leadNo //vendorNo
                controller!.frm11 = self.name //vendorname
                controller!.frm12 = self.date //webpage
                controller!.frm13 = self.tbl24 //manager
                controller!.frm14 = self.address
                controller!.frm15 = self.city
                controller!.frm16 = self.state
                controller!.frm17 = self.zip
                controller!.frm18 = self.tbl25 //profession
                controller!.frm19 = self.tbl15 //assistant
                controller!.frm20 = self.tbl11 //phone
                controller!.frm21 = self.tbl12 //phone1
                controller!.frm22 = self.tbl13 //phone2
                controller!.frm23 = self.tbl14 //phone3
                controller!.frm24 = self.tbl22 //department
                controller!.frm25 = self.tbl21 //email
                controller!.frm26 = self.tbl23 //office
                controller!.frm27 = nil
                controller!.frm28 = self.comments
                controller!.frm29 = nil
                controller!.frm30 = self.active

            } else if (formController == "Employee") {
                controller!.formController = "Employee"
                controller!.statis = "Edit"
                controller!.objectId = self.objectId //Parse Only
                controller!.leadNo = self.leadNo //employeeNo
                controller!.frm11 = self.tbl26 //first
                controller!.frm12 = self.custNo //lastname
                controller!.frm13 = self.tbl27 //company
                controller!.frm14 = self.address
                controller!.frm15 = self.city
                controller!.frm16 = self.state
                controller!.frm17 = self.zip
                controller!.frm18 = self.tbl23 //title
                controller!.frm19 = self.tbl15 //middle
                controller!.frm20 = self.tbl11 //homephone
                controller!.frm21 = self.tbl12 //workphone
                controller!.frm22 = self.tbl13 //cellphone
                controller!.frm23 = self.tbl14 //social
                controller!.frm24 = self.tbl22 //department
                controller!.frm25 = self.tbl21 //email
                controller!.frm26 = self.tbl25 //manager
                controller!.frm27 = self.tbl24
                controller!.frm28 = self.comments
                controller!.frm29 = nil
                controller!.frm30 = self.active
                
            }
        }
    }
    
    
    
    
}
/*
// MARK: - Protocol
private extension LeadDetail {
    
    func configureStyling() {
        self.mapbutton!.backgroundColor = UIColor(red:0.0, green:122.0/255.0, blue:1.0, alpha: 1.0)
        self.mapbutton!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.mySwitch!.onTintColor = UIColor(red:0.0, green:122.0/255.0, blue:1.0, alpha: 1.0)
        self.mySwitch!.tintColor = UIColor.lightGrayColor()
        photoImage!.layer.borderColor = UIColor.lightGrayColor().CGColor
        photoImage!.layer.borderWidth = 1.0
        
        
    }
} */
