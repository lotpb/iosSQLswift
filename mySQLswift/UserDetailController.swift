//
//  UserDetailController.swift
//  mySQLswift
//
//  Created by Peter Balsamo on 12/18/15.
//  Copyright © 2015 Peter Balsamo. All rights reserved.
//

import UIKit
import Parse
import MapKit
import CoreLocation
import MobileCoreServices //kUTTypeImage
import MessageUI

class UserDetailController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MKMapViewDelegate, MFMailComposeViewControllerDelegate, UITextFieldDelegate {
    
    let ipadtitle = UIFont.systemFontOfSize(20, weight: UIFontWeightLight)
    let ipadlabel = UIFont.systemFontOfSize(16, weight: UIFontWeightLight)
    
    let celltitle = UIFont.systemFontOfSize(18, weight: UIFontWeightLight)
    let celllabel = UIFont.systemFontOfSize(14, weight: UIFontWeightLight)
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mainView: UIView?
    @IBOutlet weak var userimageView: UIImageView?

    @IBOutlet weak var createLabel: UILabel?
    @IBOutlet weak var usernameField : UITextField?
    @IBOutlet weak var emailField : UITextField?
    @IBOutlet weak var phoneField : UITextField?
    @IBOutlet weak var mapLabel: UILabel!
    
    @IBOutlet weak var pickFile: UIButton?
    @IBOutlet weak var selectCamera: UIButton?
    @IBOutlet weak var updateBtn: UIButton?
    @IBOutlet weak var callBtn: UIButton?
    @IBOutlet weak var emailBtn: UIButton?

    
    var objectId : NSString?
    var username : NSString?
    var create : NSString?
    var email : NSString?
    var phone : NSString?
    
    var user : PFUser?
    var userquery : PFObject?
    var userimage : UIImage?
    var pickImage : UIImage?
    var pictureData : NSData?
    
    var imagePicker: UIImagePickerController!

    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    //var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 50, 50)) as UIActivityIndicatorView
    
    //var getEmail : NSString?
    var emailTitle :NSString?
    var messageBody:NSString?


    override func viewDidLoad() {
        super.viewDidLoad()

        let titleButton: UIButton = UIButton(frame: CGRectMake(0, 0, 100, 32))
        titleButton.setTitle("myUser Info", forState: UIControlState.Normal)
        titleButton.titleLabel?.font = Font.navlabel
        titleButton.titleLabel?.textAlignment = NSTextAlignment.Center
        titleButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        titleButton.addTarget(self, action: Selector(), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.titleView = titleButton
        
        mapView.delegate = self
        mapView!.layer.borderColor = UIColor.lightGrayColor().CGColor
        mapView!.layer.borderWidth = 1.0
        
        callBtn!.layer.cornerRadius = 24.0
        callBtn!.layer.borderColor = Color.BlueColor.CGColor
        callBtn!.layer.borderWidth = 3.0
        callBtn!.setTitleColor(Color.BlueColor, forState: UIControlState.Normal)
        
        updateBtn!.layer.cornerRadius = 24.0
        updateBtn!.layer.borderColor = Color.BlueColor.CGColor
        updateBtn!.layer.borderWidth = 3.0
        updateBtn!.setTitleColor(Color.BlueColor, forState: UIControlState.Normal)
        
        emailBtn!.layer.cornerRadius = 24.0
        emailBtn!.layer.borderColor = Color.BlueColor.CGColor
        emailBtn!.layer.borderWidth = 3.0
        emailBtn!.setTitleColor(Color.BlueColor, forState: UIControlState.Normal)
        
        self.usernameField?.text = self.username as? String
        self.emailField?.text = self.email as? String
        self.phoneField?.text = self.phone as? String
        
        self.createLabel!.text = self.create as? String
        self.userimageView?.image = self.userimage
        self.userimageView?.backgroundColor = UIColor.blackColor()
        self.userimageView!.userInteractionEnabled = true
        self.mainView!.backgroundColor = UIColor(white:0.90, alpha:1.0)
        self.view.backgroundColor = UIColor(white:0.90, alpha:1.0)
        
        let topBorder = CALayer()
        let width = CGFloat(2.0)
        topBorder.borderColor = UIColor.darkGrayColor().CGColor
        topBorder.frame = CGRect(x: 0, y: 175, width:  self.mainView!.frame.size.width, height: 0.5)
        topBorder.borderWidth = width
        self.mainView!.layer.addSublayer(topBorder)
        self.mainView!.layer.masksToBounds = true
        
        let bottomBorder = CALayer()
        let width1 = CGFloat(2.0)
        bottomBorder.borderColor = UIColor.darkGrayColor().CGColor
        bottomBorder.frame = CGRect(x: 0, y: 370, width:self.mainView!.frame.size.width, height: 0.5)
        bottomBorder.borderWidth = width1
        self.mainView!.layer.addSublayer(bottomBorder)
        self.mainView!.layer.masksToBounds = true
        
        
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad {
            self.usernameField!.font = ipadtitle
            self.emailField!.font = ipadtitle
            self.phoneField!.font = ipadtitle
            self.createLabel!.font = ipadlabel
            self.mapLabel!.font = Font.Snapshot.celltitle
        } else {
            self.usernameField!.font = celltitle
            self.emailField!.font = celltitle
            self.phoneField!.font = celltitle
            self.createLabel!.font = celllabel
            self.mapLabel!.font = Font.Snapshot.celltitle
        }
        
        let query = PFUser.query()
        do {
            userquery = try query!.getObjectWithId(self.objectId as! String)
            let location = userquery!.valueForKey("currentLocation") as! PFGeoPoint
            
            let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            let span = MKCoordinateSpanMake(0.005, 0.005)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            self.mapView!.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.title = userquery!.objectForKey("username") as? String
            annotation.coordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude)
            self.mapView!.addAnnotation(annotation)
            self.mapView!.showsUserLocation = true
        } catch {
            print("")
        }
        
        emailTitle = defaults.stringForKey("emailtitleKey")
        messageBody = defaults.stringForKey("emailmessageKey")
        
        self.emailField!.keyboardType = UIKeyboardType.EmailAddress
        self.phoneField!.keyboardType = UIKeyboardType.NumbersAndPunctuation
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            
            self.userimageView!.image = pickedImage
            /*
            let uncroppedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            let croppedImage = info[UIImagePickerControllerEditedImage] as? UIImage
            let cropRect = info[UIImagePickerControllerCropRect]!.CGRectValue */
            
            dismissViewControllerAnimated(true, completion: { () -> Void in
            })
        }
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - Call Phone
    
