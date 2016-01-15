//
//  News.swift
//  mySQLswift
//
//  Created by Peter Balsamo on 12/9/15.
//  Copyright © 2015 Peter Balsamo. All rights reserved.
//

import UIKit
import Parse
import AVKit
import AVFoundation

class News: UIViewController {

    @IBOutlet weak var wallScroll: UIScrollView?
    @IBOutlet weak var DateInput: UITextField?
    @IBOutlet weak var itemText: UITextField?
    
    @IBOutlet weak var videoController: AVPlayerViewController?
    
    //var refreshControl: UIRefreshControl!
    var imageFilesArray : NSArray!
    var imageDetailurl : NSString?
    
    var videoURL : NSURL?

 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleButton: UIButton = UIButton(frame: CGRectMake(0, 0, 100, 32))
        titleButton.setTitle("News Today", forState: UIControlState.Normal)
        titleButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 25.0)
        titleButton.titleLabel?.textAlignment = NSTextAlignment.Center
        titleButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        titleButton.addTarget(self, action: Selector(), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.titleView = titleButton


        //self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: Selector())
        let searchButton = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: Selector("searchButton:"))
        let buttons:NSArray = [addButton,searchButton]
        self.navigationItem.rightBarButtonItems = buttons as? [UIBarButtonItem]
        

    }
        
    override func viewWillAppear(animated: Bool) {
        //self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = UIColor(white:0.45, alpha:1.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:, // TODO: and // FIXME:
    


    
    // MARK: - localNotification
    
    override class func initialize() {
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            self.sendNotification()
        }
    }
    
    class func sendNotification() {
        let localNotification: UILocalNotification = UILocalNotification()
        localNotification.alertAction = "Membership Status"
        localNotification.alertBody = "Our system has detected that your membership is inactive."
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 10)
        localNotification.timeZone = NSTimeZone.localTimeZone()
        localNotification.category = "status"
        localNotification.userInfo = [ "cause": "inactiveMembership"]
        localNotification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
}
//-----------------------end------------------------------



