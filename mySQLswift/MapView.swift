//
//  MapView.swift
//  mySQLswift
//
//  Created by Peter Balsamo on 1/7/16.
//  Copyright © 2016 Peter Balsamo. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapView: UIViewController, MKMapViewDelegate,  CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var travelTime: UILabel!
    @IBOutlet weak var travelDistance: UILabel!
    @IBOutlet weak var steps: UITextView!
    @IBOutlet weak var clearRoute: UIButton!
    @IBOutlet weak var routView: UIView!
    @IBOutlet weak var mapTypeSegmentedControl: UISegmentedControl!
    
    var mapaddress : NSString?
    var mapcity : NSString?
    var mapstate : NSString?
    var mapzip : NSString?
    
    var route: MKRoute!
    var allSteps : NSString?
    
    var locationManager: CLLocationManager!
    var annotationPoint: MKPointAnnotation!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.allSteps = ""
        self.travelTime.text = ""
        self.travelDistance.text = ""
        //self.travelTime.sizeToFit()
        //self.travelDistance.sizeToFit()
        
        self.travelTime.font = UIFont (name: "HelveticaNeue-Medium", size: 18)
        self.travelDistance.font = UIFont (name: "HelveticaNeue-Medium", size: 18)
        self.steps.font = UIFont (name: "HelveticaNeue-light", size: 18)
        
        self.travelTime.textColor = UIColor(red:0.0, green:122.0/255.0, blue:1.0, alpha: 1.0)
        self.travelDistance.textColor = UIColor(red:0.0, green:122.0/255.0, blue:1.0, alpha: 1.0)
        
        self.clearRoute!.backgroundColor = UIColor(red:0.0, green:122.0/255.0, blue:1.0, alpha: 1.0)
        self.clearRoute!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.clearRoute!.addTarget(self, action: Selector(), forControlEvents: UIControlEvents.TouchUpInside)
        let btnLayer3: CALayer = self.clearRoute!.layer
        btnLayer3.masksToBounds = true
        btnLayer3.cornerRadius = 9.0
        
        let actionButton = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "shareButton")
        let buttons:NSArray = [actionButton]
        self.navigationItem.rightBarButtonItems = buttons as? [UIBarButtonItem]
        
    }
    
    override func viewWillAppear(animated: Bool) {
        //locationManager.startUpdatingHeading()
        //locationManager.startUpdatingLocation()
    }
    
    override func viewWillDisappear(animated: Bool) {
        locationManager.stopUpdatingHeading()
        locationManager.stopUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - CLLocationManager
    
    override func viewDidAppear(animated: Bool)
    {
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.delegate = self;
        
        let status = CLLocationManager.authorizationStatus()
        if status == .NotDetermined || status == .Denied || status == .AuthorizedWhenInUse {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        
        self.mapView.delegate = self
        self.mapView.setUserTrackingMode(MKUserTrackingMode.FollowWithHeading, animated: true)
        self.mapView.showsUserLocation = true
        self.mapView.zoomEnabled = true
        self.mapView.scrollEnabled = true
        self.mapView.rotateEnabled = true
        self.mapView.showsPointsOfInterest = true
        self.mapView.showsBuildings = true
        self.mapView.showsCompass = true
        self.mapView.showsScale = true
        self.mapView.showsTraffic = true
        
        let location: String = String(format: "%@ %@ %@ %@", self.mapaddress!, self.mapcity!, self.mapstate!, self.mapzip!)
        
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(location, completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            
            if error != nil{
                print("Geocode failed with error: \(error!.localizedDescription)")
            } else if placemarks!.count > 0 {
                let placemark = placemarks![0]
                
                if(self.annotationPoint == nil)
                {
                self.annotationPoint = MKPointAnnotation()
                self.annotationPoint.coordinate = placemark.location!.coordinate
                self.annotationPoint.title = self.mapaddress as? String
                self.annotationPoint.subtitle = String(format: "%@ %@ %@", self.mapcity!, self.mapstate!, self.mapzip!)
                self.mapView.addAnnotation(self.annotationPoint)
                }
                self.locationManager.stopUpdatingLocation()
                
        // MARK:  Directions
                
                let request = MKDirectionsRequest()
                
                request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: self.locationManager.location!.coordinate.latitude, longitude: self.locationManager.location!.coordinate.longitude), addressDictionary: nil))
                
                request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: placemark.location!.coordinate.latitude, longitude: placemark.location!.coordinate.longitude), addressDictionary: nil))
                
        // MARK:  AlternateRoutes
                request.requestsAlternateRoutes = false
        // MARK:  transportType
                request.transportType = .Automobile
                
                let directions = MKDirections(request: request)
                
                directions.calculateDirectionsWithCompletionHandler { [unowned self] response, error in
                    guard let unwrappedResponse = response else { return }
                    
                    for route in unwrappedResponse.routes {
                        //self.mapView.addOverlay(route.polyline)
                        self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                        self.showRoute(response!)
                    }
                }
            }
        })
    }
    
    // MARK: - Routes
    
    func showRoute(response: MKDirectionsResponse) {
        
        let temp:MKRoute = response.routes.first! as MKRoute
        self.route = temp
        self.travelTime.text = NSString(format:"Time %0.1f minutes", route.expectedTravelTime/60) as String
        self.travelDistance.text = String(format:"Distance %0.1f Miles", route.distance/1609.344) as String
        self.mapView.addOverlay(route.polyline, level: MKOverlayLevel.AboveRoads)
        
        for (var i = 0; i < self.route.steps.count; i++)
        {
            let step:MKRouteStep = self.route.steps[i] as MKRouteStep;
            let newStep:NSString = step.instructions
            let distStep:NSString = String(format:"%0.2f Miles", step.distance/1609.344) as String
            self.allSteps = self.allSteps!.stringByAppendingString( "\(i+1). ")
            self.allSteps = self.allSteps!.stringByAppendingString(newStep as String)
            self.allSteps = self.allSteps!.stringByAppendingString("  ");
            self.allSteps = self.allSteps!.stringByAppendingString(distStep as String)
            self.allSteps = self.allSteps!.stringByAppendingString("\n\n");
            self.steps.text = self.allSteps as! String
        }
    }
    
    // MARK: - Map Annotation
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        
        let annotationView = MKPinAnnotationView()
        //annotationView.rightCalloutAccessoryView = UIButton(type: UIButtonType.InfoLight)
        annotationView.pinTintColor = UIColor.redColor()
        annotationView.draggable = true
        annotationView.canShowCallout = true
        annotationView.animatesDrop = true
        return annotationView
    }
    
    // MARK: - Map Overlay
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.blueColor()
        renderer.lineWidth = 3
        return renderer
    }
    
    // MARK: - SegmentedControl

    @IBAction func mapTypeChanged(sender: AnyObject) {
        
        if(mapTypeSegmentedControl.selectedSegmentIndex == 0)
        {
            self.mapView.mapType = MKMapType.Standard
        }
        else if(mapTypeSegmentedControl.selectedSegmentIndex == 1)
        {
            self.mapView.mapType = MKMapType.HybridFlyover
        }
        else if(mapTypeSegmentedControl.selectedSegmentIndex == 2)
        {
            self.mapView.mapType = MKMapType.Satellite
        }
    }
    
    // MARK: - Button
    
    func shareButton() {
        
        let alertController = UIAlertController(title:"Map Options", message:"", preferredStyle: .ActionSheet)
        
        let buttonOne = UIAlertAction(title: "Show Traffic", style: .Default, handler: { (action) -> Void in
            self.routView.hidden = true
            //self.performSegueWithIdentifier("snapshotSegue", sender: self)
        })
        let buttonTwo = UIAlertAction(title: "Show Scale", style: .Default, handler: { (action) -> Void in
            //self.performSegueWithIdentifier("userSegue", sender: self)
        })
        let buttonThree = UIAlertAction(title: "Show Compass", style: .Default, handler: { (action) -> Void in
            //self.performSegueWithIdentifier("notificationSegue", sender: self)
        })
        let buttonFour = UIAlertAction(title: "Show Buildings", style: .Default, handler: { (action) -> Void in
            //self.performSegueWithIdentifier("showLogin", sender: self)
        })
        let buttonFive = UIAlertAction(title: "Show User Location", style: .Default, handler: { (action) -> Void in
            //self.performSegueWithIdentifier("codegenSegue", sender: self)
        })
        let buttonSix = UIAlertAction(title: "Show Points of Interest", style: .Default, handler: { (action) -> Void in
            //self.performSegueWithIdentifier("showLogin", sender: self)
        })
        let buttonCancel = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
        }
        
        alertController.addAction(buttonOne)
        alertController.addAction(buttonTwo)
        alertController.addAction(buttonThree)
        alertController.addAction(buttonFour)
        alertController.addAction(buttonFive)
        alertController.addAction(buttonSix)
        alertController.addAction(buttonCancel)
        /*
        if let popoverController = alertController.popoverPresentationController {
            popoverController.barButtonItem = sender as? UIBarButtonItem
        } */
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}
