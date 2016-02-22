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
    
    let celllabel1 = UIFont.systemFontOfSize(18, weight: UIFontWeightMedium)
    let cellsteps = UIFont.systemFontOfSize(18, weight: UIFontWeightLight)
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var travelTime: UILabel!
    @IBOutlet weak var travelDistance: UILabel!
    @IBOutlet weak var steps: UITextView!
    @IBOutlet weak var clearRoute: UIButton!
    @IBOutlet weak var routView: UIView!
    @IBOutlet weak var mapTypeSegmentedControl: UISegmentedControl!
    
    var activityIndicator: UIActivityIndicatorView?
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
        
        self.travelTime.font = celllabel1
        self.travelDistance.font = celllabel1
        self.steps.font = cellsteps
        
        self.routView.backgroundColor = Color.DGrayColor
        self.travelTime.textColor = UIColor.whiteColor()
        self.travelDistance.textColor = UIColor.whiteColor()
        
        self.clearRoute!.backgroundColor = UIColor.whiteColor()
        self.clearRoute!.setTitleColor(Color.DGrayColor, forState: UIControlState.Normal)
        self.clearRoute!.addTarget(self, action: Selector(), forControlEvents: UIControlEvents.TouchUpInside)
        let btnLayer3: CALayer = self.clearRoute!.layer
        btnLayer3.masksToBounds = true
        btnLayer3.cornerRadius = 9.0
        
        let actionButton = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "shareButton")
        let buttons:NSArray = [actionButton]
        self.navigationItem.rightBarButtonItems = buttons as? [UIBarButtonItem]
        
        addActivityIndicator()
        
    }
    
    func addActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(frame: UIScreen.mainScreen().bounds)
        activityIndicator?.activityIndicatorViewStyle = .WhiteLarge
        activityIndicator?.backgroundColor = UIColor(red:0.0, green:122.0/255.0, blue:1.0, alpha: 1.0) //view.backgroundColor
        activityIndicator?.startAnimating()
        view.addSubview(activityIndicator!)
    }
    
    func hideActivityIndicator() {
        if activityIndicator != nil {
            activityIndicator?.removeFromSuperview()
            activityIndicator = nil
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        //navigationController?.navigationBarHidden = false
        //automaticallyAdjustsScrollViewInsets = false
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
        self.mapView.showsCompass = true
        self.mapView.showsScale = true
        //self.mapView.showsTraffic = true
        //self.mapView.showsBuildings = true
        
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
                request.requestsAlternateRoutes = true
        // MARK:  transportType
                request.transportType = .Automobile
                
                let directions = MKDirections(request: request)
                
                directions.calculateDirectionsWithCompletionHandler { [unowned self] response, error in
                    guard let unwrappedResponse = response else { return }
                    
                    for route in unwrappedResponse.routes {
                        self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                        //self.mapView.addOverlay(route.polyline)
                        self.showRoute(response!)
                        self.hideActivityIndicator()
                    }
                }
            }
        })
    }
    
    // MARK: - Routes
    
    func showRoute(response: MKDirectionsResponse) {
        
        let temp:MKRoute = response.routes.first! as MKRoute
        self.route = temp
        self.travelTime.text = NSString(format:"Time: %0.1f minutes", route.expectedTravelTime/60) as String
        self.travelDistance.text = String(format:"Distance: %0.1f Miles", route.distance/1609.344) as String
        self.mapView.addOverlay(route.polyline, level: MKOverlayLevel.AboveRoads)
        
        /*
        if mapView.overlays.count == 1 {
        mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0), animated: false)
        } else {
        let polylineBoundingRect =  MKMapRectUnion(mapView.visibleMapRect, route.polyline.boundingMapRect)
        mapView.setVisibleMapRect(polylineBoundingRect, edgePadding: UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0), animated: false)
        } */
        
        for (var i = 0; i < self.route.steps.count; i++)
        {
            let step:MKRouteStep = self.route.steps[i] as MKRouteStep;
            let newStep:NSString = step.instructions
            let distStep:NSString = String(format:"%0.2f miles", step.distance/1609.344) as String
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
        
        if (annotation is MKUserLocation) { //added blue circle userlocation
        return nil
        }
        
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
        
        if mapView.overlays.count == 1 {
            renderer.strokeColor =
                UIColor.blueColor().colorWithAlphaComponent(0.75)
        } else if mapView.overlays.count == 2 {
            renderer.strokeColor =
                UIColor.greenColor().colorWithAlphaComponent(0.75)
        } else if mapView.overlays.count == 3 {
            renderer.strokeColor =
                UIColor.redColor().colorWithAlphaComponent(0.75)
        }
  
        //renderer.strokeColor = UIColor.blueColor()
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
    
    func trafficBtnTapped() {
        
        mapView.showsTraffic = !mapView.showsTraffic
        
        // shown
        if mapView.showsTraffic {
            //sender.setTitle("Hide Traffic", forState: UIControlState.Normal)
        }
            // hidden
        else {
            //sender.setTitle("Show Traffic", forState: UIControlState.Normal)
        }
    }
    
    func scaleBtnTapped() {
        
        mapView.showsScale = !mapView.showsScale
        
        // shown
        if mapView.showsScale {
            //sender.setTitle("Hide Scale", forState: UIControlState.Normal)
        }
            // hidden
        else {
            //sender.setTitle("Show Scale", forState: UIControlState.Normal)
        }
    }
    
    func compassBtnTapped() {
        
        mapView.showsCompass = !mapView.showsCompass
    }
    
    func buildingBtnTapped() {
        
        mapView.showsBuildings = !mapView.showsBuildings
    }
    
    func userlocationBtnTapped() {
        
        mapView.showsUserLocation = !mapView.showsUserLocation
    }
    
    func pointsofinterestBtnTapped() {
        
        mapView.showsPointsOfInterest = !mapView.showsPointsOfInterest
        
    }
    
    func requestsAlternateRoutesBtnTapped() {
        
        //mapView.requestsAlternateRoutes = !mapView.requestsAlternateRoutes

    }
    
    func shareButton() {
        
        let alertController = UIAlertController(title:"Map Options", message:"", preferredStyle: .ActionSheet)
        
        let buttonOne = UIAlertAction(title: "Show Traffic", style: .Default, handler: { (action) -> Void in
            self.trafficBtnTapped()
        })
        let buttonTwo = UIAlertAction(title: "Show Scale", style: .Default, handler: { (action) -> Void in
            self.scaleBtnTapped()
        })
        let buttonThree = UIAlertAction(title: "Show Compass", style: .Default, handler: { (action) -> Void in
            self.compassBtnTapped()
        })
        let buttonFour = UIAlertAction(title: "Show Buildings", style: .Default, handler: { (action) -> Void in
            self.buildingBtnTapped()
        })
        let buttonFive = UIAlertAction(title: "Show User Location", style: .Default, handler: { (action) -> Void in
            self.userlocationBtnTapped()
        })
        let buttonSix = UIAlertAction(title: "Show Points of Interest", style: .Default, handler: { (action) -> Void in
            self.pointsofinterestBtnTapped()
        })
        let buttonSeven = UIAlertAction(title: "Alternate Routes", style: .Default, handler: { (action) -> Void in
            self.requestsAlternateRoutesBtnTapped()
        })
        let buttonCancel = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
        }
        
        alertController.addAction(buttonOne)
        alertController.addAction(buttonTwo)
        alertController.addAction(buttonThree)
        alertController.addAction(buttonFour)
        alertController.addAction(buttonFive)
        alertController.addAction(buttonSix)
        alertController.addAction(buttonSeven)
        alertController.addAction(buttonCancel)
        /*
        if let popoverController = alertController.popoverPresentationController {
            popoverController.barButtonItem = sender as? UIBarButtonItem
        } */
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}
