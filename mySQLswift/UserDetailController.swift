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

class UserDetailController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MKMapViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mainView: UIView?
    @IBOutlet weak var userimageView: UIImageView?
    @IBOutlet weak var pickFile: UIButton?
    @IBOutlet weak var selectCamera: UIButton?
    @IBOutlet weak var update: UIButton?
    @IBOutlet weak var createLabel: UILabel?
    @IBOutlet weak var usernameField : UITextField?
    @IBOutlet weak var emailField : UITextField?
    @IBOutlet weak var phoneField : UITextField?
    
    var objectId : NSString?
    var username : NSString?
    var create : NSString?
    var email : NSString?
    var phone : NSString?
    
    var query : PFQuery?
    var user : PFUser?
    var userquery: PFObject?
    var userimage : UIImage?
    var pickImage : UIImage?
    var pictureData : NSData?
    
    var imagePicker: UIImagePickerController!
    
    var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 150, 150)) as UIActivityIndicatorView


    override func viewDidLoad() {
        super.viewDidLoad()

        let titleButton: UIButton = UIButton(frame: CGRectMake(0, 0, 100, 32))
        titleButton.setTitle("myUser Info", forState: UIControlState.Normal)
        titleButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 25.0)
        titleButton.titleLabel?.textAlignment = NSTextAlignment.Center
        titleButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        titleButton.addTarget(self, action: Selector(), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.titleView = titleButton
        
        mapView.delegate = self
        mapView!.layer.borderColor = UIColor.lightGrayColor().CGColor
        mapView!.layer.borderWidth = 0.5
        
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
            self.usernameField!.font = UIFont (name: "HelveticaNeue-Light", size: 20)
            self.emailField!.font = UIFont (name: "HelveticaNeue-Light", size: 20)
            self.phoneField!.font = UIFont (name: "HelveticaNeue-Light", size: 20)
            self.createLabel!.font = UIFont (name: "HelveticaNeue-Light", size: 16)
        } else {
            self.usernameField!.font = UIFont (name: "HelveticaNeue-Light", size: 18)
            self.emailField!.font = UIFont (name: "HelveticaNeue-Light", size: 18)
            self.phoneField!.font = UIFont (name: "HelveticaNeue-Light", size: 18)
            self.createLabel!.font = UIFont (name: "HelveticaNeue-Light", size: 14)
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
        
        self.emailField!.keyboardType = UIKeyboardType.EmailAddress
        self.phoneField!.keyboardType = UIKeyboardType.NumbersAndPunctuation;
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
    
    
    @IBAction func Update(sender: AnyObject) {
        
        activityIndicator.center = self.userimageView!.center
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
        
        pictureData = UIImageJPEGRepresentation(self.userimageView!.image!, 1.0)
        let file = PFFile(name: "img", data: pictureData!)
        
        let query = PFUser.query()!
        query.whereKey("objectId", equalTo:self.objectId!)
        query.getFirstObjectInBackgroundWithBlock {(updateuser: PFObject?, error: NSError?) -> Void in
            if error == nil {
                updateuser!.setObject(self.usernameField!.text!, forKey:"username")
                updateuser!.setObject(self.usernameField!.text!, forKey:"email")
                updateuser!.setObject(self.usernameField!.text!, forKey:"phone")
                updateuser!.saveEventually()
                
                file!.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                    if success {
                        self.user = PFUser.currentUser()
                        self.user!.setObject(file!, forKey:"imageFile")
                        self.user!.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                        }
                    }
                }
                
                let alert = UIAlertController(title: "Upload Complete", message: "Successfully updated the data", preferredStyle: UIAlertControllerStyle.Alert)
                let alertActionTrue = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in
                    self.navigationController?.popToRootViewControllerAnimated(true)
                })
                alert.addAction(alertActionTrue)
                self .presentViewController(alert, animated: true, completion: nil)
                
            } else {
                
                let alert = UIAlertController(title: "Upload Failure", message: "Failure updating the data", preferredStyle: UIAlertControllerStyle.Alert)
                let alertActionTrue = UIAlertAction(title: "OK", style: UIAlertActionStyle.Destructive, handler: {(alert: UIAlertAction!) in
                    self.navigationController?.popToRootViewControllerAnimated(true)
                })
                alert.addAction(alertActionTrue)
                self .presentViewController(alert, animated: true, completion: nil)
            }
        }
        self.activityIndicator.stopAnimating()
        self.activityIndicator.removeFromSuperview()
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
}