    @IBAction func callPhone(sender: AnyObject) {
        
        let phoneNo : NSString?
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Phone {
            
            phoneNo = self.phoneField!.text
            if let phoneCallURL:NSURL = NSURL(string:"telprompt:\(phoneNo!)") {
                
                let application:UIApplication = UIApplication.sharedApplication()
                if (application.canOpenURL(phoneCallURL)) {
                    application.openURL(phoneCallURL)
                }
            } else {
                
                self.simpleAlert("Alert", message: "Call facility is not available!!!")
            }
        } else {
            
            self.simpleAlert("Alert", message: "Your device doesn't support this feature.")
        }
    }
    
    
    // MARK: - Send Email
    
    @IBAction func sendEmail(sender: AnyObject) {
        
        if ((self.emailField != NSNull()) && ( self.emailField != 0 )) {
            
            self.getEmail((emailField?.text)!)
            
        } else {
            
            self.simpleAlert("Alert", message: "Your field doesn't have valid email.")
        }
    }
    
    
    func getEmail(emailfield: NSString) {
        
        let email = MFMailComposeViewController()
        email.mailComposeDelegate = self
        email.setToRecipients([emailfield as String])
        email.setSubject((emailTitle as? String)!)
        email.setMessageBody((messageBody as? String)!, isHTML:true)
        email.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        self.presentViewController(email, animated: true, completion: nil)
    }
    
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func Update(sender: AnyObject) {
        
        self.user = PFUser.currentUser()
        if self.usernameField!.text! == self.user?.username {
            
            self.activityIndicator.center = self.userimageView!.center
            self.activityIndicator.startAnimating()
            self.view.addSubview(activityIndicator)
            
            pictureData = UIImageJPEGRepresentation(self.userimageView!.image!, 1.0)
            let file = PFFile(name: "img", data: pictureData!)
            
            file!.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                if success {
                    self.user!.setObject(self.usernameField!.text!, forKey:"username")
                    self.user!.setObject(self.emailField!.text!, forKey:"email")
                    self.user!.setObject(self.phoneField!.text!, forKey:"phone")
                    self.user!.setObject(file!, forKey:"imageFile")
                    self.user!.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                    }
                    self.simpleAlert("Upload Complete", message: "Successfully updated the data")
                } else {
                    self.simpleAlert("Upload Failure", message: "Failure updating the data")
                }
            }
            //self.navigationController?.popToRootViewControllerAnimated(true)
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        } else {
            self.simpleAlert("Alert", message: "User is not valid to edit data")
        }
    }
    
}
