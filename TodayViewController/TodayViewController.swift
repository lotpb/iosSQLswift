//
//  TodayViewController.swift
//  TodayViewController
//
//  Created by Peter Balsamo on 2/19/16.
//  Copyright © 2016 Peter Balsamo. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreLocation

class TodayViewController: UIViewController, NCWidgetProviding, CLLocationManagerDelegate {
    
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    
    var locationManager: CLLocationManager = CLLocationManager()
    var currentLocation: CLLocation?

        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        latitudeLabel.text = "searching..."
        longitudeLabel.text = "searching..."
    }
    
    override func viewWillAppear(animated: Bool) {
        performWidgetUpdate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        currentLocation = locations[locations.count - 1]
    }
    
    func performWidgetUpdate()
    {
        if currentLocation != nil {
            let latitudeText = String(format: "Lat: %.4f",
                currentLocation!.coordinate.latitude)
            
            let longitudeText = String(format: "Lon: %.4f",
                currentLocation!.coordinate.longitude)
            
            self.latitudeLabel.text = latitudeText
            self.longitudeLabel.text = longitudeText
        }
    }

    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        
        performWidgetUpdate()
        completionHandler(NCUpdateResult.NewData)
    }
    
    @IBAction func openApp(sender: AnyObject) {
        
        let myAppUrl = NSURL(string: "TheLight://")!
        extensionContext?.openURL(myAppUrl, completionHandler: { (success) in
            if (!success) {
                // let the user know it failed
            }
        })
    }
    
    func widgetMarginInsetsForProposedMarginInsets
        (defaultMarginInsets: UIEdgeInsets) -> (UIEdgeInsets) {
            return UIEdgeInsetsZero
    }
    
}
