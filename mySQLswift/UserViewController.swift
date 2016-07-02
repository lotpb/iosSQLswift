//
//  UserViewController.swift
//  mySQLswift
//
//  Created by Peter Balsamo on 12/17/15.
//  Copyright © 2015 Peter Balsamo. All rights reserved.
//

import UIKit
import Parse
import MapKit
import CoreLocation

class UserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate,  UICollectionViewDataSource, MKMapViewDelegate {
    
    let ipadtitle = UIFont.systemFontOfSize(20, weight: UIFontWeightRegular)
    let ipadsubtitle = UIFont.systemFontOfSize(16, weight: UIFontWeightRegular)
    
    let celltitle = UIFont.systemFontOfSize(16, weight: UIFontWeightRegular)
    let cellsubtitle = UIFont.systemFontOfSize(12, weight: UIFontWeightRegular)

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mainView: UIView!
    
    var formController: NSString?
    var selectedImage: UIImage?
    var user: PFUser?
    
    var _feedItems : NSMutableArray = NSMutableArray()
    var filteredString : NSMutableArray = NSMutableArray()
    var refreshControl: UIRefreshControl!

    var objects = [AnyObject]()
    var pasteBoard = UIPasteboard.generalPasteboard()
    //let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleButton: UIButton = UIButton(frame: CGRectMake(0, 0, 100, 32))
        titleButton.setTitle("myUsers", forState: UIControlState.Normal)
        titleButton.titleLabel?.font = Font.navlabel
        titleButton.titleLabel?.textAlignment = NSTextAlignment.Center
        titleButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        titleButton.addTarget(self, action: Selector(), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.titleView = titleButton
        
        mapView!.delegate = self
        mapView!.layer.borderColor = UIColor.lightGrayColor().CGColor
        mapView!.layer.borderWidth = 0.5
        
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        self.tableView!.estimatedRowHeight = 110
        self.tableView!.rowHeight = UITableViewAutomaticDimension
        self.tableView!.backgroundColor = UIColor.clearColor()
        self.tableView!.tableFooterView = UIView(frame: .zero)
        
        self.collectionView!.dataSource = self
        self.collectionView!.delegate = self
        self.collectionView!.backgroundColor = UIColor.whiteColor()
        
        //let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: nil)
        let searchButton = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: nil)
        let buttons:NSArray = [searchButton]
        self.navigationItem.rightBarButtonItems = buttons as? [UIBarButtonItem]
        
        parseData()

