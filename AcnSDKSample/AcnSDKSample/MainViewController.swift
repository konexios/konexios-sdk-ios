//
//  MainViewController.swift
//  AcnSDKSample
//
//  Created by Michael Kalinin on 25/11/2016.
//  Copyright © 2016 Arrow. All rights reserved.
//

import UIKit
import AcnSDK

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DeviceDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var startStopButton: UIButton!
    
    var tableViewTelemetries: [SensorType] {
        return [
            .accelerometerX,
            .accelerometerY,
            .accelerometerZ,
            .gyroscopeX,
            .gyroscopeY,
            .gyroscopeZ,
            .magnetometerX,
            .magnetometerY,
            .magnetometerZ
        ]
    }
    
    var gatewayId: String!
    var userId: String!
    
    var device: IPhoneDevice!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        navigationItem.setHidesBackButton(true, animated: false)
        startStopButton.isEnabled = false
        
        device = IPhoneDevice(userHid: userId, gatewayHid: gatewayId)
        device.delegate = self
        
        IotConnectService.sharedInstance.checkinGateway(hid: gatewayId) { success in
            if success {
                IotConnectService.sharedInstance.gatewayConfig(hid: self.gatewayId) { success in
                    if success {
                        DispatchQueue.global().async {
                            IotConnectService.sharedInstance.connectMQTT(gatewayId: self.gatewayId)
                        }
                        
                        IotConnectService.sharedInstance.startHeartbeat(interval: 60.0, gatewayId: self.gatewayId)
                        
                        DispatchQueue.main.async { [weak self] in
                            self?.startStopButton.isEnabled = true
                        }
                    }
                }
            }
        }        
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func startStopClicked(_ sender: UIButton) {
        if device != nil {
            if !device!.enabled {
                device!.enable()
                startStopButton.setTitle("Stop", for: UIControlState.normal)
            } else {
                device!.disable()
                startStopButton.setTitle("Start", for: UIControlState.normal)
            }
        }
    }
    
    // MARK: DeviceDelegate
    
    func telemetryUpdated() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewTelemetries.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsTableViewCell", for: indexPath)
        
        if let telemetry = device?.getTelemetryForDisplay(type: self.tableViewTelemetries[indexPath.row]) {
            cell.textLabel?.text = telemetry.label
            cell.detailTextLabel?.text = telemetry.value
        }        
       
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 20.0
    }
    

}
