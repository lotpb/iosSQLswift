//
//  EditController.swift
//  mySQLswift
//
//  Created by Peter Balsamo on 1/4/16.
//  Copyright © 2016 Peter Balsamo. All rights reserved.
//

import UIKit
import Parse

class EditData: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView?
    
    @IBOutlet weak var first: UITextField!
    @IBOutlet weak var last: UITextField!
    @IBOutlet weak var company: UITextField!
    @IBOutlet weak var following: UILabel!
    @IBOutlet weak var activebutton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView?
    
    //var salesArray : NSMutableArray = NSMutableArray()
    //var callbackArray : NSMutableArray = NSMutableArray()
    //var contractorArray : NSMutableArray = NSMutableArray()
    //var rateArray : NSMutableArray = NSMutableArray()
    
    var datePickerView : UIDatePicker = UIDatePicker()
    var pickerView : UIPickerView = UIPickerView()
    var pickOption = ["Call", "Follow", "Looks Good", "Future", "Bought", "Dead", "Cancel", "Sold"]
    var pickRate = ["A", "B", "C", "D", "F"]
    var pickContract = ["A & S Home Improvement", "Islandwide Gutters", "Ashland Home Improvement", "John Kat Windows", "Jose Rosa", "Peter Balsamo"]
    
    var date : UITextField!
    var address : UITextField!
    var city : UITextField!
    var state : UITextField!
    var zip : UITextField!
    var aptDate : UITextField!
    var phone : UITextField!
    var salesman : UITextField!
    var jobName : UITextField!
    var adName : UITextField!
    var amount : UITextField!
    var email : UITextField!
    var spouse : UITextField!
    var callback : UITextField!
    var start : UITextField! //cust
    var complete : UITextField! //cust
    var comment : UITextView!
    
    var formController : NSString?
    var status : NSString?
    var objectId : NSString?
    var custNo : NSString?
    var leadNo : NSString?
    var time : NSString?

    var rate : NSString? //cust
    var saleNo : NSString?
    var jobNo : NSString?
    var adNo : NSString?
    
    var photo : NSString?
    var photo1 : NSString?
    var photo2 : NSString?
    
    var frm11 : NSString?
    var frm12 : NSString?
    var frm13 : NSString?
    var frm14 : NSString?
    var frm15 : NSString?
    var frm16 : NSString?
    var frm17 : NSString?
    var frm18 : NSString?
    var frm19 : NSString?
    var frm20 : NSString?
    var frm21 : NSString?
    var frm22 : NSString?
    var frm23 : NSString?
    var frm24 : NSString?
    var frm25 : NSString?
    var frm26 : NSString?
    var frm27 : NSString?
    var frm28 : NSString?
    var frm29 : NSString?
    var frm30 : NSString?
    var frm31 : NSString? //start
    var frm32 : NSString? //completion
    
    var defaults = NSUserDefaults.standardUserDefaults()
    var simpleStepper : UIStepper!
    var lookupItem : String?
    var pasteBoard = UIPasteboard.generalPasteboard()
    
    //var searchController: UISearchController!
    //var resultsController: UITableViewController!
    //var foundUsers = [String]()
    
    //var active : NSString?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleButton: UIButton = UIButton(frame: CGRectMake(0, 0, 100, 32))
        titleButton.setTitle(String(format: "%@ %@", self.status!, self.formController!), forState: UIControlState.Normal)
        titleButton.titleLabel?.font = Font.navlabel
        titleButton.titleLabel?.textAlignment = NSTextAlignment.Center
        titleButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        titleButton.addTarget(self, action: Selector(), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.titleView = titleButton
        
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        self.tableView!.estimatedRowHeight = 44
        self.tableView!.rowHeight = UITableViewAutomaticDimension
        self.tableView!.backgroundColor = UIColor.whiteColor()
        self.tableView!.tableFooterView = UIView(frame: .zero)
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "updateData")
        let buttons:NSArray = [saveButton]
        self.navigationItem.rightBarButtonItems = buttons as? [UIBarButtonItem]
        
        if (status == "New") {
            self.following!.text = "Following"
            self.frm30 = "1"
            let replyimage : UIImage? = UIImage(named:"iosStar.png")!
            self.activebutton!.setImage(replyimage, forState: .Normal)
        }
        
        if (status == "Edit") {
            parseLookup()
            if (frm30 == "1") { //if Active
                
                self.following.text = "Following"
                let replyimage : UIImage? = UIImage(named:"iosStar.png")!
                self.activebutton!.setImage(replyimage, forState: .Normal)
            } else {
                self.following.text = "Follow"
                let replyimage : UIImage? = UIImage(named:"iosStarNA.png")!
                self.activebutton.setImage(replyimage, forState: .Normal)
            }
        }
        
        profileImageView!.layer.cornerRadius = profileImageView!.frame.size.width/2
        profileImageView!.clipsToBounds = true
        
        //parsePick()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        passFieldData()
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
    
    
    // MARK: - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (self.formController == "Customer") {
            return 16
        } else {
            return 14
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if indexPath.row == 13 {
            return 100
        }
        return 44
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
    
        let textframe: UITextField?
        let textviewframe: UITextView?
        let aptframe: UITextField?
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.stringFromDate((NSDate()) as NSDate)
        
        aptframe = UITextField(frame:CGRect(x: 220, y: 7, width: 80, height: 30))
        
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad {
            
            textframe = UITextField(frame:CGRect(x: 118, y: 7, width: 250, height: 30))
            textviewframe = UITextView(frame:CGRect(x: 118, y: 7, width: 250, height: 95))
            textframe!.font = Font.Edittitle
            aptframe!.font = Font.Edittitle
            textviewframe!.font = Font.Edittitle
            self.first!.font = Font.Edittitle
            self.last!.font = Font.Edittitle
            self.company!.font = Font.Edittitle

        } else {
            
            textframe = UITextField(frame:CGRect(x: 118, y: 7, width: 205, height: 30))
            textviewframe = UITextView(frame:CGRect(x: 118, y: 7, width: 240, height: 95))
            textframe!.font = Font.Edittitle
            aptframe!.font = Font.Edittitle
            textviewframe!.font = Font.Edittitle
            self.first!.font = Font.Edittitle
            self.last!.font = Font.Edittitle
            self.company!.font = Font.Edittitle
        }
        
        textframe!.autocorrectionType = UITextAutocorrectionType.No
        textframe!.clearButtonMode = .WhileEditing
        textframe!.autocapitalizationType = UITextAutocapitalizationType.Words
        textframe!.textColor = UIColor.blackColor()
        
        self.comment?.autocorrectionType = UITextAutocorrectionType.Default
        self.callback?.clearButtonMode = .Never
        self.zip?.keyboardType = UIKeyboardType.DecimalPad
        
        if (formController == "Leads" || formController == "Customer") {
            self.amount?.keyboardType = UIKeyboardType.DecimalPad
        }
        if (formController == "Customer") {
            self.callback?.keyboardType = UIKeyboardType.DecimalPad
        }
        if (formController == "Vendor") {
            self.last?.keyboardType = UIKeyboardType.URL
            self.salesman?.keyboardType = UIKeyboardType.NumbersAndPunctuation
            self.jobName?.keyboardType = UIKeyboardType.NumbersAndPunctuation
            self.adName?.keyboardType = UIKeyboardType.NumbersAndPunctuation
        }
        if (formController == "Employee") {
            self.salesman?.keyboardType = UIKeyboardType.NumbersAndPunctuation
            self.jobName?.keyboardType = UIKeyboardType.NumbersAndPunctuation
            self.adName?.keyboardType = UIKeyboardType.NumbersAndPunctuation
        }
        self.email?.keyboardType = UIKeyboardType.EmailAddress
        self.phone?.keyboardType = UIKeyboardType.NumbersAndPunctuation
        
        self.email?.returnKeyType = UIReturnKeyType.Next
        
        if (indexPath.row == 0) {
            
            self.date = textframe
            self.date!.tag = 0
            
            if self.frm18 == nil {
                self.date!.text = ""
            } else {
                self.date!.text = self.frm18 as? String
            }
            
            if (self.formController == "Leads" || self.formController == "Customer") {
                if (self.status == "New") {
                    self.date?.text = dateString
                }
                self.date?.inputView = datePickerView
                datePickerView.datePickerMode = UIDatePickerMode.Date
                datePickerView.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
                //datePickerView.backgroundColor = UIColor.whiteColor()
            }
            
            if (self.formController == "Vendor") {
                self.date?.placeholder = "Profession"
                cell.textLabel!.text = "Profession"
                
            } else if (self.formController == "Employee") {
                self.date!.placeholder = "Title"
                cell.textLabel!.text = "Title"
                
            } else {
                self.date?.placeholder = "Date"
                cell.textLabel!.text = "Date"
            }
            
            cell.contentView.addSubview(self.date!)
            
        } else if (indexPath.row == 1) {
            
            self.address = textframe
            if self.frm14 == nil {
                self.address!.text = ""
            } else {
                self.address!.text = self.frm14 as? String
            }
            self.address!.placeholder = "Address"
            cell.textLabel!.text = "Address"
            cell.contentView.addSubview(self.address!)
            
        } else if (indexPath.row == 2) {
            
            self.city = textframe
            if self.frm15 == nil {
                self.city!.text = ""
            } else {
                self.city!.text = self.frm15 as? String
            }
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            self.city!.placeholder = "City"
            cell.textLabel!.text = "City"
            cell.contentView.addSubview(self.city!)
            
        } else if (indexPath.row == 3) {
            
            self.state = textframe
            if self.frm16 == nil {
                self.state!.text = ""
            } else {
                self.state!.text = self.frm16 as? String
            }
            self.state!.placeholder = "State"
            cell.textLabel!.text = "State"
            cell.contentView.addSubview(self.state!)
            
            self.zip = aptframe
            self.zip!.placeholder = "Zip"
                if self.frm17 == nil {
                    self.zip!.text = ""
                } else {
                    self.zip!.text = self.frm17 as? String
                }
            
            cell.contentView.addSubview(self.zip!)
            
        } else if (indexPath.row == 4) {
            
            self.aptDate = textframe
            if self.frm19 == nil {
                self.aptDate!.text = ""
            } else {
                self.aptDate!.text = self.frm19 as? String
            }
            if (self.formController == "Customer") {
                self.pickerView.tag = 24
                self.aptDate!.placeholder = "Rate"
                cell.textLabel!.text = "Rate"
                self.aptDate?.inputView = self.pickerView
                self.pickerView.reloadAllComponents()
                
                
            } else if (self.formController == "Vendor") {
                self.aptDate!.placeholder = "Assistant"
                cell.textLabel!.text = "Assistant"
                
            } else if (self.formController == "Employee") {
                self.aptDate!.placeholder = "Middle"
                cell.textLabel!.text = "Middle"
                
            } else { //leads
                if (self.status == "New") {
                    self.aptDate?.text = dateString
                }
                self.aptDate!.tag = 4
                self.aptDate!.placeholder = "Apt Date"
                cell.textLabel!.text = "Apt Date"
                self.aptDate!.inputView = datePickerView
                datePickerView.datePickerMode = UIDatePickerMode.Date
                datePickerView.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
                //datePickerView.backgroundColor = UIColor.whiteColor()
            }
            
            cell.contentView.addSubview(self.aptDate!)
            
        } else if (indexPath.row == 5) {
            
            self.phone = textframe
            self.phone!.placeholder = "Phone"
            if (self.frm20 == nil) {
                self.phone!.text = defaults.stringForKey("areacodeKey")
            } else {
                self.phone!.text = self.frm20 as? String
            }
            cell.textLabel!.text = "Phone"
            cell.contentView.addSubview(self.phone!)
            
        } else if (indexPath.row == 6) {
            
            self.salesman = textframe
            self.salesman!.adjustsFontSizeToFitWidth = true
            self.salesman!.tag = 6
            
            if self.frm21 == nil {
                self.salesman!.text = ""
            } else {
                self.salesman!.text = self.frm21 as? String
            }
 
            if (self.formController == "Vendor") {
                self.salesman!.placeholder = "Phone 1"
                cell.textLabel!.text = "Phone 1"
                self.salesman!.inputView = nil
                
            } else if (self.formController == "Employee") {
                self.salesman!.placeholder = "Work Phone"
                cell.textLabel!.text = "Work Phone"
                self.salesman!.inputView = nil
            } else {
                self.salesman!.placeholder = "Salesman"
                self.salesman!.inputView = nil //[self customPicker:6]
                cell.textLabel!.text = "Salesman"
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            }
            
            cell.contentView.addSubview(self.salesman!)
            
        } else if (indexPath.row == 7) {
            
            self.jobName = textframe
            if self.frm22 == nil {
                self.jobName!.text = ""
            } else {
                self.jobName!.text = self.frm22 as? String
            }
            
            if (self.formController == "Vendor") {
                self.jobName!.placeholder = "Phone 2"
                cell.textLabel!.text = "Phone 2"
                
            } else if (self.formController == "Employee") {
                self.jobName!.placeholder = "Cell Phone"
                cell.textLabel!.text = "Cell Phone"
            } else {
                self.jobName!.placeholder = "Job"
                cell.textLabel!.text = "Job"
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            }
            
            cell.contentView.addSubview(self.jobName!)
            
        } else if (indexPath.row == 8) {
            self.adName = textframe
            self.adName!.placeholder = "Advertiser"
            if self.frm23 == nil {
                self.adName!.text = ""
            } else {
                self.adName!.text = self.frm23 as? String
            }
            
            if ((self.formController == "Leads") || (self.formController == "Customer")) {
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            }
            if (self.formController == "Vendor") {
                self.adName!.placeholder = "Phone 3"
                cell.textLabel!.text = "phone 3"
                
            } else if (self.formController == "Employee") {
                self.adName!.placeholder = "Social Security"
                cell.textLabel!.text = "Social Sec"
                
            } else if (self.formController == "Customer") {
                self.adName!.placeholder = "Product"
                cell.textLabel!.text = "Product"
                
            } else {
                cell.textLabel!.text = "Advertiser"
            }
            
            cell.contentView.addSubview(self.adName!)
            
        } else if(indexPath.row == 9) {
            
            self.amount = textframe
            
            if ((self.formController == "Leads") || (self.formController == "Customer")){
                
                let simpleStepper = UIStepper(frame:CGRectZero)
                simpleStepper.tag = 9
                // FIXME:
                simpleStepper.value = 0 //Double(self.amount.text!)!
                simpleStepper.stepValue = 100
                simpleStepper.tintColor = UIColor.grayColor()
                cell.accessoryView = simpleStepper
                simpleStepper.addTarget(self, action: "stepperValueDidChange:", forControlEvents: UIControlEvents.ValueChanged)
            }
            
            self.amount!.placeholder = "Amount"
                if self.frm24 == nil {
                    self.amount!.text = ""
                } else {
                    self.amount!.text = self.frm24 as? String
                }
            cell.textLabel!.text = "Amount"
            
            if ((self.formController == "Vendor") || (self.formController == "Employee")) {
                self.amount!.placeholder = "Department"
                cell.textLabel!.text = "Department"
            }
            
            cell.contentView.addSubview(self.amount!)
            
        } else if (indexPath.row == 10) {
            
            self.email = textframe
            self.email!.placeholder = "Email"
            if self.frm25 == nil {
                self.email!.text = ""
            } else {
                self.email!.text = self.frm25 as? String
            }
            cell.textLabel!.text = "Email"
            cell.contentView.addSubview(self.email!)
            
        } else if(indexPath.row == 11) {
            self.spouse = textframe
            self.spouse!.placeholder = "Spouse"
            
            if self.frm26 == nil {
                self.spouse!.text = ""
            } else {
                self.spouse!.text = self.frm26 as? String
            }
            
            if (formController == "Vendor") {
                self.spouse!.placeholder = "Office"
                cell.textLabel!.text = "Office"
            } else if (formController == "Employee") {
                self.spouse!.placeholder = "Country"
                cell.textLabel!.text = "Country"
            } else {
                cell.textLabel!.text = "Spouse"
            }
            
            cell.contentView.addSubview(self.spouse!)
            
        } else if (indexPath.row == 12) {
            self.callback = textframe
            
            
                if self.frm27 == nil {
                    self.callback!.text = ""
                } else {
                    self.callback!.text = self.frm27 as? String
                }
            
            if (self.formController == "Customer") {
                self.callback!.placeholder = "Quan"
                cell.textLabel!.text = "# Windows"
                
                if (self.status == "Edit") {
                    
                    let simpleStepper = UIStepper(frame:CGRectZero)
                    simpleStepper.tag = 12
                    // FIXME:
                    simpleStepper.value = Double(self.callback.text!)!
                    simpleStepper.stepValue = 1
                    simpleStepper.tintColor = UIColor.grayColor()
                    cell.accessoryView = simpleStepper
                    simpleStepper.addTarget(self, action: "stepperValueDidChange:", forControlEvents: UIControlEvents.ValueChanged)
                }
            }
            else if (self.formController == "Vendor") {
                self.callback!.hidden = true //Field
                self.callback!.placeholder = ""
                cell.textLabel!.text = ""
            }
            else if (self.formController == "Employee") {
                self.callback!.placeholder = "Manager"
                cell.textLabel!.text = "Manager"
            }
            else {
                self.callback!.placeholder = "Call Back"
                cell.textLabel!.text = "Call Back"
                self.pickerView.tag = 12
                //self.pickerView.reloadAllComponents()
                self.callback?.inputView = self.pickerView
                
            }
            
            cell.contentView.addSubview(self.callback!)
            
        } else if (indexPath.row == 13) {
            self.comment = textviewframe
            if self.frm28 == nil {
                self.comment!.text = ""
            } else {
                self.comment!.text = self.frm28 as? String
            }
            cell.textLabel!.text = "Comments"
            cell.contentView.addSubview(self.comment!)
            
        } else if(indexPath.row == 14) {
            self.start = textframe
            self.start!.tag = 14
            self.start!.placeholder = "Start Date"
            if self.frm31 == nil {
                self.start!.text = ""
            } else {
                self.start!.text = self.frm31 as? String
            }
            self.start!.inputView = datePickerView
            datePickerView.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
            cell.textLabel!.text = "Start Date"
            cell.contentView.addSubview(self.start!)
            
        } else if(indexPath.row == 15) {
            self.complete = textframe
            self.complete!.tag = 15
            self.complete!.placeholder = "Completion Date"
            
            if self.frm32 == nil {
            self.complete!.text = ""
            } else {
            self.complete!.text = self.frm32 as? String
            }
            self.complete!.inputView = datePickerView
            datePickerView.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
            cell.textLabel!.text = "End Date"
            cell.contentView.addSubview(self.complete!)
            }
        
        return cell
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
    
    // MARK: - Button
    
    @IBAction func activeButton(sender: UIButton) {
        
        if(self.frm30 == "1") {
            self.following.text = "Following"
            self.frm30 = "1"
            let replyimage : UIImage? = UIImage(named:"iosStar.png")
            self.activebutton.setImage(replyimage, forState: .Normal)
        } else {
            self.following.text = "Follow"
            self.frm30 = "0"
            let replyimage : UIImage? = UIImage(named:"iosStarNA.png")
            self.activebutton.setImage(replyimage, forState: .Normal)
        }
    }
    
    
    // MARK: - StepperValueChanged
    
    func stepperValueDidChange(sender: UIStepper) {
        
        if (sender.tag == 12) {
            self.callback?.text = "\(Int(sender.value))"
        } else if (sender.tag == 9) {
            self.amount?.text = "\(Int(sender.value))"
        }
    }
    
    
    // MARK: - TextField
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    
    // MARK: - PickView
    // FIXME:
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 12) {
            return pickOption.count
        } else if (pickerView.tag == 24) {
            return pickRate.count
        } else if (pickerView.tag == 3) {
            return pickContract.count
        }else {
            return 0
             //return callbackArray.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if (pickerView.tag == 12) {
            //return callbackArray[row] .valueForKey("CallBack") as? String
            return "\(pickOption[row])"
            //return pickOption[row]
        } else if (pickerView.tag == 24) {
            return "\(pickRate[row])"
            //return pickRate[row]
        } else if (pickerView.tag == 3) {
            return "\(pickContract[row])"
            //return pickContract[row]
        }
        return nil
    }

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 12) {
            //self.callback.text = callbackArray[row] .valueForKey("CallBack") as? String
            self.callback.text = pickOption[row]
        } else if (pickerView.tag == 24) {
            self.aptDate.text = pickRate[row]
        } else if (pickerView.tag == 3) {
            self.company.text = pickContract[row]
        }
    }
    
    
    // MARK: - Datepicker
    
    func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if (sender.tag == 0) {
            self.date?.text = dateFormatter.stringFromDate(sender.date)
        } else if (sender.tag == 4) {
            self.aptDate?.text = dateFormatter.stringFromDate(sender.date)
        } else if (sender.tag == 14) {
            self.start?.text = dateFormatter.stringFromDate(sender.date)
        } else if (sender.tag == 15) {
            self.complete?.text = dateFormatter.stringFromDate(sender.date)
        }
    }
    
    
    // MARK: - FieldData Header
    
    func passFieldData() {
        
        if (self.formController == "Leads" || self.formController == "Customer") {
            self.last.borderStyle = UITextBorderStyle.RoundedRect
            self.last.layer.borderColor = UIColor(red:151/255.0, green:193/255.0, blue:252/255.0, alpha: 1.0).CGColor
            self.last.layer.borderWidth = 2.0
            self.last.layer.cornerRadius = 7.0
        }
        
        if (self.formController == "Vendor" || self.formController == "Employee") {
            self.first.borderStyle = UITextBorderStyle.RoundedRect
            self.first.layer.borderColor = UIColor(red:151/255.0, green:193/255.0, blue:252/255.0, alpha: 1.0).CGColor
            self.first.layer.borderWidth = 2.0
            self.first.layer.cornerRadius = 7.0
        }
        
        if self.frm11 != nil {
            self.first.text = self.frm11 as? String
        } else {
            self.first.text = ""
        }
        
        if self.frm12 != nil {
            self.last.text = self.frm12 as? String
        } else {
            self.last.text = ""
        }
        
        if self.frm13 != nil {
            self.company.text = self.frm13 as? String
        } else {
            self.company.text = ""
        }
        
        if (formController == "Customer") {
            
            
            if (self.status == "New") {
                self.company?.hidden = true
            } else {
                self.pickerView.tag = 3
                self.company.placeholder = "Contractor"
                self.company?.inputView = self.pickerView
                self.pickerView.reloadAllComponents()
            }
        } else if (self.formController == "Vendor") {
            self.first.placeholder = "Company"
            self.last.placeholder = "Webpage"
            self.company.placeholder = "Manager"
            
        } else if (formController == "Employee") {
            self.first.placeholder = "First"
            self.last.placeholder = "Last"
            self.company.placeholder = "Subcontractor"
            
        } else {
            self.company.hidden = true
        }
        
    }
    
    // MARK: - Parse
    
    func parsePick() {
        /*
        //if (self.formController == "Leads") {
            
            let query = PFQuery(className:"Callback")
            //query.orderByDescending("Callback")
            query.cachePolicy = PFCachePolicy.CacheThenNetwork
            query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil {
                    let temp: NSArray = objects! as NSArray
                    self.callbackArray = temp.mutableCopy() as! NSMutableArray
                    //self.pickerView.reloadAllComponents()
                    //self.tableView!.reloadData()
                } else {
                    print("Error")
                }
            }
       // } */
    }
    
    func parseLookup() {
        
        if (self.formController == "Leads") {
            
            let query = PFQuery(className:"Advertising")
            query.whereKey("AdNo", equalTo:self.frm23!)
            query.cachePolicy = PFCachePolicy.CacheThenNetwork
            query.getFirstObjectInBackgroundWithBlock {(object: PFObject?, error: NSError?) -> Void in
                if error == nil {
                    self.adName!.text = object!.objectForKey("Advertiser") as? String
                }
            }
        } else if (self.formController == "Customer") {
            
            let query = PFQuery(className:"Product")
            query.whereKey("ProductNo", equalTo:self.frm23!)
            query.cachePolicy = PFCachePolicy.CacheThenNetwork
            query.getFirstObjectInBackgroundWithBlock {(object: PFObject?, error: NSError?) -> Void in
                if error == nil {
                    self.adName!.text = object!.objectForKey("Products") as? String
                }
            }
        }
        
        if (self.formController == "Leads" || self.formController == "Customer") {
            
            let query = PFQuery(className:"Job")
            query.whereKey("JobNo", equalTo:self.frm22!)
            query.cachePolicy = PFCachePolicy.CacheThenNetwork
            query.getFirstObjectInBackgroundWithBlock {(object: PFObject?, error: NSError?) -> Void in
                if error == nil {
                    self.jobName!.text = object!.objectForKey("Description") as? String
                }
            }
            
            let query1 = PFQuery(className:"Salesman")
            query1.whereKey("SalesNo", equalTo:self.frm21!)
            query1.cachePolicy = PFCachePolicy.CacheThenNetwork
            query1.getFirstObjectInBackgroundWithBlock {(object: PFObject?, error: NSError?) -> Void in
                if error == nil {
                    self.salesman!.text = object!.objectForKey("Salesman") as? String
                }
            }
        } 
    }
    
    
    // MARK: - AlertController
    
    func simpleAlert (title:String, message:String) {
        
        let alertController = UIAlertController(title:title, message:message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title:"OK", style:UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated:true, completion:nil)
    }
    
    
    // MARK: - Segues
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if (indexPath.row == 2) {
            lookupItem = "City"
        }
        if (indexPath.row == 6) {
            lookupItem = "Salesman"
        }
        if (indexPath.row == 7) {
            lookupItem = "Job"
        }
        if (indexPath.row == 8) {
            if (self.formController == "Customer") {
                lookupItem = "Product"
            } else {
                lookupItem = "Advertiser"
            }
        }
        self.performSegueWithIdentifier("lookupDataSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "lookupDataSegue" {
            
            let controller = segue.destinationViewController as? LookupData
            controller!.delegate = self
            controller!.lookupItem = lookupItem
        }

    }
    
    // MARK: - Update Data
    
    func updateData() {
        
        let numberFormatter = NSNumberFormatter()
        
        if (self.formController == "Leads") {
    
            let myLead : NSNumber? = numberFormatter.numberFromString(self.leadNo as! String)!
            let myActive : NSNumber = numberFormatter.numberFromString((self.frm30 as? String)!)!
            let myZip : NSNumber = numberFormatter.numberFromString(self.zip.text!)!
            let mySale : NSNumber = numberFormatter.numberFromString(self.saleNo! as String)!
            let myJob : NSNumber = numberFormatter.numberFromString(self.jobNo! as String)!
            let myAd : NSNumber = numberFormatter.numberFromString(self.adNo! as String)!
            
            
            var Amount = self.amount.text
            numberFormatter.numberStyle = .NoStyle
            if Amount == nil { Amount = "0" }
            let myAmount = numberFormatter.numberFromString(Amount!)
            print(myAmount) 
            
            /*
            var Amount:NSNumber? = numberFormatter.numberFromString(self.amount.text!)
            numberFormatter.numberStyle = .DecimalStyle
            if Amount == nil {
                Amount = 0
            }
            //let myAmount =  numberFormatter.stringFromNumber(Amount!)
            let myAmount =  numberFormatter.stringFromNumber(Amount!)
            print(myAmount)
            
            */
            
            
            
            
            
            if (self.status == "Edit") { //Edit Lead
                
                let query = PFQuery(className:"Leads")
                query.whereKey("objectId", equalTo:self.objectId!)
                query.getFirstObjectInBackgroundWithBlock {(updateblog: PFObject?, error: NSError?) -> Void in
                    if error == nil {
                        updateblog!.setObject(myLead ?? NSNumber(integer:-1), forKey:"LeadNo")
                        updateblog!.setObject(myActive ?? NSNumber(integer:-1), forKey:"Active")
                        updateblog!.setObject(self.date.text ?? NSNull(), forKey:"Date")
                        updateblog!.setObject(self.first.text ?? NSNull(), forKey:"First")
                        updateblog!.setObject(self.last.text ?? NSNull(), forKey:"LastName")
                        updateblog!.setObject(self.address.text ?? NSNull(), forKey:"Address")
                        updateblog!.setObject(self.city.text ?? NSNull(), forKey:"City")
                        updateblog!.setObject(self.state.text ?? NSNull(), forKey:"State")
                        updateblog!.setObject(myZip ?? NSNumber(integer:-1), forKey:"Zip")
                        updateblog!.setObject(self.phone.text ?? NSNull(), forKey:"Phone")
                        updateblog!.setObject(self.aptDate.text ?? NSNull(), forKey:"AptDate")
                        updateblog!.setObject(self.email.text ?? NSNull(), forKey:"Email")
                        //updateblog!.setObject(myAmount ?? NSNumber(integer:-1), forKey:"Amount")
                        updateblog!.setObject(self.spouse.text ?? NSNull(), forKey:"Spouse")
                        updateblog!.setObject(self.callback.text ?? NSNull(), forKey:"CallBack")
                        updateblog!.setObject(mySale ?? NSNumber(integer:-1), forKey:"SalesNo")
                        updateblog!.setObject(myJob ?? NSNumber(integer:-1), forKey:"JobNo")
                        updateblog!.setObject(myAd ?? NSNumber(integer:-1), forKey:"AdNo")
                        updateblog!.setObject(self.comment.text ?? NSNull(), forKey:"Coments")
                        //updateblog!.setObject(self.photo.text ?? NSNull(), forKey:"Photo")
                        updateblog!.saveEventually()
                        
                        self.simpleAlert("Upload Complete", message: "Successfully updated the data")
                        
                    } else {
                        
                        self.simpleAlert("Upload Failure", message: "Failure updating the data")
                    }
                }
                self.navigationController?.popToRootViewControllerAnimated(true)
                
            } else { //Save Lead
                
                let saveblog:PFObject = PFObject(className:"Leads")
                saveblog.setObject(self.leadNo ?? NSNumber(integer:-1), forKey:"LeadNo")
                saveblog.setObject(self.frm30 ?? NSNumber(integer:1), forKey:"Active")
                saveblog.setObject(self.date.text ?? NSNull(), forKey:"Date")
                saveblog.setObject(self.first.text ?? NSNull(), forKey:"First")
                saveblog.setObject(self.last.text ?? NSNull(), forKey:"LastName")
                saveblog.setObject(self.address.text ?? NSNull(), forKey:"Address")
                saveblog.setObject(self.city.text ?? NSNull(), forKey:"City")
                saveblog.setObject(self.state.text ?? NSNull(), forKey:"State")
                saveblog.setObject(myZip ?? NSNumber(integer:-1), forKey:"Zip")
                saveblog.setObject(self.phone.text ?? NSNull(), forKey:"Phone")
                saveblog.setObject(self.aptDate.text ?? NSNull(), forKey:"AptDate")
                saveblog.setObject(self.email.text ?? NSNull(), forKey:"Email")
                saveblog.setObject(myAmount ?? NSNumber(integer:-1), forKey:"Amount")
                saveblog.setObject(self.spouse.text ?? NSNull(), forKey:"Spouse")
                saveblog.setObject(self.callback.text ?? NSNull(), forKey:"CallBack")
                saveblog.setObject(mySale ?? NSNumber(integer:-1), forKey:"SalesNo")
                saveblog.setObject(myJob ?? NSNumber(integer:-1), forKey:"JobNo")
                saveblog.setObject(myAd ?? NSNumber(integer:-1), forKey:"AdNo")
                saveblog.setObject(self.comment.text ?? NSNull(), forKey:"Coments")
                saveblog.setObject(self.photo ?? NSNull(), forKey:"Photo")
                
                PFACL.setDefaultACL(PFACL(), withAccessForCurrentUser: true)
                
                saveblog.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                    if success == true {
                        self.simpleAlert("Upload Complete", message: "Successfully updated the data")
                    } else {
                        self.simpleAlert("Upload Failure", message: "Failure updating the data")
                    }
                }
            }
            self.navigationController?.popToRootViewControllerAnimated(true)
            
        } else  if (self.formController == "Customer") {
            
            let myCust : NSNumber = numberFormatter.numberFromString(self.custNo as! String)!
            let myLead : NSNumber = numberFormatter.numberFromString(self.leadNo as! String)!
            let myActive : NSNumber = numberFormatter.numberFromString(self.frm30! as String)!
            let myZip : NSNumber = numberFormatter.numberFromString(self.zip.text!)!
            let myQuan : NSNumber = numberFormatter.numberFromString(self.callback.text!)!
            let mySale : NSNumber = numberFormatter.numberFromString(self.saleNo! as String)!
            let myJob : NSNumber = numberFormatter.numberFromString(self.jobNo! as String)!
            let myAd : NSNumber = numberFormatter.numberFromString(self.adNo! as String)!
            
            var Amount = (self.amount.text)
            numberFormatter.numberStyle = .NoStyle
            if Amount == nil {
                Amount = "0"
            }
            let myAmount =  numberFormatter.numberFromString(Amount!)
            
            if (self.status == "Edit") { //Edit Customer
                
                let query = PFQuery(className:"Customer")
                query.whereKey("objectId", equalTo:self.objectId!)
                query.getFirstObjectInBackgroundWithBlock {(updateblog: PFObject?, error: NSError?) -> Void in
                    if error == nil {
                        updateblog!.setObject(myCust ?? NSNumber(integer:-1), forKey:"CustNo")
                        updateblog!.setObject(myLead ?? NSNumber(integer:-1), forKey:"LeadNo")
                        updateblog!.setObject(myActive ?? NSNumber(integer:1), forKey:"Active")
                        updateblog!.setObject(self.date.text ?? NSNull(), forKey:"Date")
                        updateblog!.setObject(self.first.text ?? NSNull(), forKey:"First")
                        updateblog!.setObject(self.last.text ?? NSNull(), forKey:"LastName")
                        updateblog!.setObject(self.address.text ?? NSNull(), forKey:"Address")
                        updateblog!.setObject(self.city.text ?? NSNull(), forKey:"City")
                        updateblog!.setObject(self.state.text ?? NSNull(), forKey:"State")
                        updateblog!.setObject(myZip ?? NSNumber(integer:-1), forKey:"Zip")
                        updateblog!.setObject(self.phone.text ?? NSNull(), forKey:"Phone")
                        updateblog!.setObject(myQuan ?? NSNumber(integer:-1), forKey:"Quan")
                        updateblog!.setObject(self.email.text ?? NSNull(), forKey:"Email")
                        updateblog!.setObject(myAmount ?? NSNumber(integer:-1), forKey:"Amount")
                        updateblog!.setObject(self.spouse.text ?? NSNull(), forKey:"Spouse")
                        updateblog!.setObject(self.aptDate.text ?? NSNull(), forKey:"Rate")
                        updateblog!.setObject(mySale ?? NSNumber(integer:-1), forKey:"SalesNo")
                        updateblog!.setObject(myJob ?? NSNumber(integer:-1), forKey:"JobNo")
                        updateblog!.setObject(myAd ?? NSNumber(integer:-1), forKey:"ProductNo")
                        updateblog!.setObject(self.start.text ?? NSNull(), forKey:"Start")
                        updateblog!.setObject(self.complete.text ?? NSNull(), forKey:"Completion")
                        updateblog!.setObject(self.comment.text ?? NSNull(), forKey:"Comments")
                        updateblog!.setObject(self.company.text ?? NSNull(), forKey:"Contractor")
                        updateblog!.setObject(self.photo ?? NSNull(), forKey:"Photo")
                        updateblog!.setObject(self.photo1 ?? NSNull(), forKey:"Photo1")
                        updateblog!.setObject(self.photo2 ?? NSNull(), forKey:"Photo2")
                        updateblog!.setObject(self.time ?? NSNull(), forKey:"Time")
                        updateblog!.saveEventually()
                        
                        self.simpleAlert("Upload Complete", message: "Successfully updated the data")
                        
                    } else {
                        
                        self.simpleAlert("Upload Failure", message: "Failure updating the data")
                    }
                }
                self.navigationController?.popToRootViewControllerAnimated(true)
                
            } else { //Save Customer
                
                let saveblog:PFObject = PFObject(className:"Customer")
                saveblog.setObject(myCust ?? NSNumber(integer:-1), forKey:"CustNo")
                saveblog.setObject(myLead ?? NSNumber(integer:-1), forKey:"LeadNo")
                saveblog.setObject(myActive ?? NSNumber(integer:1), forKey:"Active")
                saveblog.setObject(self.date.text ?? NSNull(), forKey:"Date")
                saveblog.setObject(self.first.text ?? NSNull(), forKey:"First")
                saveblog.setObject(self.last.text ?? NSNull(), forKey:"LastName")
                saveblog.setObject(self.company.text ?? NSNull(), forKey:"Contractor")
                saveblog.setObject(self.address.text ?? NSNull(), forKey:"Address")
                saveblog.setObject(self.city.text ?? NSNull(), forKey:"City")
                saveblog.setObject(self.state.text ?? NSNull(), forKey:"State")
                saveblog.setObject(myZip ?? NSNumber(integer:-1), forKey:"Zip")
                saveblog.setObject(self.phone.text ?? NSNull(), forKey:"Phone")
                saveblog.setObject(self.aptDate.text ?? NSNull(), forKey:"Rate")
                saveblog.setObject(mySale ?? NSNumber(integer:-1), forKey:"SalesNo")
                saveblog.setObject(myJob ?? NSNumber(integer:-1), forKey:"JobNo")
                saveblog.setObject(myAd ?? NSNumber(integer:-1), forKey:"AdNo")
                saveblog.setObject(myAmount ?? NSNumber(integer:-1), forKey:"Amount")
                saveblog.setObject(myQuan ?? NSNumber(integer:-1), forKey:"Quan")
                saveblog.setObject(self.email.text ?? NSNull(), forKey:"Email")
                saveblog.setObject(self.spouse.text ?? NSNull(), forKey:"Spouse")
                saveblog.setObject(self.callback.text ?? NSNull(), forKey:"CallBack")
                saveblog.setObject(self.start.text ?? NSNull(), forKey:"Start")
                saveblog.setObject(self.complete.text ?? NSNull(), forKey:"Complete")
                saveblog.setObject(self.comment.text ?? NSNull(), forKey:"Comment")
                saveblog.setObject(NSNull(), forKey:"Photo")
                
                PFACL.setDefaultACL(PFACL(), withAccessForCurrentUser: true)
                
                saveblog.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                    if success == true {
                        self.simpleAlert("Upload Complete", message: "Successfully updated the data")
                    } else {
                        self.simpleAlert("Upload Failure", message: "Failure updating the data")
                    }
                }
            }
            self.navigationController?.popToRootViewControllerAnimated(true)
            
        } else  if (self.formController == "Vendor") {
            
            var Active = (self.frm30 as? String)
            numberFormatter.numberStyle = .NoStyle
            if Active == nil { Active = "0" }
            let myActive =  numberFormatter.numberFromString(Active!)
            
            var Lead = (self.leadNo)
            numberFormatter.numberStyle = .NoStyle
            if Lead == nil {
                Lead = "-1"
            }
            let myLead =  numberFormatter.numberFromString(Lead! as String)
            
            if (self.status == "Edit") { //Edit Vendor
                
                let query = PFQuery(className:"Vendors")
                query.whereKey("objectId", equalTo:self.objectId!)
                query.getFirstObjectInBackgroundWithBlock {(updateblog: PFObject?, error: NSError?) -> Void in
                    if error == nil {
                        updateblog!.setObject(myLead!, forKey:"VendorNo")
                        updateblog!.setObject(myActive!, forKey:"Active")
                        updateblog!.setObject(self.first.text ?? NSNull(), forKey:"Vendor")
                        updateblog!.setObject(self.address.text ?? NSNull(), forKey:"Address")
                        updateblog!.setObject(self.city.text ?? NSNull(), forKey:"City")
                        updateblog!.setObject(self.state.text ?? NSNull(), forKey:"State")
                        updateblog!.setObject(self.zip.text ?? NSNull(), forKey:"Zip")
                        updateblog!.setObject(self.phone.text ?? NSNull(), forKey:"Phone")
                        updateblog!.setObject(self.salesman.text ?? NSNull(), forKey:"Phone1")
                        updateblog!.setObject(self.jobName.text ?? NSNull(), forKey:"Phone2")
                        updateblog!.setObject(self.adName.text ?? NSNull(), forKey:"Phone3")
                        updateblog!.setObject(self.email.text ?? NSNull(), forKey:"Email")
                        updateblog!.setObject(self.last.text ?? NSNull(), forKey:"WebPage")
                        updateblog!.setObject(self.amount.text ?? NSNull(), forKey:"Department")
                        updateblog!.setObject(self.spouse.text ?? NSNull(), forKey:"Office")
                        updateblog!.setObject(self.company.text ?? NSNull(), forKey:"Manager")
                        updateblog!.setObject(self.date.text ?? NSNull(), forKey:"Profession")
                        updateblog!.setObject(self.aptDate.text ?? NSNull(), forKey:"Assistant")
                        updateblog!.setObject(self.comment.text ?? NSNull(), forKey:"Comments")
                        updateblog!.saveEventually()
                        
                        self.simpleAlert("Upload Complete", message: "Successfully updated the data")
                        
                    } else {
                        
                        self.simpleAlert("Upload Failure", message: "Failure updating the data")
                    }
                }
                self.navigationController?.popToRootViewControllerAnimated(true)
                
            } else { //Save Vendor
                
                let saveVend:PFObject = PFObject(className:"Vendors")
                saveVend.setObject(myLead!, forKey:"VendorNo")
                saveVend.setObject(myActive!, forKey:"Active")
                saveVend.setObject(self.first.text ?? NSNull(), forKey:"Vendor")
                saveVend.setObject(self.address.text ?? NSNull(), forKey:"Address")
                saveVend.setObject(self.city.text ?? NSNull(), forKey:"City")
                saveVend.setObject(self.state.text ?? NSNull(), forKey:"State")
                saveVend.setObject(self.zip.text ?? NSNumber(integer:-1), forKey:"Zip")
                saveVend.setObject(self.phone.text ?? NSNull(), forKey:"Phone")
                saveVend.setObject(self.salesman.text ?? NSNull(), forKey:"Phone1")
                saveVend.setObject(self.jobName.text ?? NSNull(), forKey:"Phone2")
                saveVend.setObject(self.adName.text ?? NSNull(), forKey:"Phone3")
                saveVend.setObject(self.email.text ?? NSNull(), forKey:"Email")
                saveVend.setObject(self.last.text ?? NSNull(), forKey:"WebPage")
                saveVend.setObject(self.amount.text ?? NSNull(), forKey:"Department")
                saveVend.setObject(self.spouse.text ?? NSNull(), forKey:"Office")
                saveVend.setObject(self.company.text ?? NSNull(), forKey:"Manager")
                saveVend.setObject(self.date.text ?? NSNull(), forKey:"Profession")
                saveVend.setObject(self.aptDate.text ?? NSNull(), forKey:"Assistant")
                saveVend.setObject(self.comment.text ?? NSNull(), forKey:"Comments")
                
                PFACL.setDefaultACL(PFACL(), withAccessForCurrentUser: true)
                
                saveVend.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                    if success == true {
                        self.simpleAlert("Upload Complete", message: "Successfully updated the data")
                    } else {
                        
                        self.simpleAlert("Upload Failure", message: "Failure updating the data")
                    }
                }
            }
            self.navigationController?.popToRootViewControllerAnimated(true)
            
        } else if (self.formController == "Employee") {
            
            var Active = (self.frm30 as? String)
            numberFormatter.numberStyle = .NoStyle
            if Active == nil {
                Active = "0"
            }
            let myActive =  numberFormatter.numberFromString(Active!)
            
            var Lead = (self.leadNo as? String)
            numberFormatter.numberStyle = .NoStyle
            if Lead == nil {
                Lead = "-1"
            }
            let myLead =  numberFormatter.numberFromString(Lead!)
            
            if (self.status == "Edit") { //Edit Employee
                
                let query = PFQuery(className:"Employee")
                query.whereKey("objectId", equalTo:self.objectId!)
                query.getFirstObjectInBackgroundWithBlock {(updateblog: PFObject?, error: NSError?) -> Void in
                    if error == nil {
                        updateblog!.setObject(myLead!, forKey:"EmployeeNo")
                        updateblog!.setObject(myActive!, forKey:"Active")
                        updateblog!.setObject(self.company.text ?? NSNull(), forKey:"Company")
                        updateblog!.setObject(self.address.text ?? NSNull(), forKey:"Address")
                        updateblog!.setObject(self.city.text ?? NSNull(), forKey:"City")
                        updateblog!.setObject(self.state.text ?? NSNull(), forKey:"State")
                        updateblog!.setObject(self.zip.text ?? NSNull(), forKey:"Zip")
                        updateblog!.setObject(self.phone.text ?? NSNull(), forKey:"HomePhone")
                        updateblog!.setObject(self.salesman.text ?? NSNull(), forKey:"WorkPhone")
                        updateblog!.setObject(self.jobName.text ?? NSNull(), forKey:"CellPhone")
                        updateblog!.setObject(self.adName.text ?? NSNull(), forKey:"SS")
                        updateblog!.setObject(self.email.text ?? NSNull(), forKey:"Email")
                        updateblog!.setObject(self.last.text ?? NSNull(), forKey:"Last")
                        updateblog!.setObject(self.amount.text ?? NSNull(), forKey:"Department")
                        updateblog!.setObject(self.spouse.text ?? NSNull(), forKey:"Country")
                        updateblog!.setObject(self.first.text ?? NSNull(), forKey:"First")
                        updateblog!.setObject(self.callback.text ?? NSNull(), forKey:"Manager")
                        updateblog!.setObject(self.date.text ?? NSNull(), forKey:"Title")
                        updateblog!.setObject(self.aptDate.text ?? NSNull(), forKey:"Middle")
                        updateblog!.setObject(self.comment.text ?? NSNull(), forKey:"Comments")
                        updateblog!.saveEventually()

                        self.simpleAlert("Upload Complete", message: "Successfully updated the data")
                        
                    } else {
                        
                        self.simpleAlert("Upload Failure", message: "Failure updating the data")
                    }
                }
                self.navigationController?.popToRootViewControllerAnimated(true)
                
            } else { //Save Employee
                
                let saveblog:PFObject = PFObject(className:"Employee")
                saveblog.setObject(NSNumber(integer:-1), forKey:"EmployeeNo")
                saveblog.setObject(NSNumber(integer:1), forKey:"Active")
                saveblog.setObject(self.company.text ?? NSNull(), forKey:"Company")
                saveblog.setObject(self.address.text ?? NSNull(), forKey:"Address")
                saveblog.setObject(self.city.text ?? NSNull(), forKey:"City")
                saveblog.setObject(self.state.text ?? NSNull(), forKey:"State")
                saveblog.setObject(self.zip.text ?? NSNull(), forKey:"Zip")
                saveblog.setObject(self.phone.text ?? NSNull(), forKey:"HomePhone")
                saveblog.setObject(self.salesman.text ?? NSNull(), forKey:"WorkPhone")
                saveblog.setObject(self.jobName.text ?? NSNull(), forKey:"CellPhone")
                saveblog.setObject(self.adName.text ?? NSNull(), forKey:"SS")
                saveblog.setObject(self.date.text ?? NSNull(), forKey:"Country")
                saveblog.setObject(self.email.text ?? NSNull(), forKey:"Email")
                saveblog.setObject(self.last.text ?? NSNull(), forKey:"Last")
                saveblog.setObject(self.amount.text ?? NSNull(), forKey:"Department")
                saveblog.setObject(self.aptDate.text ?? NSNull(), forKey:"Middle")
                saveblog.setObject(self.first.text ?? NSNull(), forKey:"First")
                saveblog.setObject(self.callback.text ?? NSNull(), forKey:"Manager")
                saveblog.setObject(self.spouse.text ?? NSNull(), forKey:"Title")
                saveblog.setObject(self.comment.text ?? NSNull(), forKey:"Comments")
                
                PFACL.setDefaultACL(PFACL(), withAccessForCurrentUser: true)
                
                saveblog.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                    if success == true {
                        self.simpleAlert("Upload Complete", message: "Successfully updated the data")
                        
                    } else {
                        
                        self.simpleAlert("Upload Failure", message: "Failure updating the data")
                    }
                }
            }
        }
    }
}

extension EditData: LookupDataDelegate {
    func cityFromController(passedData: NSString) {
        self.city!.text = passedData as String
    }
    func stateFromController(passedData: NSString) {
        self.state!.text = passedData as String
    }
    func zipFromController(passedData: NSString) {
        self.zip!.text = passedData as String
    }
    func salesFromController(passedData: NSString) {
        self.saleNo! = passedData as String
    }
    func salesNameFromController(passedData: NSString) {
        self.salesman!.text = passedData as String
    }
    func jobFromController(passedData: NSString) {
        self.jobNo! = passedData as String
    }
    func jobNameFromController(passedData: NSString) {
        self.jobName!.text = passedData as String
    }
    func productFromController(passedData: NSString) {
        self.adNo! = passedData as String
    }
    func productNameFromController(passedData: NSString) {
        self.adName!.text = passedData as String
    }
}
