//
//  News.swift
//  mySQLswift
//
//  Created by Peter Balsamo on 12/9/15.
//  Copyright © 2015 Peter Balsamo. All rights reserved.
//

import UIKit
import Parse


class News: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchResultsUpdating {
    
    let navColor = UIColor(white:0.45, alpha:1.0)
    let likeColor = UIColor(red:0.0, green:122.0/255.0, blue:1.0, alpha: 1.0)

    @IBOutlet weak var collectionView: UICollectionView!
    
    var _feedItems : NSMutableArray = NSMutableArray()
    
    var imageObject :PFObject!
    var imageFile :PFFile!
    
    var selectedImage : UIImage?
    var searchController = UISearchController!()
    var resultsController: UITableViewController!
    var foundUsers = [String]()
    
    var imageDetailurl : NSString?
    var videoURL: NSURL?
    
    var refreshControl: UIRefreshControl!

 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleButton: UIButton = UIButton(frame: CGRectMake(0, 0, 100, 32))
        titleButton.setTitle("News Today", forState: UIControlState.Normal)
        titleButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 25.0)
        titleButton.titleLabel?.textAlignment = NSTextAlignment.Center
        titleButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        titleButton.addTarget(self, action: Selector(), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.titleView = titleButton
        
        self.collectionView!.backgroundColor = UIColor(white:0.90, alpha:1.0)
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action:"newButton:")
        let searchButton = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action:"searchButton:")
        let buttons:NSArray = [addButton,searchButton]
        self.navigationItem.rightBarButtonItems = buttons as? [UIBarButtonItem]
        
        parseData()
        
        self.refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = navColor
        refreshControl.tintColor = UIColor.whiteColor()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refreshData:", forControlEvents: UIControlEvents.ValueChanged)
        self.collectionView!.addSubview(refreshControl)
        
    }
        
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = navColor
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
    
    
    // MARK: - collectionView
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self._feedItems.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CollectionViewCell
        
        cell.backgroundColor = UIColor.whiteColor()
        cell.sourceLabel.textColor = UIColor(white:0.45, alpha:1.0)
        
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad {
            cell.titleLabel!.font = UIFont (name: "HelveticaNeue", size: 20)
            cell.sourceLabel!.font = UIFont (name: "HelveticaNeue", size: 14)
            cell.numLabel!.font = UIFont (name: "HelveticaNeue-Medium", size:16)

        } else {
            cell.titleLabel!.font = UIFont (name: "HelveticaNeue", size: 20)
            cell.sourceLabel!.font = UIFont (name: "HelveticaNeue", size: 14)
            cell.numLabel!.font = UIFont (name: "HelveticaNeue-Medium", size:16)
 
        }
        
        imageObject = _feedItems.objectAtIndex(indexPath.row) as! PFObject
        imageFile = imageObject.objectForKey("imageFile") as? PFFile
        imageFile!.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
        
        cell.imageView?.image = UIImage(data: imageData!)
        cell.imageView!.backgroundColor = UIColor.blackColor()

        cell.titleLabel?.text = self._feedItems[indexPath.row] .valueForKey("newsTitle") as? String
            
        let creationDate:NSDate = (self._feedItems[indexPath.row] .valueForKey("createdAt") as? NSDate)!
        let datetime1:NSDate = creationDate
        let datetime2:NSDate = NSDate()
        let dateInterval:Double = datetime2.timeIntervalSinceDate(datetime1)/(60*60*24)
        let mydate = String(format: "%d, %@", dateInterval, "days ago ")
            
        cell.sourceLabel?.text  = String(format: "%@ %@", (self._feedItems[indexPath.row] .valueForKey("newsDetail") as? String)!, (mydate as NSString))
    
        }
        
        if ((self.imageDetailurl?.containsString("movie.mp4")) != nil) {
            
            let playButton = UIButton(type: UIButtonType.Custom) as UIButton
            playButton.frame = CGRectMake(cell.imageView.frame.size.width/2, cell.imageView.frame.origin.y+55, 50, 50)
            playButton.alpha = 1.0
            playButton.tintColor = UIColor.whiteColor()
            let playimage : UIImage? = UIImage(named:"play_button.png")!.imageWithRenderingMode(.AlwaysTemplate)
            playButton .setImage(playimage, forState: .Normal)
            playButton.userInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: Selector("playVideo:"))
            playButton.addGestureRecognizer(tap)
            cell.addSubview(playButton)
            
            videoURL = NSURL(string:(self.imageDetailurl as? String)!)
        }
        
        cell.actionBtn.tintColor = UIColor.lightGrayColor()
        let imagebutton : UIImage? = UIImage(named:"Upload50.png")!.imageWithRenderingMode(.AlwaysTemplate)
        cell.actionBtn .setImage(imagebutton, forState: .Normal)
        //actionBtn .addTarget(self, action: "shareButton:", forControlEvents: UIControlEvents.TouchUpInside)
        
        cell.likeButton.tintColor = UIColor.lightGrayColor()
        let likeimage : UIImage? = UIImage(named:"Thumb Up.png")!.imageWithRenderingMode(.AlwaysTemplate)
        cell.likeButton .setImage(likeimage, forState: .Normal)
        cell.likeButton .addTarget(self, action: "likeButton:", forControlEvents: UIControlEvents.TouchUpInside)
        
        var Liked:Int? = _feedItems[indexPath.row] .valueForKey("Liked")as? Int
        if Liked == nil {
            Liked = 0
        }
        cell.numLabel?.text = "\(Liked!)"
        
        if !(cell.numLabel.text! == "0") {
            cell.numLabel.textColor = likeColor
        } else {
            cell.numLabel.text! = ""
        }
        
        return cell
        
    }
    
    // MARK: - Button
    
    func newButton(sender: AnyObject) {
        
        self.performSegueWithIdentifier("uploadSegue", sender: self)
    }
    
    func likeButton(sender:UIButton) {
        
        sender.tintColor = likeColor
        let hitPoint = sender.convertPoint(CGPointZero, toView: self.collectionView)
        let indexPath = self.collectionView!.indexPathForItemAtPoint(hitPoint)
        
        let query = PFQuery(className:"Newsios")
        query.whereKey("objectId", equalTo:(_feedItems.objectAtIndex((indexPath?.row)!) .valueForKey("objectId") as? String)!)
        query.getFirstObjectInBackgroundWithBlock {(object: PFObject?, error: NSError?) -> Void in
            if error == nil {
                object!.incrementKey("Liked")
                object!.saveInBackground()
            }
        }
    }
    
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
    
    func parseData() {
        
        let query = PFQuery(className:"Newsios")
        query.cachePolicy = PFCachePolicy.CacheThenNetwork
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                let temp: NSArray = objects! as NSArray
                self._feedItems = temp.mutableCopy() as! NSMutableArray
                self.collectionView!.reloadData()
            } else {
                print("Error")
            }
        }
    }

    
    // MARK: - Search
    
    func searchButton(sender: AnyObject) {
        
        searchController = UISearchController(searchResultsController: resultsController)
        searchController.searchBar.searchBarStyle = .Prominent
        searchController.searchResultsUpdater = self
        searchController.searchBar.showsBookmarkButton = false
        searchController.searchBar.showsCancelButton = true
        searchController.searchBar.placeholder = "Search here..."
        searchController.searchBar.sizeToFit()
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = true
        searchController.hidesNavigationBarDuringPresentation = true
        //searchController.searchBar.scopeButtonTitles = searchScope
        //tableView!.tableHeaderView = searchController.searchBar
        //tableView!.tableFooterView = UIView(frame: CGRectZero)
        UISearchBar.appearance().barTintColor = navColor
        
        self.presentViewController(searchController, animated: true, completion: nil)
    }
    
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
    }
    
    // MARK: - Segues
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        imageObject = _feedItems.objectAtIndex(indexPath.row) as! PFObject
        imageFile = imageObject.objectForKey("imageFile") as? PFFile
        
        imageFile!.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
            
            self.selectedImage = UIImage(data: imageData!)
        }
        
        self.performSegueWithIdentifier("newsdetailseque", sender:self)
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "newsdetailseque"
        {
            let vc = segue.destinationViewController as? NewsDetailController
            let indexPaths = self.collectionView!.indexPathsForSelectedItems()!
            let indexPath = indexPaths[0] as NSIndexPath
            
            vc!.objectId = self._feedItems[indexPath.row] .valueForKey("objectId") as? String
            vc!.newsTitle = (self._feedItems[indexPath.row] .valueForKey("newsTitle") as? String)!
            vc!.newsDetail = self._feedItems[indexPath.row] .valueForKey("newsDetail") as? String
            vc!.newsDate = self._feedItems[indexPath.row] .valueForKey("createAt") as? String
            vc!.newsStory = self._feedItems[indexPath.row] .valueForKey("storyText") as? String
            vc!.image = self.selectedImage
            vc!.imageDetailurl = self.imageDetailurl
        }
    }
    
    
}
//-----------------------end------------------------------



