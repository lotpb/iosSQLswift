//
//  DetailViewController.swift
//  mySQLswift
//
//  Created by Peter Balsamo on 12/8/15.
//  Copyright © 2015 Peter Balsamo. All rights reserved.
//

import UIKit
import ReplayKit
//import AVFoundation
import UIKit
import CoreLocation
import iAd //added iAd
import CoreSpotlight //added CoreSpotlight
import MobileCoreServices //added CoreSpotlight

class DetailViewController: UIViewController, RPPreviewViewControllerDelegate, AVSpeechSynthesizerDelegate, CLLocationManagerDelegate, UIPickerViewDelegate, UIPickerViewDataSource
 {
    
    let session = AVAudioSession.sharedInstance()
    var recorder: AVAudioRecorder?
    
    var manager = CLLocationManager()
    let identifier = "MyIdentifier" //added CoreSpotlight

    @IBOutlet weak var latitudeText: UILabel!
    @IBOutlet weak var longitudeText: UILabel!
    @IBOutlet weak var speechButton: UIButton!
    @IBOutlet weak var lightoff: UIButton!
    
    @IBOutlet weak var volume: UITextField?
    @IBOutlet weak var pitch: UITextField?
    @IBOutlet weak var ratetext: UITextField?
    
    @IBOutlet weak var subject: UITextView?
    
    @IBOutlet weak var languagePick: UIPickerView?
    var arrVoiceLanguages: [Dictionary<String, String!>] = []
    var selectedVoiceLanguage = 0
    
    var defaults = NSUserDefaults.standardUserDefaults()

    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            //self.configureView()
        }
    }
