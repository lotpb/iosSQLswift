//
//  UploadController.swift
//  mySQLswift
//
//  Created by Peter Balsamo on 1/20/16.
//  Copyright © 2016 Peter Balsamo. All rights reserved.
//

import UIKit
import Parse
//import CoreLocation
import MobileCoreServices //kUTTypeImage

class UploadController: UIViewController, UINavigationControllerDelegate,
UIImagePickerControllerDelegate {
    
    let addText = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var imgToUpload: UIImageView!
    @IBOutlet weak var commentTitle: UITextField!
    @IBOutlet weak var commentSorce: UITextField!
    @IBOutlet weak var commentDetail: UITextView!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var selectPic: UIButton!
    
    var formStat : String?
    var objectId : String?
    var newstitle : String?
    var newsdetail : String?
    var newsStory : String?
    var imageDetailurl : String?
    var newsImage : UIImage!
    
    var username : NSString?
    
    var file : PFFile?
    var pictureData : NSData?
    var user : PFUser?
    //var query : PFQuery?
    //var userquery: PFObject?
    //var userimage : UIImage?
    //var pickImage : UIImage?
    
    var videoURL : NSURL?
    
    var imagePicker: UIImagePickerController!
    
    var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 150, 150)) as UIActivityIndicatorView
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleButton: UIButton = UIButton(frame: CGRectMake(0, 0, 100, 32))
        titleButton.setTitle("myUpload", forState: UIControlState.Normal)
        titleButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 25.0)
        titleButton.titleLabel?.textAlignment = NSTextAlignment.Center
        titleButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        titleButton.addTarget(self, action: Selector(), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.titleView = titleButton
        
        self.mainView.backgroundColor = UIColor(white:0.90, alpha:1.0)

        if (self.progressView.progress == 0) {
            self.progressView.hidden = true
        } else {
            self.progressView.hidden = false
        }
        
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad {
            
            self.commentTitle!.font = UIFont (name: "HelveticaNeue", size: 18)
            self.commentSorce!.font = UIFont (name: "HelveticaNeue", size: 18)
            self.commentSorce!.font = UIFont (name: "HelveticaNeue", size: 18)
            
        } else {
            self.commentTitle!.font = UIFont (name: "HelveticaNeue", size: 16)
            self.commentSorce!.font = UIFont (name: "HelveticaNeue", size: 16)
            self.commentSorce!.font = UIFont (name: "HelveticaNeue", size: 16)
            
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
        
        self.clearButton.setTitle("clear", forState: UIControlState.Normal)
        self.clearButton .addTarget(self, action: "clearBtn", forControlEvents: UIControlEvents.TouchUpInside)
        self.clearButton.tintColor = UIColor(white:0.45, alpha:1.0)
        self.selectPic.tintColor = UIColor(white:0.45, alpha:1.0)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: - Button
    
    func clearBtn() {
        
        if (self.clearButton.titleLabel!.text == "clear")   {
            self.commentDetail.text = ""
            self.clearButton.setTitle("add text", forState: UIControlState.Normal)
            self.clearButton.sizeToFit()
        } else {
            self.commentDetail.text = addText
            self.clearButton.setTitle("clear", forState: UIControlState.Normal)
            self.clearButton.sizeToFit()
        }
    }
    
    // MARK: - Button
    
    @IBAction func selectCamera(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            
            imagePicker = UIImagePickerController()
            imagePicker.sourceType = .Camera
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            imagePicker.showsCameraControls = true
            //imagePicker.videoMaximumDuration = 10.0
            self.presentViewController(imagePicker, animated: true, completion: nil)
        } else {
            print("Camera is not available")
        }
    }
    
    @IBAction func selectImage(sender: AnyObject) {
        
        imagePicker = UIImagePickerController()
        imagePicker.sourceType = .SavedPhotosAlbum
        imagePicker.mediaTypes = [kUTTypeImage as String]
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.presentViewController(imagePicker, animated: false, completion: nil)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: AnyObject]) {
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.imgToUpload!.image = pickedImage
            dismissViewControllerAnimated(true, completion: { () -> Void in
            })
        }
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func uploadImage(sender: AnyObject) {
        
        activityIndicator.center = self.imgToUpload!.center
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
        
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
                    
                    let alert = UIAlertController(title: "Upload Complete", message: "Successfully updated the data", preferredStyle: UIAlertControllerStyle.Alert)
                    let alertActionTrue = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in })
                    
                    alert.addAction(alertActionTrue)
                    self .presentViewController(alert, animated: true, completion: nil)
                }
            }
            
        } else {
            
            if ((newsImage) != nil) {
                pictureData = UIImageJPEGRepresentation(self.imgToUpload!.image!, 1.0)
                file = PFFile(name: "img", data: pictureData!)
            } else {
                pictureData =  NSData(contentsOfURL: videoURL!)
                file = PFFile(name: "movie.mp4", data: pictureData!)
            }
            
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
                            self.navigationController?.popViewControllerAnimated(true)
                        } else {
                            print("Error: \(error) \(error!.userInfo)")
                        }
                    }
                }
            }
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
        }
    }


}
