//
//  LoginController.swift
//  mySQLswift
//
//  Created by Peter Balsamo on 12/13/15.
//  Copyright © 2015 Peter Balsamo. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import ParseFacebookUtilsV4
import MapKit
import LocalAuthentication


class LoginController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var mapView: MKMapView?
    
    @IBOutlet weak var forgotPassword: UIButton?
    @IBOutlet weak var registerBtn: UIButton?
    @IBOutlet weak var loginBtn: UIButton?
    @IBOutlet weak var backloginBtn: UIButton?
    @IBOutlet weak var authentButton: UIButton!
    
    @IBOutlet weak var usernameField: UITextField?
    @IBOutlet weak var passwordField: UITextField?
    @IBOutlet weak var reEnterPasswordField: UITextField?
    @IBOutlet weak var emailField: UITextField?
    @IBOutlet weak var phoneField: UITextField?
    
    var defaults = NSUserDefaults.standardUserDefaults()
    var pictureData : NSData?
    var user : PFUser?
    var userimage : UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleButton: UIButton = UIButton(frame: CGRectMake(0, 0, 100, 32))
        titleButton.setTitle("Login", forState: UIControlState.Normal)
        titleButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 25.0)
        titleButton.titleLabel?.textAlignment = NSTextAlignment.Center
        titleButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        titleButton.addTarget(self, action: Selector(), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.titleView = titleButton

        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        let searchButton = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: "searchButton:")
        let buttons:NSArray = [addButton,searchButton]
        self.navigationItem.rightBarButtonItems = buttons as? [UIBarButtonItem]
        
        if ((defaults.stringForKey("registerKey") == nil)) {
            
            self.registerBtn!.setTitle("Sign in", forState: UIControlState.Normal)
            self.loginBtn!.hidden = true //hide login button no user is regsitered
            self.forgotPassword!.hidden = true
            self.authentButton!.hidden = true
            self.emailField!.hidden = false
            self.phoneField!.hidden = false//
            
        } else {
            
            self.usernameField!.text = defaults.stringForKey("usernameKey")
            self.reEnterPasswordField!.hidden = true//
            self.registerBtn!.hidden = false //
            self.emailField!.hidden = true//
            self.phoneField!.hidden = true//
            self.forgotPassword!.hidden = false//
            self.backloginBtn!.hidden = true //
        }
        
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad {
            self.usernameField!.font = UIFont (name: "HelveticaNeue", size: 20)
            self.passwordField!.font = UIFont (name: "HelveticaNeue", size: 20)
            self.reEnterPasswordField!.font = UIFont (name: "HelveticaNeue", size: 20)
            self.emailField!.font = UIFont (name: "HelveticaNeue", size: 20)
            self.phoneField!.font = UIFont (name: "HelveticaNeue", size: 20)
        } else {
            self.usernameField!.font = UIFont (name: "HelveticaNeue", size: 18)
            self.passwordField!.font = UIFont (name: "HelveticaNeue", size: 18)
            self.reEnterPasswordField!.font = UIFont (name: "HelveticaNeue", size: 18)
            self.emailField!.font = UIFont (name: "HelveticaNeue", size: 18)
            self.phoneField!.font = UIFont (name: "HelveticaNeue", size: 18)
        }
        
        self.emailField!.keyboardType = UIKeyboardType.EmailAddress
        self.phoneField!.keyboardType = UIKeyboardType.NumbersAndPunctuation
        
        if ((PFUser.currentUser()) != nil) {
            //self.user = PFUser.user()
            let user = PFUser.currentUser()!
            PFGeoPoint.geoPointForCurrentLocationInBackground {(geoPoint: PFGeoPoint?, error: NSError?) -> Void in
                user.setObject(geoPoint!, forKey: "currentLocation");
                user.saveInBackground();
                
                let theirLocation = CLLocationCoordinate2D(latitude: geoPoint!.latitude, longitude: geoPoint!.longitude)
                let span = MKCoordinateSpanMake(0.40, 0.40)
                let region = MKCoordinateRegionMake(theirLocation, span)
                self.mapView!.setRegion(region, animated: true)
                
                self.refreshMap()
            }
        }
        
        // MARK: - Facebook
        
        if (FBSDKAccessToken.currentAccessToken() == nil) {
            print("Not logged in...")
        } else {
            print("Logged in...")
        }
        
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.center = self.view.center
        loginButton.delegate = self
        self.view.addSubview(loginButton)

        /*
        let requestParameters = ["fields": "id, email, first_name, last_name"]
        let userDetails = FBSDKGraphRequest(graphPath: "me", parameters: requestParameters)
        userDetails.startWithCompletionHandler { (connection, result, error:NSError!) -> Void in
            
            if(error != nil) {
                print("\(error.localizedDescription)")
                return
            }
            
            if(result != nil) {
                
                let userId:String = result["id"] as! String
                let userFirstName:String? = result["first_name"] as? String
                let userLastName:String? = result["last_name"] as? String
                let userEmail:String? = result["email"] as? String
                
                print("\(userEmail)")
                
                let myUser:PFUser = PFUser.currentUser()!
                // Save first name
                if(userFirstName != nil) {
                    myUser.setObject(userFirstName!, forKey: "username")
                }
                //Save last name
                if(userLastName != nil) {
                    myUser.setObject(userLastName!, forKey: "username")
                }
                // Save email address
                if(userEmail != nil) {
                    myUser.setObject(userEmail!, forKey: "email")
                }
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                    
                    // Get Facebook profile picture
                    let userProfile = "https://graph.facebook.com/" + userId + "/picture?type=large"
                    let profilePictureUrl = NSURL(string: userProfile)
                    let profilePictureData = NSData(contentsOfURL: profilePictureUrl!)
                    if(profilePictureData != nil) {
                        let profileFileObject = PFFile(data:profilePictureData!)
                        myUser.setObject(profileFileObject!, forKey: "imageFile")
                    }
                    myUser.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                        
                        if(success)
                        {
                            print("User details are now updated")
                        }
                    })
                }
            }
        } */
        
        // MARK:
        
    }
    
    override func viewWillAppear(animated: Bool) {
        //self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = UIColor.redColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!)
    {
        if error == nil
        {
            self.performSegueWithIdentifier("loginSegue", sender: nil)
            print("Login complete.")
            /*
            defaults.setObject("Peter Balsamo", forKey: "usernameKey")
            defaults.setObject("3911", forKey: "passwordKey")
            defaults.setObject("eunitedws@verizon.net", forKey: "emailKey")
            defaults.setBool(true, forKey: "registerKey")
            //defaults.synchronize() */
        } else {
            print(error.localizedDescription)
        }
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!)
    {
        print("User logged out...")
    }
    
    func refreshMap() {
        
        //let geoPoint = PFGeoPoint(latitude: self.mapView!.centerCoordinate.latitude, longitude:self.mapView!.centerCoordinate.longitude)
        //let myParseId = PFUser.currentUser()!.objectId //PFUser.currentUser().objectId
        //var radius = 100.0
        
        PFGeoPoint.geoPointForCurrentLocationInBackground {
            (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
            if error == nil {
                // do something with the new geoPoint
            }
        }
    }
    
    // MARK: - LoginUser
    
    @IBAction func LoginUser(sender:AnyObject) {
        
        PFUser.logInWithUsernameInBackground(usernameField!.text!, password: passwordField!.text!) { user, error in
            if user != nil {
                self.performSegueWithIdentifier("loginSegue", sender: nil)
            } else {
                
                PFUser.currentUser()?.fetchInBackgroundWithBlock({ (object, error) -> Void in
                    
                    let isEmailVerified = PFUser.currentUser()?.objectForKey("emailVerified")?.boolValue
                    
                    if isEmailVerified == true {
                        self.emailField!.text = "Email has been verified."
                    } else {
                        self.emailField!.text = "Email is not verified."
                    }
                })
            }
        }
    }
    
    @IBAction func returnLogin(sender:AnyObject) {
        
        self.registerBtn!.setTitle("Create an Account", forState: UIControlState.Normal)
        self.usernameField!.text = defaults.stringForKey("soundKey")
        self.passwordField!.hidden = false //
        self.loginBtn!.hidden = false //
        self.registerBtn!.hidden = false //
        self.forgotPassword!.hidden = false //
        self.authentButton!.hidden = false //
        self.backloginBtn!.hidden = true //
        self.reEnterPasswordField!.hidden = true //
        self.emailField!.hidden = true //
        self.phoneField!.hidden = true //
        
    }
    
    // MARK: - RegisterUser
    
    @IBAction func registerUser(sender:AnyObject) {
        
        if (self.registerBtn!.titleLabel!.text == "Create an Account") {
            
            self.registerBtn!.setTitle("Sign in", forState: UIControlState.Normal)
            self.usernameField!.text = ""
            self.loginBtn!.hidden = true
            self.forgotPassword!.hidden = true
            self.authentButton!.hidden = true
            self.backloginBtn!.hidden = false
            self.reEnterPasswordField!.hidden = false
            self.emailField!.hidden = false
            self.phoneField!.hidden = false
            
        } else {
            //check if all text fields are completed
            if (self.usernameField!.text == "" || self.passwordField!.text == "" || self.reEnterPasswordField!.text == "") {
                
                let alertController = UIAlertController(title: "Oooops", message:
                    "You must complete all fields", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                checkPasswordsMatch()
            }
        }
        
        
    }
    
    func registerNewUser() {
        
        userimage = UIImage(named:"profile-rabbit-toy.png")
        pictureData = UIImageJPEGRepresentation(userimage!, 0.9)
        let file = PFFile(name: "Image.jpg", data: pictureData!)
        
        let user = PFUser()
        user.username = usernameField!.text
        user.password = passwordField!.text
        
        user.setObject(file!, forKey:"imageFile")
        user.signUpInBackgroundWithBlock { succeeded, error in
            if (succeeded) {
                
                self.defaults.setObject(self.usernameField!.text, forKey: "usernameKey")
                self.defaults.setObject(self.passwordField!.text, forKey: "passwordKey")
                if ((self.emailField!.text == nil) == 0) {
                    self.defaults.setObject(self.emailField!.text, forKey: "emailKey")
                }
                self.defaults.setBool(true, forKey: "registerKey")
                //self.defaults.synchronize()
                
                let alertController = UIAlertController(title: "Success", message:
                    "You have registered a new user", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
                
                self.usernameField!.text = nil;
                self.passwordField!.text = nil;
                self.emailField!.text = nil;
                self.phoneField!.text = nil;
                
                self.presentViewController(alertController, animated: true, completion: nil)
                
                self.performSegueWithIdentifier("loginSegue", sender: nil)
            } else {
                print("Error: \(error) \(error!.userInfo)")
                
            }
        }
    }
    
    // MARK: - FacebookLoginUser
    
    @IBAction func FacebookLoginUser(sender:AnyObject) {
        
        let permissions = [ "public_profile", "email", "user_friends" ]
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions,  block: {  (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                if user.isNew {
                    print("User signed up and logged in through Facebook!")
                } else {
                    print("User logged in through Facebook!")
                }
            } else {
                print("Uh oh. The user cancelled the Facebook login.")
            }
        })
        
        PFFacebookUtils.linkUserInBackground(user!, withPublishPermissions: ["publish_actions"], block: {
            (succeeded: Bool?, error: NSError?) -> Void in
            if (succeeded != nil) {
                print("User now has read and publish permissions!")
            }
        })
        
    }
    
    // MARK: - Password
    
    @IBAction func passwordReset(sender:AnyObject) {
        
        self.usernameField!.hidden = true
        self.loginBtn!.hidden = true
        self.passwordField!.hidden = true
        self.authentButton!.hidden = true
        self.backloginBtn!.hidden = false
        self.registerBtn!.hidden = true
        self.emailField!.hidden = false
        
        let email = self.emailField!.text;
        let finalEmail = email!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        PFUser.requestPasswordResetForEmailInBackground(finalEmail) { (success, error) -> Void in
            if success {
                let alertController = UIAlertController(title: "Alert", message:
                    "Link to reset the password has been send to specified email", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                
                let alertController = UIAlertController(title: "Alert", message:
                    "Enter email in field: %@", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            
        }
    }
    
    func checkPasswordsMatch() {
        
        if self.passwordField!.text == self.reEnterPasswordField!.text {
            
            registerNewUser()
        } else {
            let alertController = UIAlertController(title: "Oooops", message:
                "Your entered passwords do not match", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
    }
    
    // MARK: - Authenticate
    
    
    @IBAction func authenticateUser(sender: AnyObject) {
        
        //[self.passwordField resignFirstResponder];
        
        let context = LAContext()
        var error: NSError?
        let reasonString = "Authentication is needed to access your app! :)"
        
        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error)
        {
            context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: { (success, policyError) -> Void in
                
                if success
                {
                    //dispatch_async(dispatch_get_main_queue(), ^{
                    self.didAuthenticateWithTouchId()
                    print("Authentication successful! :) ")
                    //[self showMessage:@"Authentication is successful" withTitle:@"Success"];
                    // });
                } else {
                    switch policyError!.code {
                    case LAError.SystemCancel.rawValue:
                        print("Authentication was cancelled by the system.")
                    case LAError.UserCancel.rawValue:
                        print("Authentication was cancelled by the user.")
                        
                    case LAError.UserFallback.rawValue:
                        print("User selected to enter password.")
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            self.showPasswordAlert()
                        })
                    default:
                        print("Authentication failed! :(")
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            self.showPasswordAlert()
                        })
                    }
                }
                
            })
        } else {
            print(error?.localizedDescription)
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                self.showPasswordAlert()
            })
        }
        
    }
    
    func didAuthenticateWithTouchId() {
        
        defaults.setObject("Peter Balsamo", forKey: "usernameKey")
        defaults.setObject("3911", forKey: "passwordKey")
        defaults.setObject("eunitedws@verizon.net", forKey: "emailKey")
        defaults.setBool(true, forKey: "registerKey")
        //defaults.synchronize()
        
        self.performSegueWithIdentifier("loginSegue", sender: nil)
        
    }
    
    // MARK: Authenticate Password Alert
    
    func showPasswordAlert()
    {
        let alertController = UIAlertController(title: "Touch ID Password", message: "Please enter your password.", preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Cancel) { (action) -> Void in
            
            if let textField = alertController.textFields?.first as UITextField?
            {
                if textField.text == "veasoftware"
                {
                    print("Authentication successful! :) ")
                }
                else
                {
                    self.showPasswordAlert()
                }
            }
        }
        alertController.addAction(defaultAction)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            
            textField.placeholder = "Password"
            textField.secureTextEntry = true
            
        }
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
}