/*
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.description
            }
        }
    } */


    override func viewDidLoad() {
        super.viewDidLoad()

        let titleButton: UIButton = UIButton(frame: CGRectMake(0, 0, 100, 32))
        titleButton.setTitle("mySQL Software", forState: UIControlState.Normal)
        titleButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 25.0)
        titleButton.titleLabel?.textAlignment = NSTextAlignment.Center
        titleButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        titleButton.addTarget(self, action: Selector(), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.titleView = titleButton
        
        let addButton = UIBarButtonItem(title: "Start", style: .Plain, target: self, action: "startRecording")
        let searchButton = UIBarButtonItem(title: "Light", style: .Plain, target: self, action: "lightcamera")
        let buttons:NSArray = [addButton,searchButton]
        self.navigationItem.rightBarButtonItems = buttons as? [UIBarButtonItem]
        
        // MARK: - locationManager
        
        //manager.delegate = self
        //manager.requestLocation()
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        
        // MARK: - iAd

        if (defaults.valueForKey("iadKey") == nil)  {
            canDisplayBannerAds = true
        } else {
            canDisplayBannerAds = false
        }
        
        //prepareVoiceList()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnSwipe = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - CoreSpotlight
    
    @IBAction func AddItemToCoreSpotlight(sender: AnyObject) {
        let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
        attributeSet.title = "mySQLtest"
        attributeSet.contentDescription = "CoreSpotLight tutorial"
        
        let item = CSSearchableItem(uniqueIdentifier: identifier, domainIdentifier: "com.eunitedws", attributeSet: attributeSet)
        CSSearchableIndex.defaultSearchableIndex().indexSearchableItems([item]) { (error: NSError?) -> Void in
            if let error =  error {
                print("Indexing error: \(error.localizedDescription)")
            } else {
                print("Search item successfully indexed")
            }
        }
    }
    
    @IBAction func RemoveItemFromCoreSpotlight(sender: AnyObject) {
        CSSearchableIndex.defaultSearchableIndex().deleteSearchableItemsWithIdentifiers([identifier])
            { (error: NSError?) -> Void in
                if let error = error {
                    print("Remove error: \(error.localizedDescription)")
                } else {
                    print("Search item successfully removed")
                }
        }
    }
    
    
     // MARK: - RPScreenRecorder
    
    func startRecording() {
        let recorder = RPScreenRecorder.sharedRecorder()
        
        recorder.startRecordingWithMicrophoneEnabled(true) { [unowned self] (error) in
            if let unwrappedError = error {
                print(unwrappedError.localizedDescription)
            } else {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Stop", style: .Plain, target: self, action: "stopRecording")
            }
        }
    }
    
    
    func stopRecording() {
        let recorder = RPScreenRecorder.sharedRecorder()
        
        recorder.stopRecordingWithHandler { [unowned self] (preview, error) in
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Start", style: .Plain, target: self, action: "startRecording")
            
            if let unwrappedPreview = preview {
                unwrappedPreview.previewControllerDelegate = self
                self.presentViewController(unwrappedPreview, animated: true, completion: nil)
            }
        }
    }
    
    func previewControllerDidFinish(previewController: RPPreviewViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }


    // MARK: - camera light

    func lightcamera() {
        toggleTorch(on: true)

    }
    
    @IBAction func lightoff(sender: AnyObject) {
        toggleTorch(on: false)
        
    }
    
    func toggleTorch(on on: Bool) {
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                
                if on == true {
                    device.torchMode = .On
                } else {
                    device.torchMode = .Off
                }
                
                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }
    
    // MARK: - speech
    
    @IBAction func speech(sender: AnyObject) {
        //"King Solomon the wisest of men. for i found one righteous man in a thousand and not one righteous woman"
        //"Hello world!!! my name is Peter Balsamo")
        let utterance = AVSpeechUtterance(string: "Hello world!!! It's time too kiss the feet of Peter Balsamo")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        utterance.rate = 0.3
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speakUtterance(utterance)
    }
    
    
    // MARK: - speak red text
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        let mutableAttributedString = NSMutableAttributedString(string: utterance.speechString)
        mutableAttributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: characterRange)
        subject!.attributedText = mutableAttributedString
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didFinishSpeechUtterance utterance: AVSpeechUtterance) {
        subject!.attributedText = NSAttributedString(string: utterance.speechString)
    }
    
    @IBAction func speak(sender: AnyObject) {
        let string = subject!.text
        let utterance = AVSpeechUtterance(string: string!)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        utterance.rate = 0.4
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.delegate = self
        synthesizer.speakUtterance(utterance)
    }
    
    
    // MARK: - locationManager
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let location = locations.first {
            //print("Found user's location: \(location)")
            latitudeText!.text = "\(location.coordinate.latitude)"
            longitudeText!.text = "\(location.coordinate.longitude)"
            
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    // MARK: UIPickerView method implementation

    func prepareVoiceList() {
        for voice in AVSpeechSynthesisVoice.speechVoices() {
            let voiceLanguageCode = (voice as AVSpeechSynthesisVoice).language
            
            let languageName = NSLocale.currentLocale().displayNameForKey(NSLocaleIdentifier, value: voiceLanguageCode)
            
            let dictionary = ["languageName": languageName, "languageCode": voiceLanguageCode]
     
            arrVoiceLanguages.append(dictionary as! Dictionary<String, String!>)
        }
    }
    
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrVoiceLanguages.count
    }
    
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let voiceLanguagesDictionary = arrVoiceLanguages[row] as Dictionary<String, String!>
        
        return voiceLanguagesDictionary["languageName"]
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedVoiceLanguage = row
    }
    
    // MARK: iBeacons
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways {
            if CLLocationManager.isMonitoringAvailableForClass(CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func startScanning() {
        let uuid = NSUUID(UUIDString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid!, major: 123, minor: 456, identifier: "MyBeacon")
        
        manager.startMonitoringForRegion(beaconRegion)
        manager.startRangingBeaconsInRegion(beaconRegion)
    }
    
    func manager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        if beacons.count > 0 {
            let beacon = beacons[0] as! CLBeacon
            updateDistance(beacon.proximity)
        } else {
            updateDistance(.Unknown)
        }
    }
    
    func updateDistance(distance: CLProximity) {
        UIView.animateWithDuration(0.8) {
            switch distance {
            case .Unknown:
                self.view.backgroundColor = UIColor.grayColor()
                
            case .Far:
                self.view.backgroundColor = UIColor.blueColor()
                
            case .Near:
                self.view.backgroundColor = UIColor.orangeColor()
                
            case .Immediate:
                self.view.backgroundColor = UIColor.redColor()
            }
        }
    }

    
    
    
}

