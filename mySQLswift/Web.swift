//
//  Web.swift
//  mySQLswift
//
//  Created by Peter Balsamo on 12/9/15.
//  Copyright © 2015 Peter Balsamo. All rights reserved.
//

import UIKit
import SafariServices
import WebKit
let MessageHandler = "didGetPosts"
let PostSelected = "postSelected"

class Web: UIViewController, SFSafariViewControllerDelegate, WKNavigationDelegate, WKScriptMessageHandler {
    
    //let navColor = UIColor(red: 0.09, green: 0.62, blue: 0.93, alpha: 1.0)
    //let headColor = UIColor(red: 0.09, green: 0.62, blue: 0.93, alpha: 1.0)
    //let searchColor = UIColor(red: 0.09, green: 0.62, blue: 0.93, alpha: 1.0)
    //let labelColor = UIColor(red: 0.02, green: 0.36, blue: 0.53, alpha: 1.0)
    //let labelColor1 = UIColor(white:0.45, alpha:1.0)
    //let buttonColor = UIColor(red: 0.02, green: 0.36, blue: 0.53, alpha: 1.0)
    //let buttonColor1 = UIColor(white:0.45, alpha:1.0)
    
    var webView: WKWebView
    var url: NSURL?
    var postsWebView: WKWebView?
    var posts: [Post] = []
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    @IBOutlet weak var recentPostsButton: UIBarButtonItem!
    @IBOutlet weak var safari: UIBarButtonItem!
  
    required init?(coder aDecoder: NSCoder) {
        let config = WKWebViewConfiguration()
        let scriptURL = NSBundle.mainBundle().pathForResource("hideSections", ofType: "js")
        let scriptContent = try? String(contentsOfFile:scriptURL!, encoding:NSUTF8StringEncoding)
        let script = WKUserScript(source: scriptContent!, injectionTime: .AtDocumentStart, forMainFrameOnly: true)
        config.userContentController.addUserScript(script)
        self.webView = WKWebView(frame: CGRectZero, configuration: config)
        super.init(coder: aDecoder)
        self.webView.navigationDelegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnSwipe = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        let myActivity = NSUserActivity(activityType: "com.appcoda.searchAPIs.detail")
        myActivity.title = "Cupertino"
        myActivity.eligibleForSearch = true
        myActivity.keywords = Set(arrayLiteral: "Cupertino", "Silcon Valley", "California", "San Jose", "San Francisco", "Apple Inc", "Mothership")
        self.userActivity = myActivity
        myActivity.eligibleForHandoff = false
        myActivity.becomeCurrent() */
 //----------------------------------------------------------

        view.insertSubview(webView, belowSubview: progressView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        let height = NSLayoutConstraint(item: webView, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 1, constant: -44)
        let width = NSLayoutConstraint(item: webView, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0)
        view.addConstraints([height, width])
        
        webView.addObserver(self, forKeyPath: "loading", options: .New, context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
        //webView.addObserver(self, forKeyPath: "title", options: .New, context: nil) //stops web title in tab bar
        
        url = NSURL(string:"http://www.cnn.com")!
        let request = NSURLRequest(URL: url!);
        webView.loadRequest(request)
        
        backButton.enabled = false
        forwardButton.enabled = false
        recentPostsButton.enabled = false 
        
        let config = WKWebViewConfiguration()
        let scriptURL = NSBundle.mainBundle().pathForResource("getPosts", ofType: "js")
        let scriptContent = try? String(contentsOfFile:scriptURL!, encoding:NSUTF8StringEncoding)
        let script = WKUserScript(source: scriptContent!, injectionTime: .AtDocumentEnd, forMainFrameOnly: true)
        config.userContentController.addUserScript(script)
        config.userContentController.addScriptMessageHandler(self, name: MessageHandler)
        postsWebView = WKWebView(frame: CGRectZero, configuration: config)
        postsWebView!.loadRequest(NSURLRequest(URL:NSURL(string:"http://www.Drudgereport.com")!))
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "postSelected:", name: PostSelected, object: nil) 
}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonPressed(sender: UIBarButtonItem) {
        webView.goBack()
    }
    
    @IBAction func forwardButtonPressed(sender: UIBarButtonItem) {
        webView.goForward()
    }
    
    @IBAction func stopButtonPressed(sender: UIBarButtonItem) {
        webView.stopLoading()
    }
    
    @IBAction func refreshButtonPressed(sender: UIBarButtonItem) {
        let request = NSURLRequest(URL:webView.URL!)
        webView.loadRequest(request)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<()>) {
        if (keyPath == "loading") {
            backButton.enabled = webView.canGoBack
            forwardButton.enabled = webView.canGoForward
        }
        if (keyPath == "estimatedProgress") {
            progressView.hidden = webView.estimatedProgress == 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
        if (keyPath == "title") {
            title = webView.title
        }
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        progressView.setProgress(0.0, animated: false)
    }
    
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
   
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: ((WKNavigationActionPolicy) -> Void)) {
        if (navigationAction.navigationType == WKNavigationType.LinkActivated && !navigationAction.request.URL!.host!.lowercaseString.hasPrefix("www.Drudgereport.com")) {
            UIApplication.sharedApplication().openURL(navigationAction.request.URL!)
            decisionHandler(WKNavigationActionPolicy.Cancel)
        } else {
            decisionHandler(WKNavigationActionPolicy.Allow)
        }
    }
    
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        if (message.name == MessageHandler) {
            if let postsList = message.body as? [Dictionary<String, String>] {
                for ps in postsList {
                    let post = Post(dictionary: ps)
                    posts.append(post)
                }
                recentPostsButton.enabled = true
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "recentPosts") {
            let navigationController = segue.destinationViewController as! UINavigationController
            let postsViewController = navigationController.topViewController as! PostsTableViewController
            postsViewController.posts = posts
        }
    }
    
    func postSelected(notification:NSNotification) {
        webView.loadRequest(NSURLRequest())
        let post = notification.object as! Post
        webView.loadRequest(NSURLRequest(URL:NSURL(string:post.postURL)!))
    }
    
//---------------------------------------------------------------
    
    
    @IBAction func didPressButton(sender: AnyObject) {
        
        let safariVC = SFSafariViewController(URL:NSURL(string: "http://www.cnn.com")!, entersReaderIfAvailable: true) // Set to false if not interested in using reader
        safariVC.delegate = self
        self.presentViewController(safariVC, animated: true, completion: nil)
    } 
    
    
    @IBAction func WebTypeChanged(sender : UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
             url = NSURL(string:"http://www.cnn.com")!
             let request = NSURLRequest(URL: url!);
             webView.loadRequest(request)
        case 1:
             url = NSURL(string:"http://www.Drudgereport.com")!
             let request = NSURLRequest(URL: url!);
             webView.loadRequest(request)
        case 2:
             url = NSURL(string:"http://www.cnet.com")!
             let request = NSURLRequest(URL: url!);
             webView.loadRequest(request)
        case 3:
            url = NSURL(string:"http://lotpb.github.io/UnitedWebPage/index.html")!
            let request = NSURLRequest(URL: url!);
            webView.loadRequest(request)
        case 4:
            url = NSURL(string:"http://finance.yahoo.com/mb/UPL/")!
            let request = NSURLRequest(URL: url!);
            webView.loadRequest(request)
        case 5:
            url = NSURL(string:"http://stocktwits.com/The_Stock_Whisperer")!
            let request = NSURLRequest(URL: url!);
            webView.loadRequest(request)
        default:
            break;
        }
    }

    
    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
