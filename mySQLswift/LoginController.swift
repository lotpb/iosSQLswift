//
//  LoginController.swift
//  mySQLswift
//
//  Created by Peter Balsamo on 12/13/15.
//  Copyright © 2015 Peter Balsamo. All rights reserved.
//

import UIKit
import Parse
import FBSDKLoginKit
import MapKit
import LocalAuthentication


class LoginController: UIViewController, FBSDKLoginButtonDelegate {
    
    let ipadtitle = UIFont.systemFontOfSize(20, weight: UIFontWeightRegular)
    let celltitle = UIFont.systemFontOfSize(18, weight: UIFontWeightRegular)
    
    @IBOutlet weak var mapView: MKMapView?
    @IBOutlet weak var mainView: UIView!
    
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
    
    //Facebook
    var fbButton : FBSDKLoginButton = FBSDKLoginButton()
    var dict : NSDictionary!
    
    let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        return imageView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if ((defaults.stringForKey("registerKey") == nil)) {
            
            self.registerBtn!.setTitle("Sign in", forState: UIControlState.Normal)
            self.loginBtn!.hidden = true //hide login button no user is regsitered
            self.forgotPassword!.hidden = true
            self.authentButton!.hidden = true
            self.emailField!.hidden = false
            self.phoneField!.hidden = false
            
        } else {
            //Keychain
            self.usernameField!.text = KeychainWrapper.stringForKey("usernameKey")
            self.passwordField!.text = KeychainWrapper.stringForKey("passwordKey")
            self.reEnterPasswordField!.hidden = true
            self.registerBtn!.hidden = false
            self.emailField!.hidden = true
            self.phoneField!.hidden = true
            self.forgotPassword!.hidden = false
            self.backloginBtn!.hidden = true
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
        
        self.passwordField!.text = ""
        
        //Facebook
        fbButton.frame = CGRectMake(10, 490, 125, 40)
        
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            print("User is already logged in")
        } else {
            fbButton.readPermissions = ["public_profile", "email", "user_friends","user_birthday"]
        }
        fbButton.delegate = self
        self.mainView.addSubview(fbButton)
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()

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
                
                self.refreshLocation()
                
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
                
                self.refreshLocation()
                self.usernameField!.text = nil
                self.passwordField!.text = nil
                self.emailField!.text = nil
                self.phoneField!.text = nil
                self.simpleAlert("Success", message: "You have registered a new user")
                
            } else {
                print("Error: \(error) \(error!.userInfo)")
            }
        }
    }
    
    
    // MARK: - Facebook

    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if ((error) != nil) {
            print(error.localizedDescription)
            return
        } else {
            fetchProfileFB()
            redirectToHome()
        }
    }
    
    
    func fetchProfileFB() {
        
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "email, name, first_name, last_name, picture.type(large)"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil) {
                print("Error: \(error)")
                
            } else {
                
                let firstName = result.valueForKey("first_name") as? String
                let lastName = result.valueForKey("last_name") as? String
                
                self.usernameField!.text = "\(firstName!) \(lastName!)"
                self.emailField!.text = result.valueForKey("email") as? String
                self.passwordField!.text = "3911" //result.valueForKey("id") as? String
                
                let strPictureURL: String = (result.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String)!
                
                let image = UIImage(data: NSData(contentsOfURL: NSURL(string: strPictureURL)!)!)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.userImageView.image = image
                })
            }
        })
    }
    
    
    func redirectToHome() {
        
        let storyboard:UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
        
        let initialViewController: UIViewController = storyboard.instantiateViewControllerWithIdentifier("MasterViewController") as UIViewController
        
        self.presentViewController(initialViewController, animated: true, completion: nil)
    }
    

    /*
    func showFriendFB() {
        let parameters = ["fields": "name,picture.type(normal),gender"]
        FBSDKGraphRequest(graphPath: "me/taggable_friends", parameters: parameters).startWithCompletionHandler({ (connection, user, requestError) -> Void in
            if requestError != nil {
                print(requestError)
                return
            }
            
            var friends = [Friend]()
            for friendDictionary in user["data"] as! [NSDictionary] {
                let name = friendDictionary["name"] as? String
                if let picture = friendDictionary["picture"]?["data"]?!["url"] as? String {
                    let friend = Friend(name: name, picture: picture)
                    friends.append(friend)
                }
            }
            
            let friendsController = FriendsController(collectionViewLayout: UICollectionViewFlowLayout())
            friendsController.friends = friends
            self.navigationController?.pushViewController(friendsController, animated: true)
            self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        })
    } */
    
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
        print("loginButtonDidLogOut")
        //let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        //loginManager.logOut()
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
        
        let context = LAContext()
        var error: NSError?
        let reasonString = "Authentication is needed to access your app! :)"
        
        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error)
        {
            context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: { (success, policyError) -> Void in
                
                if success {
                    
                    print("Authentication successful! :) ")
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        self.didAuthenticateWithTouchId()
                    })
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
                        let alert : UIAlertController = UIAlertController(title: "touch id failed", message: "Try again", preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
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
        
        self.usernameField!.text = "Peter Balsamo"
        self.passwordField!.text = "3911"
        self.emailField!.text = "eunitedws@verizon.net"
        self.phoneField!.text = "(516)241-4786"

        PFUser.logInWithUsernameInBackground(usernameField!.text!, password: passwordField!.text!) { user, error in
            if user != nil {
                
                self.refreshLocation()
            }
        }
    }
    
    // MARK: Authenticate Password Alert
    
    func showPasswordAlert() {
        
        let alertController = UIAlertController(title: "Touch ID Password", message: "Please enter your password.", preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Cancel) { (action) -> Void in
            
            if let textField = alertController.textFields?.first as UITextField?
            {
                if textField.text == self.defaults.stringForKey("usernameKey")! //"Peter Balsamo"
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
    
    
    // MARK: Map
    
    func refreshLocation() {
        
        PFGeoPoint.geoPointForCurrentLocationInBackground {
            (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
            if error == nil {
                PFUser.currentUser()!.setValue(geoPoint, forKey: "currentLocation")
                PFUser.currentUser()!.saveInBackground()
                self.performSegueWithIdentifier("loginSegue", sender: nil)
            }
        }
        self.defaults.setObject(self.usernameField!.text, forKey: "usernameKey")
        self.defaults.setObject(self.passwordField!.text, forKey: "passwordKey")
        self.defaults.setObject(self.phoneField!.text, forKey: "phone")
        
        if (self.emailField!.text != nil) {
            self.defaults.setObject(self.emailField!.text, forKey: "emailKey")
        }
        self.defaults.setBool(true, forKey: "registerKey")
    }
    
    
}

