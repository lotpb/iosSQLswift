//
//  News.swift
//  mySQLswift
//
//  Created by Peter Balsamo on 12/9/15.
//  Copyright © 2015 Peter Balsamo. All rights reserved.
//

//import Foundation
import UIKit
import Parse
import AVKit
import AVFoundation


class News: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchResultsUpdating {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var _feedItems : NSMutableArray = NSMutableArray()
    
    var imageObject :PFObject!
    var imageFile :PFFile!
    
    var selectedImage : UIImage?
    var searchController: UISearchController!
    var resultsController: UITableViewController!
    var foundUsers = [String]()
    
    var playerViewController = AVPlayerViewController()
    var player = AVPlayer()
    var imageDetailurl : NSString?
    var videoURL: NSURL?
    
    var refreshControl: UIRefreshControl!
    
    var urlLabel : UILabel?

 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleButton: UIButton = UIButton(frame: CGRectMake(0, 0, 100, 32))
        titleButton.setTitle("News Today", forState: UIControlState.Normal)
        titleButton.titleLabel?.font = Font.navlabel
        titleButton.titleLabel?.textAlignment = NSTextAlignment.Center
        titleButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        titleButton.addTarget(self, action: Selector(), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.titleView = titleButton
        
        self.collectionView!.backgroundColor = UIColor(white:0.90, alpha:1.0)
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action:#selector(News.newButton(_:)))
        let searchButton = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action:#selector(News.searchButton(_:)))
        let buttons:NSArray = [addButton,searchButton]
        self.navigationItem.rightBarButtonItems = buttons as? [UIBarButtonItem]
        
        parseData()
        
        self.refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = Color.News.navColor
        refreshControl.tintColor = UIColor.whiteColor()
        let attributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: attributes)
        self.refreshControl.addTarget(self, action: #selector(News.refreshData(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.collectionView!.addSubview(refreshControl)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad {
            self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        } else {
            self.navigationController?.navigationBar.barTintColor = Color.News.navColor
        }
        
         NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(News.finishedPlaying(_:)), name: AVPlayerItemDidPlayToEndTimeNotification, object: self.playerViewController)
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
        cell.uploadbyLabel.textColor = UIColor(white:0.45, alpha:1.0)
        
        let playButton = UIButton(type: UIButtonType.Custom) as UIButton
        
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad {
            cell.titleLabel!.font = Font.News.newstitle
            cell.sourceLabel!.font = Font.News.newssource
            cell.numLabel!.font = Font.News.newslabel1
            cell.uploadbyLabel!.font = Font.News.newslabel2
            playButton.frame = CGRectMake(cell.imageView.frame.size.width/2-25, cell.imageView.frame.origin.y, 50, 50)
            
        } else {
            
            cell.titleLabel!.font = Font.News.newstitle
            cell.sourceLabel!.font = Font.News.newssource
            cell.numLabel!.font = Font.News.newslabel1
            cell.uploadbyLabel!.font = Font.News.newslabel2
            playButton.frame = CGRectMake(cell.imageView.frame.size.width/2-25, cell.imageView.frame.origin.y, 50, 50)
            
        }
        
        imageObject = _feedItems.objectAtIndex(indexPath.row) as! PFObject
        imageFile = imageObject.objectForKey("imageFile") as? PFFile
        imageFile!.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
            
            cell.imageView?.image = UIImage(data: imageData!)
        }
        
        cell.imageView!.backgroundColor = UIColor.blackColor()
        cell.imageView!.layer.borderColor = UIColor.lightGrayColor().CGColor
        cell.imageView!.layer.borderWidth = 0.5
        
        cell.titleLabel?.text = self._feedItems[indexPath.row] .valueForKey("newsTitle") as? String
        
        let date1 = (self._feedItems[indexPath.row] .valueForKey("createdAt") as? NSDate)!
        let date2 = NSDate()
        let diffDateComponents = NSCalendar.currentCalendar().components([NSCalendarUnit.Day], fromDate: date1, toDate: date2, options: NSCalendarOptions.init(rawValue: 0))
        cell.sourceLabel?.text = String(format: "%@, %d%@" , (self._feedItems[indexPath.row] .valueForKey("newsDetail") as? String)!, diffDateComponents.day," days ago" )
        
        let updated:NSDate = date1
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let createString = dateFormatter.stringFromDate(updated)
        let username = self._feedItems[indexPath.row] .valueForKey("username") as? String
        cell.uploadbyLabel.text = String(format: "%@%@ %@", "Uploaded by:", username!, createString)
        
        cell.actionBtn.tintColor = UIColor.lightGrayColor()
        let imagebutton : UIImage? = UIImage(named:"Upload50.png")!.imageWithRenderingMode(.AlwaysTemplate)
        cell.actionBtn .setImage(imagebutton, forState: .Normal)
        cell.actionBtn .addTarget(self, action: #selector(News.shareButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        cell.likeButton.tintColor = UIColor.lightGrayColor()
        let likeimage : UIImage? = UIImage(named:"Thumb Up.png")!.imageWithRenderingMode(.AlwaysTemplate)
        cell.likeButton .setImage(likeimage, forState: .Normal)
        cell.likeButton .addTarget(self, action: #selector(News.likeButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        var Liked:Int? = _feedItems[indexPath.row] .valueForKey("Liked")as? Int
        if Liked == nil {
            Liked = 0
        }
        cell.numLabel?.text = "\(Liked!)"
        
        if !(cell.numLabel.text! == "0") {
            cell.numLabel.textColor = Color.News.buttonColor
        } else {
            cell.numLabel.text! = ""
        }
        
        let value = self.imageFile.url
        //print("\(value!)")
        let result1 = value!.containsString("movie.mp4")
        //if s!.rangeOfString("movie.mp4") != nil {
        //print(result1)
        if (result1 == true) {
            
            playButton.alpha = 0.3
            playButton.userInteractionEnabled = true
            //playButton.center = cell.imageView.center
            playButton.tintColor = UIColor.whiteColor()
            let playimage : UIImage? = UIImage(named:"play_button.png")!.imageWithRenderingMode(.AlwaysTemplate)
            playButton .setImage(playimage, forState: .Normal)
            //playButton .setTitle(urlLabel!.text, forState: UIControlState.Normal)
            let tap = UITapGestureRecognizer(target: self, action: #selector(News.playVideo(_:)))
            playButton.addGestureRecognizer(tap)
            cell.imageView.addSubview(playButton)
            
        }
        
        return cell
        
    }
    
    
    // MARK: - Button
    
    func newButton(sender: AnyObject) {
        
        self.performSegueWithIdentifier("uploadSegue", sender: self)
    }
    
    func likeButton(sender:UIButton) {
        
        sender.tintColor = Color.BlueColor
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
    
    func shareButton(sender: UIButton) {
        
        let point : CGPoint = sender.convertPoint(CGPointZero, toView:collectionView)
        let indexPath = collectionView!.indexPathForItemAtPoint(point)
        let socialText = self._feedItems[indexPath!.row] .valueForKey("newsTitle") as? String
        
        imageObject = _feedItems.objectAtIndex(indexPath!.row) as! PFObject
        imageFile = imageObject.objectForKey("imageFile") as? PFFile
        imageFile!.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
            let image = UIImage(data: imageData!)
            
            let activityViewController = UIActivityViewController (
                activityItems: [socialText!, (image)!],
                applicationActivities: nil)
            
            self.presentViewController(activityViewController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Video
    
    func playVideo(sender: UITapGestureRecognizer) {
        
        //let path = NSBundle.mainBundle().pathForResource("emoji zone", ofType: "mp4")
        let path = self.imageFile.url!
        player = AVPlayer(URL: NSURL(fileURLWithPath: path))
        playerViewController.player = player
        self.presentViewController(playerViewController, animated: true) {
            self.playerViewController.player?.play()
        }
        /*
        let url = NSURL.fileURLWithPath(self.imageFile.url!)
        //let url = NSURL.fileURLWithPath(self.imageDetailurl as! String)
        let player = AVPlayer(URL: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        playerViewController.view.frame = self.view.bounds
        playerViewController.videoGravity = AVLayerVideoGravityResizeAspect
        playerViewController.showsPlaybackControls = true
        //self.imgToUpload.addSubview(playerViewController.view)
        self.view.addSubview(playerViewController.view)
        self.addChildViewController(playerViewController)
        
        player.play() */
    }
    
    func finishedPlaying(myNotification:NSNotification) {
        
        let stopedPlayerItem: AVPlayerItem = myNotification.object as! AVPlayerItem
        stopedPlayerItem.seekToTime(kCMTimeZero)
    }
    
    // MARK: - Parse
    
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
        //tableView!.tableFooterView = UIView(frame: .zero)
        UISearchBar.appearance().barTintColor = Color.News.navColor
        
        self.presentViewController(searchController, animated: true, completion: nil)
    }
    
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
    }
    
    // MARK: - Segues
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        imageObject = _feedItems.objectAtIndex(indexPath.row) as! PFObject
        imageFile = imageObject.objectForKey("imageFile") as? PFFile
        imageFile!.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
            
            self.selectedImage = UIImage(data: imageData!)
            self.performSegueWithIdentifier("newsdetailseque", sender:self)
        }
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
            vc!.newsDate = String(self._feedItems[indexPath.row] .valueForKey("createAt") as? NSDate)
            vc!.newsStory = self._feedItems[indexPath.row] .valueForKey("storyText") as? String
            vc!.image = self.selectedImage
            vc!.imageDetailurl = self.imageDetailurl
        }
    }
    
    
}
//-----------------------end------------------------------



