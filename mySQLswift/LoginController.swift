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
    
    let ipadtitle = UIFont.systemFontOfSize(20, weight: UIFontWeightRegular)
    let celltitle = UIFont.systemFontOfSize(18, weight: UIFontWeightRegular)
    
    let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    /*
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFontOfSize(20)
        label.textAlignment = .Center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }() */
    

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
    
    let fbButton = FBSDKLoginButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if ((defaults.stringForKey("registerKey") == nil)) {
            
            self.registerBtn!.setTitle("Sign in", forState: UIControlState.Normal)
            self.loginBtn!.hidden = true //hide login button no user is regsitered
            self.forgotPassword!.hidden = true
            self.authentButton!.hidden = true
            self.emailField!.hidden = false
            self.phoneField!.hidden = false//
            
        } else {
            //Keychain
            self.usernameField!.text = KeychainWrapper.stringForKey("usernameKey")
            self.passwordField!.text = KeychainWrapper.stringForKey("passwordKey")
            self.reEnterPasswordField!.hidden = true//
            self.registerBtn!.hidden = false //
            self.emailField!.hidden = true//
            self.phoneField!.hidden = true//
            self.forgotPassword!.hidden = false//
            self.backloginBtn!.hidden = true //
        }
        
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad {
            self.usernameField!.font = ipadtitle
            self.passwordField!.font = ipadtitle
            self.reEnterPasswordField!.font = ipadtitle
            self.emailField!.font = ipadtitle
            self.phoneField!.font = ipadtitle
        } else {
            self.usernameField!.font = celltitle
            self.passwordField!.font = celltitle
            self.reEnterPasswordField!.font = celltitle
            self.emailField!.font = celltitle
            self.phoneField!.font = celltitle
        }
        
        self.registerBtn!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.loginBtn!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.backloginBtn!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.emailField!.keyboardType = UIKeyboardType.EmailAddress
        self.phoneField!.keyboardType = UIKeyboardType.NumbersAndPunctuation
        
        if ((PFUser.currentUser()) != nil) {
            let user = PFUser.currentUser()!
            PFGeoPoint.geoPointForCurrentLocationInBackground {(geoPoint: PFGeoPoint?, error: NSError?) -> Void in
                user.setObject(geoPoint!, forKey: "currentLocation")
                user.saveInBackground()
                
                let theirLocation = CLLocationCoordinate2D(latitude: geoPoint!.latitude, longitude: geoPoint!.longitude)
                let span = MKCoordinateSpanMake(0.40, 0.40)
                let region = MKCoordinateRegionMake(theirLocation, span)
                self.mapView!.setRegion(region, animated: true)
                
                self.refreshMap()
            }
        }
        
        //Facebook
        
        fbButton.frame = CGRectMake(10, 490, 100, 25)
        fbButton.readPermissions = ["email"] //["public_profile", "email", "user_friends", "user_birthday", "user_location"]
        fbButton.delegate = self
        self.view.addSubview(fbButton)
        
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            fetchProfile()
        }
        

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = UIColor.redColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - LoginUser
    
    @IBAction func LoginUser(sender:AnyObject) {
        
        PFUser.logInWithUsernameInBackground(usernameField!.text!, password: passwordField!.text!) { user, error in
            if user != nil {
                
                self.performSegueWithIdentifier("loginSegue", sender: nil)
                self.defaults.setObject(self.usernameField!.text, forKey: "usernameKey")
                self.defaults.setObject(self.passwordField!.text, forKey: "passwordKey")
                if (self.emailField!.text != nil) {
                    self.defaults.setObject(self.emailField!.text, forKey: "emailKey")
                }
                self.defaults.setBool(true, forKey: "registerKey")

            } else {
                
                self.simpleAlert("Oooops", message: "Your username and password does not match")
                
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
        self.fbButton.hidden = false
        
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
            self.fbButton.hidden = true
            
        } else {
            //check if all text fields are completed
            if (self.usernameField!.text == "" || self.passwordField!.text == "" || self.reEnterPasswordField!.text == "") {
                
                self.simpleAlert("Oooops", message: "You must complete all fields")
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

                self.simpleAlert("Success", message: "You have registered a new user")
                
                self.usernameField!.text = nil
                self.passwordField!.text = nil
                self.emailField!.text = nil
                self.phoneField!.text = nil
                
                self.performSegueWithIdentifier("loginSegue", sender: nil)
                
            } else {
                print("Error: \(error) \(error!.userInfo)")
                
            }
        }
    }
    
    // MARK: - Facebook
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!)
    {
        if error == nil
        {
            self.performSegueWithIdentifier("loginSegue", sender: nil)
            print("Login complete.")
            
            defaults.setObject("Peter Balsamo", forKey: "usernameKey")
            defaults.setObject("3911", forKey: "passwordKey")
            defaults.setObject("eunitedws@verizon.net", forKey: "emailKey")
            defaults.setBool(true, forKey: "registerKey")
      
        } else {
            print(error.localizedDescription)
        }
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!)
    {
        print("User logged out...")
    }
    
    func fetchProfile() {
        
        let parameters = ["fields": "email, first_name, last_name, picture.type(large)"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).startWithCompletionHandler({ (connection, user, requestError) -> Void in
            
            if requestError != nil {
                print(requestError)
                return
            }
            
            let emailFB = user["email"] as? String
            let firstName = user["first_name"] as? String
            let lastName = user["last_name"] as? String
            
            self.usernameField!.text = "\(firstName!) \(lastName!)"
            self.emailField!.text = emailFB
            
            self.defaults.setObject(self.usernameField!.text, forKey: "usernameKey")
            self.defaults.setObject(self.emailField!.text, forKey: "emailKey")
            
            var pictureUrl = ""
            
            if let picture = user["picture"] as? NSDictionary, data = picture["data"] as? NSDictionary, url = data["url"] as? String {
                pictureUrl = url
            }
            
            let url = NSURL(string: pictureUrl)
            NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
                if error != nil {
                    print(error)
                    return
                }
                
                let image = UIImage(data: data!)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.userImageView.image = image
                })
                
            }).resume()
            
        })
        
        /*
        FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":"first_name, last_name, picture.type(large)"]).startWithCompletionHandler { (connection, result, error) -> Void in
        
        let strFirstName: String = (result.objectForKey("first_name") as? String)!
        let strLastName: String = (result.objectForKey("last_name") as? String)!
        
        let strPictureURL: String = (result.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String)!
        
        //self.lblName.text = "Welcome, \(strFirstName) \(strLastName)"
        self.lblName.text = "\(strFirstName) \(strLastName)"
        
        self.ivUserProfileImage.image = UIImage(data: NSData(contentsOfURL: NSURL(string: strPictureURL)!)!)
        
        defaults.setObject(self.lblName.text, forKey: "usernameKey")
        //defaults.setObject("eunitedws@verizon.net", forKey: "emailKey")
        
        } */
        
        
        
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
        
        let email = self.emailField!.text
        let finalEmail = email!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        PFUser.requestPasswordResetForEmailInBackground(finalEmail) { (success, error) -> Void in
            if success {
                self.simpleAlert("Alert", message: "Link to reset the password has been send to specified email")
                
            } else {
                
                self.simpleAlert("Alert", message: "Enter email in field: %@")
            }
            
        }
    }
    
    func checkPasswordsMatch() {
        
        if self.passwordField!.text == self.reEnterPasswordField!.text {
            
            registerNewUser()
        } else {
            
            self.simpleAlert("Oooops", message: "Your entered passwords do not match")
        }
        
    }
    
    // MARK: - Authenticate
    
    
    @IBAction func authenticateUser(sender: AnyObject) {
        
        //[self.passwordField resignFirstResponder]
        
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
                    //[self showMessage:@"Authentication is successful" withTitle:@"Success"]
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
        print("Login complete.")
        self.performSegueWithIdentifier("loginSegue", sender: nil)
    }
    
    // MARK: Authenticate Password Alert
    
    func showPasswordAlert() {
        
        let alertController = UIAlertController(title: "Touch ID Password", message: "Please enter your password.", preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Cancel) { (action) -> Void in
            
            if let textField = alertController.textFields?.first as UITextField?
            {
                if textField.text == "Peter Balsamo"
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
    
    
    // MARK: - AlertController
    
    func simpleAlert (title:String, message:String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: Map
    
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
    
}

