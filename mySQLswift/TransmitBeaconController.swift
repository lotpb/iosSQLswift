//
//  TransmitBeaconController.swift
//  mySQLswift
//
//  Created by Peter Balsamo on 1/19/16.
//  Copyright © 2016 Peter Balsamo. All rights reserved.
//

import UIKit
import QuartzCore
import CoreLocation
import CoreBluetooth


class TransmitBeaconController: UIViewController, CBPeripheralManagerDelegate {
    
    @IBOutlet weak var btnAction: UIButton!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblBTStatus: UILabel!
    @IBOutlet weak var txtMajor: UITextField!
    @IBOutlet weak var txtMinor: UITextField!
    
    let uuid = NSUUID(UUIDString: "F34A1A1F-500F-48FB-AFAA-9584D641D7B1")
    var beaconRegion: CLBeaconRegion!
    var bluetoothPeripheralManager: CBPeripheralManager!
    var isBroadcasting = false
    var dataDictionary = NSDictionary()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        btnAction.layer.cornerRadius = btnAction.frame.size.width / 2
        
        let swipeDownGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "handleSwipeGestureRecognizer:")
        swipeDownGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Down
        view.addGestureRecognizer(swipeDownGestureRecognizer)
        
        bluetoothPeripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Custom method implementation
    
    func handleSwipeGestureRecognizer(gestureRecognizer: UISwipeGestureRecognizer) {
        txtMajor.resignFirstResponder()
        txtMinor.resignFirstResponder()
    }
    
    
    // MARK: IBAction method implementation
    
    @IBAction func switchBroadcastingState(sender: AnyObject) {
        if txtMajor.text == "" || txtMinor.text == "" {
            return
        }
        
        if txtMajor.isFirstResponder() || txtMinor.isFirstResponder() {
            return
        }
        
        
        if !isBroadcasting {
            if bluetoothPeripheralManager.state == .PoweredOn {
                let major: CLBeaconMajorValue = UInt16(Int(txtMajor.text!)!)
                let minor: CLBeaconMinorValue = UInt16(Int(txtMinor.text!)!)
                beaconRegion = CLBeaconRegion(proximityUUID: uuid!, major: major, minor: minor, identifier: "com.TheLight.beacon")
                
                dataDictionary = beaconRegion.peripheralDataWithMeasuredPower(nil)
                bluetoothPeripheralManager.startAdvertising(dataDictionary as? [String : AnyObject])
                
                btnAction.setTitle("Stop", forState: UIControlState.Normal)
                lblStatus.text = "Broadcasting..."
                txtMajor.enabled = false
                txtMinor.enabled = false
                
                isBroadcasting = true
            }
        }
        else {
            bluetoothPeripheralManager.stopAdvertising()
            
            btnAction.setTitle("Start", forState: UIControlState.Normal)
            lblStatus.text = "Stopped"
            
            txtMajor.enabled = true
            txtMinor.enabled = true
            
            isBroadcasting = false
        }
    }
    
    
    // MARK: CBPeripheralManagerDelegate method implementation
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
        var statusMessage = ""
        
        switch peripheral.state {
        case CBPeripheralManagerState.PoweredOn:
            statusMessage = "Bluetooth Status: Turned On"
            
        case CBPeripheralManagerState.PoweredOff:
            if isBroadcasting {
                switchBroadcastingState(self)
            }
            statusMessage = "Bluetooth Status: Turned Off"
            
        case CBPeripheralManagerState.Resetting:
            statusMessage = "Bluetooth Status: Resetting"
            
        case CBPeripheralManagerState.Unauthorized:
            statusMessage = "Bluetooth Status: Not Authorized"
            
        case CBPeripheralManagerState.Unsupported:
            statusMessage = "Bluetooth Status: Not Supported"
            
        default:
            statusMessage = "Bluetooth Status: Unknown"
        }
        
        lblBTStatus.text = statusMessage
    }
    
}
