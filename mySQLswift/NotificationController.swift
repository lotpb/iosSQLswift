//
//  NotificationController.swift
//  mySQLswift
//
//  Created by Peter Balsamo on 12/20/15.
//  Copyright © 2015 Peter Balsamo. All rights reserved.
//

import UIKit

class NotificationController: UIViewController {
    
    @IBOutlet weak var customMessage: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var frequencySegmentedControl : UISegmentedControl!
    @IBOutlet weak var saveButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        let titleButton: UIButton = UIButton(frame: CGRectMake(0, 0, 100, 32))
        titleButton.setTitle("myNotification", forState: UIControlState.Normal)
        titleButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 25.0)
        titleButton.titleLabel?.textAlignment = NSTextAlignment.Center
        titleButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        //titleButton.addTarget(self, action: Selector(), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.titleView = titleButton
        
        //let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: Selector())
        let editButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: Selector("editButton:"))
        let buttons:NSArray = [editButton]
        self.navigationItem.rightBarButtonItems = buttons as? [UIBarButtonItem]
        
        self.customMessage.clearButtonMode = .Always
        self.customMessage.clearButtonMode = .WhileEditing
        self.customMessage!.font = UIFont (name: "HelveticaNeue", size: 18)
        self.customMessage.placeholder = "enter notification"
        
        UITextField.appearance().tintColor = UIColor.orangeColor()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        //self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = UIColor(white:0.45, alpha:1.0)
    }
    
    func editButton(sender:AnyObject) {
        
        self.performSegueWithIdentifier("notificationdetailsegue", sender: self)
        
    }
    
    // MARK: - localNotification
    
    /*
    override class func initialize() {
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            self.sendNotification()
        }
    } */
    
    @IBAction func sendNotification(sender:AnyObject) {
        
        let notifications:UILocalNotification = UILocalNotification()
        //notifications.timeZone = NSTimeZone.localTimeZone()
        //notifications.timeZone = NSTimeZone.systemTimeZone()
        notifications.fireDate = datePicker.date
        
        switch(frequencySegmentedControl.selectedSegmentIndex){
        case 0:
            notifications.repeatInterval = NSCalendarUnit(rawValue: 0)
            break;
        case 1:
            notifications.repeatInterval = .Day
            break;
        case 2:
            notifications.repeatInterval = .Weekday
            break;
        case 3:
            notifications.repeatInterval = .Year
            break;
        default:
            notifications.repeatInterval = NSCalendarUnit(rawValue: 0)
            break;
        }
        
        notifications.alertBody = customMessage.text
        notifications.alertAction = "Hey you! Yeah you! Swipe to unlock!"
        notifications.category = "status"
        notifications.userInfo = [ "cause": "inactiveMembership"]
        notifications.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
        notifications.soundName = "Tornado.caf"
        UIApplication.sharedApplication().scheduleLocalNotification(notifications)
        self.customMessage.text = ""
    }
    
     @IBAction func memberNotification(sender:AnyObject) {
      
        let notifications:UILocalNotification = UILocalNotification()
        notifications.fireDate = datePicker.date
        notifications.timeZone = NSTimeZone.localTimeZone()
        
        switch(frequencySegmentedControl.selectedSegmentIndex){
        case 0:
            notifications.repeatInterval = NSCalendarUnit(rawValue: 0)
            break;
        case 1:
            notifications.repeatInterval = .Day
            break;
        case 2:
            notifications.repeatInterval = .Weekday
            break;
        case 3:
            notifications.repeatInterval = .Year
            break;
        default:
            notifications.repeatInterval = NSCalendarUnit(rawValue: 0)
            break;
        }
        
        notifications.alertAction = "Membership Status"
        notifications.alertBody = "Our system has detected that your membership is inactive."
        notifications.category = "status"
        notifications.userInfo = [ "cause": "inactiveMembership"]
        notifications.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
        notifications.soundName = "Tornado.caf"
        UIApplication.sharedApplication().scheduleLocalNotification(notifications)
        self.customMessage.text = ""
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
