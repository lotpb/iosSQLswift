//
//  LookupData.swift
//  mySQLswift
//
//  Created by Peter Balsamo on 1/10/16.
//  Copyright © 2016 Peter Balsamo. All rights reserved.
//

import UIKit
import Parse

protocol LookupDataDelegate: class {
    func cityFromController(passedData: NSString)
    func stateFromController(passedData: NSString)
    func zipFromController(passedData: NSString)
    func salesFromController(passedData: NSString)
    func salesNameFromController(passedData: NSString)
    func jobFromController(passedData: NSString)
    func jobNameFromController(passedData: NSString)
    func productFromController(passedData: NSString)
    func productNameFromController(passedData: NSString)
}

class LookupData: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    weak var delegate:LookupDataDelegate?
    
    @IBOutlet weak var tableView: UITableView?
 
    var zipArray : NSMutableArray = NSMutableArray()
    var salesArray : NSMutableArray = NSMutableArray()
    var jobArray : NSMutableArray = NSMutableArray()
    var adproductArray : NSMutableArray = NSMutableArray()
    var filteredString : NSMutableArray = NSMutableArray()
    
    var lookupItem : String?
    
    var refreshControl: UIRefreshControl!
    
    var isFilltered = false
    var searchController = UISearchController!()
    var resultsController: UITableViewController!
    //var foundUsers = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleButton: UIButton = UIButton(frame: CGRectMake(0, 0, 100, 32))
        titleButton.setTitle(String(format: "%@ %@", "Lookup", self.lookupItem!), forState: UIControlState.Normal)
        titleButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 25.0)
        titleButton.titleLabel?.textAlignment = NSTextAlignment.Center
        titleButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        titleButton.addTarget(self, action: Selector(), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.titleView = titleButton
        
        //self.tableView!.delegate = self
        //self.tableView!.dataSource = self
        self.tableView!.estimatedRowHeight = 44
        self.tableView!.rowHeight = UITableViewAutomaticDimension
        self.tableView!.backgroundColor = UIColor(white:0.90, alpha:1.0)
        self.automaticallyAdjustsScrollViewInsets = false
        
        searchController = UISearchController(searchResultsController: resultsController)
        searchController.searchBar.searchBarStyle = .Prominent
        searchController.searchResultsUpdater = self
        searchController.searchBar.showsBookmarkButton = false
        searchController.searchBar.showsCancelButton = true
        searchController.searchBar.placeholder = "Search here..."
        searchController.searchBar.sizeToFit()
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = true
        searchController.hidesNavigationBarDuringPresentation = false
        //tableView!.tableHeaderView = searchController.searchBar
        tableView!.tableFooterView = UIView(frame: CGRectZero)
        UISearchBar.appearance().barTintColor = UIColor(white:0.45, alpha:1.0)
        self.presentViewController(searchController, animated: true, completion: nil)
       
        //users = []
        //foundUsers = []
        resultsController = UITableViewController(style: .Plain)
        resultsController.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "UserFoundCell")
        resultsController.tableView.dataSource = self
        resultsController.tableView.delegate = self 
        
        parseData()
        
        self.refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.clearColor()
        refreshControl.tintColor = UIColor.blackColor()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refreshData:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView!.addSubview(refreshControl)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = UIColor(white:0.45, alpha:1.0)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Refresh
    
    func refreshData(sender:AnyObject) {
        parseData()
        self.refreshControl?.endRefreshing()
    }
    
    // MARK: - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.tableView {
            
            if (lookupItem == "City") {
                return zipArray.count
            } else if (lookupItem == "Salesman") {
                return salesArray.count
            } else if (lookupItem == "Job") {
                return jobArray.count
            } else if (lookupItem == "Product") || (lookupItem == "Advertiser") {
                return adproductArray.count
            }
        } else {
            //return foundUsers.count
            return filteredString.count
        }
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cellIdentifier: String!
        
        if tableView == self.tableView {
            cellIdentifier = "Cell"
        } else {
            cellIdentifier = "UserFoundCell"
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad {
            
            cell.textLabel!.font = UIFont (name: "HelveticaNeue", size: 20)
            
        } else {
            
            cell.textLabel!.font = UIFont (name: "HelveticaNeue", size: 20)
        }
        
        if (tableView == self.tableView) {
            
            if (lookupItem == "City") {
                cell.textLabel!.text = (zipArray[indexPath.row] .valueForKey("City") as? String)!
            } else if (lookupItem == "Salesman") {
                cell.textLabel!.text = (salesArray[indexPath.row] .valueForKey("Salesman") as? String)!
            } else if (lookupItem == "Job") {
                cell.textLabel!.text = (jobArray[indexPath.row] .valueForKey("Description") as? String)!
            } else if (lookupItem == "Product") {
                cell.textLabel!.text = (adproductArray[indexPath.row] .valueForKey("Products") as? String)!
            } else if (lookupItem == "Advertiser") {
                cell.textLabel!.text = (adproductArray[indexPath.row] .valueForKey("Advertiser") as? String)!
            }
            
        } else {
            
            if (lookupItem == "City") {
                //cell.textLabel!.text = foundUsers[indexPath.row]
                cell.textLabel!.text = (filteredString[indexPath.row] .valueForKey("City") as? String)!
            } else if (lookupItem == "Salesman") {
                cell.textLabel!.text = (filteredString[indexPath.row] .valueForKey("Salesman") as? String)!
            } else if (lookupItem == "Job") {
                cell.textLabel!.text = (filteredString[indexPath.row] .valueForKey("Description") as? String)!
            } else if (lookupItem == "Product") {
                cell.textLabel!.text = (filteredString[indexPath.row] .valueForKey("Products") as? String)!
            } else if (lookupItem == "Advertiser") {
                cell.textLabel!.text = (filteredString[indexPath.row] .valueForKey("Advertiser") as? String)!
            }
            
        }
        
        //cell.textLabel!.text = cityName

        return cell
    }
    
    // MARK: - Search
    
    func filterContentForSearchText(searchText: String) {
        
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        /*
        let searchString = searchController.searchBar.text
        
        // Filter the data array and get only those countries that match the search text.
        filteredString = zipArray.filter({ (str.objectForKey("City")) -> Bool in
            let countryText: NSString = country
            
            return (countryText.rangeOfString(searchString, options: NSStringCompareOptions.CaseInsensitiveSearch).location) != NSNotFound
        })
        self.resultsController.tableView.reloadData() */

    }
    
    // MARK: - Parse
    
    func parseData() {
        
        let query = PFQuery(className:"Zip")
        query.limit = 1000
        query.orderByAscending("City")
        query.cachePolicy = PFCachePolicy.CacheThenNetwork
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                let temp: NSArray = objects! as NSArray
                self.zipArray = temp.mutableCopy() as! NSMutableArray
                self.tableView!.reloadData()
            } else {
                print("Error")
            }
        }
        
        let query1 = PFQuery(className:"Salesman")
        query1.limit = 1000
        query1.orderByAscending("Salesman")
        query1.cachePolicy = PFCachePolicy.CacheThenNetwork
        query1.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                let temp: NSArray = objects! as NSArray
                self.salesArray = temp.mutableCopy() as! NSMutableArray
                self.tableView!.reloadData()
            } else {
                print("Error")
            }
        }
        
        let query2 = PFQuery(className:"Job")
        query2.limit = 1000
        query2.orderByAscending("Description")
        query2.cachePolicy = PFCachePolicy.CacheThenNetwork
        query2.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                let temp: NSArray = objects! as NSArray
                self.jobArray = temp.mutableCopy() as! NSMutableArray
                self.tableView!.reloadData()
            } else {
                print("Error")
            }
        }
        
        if (lookupItem == "Product") {
            
            let query3 = PFQuery(className:"Product")
            query3.limit = 1000
            query3.orderByDescending("Products")
            query3.cachePolicy = PFCachePolicy.CacheThenNetwork
            query3.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil {
                    let temp: NSArray = objects! as NSArray
                    self.adproductArray = temp.mutableCopy() as! NSMutableArray
                    self.tableView!.reloadData()
                } else {
                    print("Error")
                }
            }
            
        } else {
            let query4 = PFQuery(className:"Advertising")
            query4.limit = 1000
            query4.orderByDescending("Advertiser")
            query4.cachePolicy = PFCachePolicy.CacheThenNetwork
            query4.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil {
                    let temp: NSArray = objects! as NSArray
                    self.adproductArray = temp.mutableCopy() as! NSMutableArray
                    self.tableView!.reloadData()
                } else {
                    print("Error")
                }
            }
        }
        
    }
    
    // MARK: - Segues
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if (!isFilltered) {
            if (lookupItem == "City") {
                zipArray.objectAtIndex(indexPath.row)
            } else if (lookupItem == "Salesman") {
                salesArray.objectAtIndex(indexPath.row)
            } else if (lookupItem == "Job") {
                jobArray.objectAtIndex(indexPath.row)
            } else if (lookupItem == "Product") {
                adproductArray.objectAtIndex(indexPath.row)
            } else if (lookupItem == "Advertiser") {
                adproductArray.objectAtIndex(indexPath.row)
            }
        } else {
            filteredString.objectAtIndex(indexPath.row)
        }
        passDataBack()
    }
    
    func passDataBack() {
        
        let indexPath = self.tableView!.indexPathForSelectedRow!.row
        if (!isFilltered) {
            if (lookupItem == "City") {
                self.delegate? .cityFromController((zipArray.objectAtIndex(indexPath) .valueForKey("City") as? String)!)
                self.delegate? .stateFromController((zipArray[indexPath] .valueForKey("State") as? String)!)
                self.delegate? .zipFromController((zipArray[indexPath] .valueForKey("zipCode") as? String)!)
                
            } else if (lookupItem == "Salesman") {
                self.delegate? .salesFromController((salesArray.objectAtIndex(indexPath) .valueForKey("SalesNo") as? String)!)
                self.delegate? .salesNameFromController((salesArray[indexPath] .valueForKey("Salesman") as? String)!)
                
            } else if (lookupItem == "Job") {
                self.delegate? .jobFromController((jobArray[indexPath] .valueForKey("JobNo") as? String)!)
                self.delegate? .jobNameFromController((jobArray.objectAtIndex(indexPath) .valueForKey("Description") as? String)!)
                
            } else if (lookupItem == "Product") {
                self.delegate? .productFromController((adproductArray[indexPath] .valueForKey("ProductNo") as? String)!)
                self.delegate? .productNameFromController((adproductArray[indexPath] .valueForKey("Products") as? String)!)
            } else {
                self.delegate? .productFromController((adproductArray[indexPath] .valueForKey("AdNo") as? String)!)
                self.delegate? .productNameFromController((adproductArray[indexPath] .valueForKey("Advertiser") as? String)!)
            }
            
        } else {
            
            if (lookupItem == "City") {
                self.delegate? .cityFromController((filteredString.objectAtIndex(indexPath) .valueForKey("City") as? String)!)
                self.delegate? .stateFromController((filteredString[indexPath] .valueForKey("State") as? String)!)
                self.delegate? .zipFromController((filteredString[indexPath] .valueForKey("zipCode") as? String)!)
                
            } else if (lookupItem == "Salesman") {
                self.delegate? .salesFromController((filteredString.objectAtIndex(indexPath) .valueForKey("SalesNo") as? String)!)
                self.delegate? .salesNameFromController((filteredString[indexPath] .valueForKey("Salesman") as? String)!)
                
            } else if (lookupItem == "Job") {
                self.delegate? .jobFromController((filteredString[indexPath] .valueForKey("JobNo") as? String)!)
                self.delegate? .jobNameFromController((filteredString.objectAtIndex(indexPath) .valueForKey("Description") as? String)!)
                
            } else if (lookupItem == "Product") {
                self.delegate? .productFromController((filteredString[indexPath] .valueForKey("ProductNo") as? String)!)
                self.delegate? .productNameFromController((filteredString[indexPath] .valueForKey("Products") as? String)!)
            } else {
                self.delegate? .productFromController((filteredString[indexPath] .valueForKey("AdNo") as? String)!)
                self.delegate? .productNameFromController((filteredString[indexPath] .valueForKey("Advertiser") as? String)!)
            }
            
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
}
//-----------------------end------------------------------



