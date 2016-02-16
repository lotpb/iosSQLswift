//
//  StatisticController.swift
//  mySQLswift
//
//  Created by Peter Balsamo on 1/10/16.
//  Copyright © 2016 Peter Balsamo. All rights reserved.
//

import UIKit
import Parse

class StatisticController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var scrollWall: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    var photoImage: UIImageView!
    var label1 : UILabel!
    var label2 : UILabel!
    var myLabel2 : UILabel!
    var segmentedControl : UISegmentedControl!
    
    var _feedItems : NSMutableArray = NSMutableArray()
    var _feedheadItems : NSMutableArray = NSMutableArray()
    var filteredString : NSMutableArray = NSMutableArray()
    
    var _statHeaderItems : NSMutableArray = NSMutableArray()
    var _feedCustItems : NSMutableArray = NSMutableArray()
    var _feedLeadItems : NSMutableArray = NSMutableArray()
    
    var _feedLeadsToday : NSMutableArray = NSMutableArray()
    var _feedAppToday : NSMutableArray = NSMutableArray()
    var _feedAppTomorrow : NSMutableArray = NSMutableArray()
    var _feedLeadActive : NSMutableArray = NSMutableArray()
    var _feedLeadYear : NSMutableArray = NSMutableArray()
    
    var _feedCustToday : NSMutableArray = NSMutableArray()
    var _feedCustYesterday : NSMutableArray = NSMutableArray()
    var _feedCustActive : NSMutableArray = NSMutableArray()
    var _feedWinSold : NSMutableArray = NSMutableArray()
    var _feedCustYear : NSMutableArray = NSMutableArray()
    var _feedTESTItems : NSMutableArray = NSMutableArray()
    
    var symYQL : NSMutableArray = NSMutableArray()
    var fieldYQL : NSMutableArray = NSMutableArray()
    var changeYQL : NSMutableArray = NSMutableArray()
    var dayYQL : NSMutableArray = NSMutableArray()
    var textYQL : NSMutableArray = NSMutableArray()
    var humidityYQL : NSMutableArray = NSMutableArray()

    var dict = NSDictionary()
    var w1results = NSDictionary()
    var resultsYQL = NSDictionary()
    var amount = String()
    var refreshControl: UIRefreshControl!
    var myTimer: NSTimer!
    
    var searchController: UISearchController!
    var resultsController: UITableViewController!
    var foundUsers = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleButton: UIButton = UIButton(frame: CGRectMake(0, 0, 100, 32))
        titleButton.setTitle("myStats", forState: UIControlState.Normal)
        titleButton.titleLabel?.font = Font.navlabel
        titleButton.titleLabel?.textAlignment = NSTextAlignment.Center
        titleButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        titleButton.addTarget(self, action: Selector(), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.titleView = titleButton
        
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        //self.tableView!.rowHeight = 65
        self.tableView!.estimatedRowHeight = 110
        self.tableView!.rowHeight = UITableViewAutomaticDimension
        self.tableView!.backgroundColor = UIColor(white:0.90, alpha:1.0)
        self.automaticallyAdjustsScrollViewInsets = false
        
        foundUsers = []
        resultsController = UITableViewController(style: .Plain)
        resultsController.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "UserFoundCell")
        resultsController.tableView.dataSource = self
        resultsController.tableView.delegate = self
        
        let searchButton = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: "updateData")
        let buttons:NSArray = [searchButton]
        self.navigationItem.rightBarButtonItems = buttons as? [UIBarButtonItem]
        
        self.refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.blackColor()
        refreshControl.tintColor = UIColor.whiteColor()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refreshData:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView!.addSubview(refreshControl)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //navigationController?.hidesBarsOnSwipe = true
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = UIColor.brownColor()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //navigationController?.hidesBarsOnSwipe = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Refresh
    
    func refreshData(sender:AnyObject) {
        self.tableView!.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    // MARK: - Button
    
    func newData() {
        self.performSegueWithIdentifier("newleadSegue", sender: self)
    }
    
    // MARK: - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (section == 0) {
            return 10
        } else if (section == 1) {
            return 6
        } else if (section == 2) {
            return 6
        } else if (section == 3) {
            return 8
        } else if (section == 4) {
            return 8
        } else {
            if (section == 3) {
                return _feedLeadItems.count
            } else if (section == 4) {
                return _feedCustItems.count
            }
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let CellIdentifier: String = "Cell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier)! as UITableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.accessoryType = UITableViewCellAccessoryType.None
        
        label1 = UILabel(frame: CGRectMake(tableView.frame.size.width-155, 8, 77, 17))
        //label1.backgroundColor = UIColor.whiteColor()
        label1.textColor = UIColor.blackColor()
        label1.textAlignment = NSTextAlignment.Right
        
        label2 = UILabel(frame: CGRectMake(tableView.frame.size.width-70, 8, 55, 17))
        //label2.backgroundColor = UIColor.whiteColor()
        label2.textColor = UIColor.blackColor()
        label2.textAlignment = NSTextAlignment.Right
        
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad {
            
            label1.font = Font.headtitle
            label2.font = Font.headtitle
        } else {
            
            label1.font = Font.headtitle
            label2.font = Font.headtitle
        }
        
        if (indexPath.section == 0) {
            
            if (indexPath.row == 0) {
                /*
                if ((changeYQL.objectAtIndex(0) containsString("-")) || (changeYQL.objectAtIndex(0) == nil )) {
                    label2.backgroundColor = UIColor.redColor()
                } else {
                    label2.backgroundColor = UIColor.greenColor()
                }
                
                cell.textLabel!.text = symYQL.objectAtIndex(0)
                label2.text = changeYQL.objectAtIndex(0)
                label1.text = fieldYQL.objectAtIndex(0) */
                cell.contentView.addSubview(label1)
                cell.contentView.addSubview(label2)
                
                return cell
                
            } else if (indexPath.row == 1) {
                /*
                if ((changeYQL.objectAtIndex(0) containsString("-")) || (changeYQL.objectAtIndex(0) == nil )) {
                label2.backgroundColor = UIColor.redColor()
                } else {
                label2.backgroundColor = UIColor.greenColor()
                }
                
                cell.textLabel!.text = symYQL.objectAtIndex(0)
                label2.text = changeYQL.objectAtIndex(0)
                label1.text = fieldYQL.objectAtIndex(0) */
                cell.contentView.addSubview(label1)
                cell.contentView.addSubview(label2)
                
                
                return cell
                
            } else if (indexPath.row == 2) {
                /*
                if ((changeYQL.objectAtIndex(0) containsString("-")) || (changeYQL.objectAtIndex(0) == nil )) {
                label2.backgroundColor = UIColor.redColor()
                } else {
                label2.backgroundColor = UIColor.greenColor()
                }
                
                cell.textLabel!.text = symYQL.objectAtIndex(0)
                label2.text = changeYQL.objectAtIndex(0)
                label1.text = fieldYQL.objectAtIndex(0) */
                cell.contentView.addSubview(label1)
                cell.contentView.addSubview(label2)
                
                
                return cell
                
            } else if (indexPath.row == 3) {
                /*
                if ((changeYQL.objectAtIndex(0) containsString("-")) || (changeYQL.objectAtIndex(0) == nil )) {
                label2.backgroundColor = UIColor.redColor()
                } else {
                label2.backgroundColor = UIColor.greenColor()
                }
                
                cell.textLabel!.text = symYQL.objectAtIndex(0)
                label2.text = changeYQL.objectAtIndex(0)
                label1.text = fieldYQL.objectAtIndex(0) */
                cell.contentView.addSubview(label1)
                cell.contentView.addSubview(label2)
                
                
                return cell
            } else if (indexPath.row == 4) {
                /*
                if ((changeYQL.objectAtIndex(0) containsString("-")) || (changeYQL.objectAtIndex(0) == nil )) {
                label2.backgroundColor = UIColor.redColor()
                } else {
                label2.backgroundColor = UIColor.greenColor()
                }
                
                cell.textLabel!.text = symYQL.objectAtIndex(0)
                label2.text = changeYQL.objectAtIndex(0)
                label1.text = fieldYQL.objectAtIndex(0) */
                cell.contentView.addSubview(label1)
                cell.contentView.addSubview(label2)
                
                
                return cell
            } else if (indexPath.row == 5) {
                /*
                if ((changeYQL.objectAtIndex(0) containsString("-")) || (changeYQL.objectAtIndex(0) == nil )) {
                label2.backgroundColor = UIColor.redColor()
                } else {
                label2.backgroundColor = UIColor.greenColor()
                }
                
                cell.textLabel!.text = symYQL.objectAtIndex(0)
                label2.text = changeYQL.objectAtIndex(0)
                label1.text = fieldYQL.objectAtIndex(0) */
                cell.contentView.addSubview(label1)
                cell.contentView.addSubview(label2)
                
                
                return cell
            } else if (indexPath.row == 6) {
                /*
                if ((changeYQL.objectAtIndex(0) containsString("-")) || (changeYQL.objectAtIndex(0) == nil )) {
                label2.backgroundColor = UIColor.redColor()
                } else {
                label2.backgroundColor = UIColor.greenColor()
                }
                
                cell.textLabel!.text = symYQL.objectAtIndex(0)
                label2.text = changeYQL.objectAtIndex(0)
                label1.text = fieldYQL.objectAtIndex(0) */
                cell.contentView.addSubview(label1)
                cell.contentView.addSubview(label2)
                
                
                return cell
            } else if (indexPath.row == 7) {
                /*
                if ((changeYQL.objectAtIndex(0) containsString("-")) || (changeYQL.objectAtIndex(0) == nil )) {
                label2.backgroundColor = UIColor.redColor()
                } else {
                label2.backgroundColor = UIColor.greenColor()
                }
                
                cell.textLabel!.text = symYQL.objectAtIndex(0)
                label2.text = changeYQL.objectAtIndex(0)
                label1.text = fieldYQL.objectAtIndex(0) */
                cell.contentView.addSubview(label1)
                cell.contentView.addSubview(label2)
                
                
                return cell
            } else if (indexPath.row == 8) {
                /*
                if ((changeYQL.objectAtIndex(0) containsString("-")) || (changeYQL.objectAtIndex(0) == nil )) {
                label2.backgroundColor = UIColor.redColor()
                } else {
                label2.backgroundColor = UIColor.greenColor()
                }
                
                cell.textLabel!.text = symYQL.objectAtIndex(0)
                label2.text = changeYQL.objectAtIndex(0)
                label1.text = fieldYQL.objectAtIndex(0) */
                cell.contentView.addSubview(label1)
                cell.contentView.addSubview(label2)
                
                
                return cell
            } else if (indexPath.row == 9) {
                /*
                if ((changeYQL.objectAtIndex(0) containsString("-")) || (changeYQL.objectAtIndex(0) == nil )) {
                label2.backgroundColor = UIColor.redColor()
                } else {
                label2.backgroundColor = UIColor.greenColor()
                }
                
                cell.textLabel!.text = symYQL.objectAtIndex(0)
                label2.text = changeYQL.objectAtIndex(0)
                label1.text = fieldYQL.objectAtIndex(0) */
                cell.contentView.addSubview(label1)
                cell.contentView.addSubview(label2)
                
                
                return cell
            }
        } else if (indexPath.section == 1) {
            
            if (indexPath.row == 0) {
                
                cell.textLabel!.text = "Todays Temperature"
              //cell.detailTextLabel!.text = w1results valueForKeyPath:"query.results.channel.item.condition"] objectForKey:"temp"
                
                return cell
                
            } else if (indexPath.row == 1) {
                
                cell.textLabel!.text = "Todays Weather"
                //cell.detailTextLabel!.text = w1results valueForKeyPath:"query.results.channel.item.condition"] objectForKey:"temp"
                
                return cell
                
            } else if (indexPath.row == 2) {
                
                cell.textLabel!.text = "Sunrise"
                //cell.detailTextLabel!.text = w1results valueForKeyPath:"query.results.channel.item.condition"] objectForKey:"temp"
                
                return cell
                
            } else if (indexPath.row == 3) {
                
                cell.textLabel!.text = "Sunset"
                //cell.detailTextLabel!.text = w1results valueForKeyPath:"query.results.channel.item.condition"] objectForKey:"temp"
                
                return cell
            } else if (indexPath.row == 4) {
                
                cell.textLabel!.text = "Humidity"
                //cell.detailTextLabel!.text = w1results valueForKeyPath:"query.results.channel.item.condition"] objectForKey:"temp"
                
                return cell
            } else if (indexPath.row == 5) {
                
                cell.textLabel!.text = "City"
                //cell.detailTextLabel!.text = w1results valueForKeyPath:"query.results.channel.item.condition"] objectForKey:"temp"
                
                return cell
            }
            
        } else if (indexPath.section == 2) {
            
            if (indexPath.row == 0) {
                
              //cell.textLabel!.text = dayYQL.objectAtIndex(0)
              //cell.detailTextLabel!.text = w1results valueForKeyPath:"query.results.channel.item.condition"] objectForKey:"temp"
                
                return cell
                
            } else if (indexPath.row == 1) {
                
                //cell.textLabel!.text = dayYQL.objectAtIndex(0)
                //cell.detailTextLabel!.text = w1results valueForKeyPath:"query.results.channel.item.condition"] objectForKey:"temp"
                
                return cell
                
            } else if (indexPath.row == 2) {
                
                //cell.textLabel!.text = dayYQL.objectAtIndex(0)
                //cell.detailTextLabel!.text = w1results valueForKeyPath:"query.results.channel.item.condition"] objectForKey:"temp"
                
                return cell
                
            } else if (indexPath.row == 3) {
                
                //cell.textLabel!.text = dayYQL.objectAtIndex(0)
                //cell.detailTextLabel!.text = w1results valueForKeyPath:"query.results.channel.item.condition"] objectForKey:"temp"
                
                return cell
            } else if (indexPath.row == 4) {
                
                //cell.textLabel!.text = dayYQL.objectAtIndex(0)
                //cell.detailTextLabel!.text = w1results valueForKeyPath:"query.results.channel.item.condition"] objectForKey:"temp"
                
                return cell
            } else if (indexPath.row == 5) {
                
                cell.textLabel!.text = "Last Update"
                //cell.detailTextLabel!.text = w1results valueForKeyPath:"query.results.channel.item.condition"] objectForKey:"temp"
                
                return cell
            }
            
            
        } else if (indexPath.section == 3) {
            
            if (indexPath.row == 0) {
                
                cell.textLabel!.text = "Leads Today"
                //cell.detailTextLabel!.text = w1results valueForKeyPath:"query.results.channel.item.condition"] objectForKey:"temp"
                
                return cell
                
            } else if (indexPath.row == 1) {
                
                cell.textLabel!.text = "Appointment's Today"
                //cell.detailTextLabel!.text = w1results valueForKeyPath:"query.results.channel.item.condition"] objectForKey:"temp"
                
                return cell
                
            } else if (indexPath.row == 2) {
                
                cell.textLabel!.text = "Appointment's Tomorrow"
                //cell.detailTextLabel!.text = w1results valueForKeyPath:"query.results.channel.item.condition"] objectForKey:"temp"
                
                return cell
                
            } else if (indexPath.row == 3) {
                
                cell.textLabel!.text = "Leads Active"
                //cell.detailTextLabel!.text = w1results valueForKeyPath:"query.results.channel.item.condition"] objectForKey:"temp"
                
                return cell
            } else if (indexPath.row == 4) {
                
                cell.textLabel!.text = "Leads Year"
                //cell.detailTextLabel!.text = w1results valueForKeyPath:"query.results.channel.item.condition"] objectForKey:"temp"
                
                return cell
            } else if (indexPath.row == 5) {
                
                cell.textLabel!.text = "Leads Avg"
                //cell.detailTextLabel!.text = w1results valueForKeyPath:"query.results.channel.item.condition"] objectForKey:"temp"
                
                return cell
            } else if (indexPath.row == 6) {
                
                cell.textLabel!.text = "Leads High"
                //cell.detailTextLabel!.text = w1results valueForKeyPath:"query.results.channel.item.condition"] objectForKey:"temp"
                
                return cell
            } else if (indexPath.row == 7) {
                
                cell.textLabel!.text = "Leads Low"
                //cell.detailTextLabel!.text = w1results valueForKeyPath:"query.results.channel.item.condition"] objectForKey:"temp"
                
                return cell
            }
            
        } else if (indexPath.section == 4) {
            
            if (indexPath.row == 0) {
                
                cell.textLabel!.text = "Customers Today"
                //cell.detailTextLabel!.text = w1results valueForKeyPath:"query.results.channel.item.condition"] objectForKey:"temp"
                
                return cell
                
            } else if (indexPath.row == 1) {
                
                cell.textLabel!.text = "Customers Yesterday"
                //cell.detailTextLabel!.text = w1results valueForKeyPath:"query.results.channel.item.condition"] objectForKey:"temp"
                
                return cell
                
            } else if (indexPath.row == 2) {
                
                cell.textLabel!.text = "Windows Sold"
                //cell.detailTextLabel!.text = w1results valueForKeyPath:"query.results.channel.item.condition"] objectForKey:"temp"
                
                return cell
                
            } else if (indexPath.row == 3) {
                
                cell.textLabel!.text = "Customers Active"
                //cell.detailTextLabel!.text = w1results valueForKeyPath:"query.results.channel.item.condition"] objectForKey:"temp"
                
                return cell
            } else if (indexPath.row == 4) {
                
                cell.textLabel!.text = "Customers Year"
                //cell.detailTextLabel!.text = w1results valueForKeyPath:"query.results.channel.item.condition"] objectForKey:"temp"
                
                return cell
            } else if (indexPath.row == 5) {
                
                cell.textLabel!.text = "Customers Avg"
                //cell.detailTextLabel!.text = w1results valueForKeyPath:"query.results.channel.item.condition"] objectForKey:"temp"
                
                return cell
            } else if (indexPath.row == 6) {
                
                cell.textLabel!.text = "Customers High"
                //cell.detailTextLabel!.text = w1results valueForKeyPath:"query.results.channel.item.condition"] objectForKey:"temp"
                
                return cell
            } else if (indexPath.row == 7) {
                
                cell.textLabel!.text = "Customers Low"
                //cell.detailTextLabel!.text = w1results valueForKeyPath:"query.results.channel.item.condition"] objectForKey:"temp"
                
                return cell
            }
        }
        return cell
    }
    
     func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if (section == 0) {
            return 175
        } else if (section == 1) {
            return 5
        } else if (section == 2) {
            return 5
        } else if (section == 3) {
            return 5
        } else if (section == 4) {
            return 5
        }
        return 0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if (section == 0) {
            let vw = UIView()
            //vw.frame = CGRectMake(0 , 0, tableView.frame.width, 175)
            vw.backgroundColor = UIColor.brownColor()
            //tableView.tableHeaderView = vw
            /*
            photoImage = UIImageView(frame:CGRectMake(0, 0, vw.frame.size.width, 175))
            photoImage!.image = UIImage(named:"IMG_1133New.jpg")
            photoImage!.clipsToBounds = true
            photoImage!.contentMode = UIViewContentMode.ScaleAspectFill
            vw.addSubview(photoImage!)
            
            let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
            visualEffectView.frame = photoImage.bounds
            photoImage.addSubview(visualEffectView) */
            
            segmentedControl = UISegmentedControl (items: ["WEEKLY", "MONTHLY", "YEARLY"])
            segmentedControl.frame = CGRectMake(tableView.frame.size.width/2-125, 45, 250, 30)
            segmentedControl.backgroundColor = UIColor.brownColor()
            segmentedControl.tintColor = UIColor.whiteColor()
            segmentedControl.selectedSegmentIndex = 1
            segmentedControl.addTarget(self, action: "segmentedControlAction", forControlEvents: .ValueChanged)
            vw.addSubview(segmentedControl)
            
            let myLabel1:UILabel = UILabel(frame: CGRectMake(tableView.frame.size.width/2-45, 3, 90, 45))
            myLabel1.textColor = UIColor.whiteColor()
            myLabel1.textAlignment = NSTextAlignment.Center
            myLabel1.text = "Statistics"
            myLabel1.font = UIFont (name: "Avenir-Book", size: 21)
            vw.addSubview(myLabel1)
            
            myLabel2 = UILabel(frame: CGRectMake(tableView.frame.size.width/2-25, 75, 50, 45))
            myLabel2.textColor = UIColor.greenColor()
            myLabel2.textAlignment = NSTextAlignment.Center
            myLabel2.text = "SALES"
            myLabel2.font = UIFont (name: "Avenir-Black", size: 16)
            vw.addSubview(myLabel2)
            
            let separatorLineView1 = UIView(frame: CGRectMake(tableView.frame.size.width/2-30, 110, 60, 1.9))
            separatorLineView1.backgroundColor = UIColor.whiteColor()
            vw.addSubview(separatorLineView1)
            
            let myLabel3:UILabel = UILabel(frame: CGRectMake(tableView.frame.size.width/2-70, 115, 140, 45))
            myLabel3.textColor = UIColor.whiteColor()
            myLabel3.textAlignment = NSTextAlignment.Center
            myLabel3.text = "$200,000"
            myLabel3.font = UIFont (name: "Avenir-Black", size: 30)
            vw.addSubview(myLabel3)
            
            return vw
        }
        return nil
    }
    
    // MARK: - SegmentedControl
    
    func segmentedControlAction(sender: UISegmentedControl) {
        
        if(segmentedControl.selectedSegmentIndex == 0)
        {
            myLabel2.text = "$100,000"
        }
        else if(segmentedControl.selectedSegmentIndex == 1)
        {
            myLabel2.text = "$200,000"
        }
        else if(segmentedControl.selectedSegmentIndex == 2)
        {
            myLabel2.text = "$300,000"
        }
    }
    
    // MARK: - Search
    
    func searchButton(sender: AnyObject) {
        
        searchController = UISearchController(searchResultsController: resultsController)
        searchController.searchBar.searchBarStyle = .Prominent
        searchController.searchResultsUpdater = self
        searchController.searchBar.showsBookmarkButton = false
        searchController.searchBar.showsCancelButton = true
        searchController.searchBar.placeholder = "Search here..."
        searchController.searchBar.sizeToFit()
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = true
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.scopeButtonTitles = ["name", "city", "phone", "date", "active"]
        //tableView!.tableHeaderView = searchController.searchBar
        tableView.tableFooterView = UIView(frame: .zero)
        UISearchBar.appearance().barTintColor = UIColor.brownColor()
        
        self.presentViewController(searchController, animated: true, completion: nil)
    }
    
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        /*
        self.foundUsers.removeAll(keepCapacity: false)
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (self._feedItems as NSArray).filteredArrayUsingPredicate(searchPredicate)
        self.foundUsers = array as! [String]
        self.resultsController.tableView.reloadData() */
    }

    
}
