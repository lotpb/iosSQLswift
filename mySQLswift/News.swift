//
//  News.swift
//  TheLight
//
//  Created by Peter Balsamo on 7/12/16.
//  Copyright © 2016 Peter Balsamo. All rights reserved.
//

import UIKit
//import Parse
import AVKit
import AVFoundation


class News: UIViewController, UICollectionViewDelegateFlowLayout, UISearchResultsUpdating {
    
    let cellId = "cellId"
    let trendingCellId = "trendingCellId"
    let subscriptionCellId = "subscriptionCellId"
    
    let titles = ["Home", "Trending", "Subscriptions", "Account"]
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //var _feedItems : NSMutableArray = NSMutableArray()
    //var imageObject :PFObject!
    //var imageFile :PFFile!
    //var selectedImage : UIImage?
    
    var searchController: UISearchController!
    var resultsController: UITableViewController!
    var foundUsers = [String]()
    
    var playerViewController = AVPlayerViewController()
    var videoURL: String?
    var refreshControl: UIRefreshControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleLabel = UILabel(frame: CGRectMake(0, 0, view.frame.width - 32, view.frame.height))
        titleLabel.text = "  Home"
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont.systemFontOfSize(20)
        navigationItem.titleView = titleLabel
        
        //parseData()
        setupCollectionView()
        setupNavBarButtons()
        setupMenuBar()
        
