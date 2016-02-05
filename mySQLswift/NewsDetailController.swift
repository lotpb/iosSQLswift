//
//  NewsDetailController.swift
//  mySQLswift
//
//  Created by Peter Balsamo on 1/19/16.
//  Copyright © 2016 Peter Balsamo. All rights reserved.
//

import UIKit
import Parse
//import CoreLocation
import MobileCoreServices //kUTTypeImage

class NewsDetailController: UIViewController {
    
    let navlabel = UIFont.systemFontOfSize(25, weight: UIFontWeightThin)
    let navColor = UIColor(red: 0.16, green: 0.69, blue: 0.38, alpha: 1.0)
    
    let ipadtitle = UIFont.systemFontOfSize(26, weight: UIFontWeightRegular)
    let ipadsubtitle = UIFont.systemFontOfSize(18, weight: UIFontWeightRegular)
    let ipadtextview = UIFont.systemFontOfSize(18, weight: UIFontWeightLight)
    
    let fonttitle = UIFont.systemFontOfSize(20, weight: UIFontWeightRegular)
    let fontsubtitle = UIFont.systemFontOfSize(16, weight: UIFontWeightRegular)
    let fonttextview = UIFont.systemFontOfSize(16, weight: UIFontWeightLight)
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var newsImageview: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var newsTextview: UITextView!
    
    var image: UIImage!
    var objectId: NSString?
    var newsTitle: NSString?
    var newsDetail: NSString?
    var newsStory: NSString?
    var newsDate: NSString?
    
    //var videoController: MPMoviePlayerController!
    var videoURL: NSURL?
    var imageDetailurl: NSString?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleButton: UIButton = UIButton(frame: CGRectMake(0, 0, 100, 32))
        titleButton.setTitle("News Detail", forState: UIControlState.Normal)
        titleButton.titleLabel?.font = navlabel
        titleButton.titleLabel?.textAlignment = NSTextAlignment.Center
        titleButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        titleButton.addTarget(self, action: Selector(), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.titleView = titleButton
        
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 6.0
        self.newsImageview.backgroundColor = UIColor.blackColor()
        
        let editItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editData:")
        let buttons:NSArray = [editItem]
        self.navigationItem.rightBarButtonItems = buttons as? [UIBarButtonItem]

        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad {
            
            self.titleLabel.font = ipadtitle
            self.detailLabel.font = ipadsubtitle
            self.newsTextview.editable = true //bug fix
            self.newsTextview.font = ipadtextview
            self.newsTextview.editable = false //bug fix
        } else {
            self.titleLabel.font = fonttitle
            self.detailLabel.font = fontsubtitle
            self.newsTextview.editable = true//bug fix
            self.newsTextview.font = fonttextview
            self.newsTextview.editable = false //bug fix
        }
        
        self.newsImageview.image = self.image
        self.newsImageview.contentMode = UIViewContentMode.ScaleToFill
        
        self.titleLabel.text = self.newsTitle as? String
        self.titleLabel.numberOfLines = 2
        
        self.detailLabel.text = self.newsDetail as? String
        //self.detailLabel!.text = String(format: "%@, %d", (self.newsDetail as? String)!, (self.newsDate as? String)!)
        self.detailLabel.textColor = UIColor.lightGrayColor()
        self.detailLabel.sizeToFit()
        
        self.newsTextview.text = self.newsStory as? String
        
        //let value = imageDetailurl
        //let result1 = value!.containsString("movie.mp4")
        //if s!.rangeOfString("movie.mp4") != nil {
        //if (result1 == true) {
        if (self.imageDetailurl == "movie.mp4") {
            
            let playButton = UIButton(type: UIButtonType.Custom) as UIButton
            playButton.frame = CGRectMake(self.newsImageview.frame.size.width/2-130, self.newsImageview.frame.origin.y+100, 50, 50)
            playButton.alpha = 0.3
            playButton.tintColor = UIColor.whiteColor()
            let playbutton : UIImage? = UIImage(named:"play_button.png")!.imageWithRenderingMode(.AlwaysTemplate)
            playButton .setImage(playbutton, forState: .Normal)
            playButton.userInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: Selector("playVideo:"))
            playButton.addGestureRecognizer(tap)
            self.newsImageview.addSubview(playButton)
            
            videoURL = NSURL(string: self.imageDetailurl as! String)!
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.newsImageview
    }
    
    // MARK: - Button
    
    func editData(sender: AnyObject) {
        
        self.performSegueWithIdentifier("uploadSegue", sender: self)
    }
    
    // MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "uploadSegue"
        {
            let photo = segue.destinationViewController as? UploadController
            
            photo!.formStat = "Update"
            photo!.objectId = self.objectId as? String
            photo!.newsImage = self.newsImageview.image
            photo!.newstitle = self.titleLabel.text
            photo!.newsdetail = self.newsDetail as? String
            photo!.newsStory = self.newsStory as? String
            photo!.imageDetailurl = self.imageDetailurl as? String
        }
    }



}
