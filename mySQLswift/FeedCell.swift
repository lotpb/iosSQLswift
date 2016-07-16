//
//  FeedCell.swift
//  youtube
//
//  Created by Brian Voong on 7/3/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit
import Parse

class FeedCell: CollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var _feedItems : NSMutableArray = NSMutableArray()
    var imageObject :PFObject!
    var imageFile :PFFile!
    var selectedImage : UIImage?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.whiteColor()
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    var videos: [Video]?
    
    let cellId = "cellId"
    
    func fetchVideos() {
        
        let query = PFQuery(className:"Newsios")
        query.cachePolicy = PFCachePolicy.CacheThenNetwork
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                let temp: NSArray = objects! as NSArray
                self._feedItems = temp.mutableCopy() as! NSMutableArray
                self.collectionView.reloadData()
            } else {
                print("Error")
            }
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        fetchVideos()
        
        backgroundColor = .brownColor()
        
        addSubview(collectionView)
        addConstraintsWithFormat("H:|[v0]|", views: collectionView)
        addConstraintsWithFormat("V:|[v0]|", views: collectionView)
        
        collectionView.registerClass(VideoCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    // MARK: - Button
    
    func likeButton(sender:UIButton) {
        
        sender.tintColor = Color.BlueColor
        let hitPoint = sender.convertPoint(CGPointZero, toView: self.collectionView)
        let indexPath = self.collectionView.indexPathForItemAtPoint(hitPoint)
        
        let query = PFQuery(className:"Newsios")
        query.whereKey("objectId", equalTo:(_feedItems.objectAtIndex((indexPath?.row)!) .valueForKey("objectId") as? String)!)
        query.getFirstObjectInBackgroundWithBlock {(object: PFObject?, error: NSError?) -> Void in
            if error == nil {
                object!.incrementKey("Liked")
                object!.saveInBackground()
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
         return self._feedItems.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cellId", forIndexPath: indexPath) as! VideoCell
        
        //cell.video = videos?[indexPath.item]
        
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad {
            cell.titleLabelnew.font = Font.News.newstitle
            cell.subtitlelabel.font = Font.News.newssource
            cell.numberLabel.font = Font.News.newslabel1
            cell.uploadbylabel.font = Font.News.newslabel2
            
        } else {
            cell.titleLabelnew.font = Font.News.newstitle
            cell.subtitlelabel.font = Font.News.newssource
            cell.numberLabel.font = Font.News.newslabel1
            cell.uploadbylabel.font = Font.News.newslabel2
        }
        
        cell.subtitlelabel.textColor = Color.DGrayColor
        cell.uploadbylabel.textColor = Color.DGrayColor
        
        imageObject = _feedItems.objectAtIndex(indexPath.row) as! PFObject
        imageFile = imageObject.objectForKey("imageFile") as? PFFile
        imageFile!.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
            
            cell.thumbnailImageView.image = UIImage(data: imageData!)
        }
        
        //profile Image
        let query:PFQuery = PFUser.query()!
        query.whereKey("username",  equalTo:self._feedItems[indexPath.row] .valueForKey("username") as! String)
        query.cachePolicy = PFCachePolicy.CacheThenNetwork
        query.getFirstObjectInBackgroundWithBlock {(object: PFObject?, error: NSError?) -> Void in
            if error == nil {
                if let imageFile = object!.objectForKey("imageFile") as? PFFile {
                    imageFile.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                        cell.userProfileImageView.image = UIImage(data: imageData!)
                    }
                }
            }
        }
        
        cell.titleLabelnew.text = self._feedItems[indexPath.row].valueForKey("newsTitle") as? String
        
        let date1 = (self._feedItems[indexPath.row] .valueForKey("createdAt") as? NSDate)!
        let date2 = NSDate()
        let diffDateComponents = NSCalendar.currentCalendar().components([NSCalendarUnit.Day], fromDate: date1, toDate: date2, options: NSCalendarOptions.init(rawValue: 0))
        cell.subtitlelabel.text = String(format: "%@, %d%@" , (self._feedItems[indexPath.row] .valueForKey("newsDetail") as? String)!, diffDateComponents.day," days ago" )
        
        var Liked:Int? = _feedItems[indexPath.row] .valueForKey("Liked")as? Int
        if Liked == nil {
            Liked = 0
        }
        cell.numberLabel.text = "\(Liked!)"
        
        if !(cell.numberLabel.text! == "0") {
            cell.numberLabel.textColor = Color.News.buttonColor
        } else {
            cell.numberLabel.text! = ""
        }
        cell.likeButt.addTarget(self, action: #selector(FeedCell.likeButton), forControlEvents: UIControlEvents.TouchUpInside)
        
        let updated:NSDate = date1
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let createString = dateFormatter.stringFromDate(updated)
        cell.uploadbylabel.text = String(format: "%@ %@", "Uploaded", createString)
        
        cell.actionButton.addTarget(self, action: #selector(News.handleMore), forControlEvents: UIControlEvents.TouchUpInside)
        

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let height = (frame.width - 16 - 16) * 9 / 16
        return CGSizeMake(frame.width, height + 16 + 88)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    
    // MARK: - Segues
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        /*
        imageObject = _feedItems.objectAtIndex(indexPath.row) as! PFObject
        imageFile = imageObject.objectForKey("imageFile") as? PFFile
        imageFile!.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
            
            self.selectedImage = UIImage(data: imageData!)
            //News.performSegueWithIdentifier("newsdetailseque", sender:News)
        } */
    }
    
    
     func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    { /*
        if segue.identifier == "newsdetailseque"
        {
            let vc = segue.destinationViewController as? NewsDetailController
            let indexPaths = self.collectionView.indexPathsForSelectedItems()!
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


