        self.refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.clearColor()
        refreshControl.tintColor = UIColor.blackColor()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(UserViewController.refreshData), forControlEvents: UIControlEvents.ValueChanged)
        self.mapView!.addSubview(refreshControl)
  
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        user = PFUser.currentUser()!
        PFGeoPoint.geoPointForCurrentLocationInBackground {(geoPoint: PFGeoPoint?, error: NSError?) -> Void in
            
            let span:MKCoordinateSpan = MKCoordinateSpanMake(0.40, 0.40)
            let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(geoPoint!.latitude, geoPoint!.longitude)
            let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
            
            self.mapView!.setRegion(region, animated: true)
            self.mapView!.showsUserLocation = true //added
            self.refreshMap()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Refresh
    
    func refreshData(sender:AnyObject)
    {
        parseData()
        self.tableView!.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    // MARK: - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return _feedItems.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! CustomTableCell!
        
        if cell == nil {
            cell = CustomTableCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.usersubtitleLabel!.textColor = UIColor.grayColor()
        
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad {
            cell.usertitleLabel!.font = ipadtitle
            cell.usersubtitleLabel!.font = ipadsubtitle
        } else {
            cell.usertitleLabel!.font = celltitle
            cell.usersubtitleLabel!.font = cellsubtitle
        }
        
        let query:PFQuery = PFUser.query()!
        query.whereKey("username",  equalTo: self._feedItems[indexPath.row] .valueForKey("username") as! String)
        query.cachePolicy = PFCachePolicy.CacheThenNetwork
        query.getFirstObjectInBackgroundWithBlock {(object: PFObject?, error: NSError?) -> Void in
            if error == nil {
                if let imageFile = object!.objectForKey("imageFile") as? PFFile {
                    imageFile.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                        cell.userImageView?.image = UIImage(data: imageData!)
                    }
                }
            }
        }

        let dateUpdated = _feedItems[indexPath.row] .valueForKey("createdAt") as! NSDate
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "EEE, MMM d, h:mm a"
        
        cell.usertitleLabel!.text = _feedItems[indexPath.row] .valueForKey("username") as? String
        cell.usersubtitleLabel!.text = NSString(format: "%@", dateFormat.stringFromDate(dateUpdated)) as String
 
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let vw = UIView()
        vw.backgroundColor = UIColor.lightGrayColor()
        //tableView.tableHeaderView = vw
        
        let myLabel1:UILabel = UILabel(frame: CGRectMake(10, 5, tableView.frame.size.width-10, 20))
        myLabel1.numberOfLines = 1
        myLabel1.backgroundColor = UIColor.clearColor()
        myLabel1.textColor = UIColor.whiteColor()
        myLabel1.text = String(format: "%@%d", "Users ", _feedItems.count)
        myLabel1.font = Font.celllabel2
        vw.addSubview(myLabel1)
        
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
    
    // MARK: - Content Menu
    
    func tableView(tableView: UITableView, shouldShowMenuForRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
    }
    
    func tableView(tableView: UITableView, canPerformAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        
        if (action == #selector(NSObject.copy(_:))) {
            return true
        }
        return false
    }
    
    func tableView(tableView: UITableView, performAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        pasteBoard.string = cell!.textLabel?.text
    }
    
    // MARK: - CollectionView
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return _feedItems.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CollectionViewCell

        let title:UILabel = UILabel(frame: CGRectMake(0, 100, cell.bounds.size.width, 20))
        title.backgroundColor = UIColor.whiteColor()
        title.textColor = UIColor.blackColor()
        title.textAlignment = NSTextAlignment.Center
        title.layer.masksToBounds = true
        title.text = _feedItems[indexPath.row] .valueForKey("username") as? String
        title.font = Font.headtitle
        title.adjustsFontSizeToFitWidth = true
        title.clipsToBounds = true
        cell.addSubview(title)
        
        let imageObject = _feedItems.objectAtIndex(indexPath.row) as! PFObject
        let imageFile = imageObject.objectForKey("imageFile") as? PFFile
        
        cell.loadingSpinner!.hidden = true
        cell.loadingSpinner!.startAnimating()
        
        imageFile!.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
            cell.user2ImageView?.image = UIImage(data: imageData!)
            cell.loadingSpinner!.stopAnimating()
            cell.loadingSpinner!.hidden = true
        }
        
        return cell
    }
    
    // MARK: - RefreshMap
    
    func refreshMap() {
        
        let geoPoint = PFGeoPoint(latitude: self.mapView!.centerCoordinate.latitude, longitude:self.mapView!.centerCoordinate.longitude)
        
        let query = PFUser.query()
        query?.whereKey("currentLocation", nearGeoPoint: geoPoint, withinMiles:50.0)
        query?.limit = 20
        query?.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, error:NSError?) -> Void in
            
            for object in objects! {
                let annotation = MKPointAnnotation()
                annotation.title = object["username"] as? String
                let geoPoint = object["currentLocation"] as! PFGeoPoint
                annotation.coordinate = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude)
                self.mapView!.addAnnotation(annotation)
            }
        }
    }
    
    // MARK: - Parse
    
    func parseData() {
        
        let query = PFUser.query()
        query!.orderByDescending("createdAt")
        query!.cachePolicy = PFCachePolicy.CacheThenNetwork
        query!.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                let temp: NSArray = objects! as NSArray
                self._feedItems = temp.mutableCopy() as! NSMutableArray
                self.collectionView!.reloadData()
                self.tableView!.reloadData()
            } else {
                print("Error")
            }
        }
    }
    
    // MARK: - Segues
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.formController = "TableView"
        
        let imageObject = _feedItems.objectAtIndex(indexPath.row) as! PFObject
        let imageFile = imageObject.objectForKey("imageFile") as? PFFile
        
        imageFile!.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
            self.selectedImage = UIImage(data: imageData!)
            self.performSegueWithIdentifier("userdetailSegue", sender: self.tableView)
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        self.formController = "CollectionView"
        
        let imageObject = _feedItems.objectAtIndex(indexPath.row) as! PFObject
        let imageFile = imageObject.objectForKey("imageFile") as? PFFile
        
        imageFile!.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
            self.selectedImage = UIImage(data: imageData!)
            self.performSegueWithIdentifier("userdetailSegue", sender: self.collectionView)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "userdetailSegue" {
            let VC = segue.destinationViewController as? UserDetailController
            
            if self.formController == "TableView" {
                
                let indexPath = self.tableView!.indexPathForSelectedRow!.row
                
                let updated:NSDate = (self._feedItems[indexPath] .valueForKey("createdAt") as? NSDate)!
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MMM dd, yyyy"
                let createString = dateFormatter.stringFromDate(updated)
                
                VC!.objectId = self._feedItems[indexPath] .valueForKey("objectId") as? String
                VC!.username = self._feedItems[indexPath] .valueForKey("username") as? String
                VC!.create = createString
                VC!.email = self._feedItems[indexPath] .valueForKey("email") as? String
                VC!.phone = self._feedItems[indexPath] .valueForKey("phone") as? String
                VC!.userimage = self.selectedImage
                
            } else if self.formController == "CollectionView" {
                
                let indexPaths = self.collectionView!.indexPathsForSelectedItems()!
                let indexPath = indexPaths[0] as NSIndexPath
                
                let updated:NSDate = (self._feedItems[(indexPath.row)] .valueForKey("createdAt") as? NSDate)!
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MMM dd, yyyy"
                let createString = dateFormatter.stringFromDate(updated)
                
                VC!.objectId = self._feedItems[(indexPath.row)] .valueForKey("objectId") as? String
                VC!.username = self._feedItems[(indexPath.row)] .valueForKey("username") as? String
                VC!.create = createString
                VC!.email = self._feedItems[(indexPath.row)] .valueForKey("email") as? String
                VC!.phone = self._feedItems[(indexPath.row)] .valueForKey("phone") as? String
                VC!.userimage = self.selectedImage
            }
        }
    }

}
