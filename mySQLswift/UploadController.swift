//
//  UploadController.swift
//  mySQLswift
//
//  Created by Peter Balsamo on 1/20/16.
//  Copyright © 2016 Peter Balsamo. All rights reserved.
//

import UIKit
import Parse
import MobileCoreServices //kUTTypeImage
import AVKit
import AVFoundation

class UploadController: UIViewController, UINavigationControllerDelegate,
UIImagePickerControllerDelegate {
    
    let ipadtitle = UIFont.systemFontOfSize(18, weight: UIFontWeightRegular)
    
    let addText = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var imgToUpload: UIImageView!
    @IBOutlet weak var commentTitle: UITextField!
    @IBOutlet weak var commentSorce: UITextField!
    @IBOutlet weak var commentDetail: UITextView!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var selectPic: UIButton!
    
    var pickImage = false
    var playerViewController = AVPlayerViewController()
    var imagePicker: UIImagePickerController!
    var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 150, 150)) as UIActivityIndicatorView
    //var activityIndicator : UIActivityIndicatorView?
    
    var formStat : String?
    var objectId : String?
    var newstitle : String?
    var newsdetail : String?
    var newsStory : String?
    var imageDetailurl : String?
    var newsImage : UIImage!
    
    var file : PFFile!
    var pictureData : NSData!
    var videoURL : NSURL?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleButton: UIButton = UIButton(frame: CGRectMake(0, 0, 100, 32))
        titleButton.setTitle("myUpload", forState: UIControlState.Normal)
        titleButton.titleLabel?.font = Font.navlabel
        titleButton.titleLabel?.textAlignment = NSTextAlignment.Center
        titleButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        titleButton.addTarget(self, action: Selector(), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.titleView = titleButton
        
        self.mainView.backgroundColor = UIColor(white:0.90, alpha:1.0)
        self.progressView.hidden = true
        self.progressView.setProgress(0, animated: true)
        
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad {
            
            self.commentTitle!.font = ipadtitle
            self.commentDetail!.font = ipadtitle
            self.commentSorce!.font = ipadtitle
            
        } else {
            self.commentTitle!.font = Font.celllabel1
            self.commentDetail!.font = Font.celllabel1
            self.commentSorce!.font = Font.celllabel1
            
        }
        
        if (self.formStat == "Update") {
            self.commentTitle.text = self.newstitle
            self.commentDetail.text = self.newsStory
            self.commentSorce.text = self.newsdetail
            self.imgToUpload.image = self.newsImage
        } else {
            self.commentDetail.text = addText
        }
        
        
        self.imgToUpload.backgroundColor = UIColor.whiteColor()
        self.imgToUpload.userInteractionEnabled = true
        
        self.clearButton.setTitle("Clear", forState: UIControlState.Normal)
        self.clearButton .addTarget(self, action: #selector(UploadController.clearBtn), forControlEvents: UIControlEvents.TouchUpInside)
        self.clearButton.tintColor = UIColor(white:0.45, alpha:1.0)
        self.clearButton.layer.cornerRadius = 12.0
        self.clearButton.layer.borderColor = UIColor(white:0.45, alpha:1.0).CGColor
        self.clearButton.layer.borderWidth = 2.0
        
        self.selectPic.tintColor = UIColor(white:0.45, alpha:1.0)
        self.selectPic.layer.cornerRadius = 12.0
        self.selectPic.layer.borderColor = UIColor(white:0.45, alpha:1.0).CGColor
        self.selectPic.layer.borderWidth = 2.0
        
    }
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UploadController.finishedPlaying(_:)), name: AVPlayerItemDidPlayToEndTimeNotification, object: self.playerViewController)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: - Button
    
    func clearBtn() {
        
        if (self.clearButton.titleLabel!.text == "Clear")   {
            self.commentDetail.text = ""
            self.clearButton.setTitle("add text", forState: UIControlState.Normal)
            self.clearButton.sizeToFit()
        } else {
            self.commentDetail.text = addText
            self.clearButton.setTitle("Clear", forState: UIControlState.Normal)
            self.clearButton.sizeToFit()
        }
    }
    
    // MARK: - Button
    /*
    @IBAction func selectCamera(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            
            imagePicker = UIImagePickerController()
            imagePicker.sourceType = .Camera
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            imagePicker.showsCameraControls = true
            //imagePicker.videoMaximumDuration = 10.0
            imagePicker.videoQuality = UIImagePickerControllerQualityType.TypeHigh
            self.presentViewController(imagePicker, animated: true, completion: nil)
            
        } else {
            print("Camera is not available")
        }
    } */
    
    @IBAction func selectImage(sender: AnyObject) {
        
        imagePicker = UIImagePickerController()
        imagePicker.sourceType = .SavedPhotosAlbum
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(imagePicker.sourceType)!  
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        imagePicker.videoQuality = UIImagePickerControllerQualityType.TypeHigh
        self.presentViewController(imagePicker, animated: false, completion: nil)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: AnyObject]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        self.dismissViewControllerAnimated(true, completion: nil)
        
        if mediaType.isEqualToString(kUTTypeMovie as String) {
            
            //let videoURL = NSURL(string: Videos[indexPath.row].url!)
            pickImage = false
            videoURL = info[UIImagePickerControllerMediaURL] as? NSURL
            let player = AVPlayer(URL: videoURL!)
            playerViewController.player = player
   
            playerViewController.view.frame = self.imgToUpload.bounds
            playerViewController.videoGravity = AVLayerVideoGravityResizeAspect
            playerViewController.showsPlaybackControls = true
            self.imgToUpload.addSubview(playerViewController.view)
            player.play()
            
            // FIXME:
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector(), name: AVPlayerItemDidPlayToEndTimeNotification, object: playerViewController)
            
        } else if mediaType.isEqualToString(kUTTypeImage as String) {
            
            let image = info[UIImagePickerControllerEditedImage] as! UIImage
            pickImage = true
            self.imgToUpload!.image = image
            self.imgToUpload.contentMode = UIViewContentMode.ScaleToFill
            self.imgToUpload.clipsToBounds = true
            
        }
        
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func finishedPlaying(myNotification:NSNotification) {
        
        let stopedPlayerItem: AVPlayerItem = myNotification.object as! AVPlayerItem
        stopedPlayerItem.seekToTime(kCMTimeZero)
    }
    
    
    // MARK: - AlertController
    
    func simpleAlert (title:String, message:String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Update Data
    
    
    @IBAction func uploadImage(sender: AnyObject) {
        
        self.navigationItem.rightBarButtonItem!.enabled = false
        self.progressView.hidden = false
        
        activityIndicator.center = self.imgToUpload!.center
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
        
        if (pickImage == true) {//image
            pictureData = UIImageJPEGRepresentation(self.imgToUpload!.image!, 1.0)
            file = PFFile(name: "img", data: pictureData!)
        } else { //video
            pictureData =  NSData(contentsOfURL: videoURL!)
            file = PFFile(name: "movie.mp4", data: pictureData!)
        }
        
        if (self.formStat == "Update") {
            
            let query = PFQuery(className:"Newsios")
            query.whereKey("objectId", equalTo:self.objectId!)
            query.getFirstObjectInBackgroundWithBlock {(updateblog: PFObject?, error: NSError?) -> Void in
                if error == nil {
                    updateblog!.setObject(self.commentTitle.text!, forKey:"newsTitle")
                    updateblog!.setObject(self.commentSorce.text!, forKey:"newsDetail")
                    updateblog!.setObject(self.commentDetail.text!, forKey:"storyText")
                    updateblog!.setObject(PFUser.currentUser()!.username!, forKey:"username")
                    updateblog!.saveEventually()
                    /*
                    self.file!.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                        if success {
                            updateblog!.setObject(self.file!, forKey:"imageFile")
                            updateblog!.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                            }
                        }
                    } */
                    
                    self.simpleAlert("Upload Complete", message: "Successfully updated the data")
                    
                } else {
                    
                    self.simpleAlert("Upload Failure", message: "Failure updated the data")
                    
                }
            }

        } else {
            
            file!.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                if success {
                    let updateuser:PFObject = PFObject(className:"Newsios")
                    updateuser.setObject(self.file!, forKey:"imageFile")
                    updateuser.setObject(self.commentTitle.text!, forKey:"newsTitle")
                    updateuser.setObject(self.commentSorce.text!, forKey:"newsDetail")
                    updateuser.setObject(self.commentDetail.text!, forKey:"storyText")
                    updateuser.setObject(PFUser.currentUser()!.username!, forKey:"username")
                    updateuser.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                        
                        if success {
                            
                            self.simpleAlert("Save Complete", message: "Successfully saved the data")
                            
                        } else {
                            
                            print("Error: \(error) \(error!.userInfo)")
                        }
                    }
                }
            }
        }
        self.navigationController?.popToRootViewControllerAnimated(true)
        self.activityIndicator.stopAnimating()
        self.activityIndicator.removeFromSuperview()

    }


}
