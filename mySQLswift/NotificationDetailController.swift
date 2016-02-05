//
//  NotificationDetailController.swift
//  mySQLswift
//
//  Created by Peter Balsamo on 12/27/15.
//  Copyright © 2015 Peter Balsamo. All rights reserved.
//

import UIKit

class NotificationDetailController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let navlabel = UIFont.systemFontOfSize(25, weight: UIFontWeightThin)
    let ipadtitle = UIFont.systemFontOfSize(20, weight: UIFontWeightRegular)
    let ipadsubtitle = UIFont.systemFontOfSize(16, weight: UIFontWeightRegular)
    
    let celltitle = UIFont.systemFontOfSize(16, weight: UIFontWeightRegular)
    let cellsubtitle = UIFont.systemFontOfSize(12, weight: UIFontWeightRegular)
    let headtitle = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
    
    @IBOutlet weak var tableView: UITableView?
    var filteredString : NSMutableArray = NSMutableArray()
    var objects = [AnyObject]()
    var refreshControl: UIRefreshControl!
    //let searchController = UISearchController(searchResultsController: nil)
    var localNotifications = NSArray()
    var localNotification = UILocalNotification()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleButton: UIButton = UIButton(frame: CGRectMake(0, 0, 100, 32))
        titleButton.setTitle("myNotification list", forState: UIControlState.Normal)
        titleButton.titleLabel?.font = navlabel
        titleButton.titleLabel?.textAlignment = NSTextAlignment.Center
        titleButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        titleButton.addTarget(self, action:Selector(), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.titleView = titleButton
        
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        self.tableView!.rowHeight = 85
        //self.tableView!.estimatedRowHeight = 110
        //self.tableView!.rowHeight = UITableViewAutomaticDimension
        self.tableView!.backgroundColor = UIColor(white:0.90, alpha:1.0)

        //self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        let trashButton = UIBarButtonItem(barButtonSystemItem: .Trash, target: self, action: "deleteButton:")
        let buttons:NSArray = [trashButton]
        self.navigationItem.rightBarButtonItems = buttons as? [UIBarButtonItem]
        
        self.refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.clearColor()
        refreshControl.tintColor = UIColor.blackColor()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refreshData:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView!.addSubview(refreshControl)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //navigationController?.hidesBarsOnSwipe = true
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = UIColor.brownColor()
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
    
    // MARK: - Buttons
    
    func deleteButton(sender:UIButton) {

        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        self.tableView!.reloadData()
    }
    
    // MARK: - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (UIApplication.sharedApplication().scheduledLocalNotifications!.count)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell",
            forIndexPath: indexPath)
        /*
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: kCellIdentifier)
        } */

        
        localNotifications = UIApplication.sharedApplication().scheduledLocalNotifications!
        localNotification = localNotifications.objectAtIndex(indexPath.row) as! UILocalNotification
        
        cell.textLabel!.textColor = UIColor.grayColor()
        
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad {
            cell.textLabel!.font = ipadtitle
            cell.detailTextLabel!.font = ipadsubtitle

        } else {
            cell.textLabel!.font = celltitle
            cell.detailTextLabel!.font = celltitle
        }
        

        cell.textLabel!.text = localNotification.fireDate?.description
        cell.detailTextLabel!.text = localNotification.alertBody
        cell.detailTextLabel!.numberOfLines = 2
        
        /*
        let myLabel:UILabel = UILabel(frame: CGRectMake(10, 10, 50, 50))
        myLabel.backgroundColor = UIColor(white:0.45, alpha:1.0)
        myLabel.textColor = UIColor.whiteColor()
        myLabel.textAlignment = NSTextAlignment.Center
        myLabel.layer.masksToBounds = true
        myLabel.text = "Page"
        myLabel.font = headtitle
        myLabel.layer.cornerRadius = 25.0
        myLabel.userInteractionEnabled = true
        cell.addSubview(myLabel) */
        
        /*
        let imageName : UIImage = UIImage(named: "Thumb Up.png")!
        cell.imageView?.image = imageName
        cell.imageView!.userInteractionEnabled = true
        cell.imageView!.tag = indexPath.row */
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 90.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let vw = UIView()
        vw.backgroundColor = UIColor.brownColor()
        //tableView.tableHeaderView = vw
        
        let myLabel1:UILabel = UILabel(frame: CGRectMake(10, 15, 50, 50))
        myLabel1.numberOfLines = 0
        myLabel1.backgroundColor = UIColor.whiteColor()
        myLabel1.textColor = UIColor.blackColor()
        myLabel1.textAlignment = NSTextAlignment.Center
        myLabel1.layer.masksToBounds = true
        myLabel1.text = String(format: "%@%d", "Count\n", (UIApplication.sharedApplication().scheduledLocalNotifications!.count))
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
        myLabel2.text = "Active"
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
        myLabel3.text = ""
        myLabel3.font = headtitle
        myLabel3.layer.cornerRadius = 25.0
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
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    

    
}
