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
    
    let navColor = UIColor(red: 0.16, green: 0.69, blue: 0.38, alpha: 1.0)
    
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
        titleButton.setTitle("myLeads", forState: UIControlState.Normal)
        titleButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 25.0)
        titleButton.titleLabel?.textAlignment = NSTextAlignment.Center
        titleButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        titleButton.addTarget(self, action: Selector(), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.titleView = titleButton
        
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 6.0
        self.newsImageview.backgroundColor = UIColor.lightGrayColor()
        
        let editItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editData")
        let buttons:NSArray = [editItem]
        self.navigationItem.rightBarButtonItems = buttons as? [UIBarButtonItem]

        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad {
            
            self.titleLabel.font = UIFont (name: "HelveticaNeue", size: 26)
            self.detailLabel.font = UIFont (name: "HelveticaNeue", size: 18)
            self.newsTextview.editable = true //bug fix
            self.newsTextview.font = UIFont (name: "HelveticaNeue-Light", size: 18)
            self.newsTextview.editable = false //bug fix
        } else {
            self.titleLabel.font = UIFont (name: "HelveticaNeue", size: 20)
            self.detailLabel.font = UIFont (name: "HelveticaNeue", size: 16)
            self.newsTextview.editable = true//bug fix
            self.newsTextview.font = UIFont (name: "HelveticaNeue-Light", size: 16)
            self.newsTextview.editable = false //bug fix
        }
        
        self.newsImageview.image = self.image
        self.newsImageview.contentMode = UIViewContentMode.ScaleToFill
        
        self.titleLabel.text = self.newsTitle as? String
        self.titleLabel.numberOfLines = 2
        
        self.detailLabel.text = self.newsDetail as? String
        //self.detailLabel.text = String(format: "%@ %@", (self.newsDetail! as NSString), (self.newsDate! as NSString))
        self.detailLabel.textColor = UIColor.lightGrayColor()
        self.detailLabel.sizeToFit()
        
        self.newsTextview.text = self.newsStory as? String
        
        if ((self.imageDetailurl?.containsString("movie.mp4")) != nil) {
            
            let playButton = UIButton(type: UIButtonType.Custom) as UIButton
            playButton.frame = CGRectMake(self.newsImageview.frame.size.width/2-130, self.newsImageview.frame.origin.y+100, 50, 50)
            playButton.alpha = 1.0
            playButton.tintColor = UIColor.whiteColor()
            let playbutton : UIImage? = UIImage(named:"play_button.png")!.imageWithRenderingMode(.AlwaysTemplate)
            playButton .setImage(playbutton, forState: .Normal)
            playButton.userInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: Selector("playVideo:"))
            playButton.addGestureRecognizer(tap)
            self.scrollView.addSubview(playButton)
            
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

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
