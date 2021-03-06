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
import CoreBluetooth
import MobileCoreServices //added CoreSpotlight

class DetailViewController: UIViewController, RPPreviewViewControllerDelegate, AVSpeechSynthesizerDelegate, CLLocationManagerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, RPScreenRecorderDelegate {
    
    let headtitle = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
    let textviewText = "Chadi sucks in Basketball, he has no picks and certainly has no rolls"
    
    @IBOutlet weak var languagePick: UIPickerView?
    let languageList = ["Hindi", "Russian", "Greek", "United States", "United Kingdom", "Italy", "Israel", "Arabic", "China", "French", "German"]
    let languageCodeList = ["hi-IN", "ru-RU", "el-GR", "en-US", "en-GB", "it-IT", "he-IL", "ar-SA", "zh-CN", "fr-FR", "de-DE"]
    var langNum : Int!
    //var langRate : Float!
    
    @IBOutlet weak private var startRecordingButton: UIButton!
    @IBOutlet weak private var stopRecordingButton: UIButton!
    @IBOutlet weak private var processingView: UIActivityIndicatorView!
    private let recorder = RPScreenRecorder.sharedRecorder()
    
    private var locationManager = CLLocationManager()
    private let identifier = "com.TheLight" //added CoreSpotlight
    private let domainIdentifier = "com.lotpb.github.io/UnitedWebPage/index.html"
    private var activity: NSUserActivity!
    
    @IBOutlet weak var latitudeText: UILabel!
    @IBOutlet weak var longitudeText: UILabel!
    @IBOutlet weak var speechButton: UIButton!
    @IBOutlet weak var lightoff: UIButton!
    
    @IBOutlet weak var volume: UITextField?
    @IBOutlet weak var pitch: UITextField?
    @IBOutlet weak var ratetext: UITextField?
    @IBOutlet weak var subject: UITextView?

    //var defaults = NSUserDefaults.standardUserDefaults()
    
