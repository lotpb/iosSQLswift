//
//  LeadDetail.swift
//  mySQLswift
//
//  Created by Peter Balsamo on 12/10/15.
//  Copyright © 2015 Peter Balsamo. All rights reserved.
//

import UIKit
import Parse
//import Contacts
import ContactsUI
import EventKit
import MessageUI

class LeadDetail: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    let ipadname = UIFont.systemFontOfSize(30, weight: UIFontWeightLight)
    let ipaddate = UIFont.systemFontOfSize(18, weight: UIFontWeightRegular)
    let ipadaddress = UIFont.systemFontOfSize(26, weight: UIFontWeightLight)
    let ipadAmount = UIFont.systemFontOfSize(36, weight: UIFontWeightRegular)
    
    let textname = UIFont.systemFontOfSize(24, weight: UIFontWeightLight)
    let textdate = UIFont.systemFontOfSize(16, weight: UIFontWeightRegular)
    let textaddress = UIFont.systemFontOfSize(20, weight: UIFontWeightRegular)
    let textAmount = UIFont.systemFontOfSize(30, weight: UIFontWeightRegular)
    
    let Vtextname = UIFont.systemFontOfSize(18, weight: UIFontWeightLight)
    let Vtextdate = UIFont.systemFontOfSize(12, weight: UIFontWeightRegular)
    let VtextAmount = UIFont.systemFontOfSize(20, weight: UIFontWeightMedium)
    
    let celltitle = UIFont.systemFontOfSize(12, weight: UIFontWeightSemibold)
    let cellsubtitle = UIFont.systemFontOfSize(12, weight: UIFontWeightLight)
    
    let newstitle = UIFont.systemFontOfSize(18, weight: UIFontWeightSemibold)
    let newssubtitle = UIFont.systemFontOfSize(16, weight: UIFontWeightLight)
    let newsdetail = UIFont.systemFontOfSize(16, weight: UIFontWeightRegular)
    
    let textbutton = UIFont.systemFontOfSize(18, weight: UIFontWeightRegular)
    
    var tableData : NSMutableArray = NSMutableArray()
    var tableData2 : NSMutableArray = NSMutableArray()
    var tableData3 : NSMutableArray = NSMutableArray()
    var tableData4 : NSMutableArray = NSMutableArray()
    
    @IBOutlet weak var scrollWall: UIScrollView?
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tableView: UIView!
    @IBOutlet weak var mySwitch: UISwitch!
    @IBOutlet weak var activebutton: UIButton!
    @IBOutlet weak var mapbutton: UIButton!
    
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var listTableView2: UITableView!
    @IBOutlet weak var newsTableView: UITableView!
    
    @IBOutlet weak var labelNo: UILabel!
    @IBOutlet weak var labelname: UILabel!
    @IBOutlet weak var labelamount: UILabel!
    @IBOutlet weak var labeldate: UILabel!
    @IBOutlet weak var labeladdress: UILabel!
    @IBOutlet weak var labelcity: UILabel!
    @IBOutlet weak var following: UILabel!
    @IBOutlet weak var labeldatetext: UILabel!
    
    var formController : String?
    var status : NSString?
    
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
    //var dateInput : UITextField?
    //var itemText : UITextField?
    
    var savedEventId : NSString?
    var getEmail : NSString?
    
    var emailTitle :NSString?
    var messageBody:NSString?
    
    var photoImage: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleButton: UIButton = UIButton(frame: CGRectMake(0, 0, 100, 32))
        titleButton.setTitle("myDetails", forState: UIControlState.Normal)
        titleButton.titleLabel?.font = Font.navlabel
        titleButton.titleLabel?.textAlignment = NSTextAlignment.Center
        titleButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        titleButton.addTarget(self, action: Selector(), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.titleView = titleButton
        
        self.listTableView!.rowHeight = 30
        self.listTableView2!.rowHeight = 30
        self.newsTableView!.estimatedRowHeight = 100
        self.newsTableView!.rowHeight = UITableViewAutomaticDimension
        self.newsTableView!.tableFooterView = UIView(frame: .zero)
        
        emailTitle = defaults.stringForKey("emailtitleKey")
        messageBody = defaults.stringForKey("emailmessageKey")
        
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad {
            
            labelamount!.font = ipadAmount
            labelname!.font = ipadname
            labeldate!.font = ipaddate
            labeladdress!.font = ipadaddress
            labelcity!.font = ipadaddress
            mapbutton!.titleLabel?.font = textbutton
            
        } else {
            
            labeladdress!.font = textaddress
            labelcity!.font = textaddress
            mapbutton!.titleLabel?.font = textbutton
            
            if (self.formController == "Vendor" || self.formController == "Employee") {
                labelamount!.font = VtextAmount
                labeldate!.font = Vtextdate
            } else {
                labelamount!.font = textAmount
                labeldate!.font = textdate
            }
            
            if self.formController == "Vendor" {
                labelname!.font = Vtextname
            } else {
                labelname!.font = textname
            }
        }
        
        if (self.formController == "Leads") {
            if (self.tbl11 == "Sold") {
                self.mySwitch!.setOn(true, animated:true)
            } else {
                self.mySwitch!.setOn(false, animated:true)
            }
        }
        
        self.mySwitch!.onTintColor = Color.BlueColor
        self.mySwitch!.tintColor = UIColor.lightGrayColor()

        photoImage = UIImageView(frame:CGRectMake(self.view.frame.size.width/2+15, 60, self.view.frame.size.width/2-25, 110))
        photoImage!.image = UIImage(named:"IMG_1133.jpg")
        photoImage!.clipsToBounds = true
        photoImage!.layer.borderColor = UIColor.lightGrayColor().CGColor
        photoImage!.layer.borderWidth = 1.0
        photoImage!.userInteractionEnabled = true
        self.mainView!.addSubview(photoImage!) 
        
        self.mapbutton!.backgroundColor = Color.BlueColor
        self.mapbutton!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.mapbutton!.addTarget(self, action: "mapButton", forControlEvents: UIControlEvents.TouchUpInside)
        let btnLayer3: CALayer = self.mapbutton!.layer
        btnLayer3.masksToBounds = true
        btnLayer3.cornerRadius = 9.0
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editButton")
        let actionButton = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "actionButton:")
        let buttons:NSArray = [editButton,actionButton]
        self.navigationItem.rightBarButtonItems = buttons as? [UIBarButtonItem]
        
        
        let topBorder = CALayer()
        let width = CGFloat(2.0)
        topBorder.borderColor = UIColor.lightGrayColor().CGColor
        topBorder.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 0.5)
        topBorder.borderWidth = width
        tableView.layer.addSublayer(topBorder)
        tableView.layer.masksToBounds = true
        
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
        self.labelname.text = ""
        self.labelamount.text = ""
        self.labeldate.text = ""
        self.labeladdress.text = ""
        self.labelcity.text = ""
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
        status = "Edit"
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
            
            if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad {
                cell.textLabel!.font = celltitle
                cell.detailTextLabel!.font = cellsubtitle
            } else {
                cell.textLabel!.font = celltitle
                cell.detailTextLabel!.font = cellsubtitle
            }
            
            cell.textLabel!.text = tableData4.objectAtIndex(indexPath.row) as? String
            cell.textLabel!.textColor = UIColor.blackColor()
            cell.detailTextLabel!.text = tableData.objectAtIndex(indexPath.row) as? String
            cell.detailTextLabel!.textColor = UIColor.blackColor()

            return cell
            
        } else if (tableView == self.listTableView2) {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

            if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad {
                cell.textLabel!.font = celltitle
                cell.detailTextLabel!.font = cellsubtitle
            } else {
                cell.textLabel!.font = celltitle
                cell.detailTextLabel!.font = cellsubtitle
            }
            
            cell.textLabel!.text = tableData3.objectAtIndex(indexPath.row) as? String
            cell.textLabel!.textColor = UIColor.blackColor()
            cell.detailTextLabel!.text = tableData2.objectAtIndex(indexPath.row) as? String
            cell.detailTextLabel!.textColor = UIColor.blackColor()

            return cell
            
        } else if (tableView == self.newsTableView) {
            
            var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! CustomTableCell!
            
            if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad {
                cell.leadtitleDetail!.font = newstitle
                cell.leadsubtitleDetail!.font = newssubtitle
                cell.leadreadDetail!.font = newsdetail
                cell.leadnewsDetail!.font = newsdetail
            } else {
                cell.leadtitleDetail!.font = newstitle
                cell.leadsubtitleDetail!.font = newssubtitle
                cell.leadreadDetail.font = newsdetail
                cell.leadnewsDetail!.font = newsdetail
            }
            
            let width = CGFloat(2.0)
            let topBorder = CALayer()
            topBorder.borderColor = UIColor.lightGrayColor().CGColor
            topBorder.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 0.5)
            topBorder.borderWidth = width
            cell.layer.addSublayer(topBorder)
            cell.layer.masksToBounds = true

            
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
            cell.leadreadDetail.textColor = Color.BlueColor
            
            cell.leadnewsDetail.text = self.comments as? String
            cell.leadnewsDetail.numberOfLines = 0
            //cell.leadnewsDetail.textColor = UIColor.darkGrayColor()

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
            self.createContact()
        })
        let cal = UIAlertAction(title: "Add Calender Event", style: .Default, handler: { (action) -> Void in
            self.addEvent()
        })
        let web = UIAlertAction(title: "Web Page", style: .Default, handler: { (action) -> Void in
            self.openurl()
        })
        let new = UIAlertAction(title: "Add Customer", style: .Default, handler: { (action) -> Void in
            self.status = "New"
            self.performSegueWithIdentifier("editFormSegue", sender: self)
        })
        let phone = UIAlertAction(title: "Call Phone", style: .Default, handler: { (action) -> Void in
            self.callPhone()
        })
        let email = UIAlertAction(title: "Send Email", style: .Default, handler: { (action) -> Void in
            self.sendEmail()
        })
        let bday = UIAlertAction(title: "Birthday", style: .Default, handler: { (action) -> Void in
            self.getBirthday()
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
        alertController.addAction(bday)
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
                
                self.simpleAlert("Alert", message: "Call facility is not available!!!")
            }
        } else {
            
            self.simpleAlert("Alert", message: "Your device doesn't support this feature.")
        }
    }
    
    func openurl() {
        
        if ((self.tbl26 != NSNull()) && ( self.tbl26 != 0 )) {
            
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
                
        } else {
            
            self.simpleAlert("Invalid URL", message: "Your field doesn't have valid URL.")
            }
        }
    
    func sendEmail() {
        if (formController == "Leads") || (formController == "Customer") {
            if ((self.tbl15 != NSNull()) && ( self.tbl15 != 0 )) {
                self.getEmail(t15!)
                
            } else {
                
                self.simpleAlert("Alert", message: "Your field doesn't have valid email.")
            }
        }
        if (formController == "Vendor") || (formController == "Employee") {
            if ((self.tbl21 != NSNull()) && ( self.tbl21 != 0 )) {
                self.getEmail(t21!)
                
            } else {
                
                self.simpleAlert("Alert", message: "Your field doesn't have valid email.")
            }
        }
    }
    
    func getEmail(emailfield: NSString) {
      
        let email = MFMailComposeViewController()
        email.mailComposeDelegate = self
        email.setToRecipients([emailfield as String])
        email.setSubject((emailTitle as? String)!)
        email.setMessageBody((messageBody as? String)!, isHTML:true)
        email.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        self.presentViewController(email, animated: true, completion: nil)
    }

    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addEvent() {
        let eventStore = EKEventStore()
        
        let itemText = defaults.stringForKey("eventtitleKey")!
        
        let startDate = NSDate().dateByAddingTimeInterval(60 * 60)
        let endDate = startDate.dateByAddingTimeInterval(60 * 60) // One hour
        
        if (EKEventStore.authorizationStatusForEntityType(.Event) != EKAuthorizationStatus.Authorized) {
            eventStore.requestAccessToEntityType(.Event, completion: {
                granted, error in
                self.createEvent(eventStore, title: String(format: "%@, %@", itemText, self.name!), startDate: startDate, endDate: endDate)
            })
        } else {
            createEvent(eventStore, title: String(format: "%@ %@", itemText, self.name!), startDate: startDate, endDate: endDate)
        }
    }
    
    func createEvent(eventStore: EKEventStore, title: String, startDate: NSDate, endDate: NSDate) {
        let event = EKEvent(eventStore: eventStore)
        
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.location = String(format: "%@ %@ %@ %@", self.address!,self.city!,self.state!,self.zip!)
        event.notes = self.comments as? String
        event.calendar = eventStore.defaultCalendarForNewEvents
        do {
            try eventStore.saveEvent(event, span: .ThisEvent)
            savedEventId = event.eventIdentifier
            
            self.simpleAlert("Event", message: "Event successfully saved.")
            
        } catch {
            print("Bad things happened")
        }
    }
    
    
    func createContact() {
        
        let newContact = CNMutableContact()
        
        if (formController == "Leads") {
            
            newContact.givenName = self.tbl13! as String
            newContact.familyName = self.name!
            
            let homeAddress = CNMutablePostalAddress()
            homeAddress.street = self.address!
            homeAddress.city = self.city!
            homeAddress.state = self.state!
            homeAddress.postalCode = self.zip!
            homeAddress.country = "US"
            newContact.postalAddresses = [CNLabeledValue(label:CNLabelHome, value:homeAddress)]
            
            let homephone = CNLabeledValue(label:CNLabelHome, value:CNPhoneNumber(stringValue: self.tbl12! as String))
            newContact.phoneNumbers = [homephone]
            
            let homeEmail = CNLabeledValue(label: CNLabelHome, value: self.tbl15!)
            newContact.emailAddresses = [homeEmail]
            
            newContact.note = self.comments as! String
        }
        
        if (formController == "Customer") {
            
            newContact.givenName = self.tbl13! as String
            newContact.familyName = self.name!
            
            let homeAddress = CNMutablePostalAddress()
            homeAddress.street = self.address!
            homeAddress.city = self.city!
            homeAddress.state = self.state!
            homeAddress.postalCode = self.zip!
            homeAddress.country = "US"
            newContact.postalAddresses = [CNLabeledValue(label:CNLabelHome, value:homeAddress)]
            
            let homephone = CNLabeledValue(label:CNLabelHome, value:CNPhoneNumber(stringValue:self.tbl12! as String))
            newContact.phoneNumbers = [homephone]
            
            let homeEmail = CNLabeledValue(label: CNLabelHome, value: self.tbl15!)
            newContact.emailAddresses = [homeEmail]
            
            newContact.organizationName = self.tbl11 as! String
            newContact.note = self.comments as! String
        }
        
        if (formController == "Vendor") {
            
            newContact.jobTitle = (self.tbl25 as? String)!
            newContact.organizationName = (self.name! as String)
            
            let homeAddress = CNMutablePostalAddress()
            homeAddress.street = self.address!
            homeAddress.city = self.city!
            homeAddress.state = self.state!
            homeAddress.postalCode = self.zip!
            homeAddress.country = "US"
            newContact.postalAddresses = [CNLabeledValue(label:CNLabelHome, value:homeAddress)]
            
            let homephone1 = CNLabeledValue(label:CNLabelWork, value:CNPhoneNumber(stringValue: self.tbl11! as String))
            let homephone2 = CNLabeledValue(label:CNLabelWork, value:CNPhoneNumber(stringValue: self.tbl12! as String))
            let homephone3 = CNLabeledValue(label:CNLabelWork, value:CNPhoneNumber(stringValue: self.tbl13! as String))
            let homephone4 = CNLabeledValue(label:CNLabelWork, value:CNPhoneNumber(stringValue: self.tbl14! as String))
            newContact.phoneNumbers = [homephone1, homephone2, homephone3, homephone4]
            
            let homeEmail = CNLabeledValue(label: CNLabelHome, value: self.tbl21!)
            newContact.emailAddresses = [homeEmail]
            
            newContact.note = self.comments as! String
        }
        
        if (formController == "Employee") {
            
            newContact.givenName = self.tbl26! as String
            newContact.middleName = self.tbl15! as String
            newContact.familyName = self.custNo!
            
            newContact.jobTitle = (self.tbl23 as String)
            newContact.organizationName = (self.tbl27! as String)
            
            let homeAddress = CNMutablePostalAddress()
            homeAddress.street = self.address!
            homeAddress.city = self.city!
            homeAddress.state = self.state!
            homeAddress.postalCode = self.zip!
            homeAddress.country = self.tbl25 as! String
            newContact.postalAddresses = [CNLabeledValue(label:CNLabelHome, value:homeAddress)]
            
            let homephone1 = CNLabeledValue(label:CNLabelHome, value:CNPhoneNumber(stringValue: self.tbl11! as String))
            let homephone2 = CNLabeledValue(label:CNLabelWork, value:CNPhoneNumber(stringValue: self.tbl12! as String))
            let homephone3 = CNLabeledValue(label:CNLabelPhoneNumberMobile, value:CNPhoneNumber(stringValue: self.tbl13! as String))
            newContact.phoneNumbers = [homephone1, homephone2, homephone3]

            let homeEmail = CNLabeledValue(label: CNLabelHome, value: self.tbl21!)
            //let workEmail = CNLabeledValue(label: CNLabelWork,value: "liam@workemail.com")
            newContact.emailAddresses = [homeEmail]
            
            let birthday = NSDateComponents()
            birthday.year = 1988 // You can omit the year value for a yearless birthday
            birthday.month = 12
            birthday.day = 05
            newContact.birthday = birthday
            
            let anniversaryDate = NSDateComponents()
            anniversaryDate.month = 10
            anniversaryDate.day = 12
            let anniversary = CNLabeledValue(label: "Anniversary", value: anniversaryDate)
            newContact.dates = [anniversary]
            
            newContact.note = self.comments as! String
            
            /*
            if let img = UIImage(named: "contactface"),
            let imgData = UIImagePNGRepresentation(img){
            newContact.imageData = imgData
            } */
            
            //newContact.departmentName = "Food and Beverages"
            
            /*
            let facebookProfile = CNLabeledValue(label: "FaceBook", value:
            CNSocialProfile(urlString: nil, username: "ios_blog",
            userIdentifier: nil, service: CNSocialProfileServiceFacebook))
            
            let twitterProfile = CNLabeledValue(label: "Twitter", value:
            CNSocialProfile(urlString: nil, username: "ios_blog",
            userIdentifier: nil, service: CNSocialProfileServiceTwitter))
            
            newContact.socialProfiles = [facebookProfile, twitterProfile]
            */
        }
        
        do {
            let saveRequest = CNSaveRequest()
            saveRequest.addContact(newContact, toContainerWithIdentifier: nil)
            let contactStore = CNContactStore()
            
            /*
            let predicate = CNContact.predicateForContactsMatchingName("Sam")
            let toFetch = [CNContactGivenNameKey, CNContactFamilyNameKey]
            let contacts = try contactStore.unifiedContactsMatchingPredicate(
                predicate, keysToFetch: toFetch) */
            

            try contactStore.executeSaveRequest(saveRequest)
            
            self.simpleAlert("Contact", message: "Contact successfully saved.")
        }
        catch {
            
            self.simpleAlert("Contact", message: "Failed to add the contact.")
            
        }
        
    }
    
    
     // FIXME:
    
    func getBirthday() {
        
        let store = CNContactStore()
        
        //This line retrieves all contacts for the current name and gets the birthday and name properties
        
        let contacts:[CNContact] = try! store.unifiedContactsMatchingPredicate(CNContact.predicateForContactsMatchingName("\(self.name!)"), keysToFetch:[CNContactBirthdayKey, CNContactGivenNameKey, CNContactFamilyNameKey])
        
        //Get the first contact in the array of contacts (since you're only looking for 1 you don't need to loop through the contacts)
        
        let contact = contacts[0]
        if (contact != 0) {

            if let bday = contact.birthday?.date as NSDate! {
                print(bday)
                let formatter = NSDateFormatter()
                formatter.timeZone = NSTimeZone(name: "UTC")
                formatter.dateFormat = "MMM-dd-yyyy"
                let stringDate = formatter.stringFromDate(contact.birthday!.date!)
                
                self.simpleAlert("\(self.name!) Birthday", message: stringDate)
            } else {
                self.simpleAlert("Alert", message: "No Birthdays")
            }
        }
    }
    
    
    // MARK: - AlertController
    
    func simpleAlert (title:String, message:String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
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
                
                if (self.status == "Edit") {
                    
                    controller!.formController = self.formController
                    controller!.status = "Edit"
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
                    
                } else if (self.status == "New") { //new Customer from Lead
                    
                    controller!.formController = "Customer"
                    controller!.status = "New"
                    controller!.custNo = self.custNo
                    controller!.frm31 = self.leadNo
                    controller!.frm11 = self.tbl13 //first
                    controller!.frm12 = self.name
                    controller!.frm13 = nil
                    controller!.frm14 = self.address
                    controller!.frm15 = self.city
                    controller!.frm16 = self.state
                    controller!.frm17 = self.zip
                    controller!.frm18 = nil //date
                    controller!.frm19 = nil //aptdate
                    controller!.frm20 = self.tbl12 //phone
                    controller!.frm21 = self.salesman
                    controller!.frm22 = self.jobdescription
                    controller!.frm23 = nil //adNo
                    controller!.frm24 = self.amount
                    controller!.frm25 = self.tbl15 //email
                    controller!.frm26 = self.tbl14 //spouse
                    controller!.frm27 = nil //callback
                    controller!.frm28 = self.comments
                    controller!.frm29 = self.photo
                    controller!.frm30 = self.active
                    //controller!.saleNoDetail = self.tbl22 //salesNo
                    //controller!.jobNoDetail = self.tbl23 //jobNo
                    
                }
                
            } else if (formController == "Customer") {
                controller!.formController = self.formController
                controller!.status = "Edit"
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
                controller!.formController = self.formController
                controller!.status = "Edit"
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
                controller!.formController = self.formController
                controller!.status = "Edit"
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