        // get rid of black bar underneath navbar
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarMetrics: .Default)
        
        self.refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.whiteColor()//Color.News.navColor
        refreshControl.tintColor = UIColor.blackColor()
        let attributes = [NSForegroundColorAttributeName: UIColor.blackColor()]
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: attributes)
        self.refreshControl.addTarget(self, action: #selector(News.refreshData), forControlEvents: UIControlEvents.ValueChanged)
        self.collectionView!.addSubview(refreshControl)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        refreshData()
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(News.finishedPlaying), name: AVPlayerItemDidPlayToEndTimeNotification, object: self.playerViewController)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupCollectionView() {
        
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .Horizontal
            flowLayout.minimumLineSpacing = 0
        }
        
        self.collectionView?.backgroundColor = UIColor.whiteColor()
        collectionView?.registerClass(FeedCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.registerClass(TrendingCell.self, forCellWithReuseIdentifier: trendingCellId)
        collectionView?.registerClass(SubscriptionCell.self, forCellWithReuseIdentifier: subscriptionCellId)
        
        collectionView?.contentInset = UIEdgeInsetsMake(50,0,0,0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(50,0,0,0)
        
        collectionView?.pagingEnabled = true
    }
    
    func setupNavBarButtons() {
        let moreButton = UIBarButtonItem(image: UIImage(named: "nav_more_icon")?.imageWithRenderingMode(.AlwaysOriginal), style: .Plain, target: self, action: #selector(handleMore))
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action:#selector(newButton))
        let searchButton = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action:#selector(News.searchButton))
        let buttons:NSArray = [moreButton,searchButton,addButton]
        self.navigationItem.rightBarButtonItems = buttons as? [UIBarButtonItem]
    }
    
    
    // MARK: - refresh
    
    func refreshData() {
        //FeedCell.fetchVideos()
        self.collectionView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    
    // MARK: - collectionView
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let identifier: String
        if indexPath.item == 1 {
            identifier = trendingCellId
        } else if indexPath.item == 2 {
            identifier = subscriptionCellId
        } else {
            identifier = cellId
        }
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) //as! CollectionViewCell
  
        return cell
        
    }
    
    
    // MARK: - Button
    
    func newButton(sender: AnyObject) {
        
        self.performSegueWithIdentifier("uploadSegue", sender: self)
    }
    
    //-----------------------------------------------
    //Disconnected below - Not hooked up
    //-----------------------------------------------
    func shareButton(sender: UIButton) {
        /*
        let point : CGPoint = sender.convertPoint(CGPointZero, toView:collectionView)
        let indexPath = collectionView!.indexPathForItemAtPoint(point)
        let socialText = self._feedItems[indexPath!.row] .valueForKey("newsTitle") as? String
        
        let activityViewController = UIActivityViewController (
            activityItems: [socialText!],
            applicationActivities: nil)
        
        self.presentViewController(activityViewController, animated: true, completion: nil)
        */
    }
    
    //-----------------------------------------------------
    
    // MARK: - Video
    
    func playVideo(sender: UITapGestureRecognizer) {
        
        let button = sender.view as? UIButton
        self.videoURL = button!.titleLabel!.text
        let url = NSURL(string: self.videoURL!)
        let player = AVPlayer(URL: url!)
        playerViewController.videoGravity = AVLayerVideoGravityResizeAspect
        playerViewController.showsPlaybackControls = true
        playerViewController.player = player
        self.presentViewController(playerViewController, animated: true) {
            self.playerViewController.player?.play()
        }
    }
    
    func finishedPlaying(myNotification:NSNotification) {
        
        let stopedPlayerItem: AVPlayerItem = myNotification.object as! AVPlayerItem
        stopedPlayerItem.seekToTime(kCMTimeZero)
    }
    
    
    // MARK: - youtube Action Menu
    
    lazy var settingsLauncher: SettingsLauncher = {
        let launcher = SettingsLauncher()
        launcher.homeController = self
        return launcher
    }()
    
    func handleMore() {
        //show menu
        settingsLauncher.showSettings()
    }
    
    func showControllerForSetting(setting: Setting) {
        let dummySettingsViewController = UIViewController()
        dummySettingsViewController.view.backgroundColor = UIColor.whiteColor()
        dummySettingsViewController.navigationItem.title = setting.name.rawValue
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.pushViewController(dummySettingsViewController, animated: true)
    }
    
    func handleSearch() {
        scrollToMenuIndex(2)
    }
    
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = NSIndexPath(forItem: menuIndex, inSection: 0)
        collectionView?.scrollToItemAtIndexPath(indexPath, atScrollPosition: .None, animated: true)
        
        setTitleForIndex(menuIndex)
    }
    
    private func setTitleForIndex(index: Int) {
        
        if let titleLabel = navigationItem.titleView as? UILabel {
            titleLabel.text = "\(titles[index])"
        }
    }
    
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.homeController = self
        return mb
    }()
    
    private func setupMenuBar() {
        
        navigationController?.hidesBarsOnSwipe = true
        
        let redView = UIView()
        redView.backgroundColor = UIColor.rgb(230, green: 32, blue: 31)
        view.addSubview(redView)
        view.addConstraintsWithFormat("H:|[v0]|", views: redView)
        view.addConstraintsWithFormat("V:[v0(50)]", views: redView)
        
        view.addSubview(menuBar)
        view.addConstraintsWithFormat("H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat("V:[v0(50)]", views: menuBar)
        
        menuBar.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor).active = true
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 4
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let index = targetContentOffset.memory.x / view.frame.width
        
        let indexPath = NSIndexPath(forItem: Int(index), inSection: 0)
        menuBar.collectionView.selectItemAtIndexPath(indexPath, animated: true, scrollPosition: .None)
        
        setTitleForIndex(Int(index))
    } 
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(view.frame.width, view.frame.height - 50)
    }
    
    
    
    //-------------------------------------------------
    
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
        /*
        imageObject = _feedItems.objectAtIndex(indexPath.row) as! PFObject
        imageFile = imageObject.objectForKey("imageFile") as? PFFile
        imageFile!.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
            
            self.selectedImage = UIImage(data: imageData!)
            self.performSegueWithIdentifier("newsdetailseque", sender:self)
        } */
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        /*
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
            vc!.videoURL = self.imageFile.url
        } */
    }
    
}
//-----------------------end------------------------------