    //below has nothing
    var detailItem: AnyObject? { //dont delete for splitview
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
        titleButton.setTitle("TheLight Software", forState: UIControlState.Normal)
        titleButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 25.0)
        titleButton.titleLabel?.textAlignment = NSTextAlignment.Center
        titleButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        titleButton.addTarget(self, action: Selector(), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.titleView = titleButton
        
        let searchButton = UIBarButtonItem(title: "Light", style: .Plain, target: self, action: #selector(DetailViewController.lightcamera))
        let buttons:NSArray = [searchButton]
        self.navigationItem.rightBarButtonItems = buttons as? [UIBarButtonItem]
        
        // MARK: - locationManager

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        recorder.delegate = self
        processingView.hidden = true
        buttonEnabledControl(recorder.recording)

        
        let myLabel:UILabel = UILabel(frame: CGRectMake(20, 70, 60, 60))
        myLabel.backgroundColor = UIColor.orangeColor()
        myLabel.textColor = UIColor.whiteColor()
        myLabel.textAlignment = NSTextAlignment.Center
        myLabel.layer.masksToBounds = true
        myLabel.text = "Speak"
        myLabel.font = headtitle
        myLabel.layer.cornerRadius = 30.0
        myLabel.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(DetailViewController.speak))
        myLabel.addGestureRecognizer(tap)
        self.view.addSubview(myLabel)
        
        self.subject!.text = textviewText
        
        langNum = 4
        languagePick!.selectRow(langNum, inComponent: 0, animated: true)
        //langRate = 0.4
        //ratetext!.text = langRate as String
        
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
        
        let activityType = String(format: "%@.%@", identifier, domainIdentifier)
        activity = NSUserActivity(activityType: activityType)
        activity.title = "TheLight"
        activity.keywords = Set<String>(arrayLiteral: "window", "door", "siding", "roof")
        activity.eligibleForSearch = true
        activity.becomeCurrent()
        
        let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
        attributeSet.title = "TheLight"
        attributeSet.contentDescription = "CoreSpotLight tutorial"
        attributeSet.keywords = ["window", "door", "siding", "roof"]
        //let image = UIImage(named: "m7")!
        //let data = UIImagePNGRepresentation(image)
        //attributeSet.thumbnailData = data
        
        let item = CSSearchableItem(
            uniqueIdentifier: identifier,
            domainIdentifier: domainIdentifier,
            attributeSet: attributeSet)
        
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
    
    
    // MARK: - ScreenRecorderDelegate
    
    // called after stopping the recording
    func screenRecorder(screenRecorder: RPScreenRecorder, didStopRecordingWithError error: NSError, previewViewController: RPPreviewViewController?) {
        NSLog("Stop recording")
    }
    
    // called when the recorder availability has changed
    func screenRecorderDidChangeAvailability(screenRecorder: RPScreenRecorder) {
        let availability = screenRecorder.available
        NSLog("Availablility: \(availability)")
    }
    
    
    func previewControllerDidFinish(previewController: RPPreviewViewController) {
        NSLog("Preview finish")
        
        dispatch_async(dispatch_get_main_queue()) { [unowned previewController] in
            // close preview window
            previewController.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func startRecordingButtonTapped(sender: AnyObject) {
        processingView.hidden = false
        
        // start recording
        recorder.startRecordingWithMicrophoneEnabled(true) { [unowned self] error in
            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                self.processingView.hidden = true
            }
            
            if let error = error {
                NSLog("Failed start recording: \(error.localizedDescription)")
                return
            }
            
            NSLog("Start recording")
            self.buttonEnabledControl(true)
        }
    }
    
    @IBAction func stopRecordingButtonTapped(sender: AnyObject) {
        processingView.hidden = false
        
        // end recording
        recorder.stopRecordingWithHandler({ [unowned self] (previewViewController, error) in
            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                self.processingView.hidden = true
            }
            
            self.buttonEnabledControl(false)
            
            if let error = error {
                NSLog("Failed stop recording: \(error.localizedDescription)")
                return
            }
            
            NSLog("Stop recording")
            previewViewController?.previewControllerDelegate = self
            
            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                // show preview window
                self.presentViewController(previewViewController!, animated: true, completion: nil)
            }
            })
    }
    
    private func buttonEnabledControl(isRecording: Bool) {
        dispatch_async(dispatch_get_main_queue()) { [unowned self] in
            let enebledColor = UIColor(red: 0.0, green: 122.0/255.0, blue:1.0, alpha: 1.0)
            let disabledColor = UIColor.lightGrayColor()
            
            if !self.recorder.available {
                self.startRecordingButton.enabled = false
                self.startRecordingButton.backgroundColor = disabledColor
                self.stopRecordingButton.enabled = false
                self.stopRecordingButton.backgroundColor = disabledColor
                
                return
            }
            
            self.startRecordingButton.enabled = !isRecording
            self.startRecordingButton.backgroundColor = isRecording ? disabledColor : enebledColor
            self.stopRecordingButton.enabled = isRecording
            self.stopRecordingButton.backgroundColor = isRecording ? enebledColor : disabledColor
        }
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
        utterance.voice = AVSpeechSynthesisVoice(identifier: AVSpeechSynthesisVoiceIdentifierAlex)
        utterance.rate = 0.3
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speakUtterance(utterance)
    }
    
    
    // MARK: - Speak red text
    
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
        utterance.voice = AVSpeechSynthesisVoice(language: languageCodeList[langNum])
        utterance.rate = 0.4 //langRate
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.delegate = self
        synthesizer.speakUtterance(utterance)
    }
    
    // MARK:  Pickerview
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        return languageList.count
    }
    
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        return languageList[row]
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        langNum = row
    }
    
    
    // MARK: - locationManager
    
    
    func locationManager(locationManager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let location = locations.first {
 
            latitudeText!.text = String(format: "Lat: %.4f",
                location.coordinate.latitude)
            longitudeText!.text = String(format: "Lon: %.4f",
                location.coordinate.longitude)
            
        }
    }
    
    func locationManager(locationManager: CLLocationManager, didFailWithError error: NSError) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    
 
    
}

