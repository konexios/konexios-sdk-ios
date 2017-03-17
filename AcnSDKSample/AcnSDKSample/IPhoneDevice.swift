//
//  IPhoneDevice.swift
//  AcnSDKSample
//
//  Created by Michael Kalinin on 25/11/2016.
//  Copyright © 2016 Arrow. All rights reserved.
//

import Foundation
import CoreMotion
import AcnSDK

class Telemetry {
    static let NoValue = "___"
    
    var type: SensorType
    var label: String
    var value: String
    
    init(type: SensorType, label: String) {
        self.type = type
        self.label = label
        self.value = Telemetry.NoValue
    }

    func setValue(newValue: String) {
        if !newValue.isEmpty {
            value = newValue
        } else {
            value = Telemetry.NoValue
        }
    }
}

class TelemetryDisplay {
    var label: String = ""
    var value: String = ""
}

protocol DeviceDelegate {
    func telemetryUpdated()
}

class IPhoneDevice: NSObject, IotDevice {
    
    var deviceUid: String? {
        return UIDevice.current.identifierForVendor?.uuidString
    }
    
    var userHid: String
    
    var gatewayHid: String
    
    var deviceName: String {
        return "IPhoneDevice"
    }
    
    var deviceTypeName: String {
        return "IPhoneDevice"
    }
    
    var properties: [String : AnyObject] {
        return [String : AnyObject]()
    }
    
    var deviceId: String?
    var externalId: String?
    
    var pollingTimer: Timer?
    
    let motionManager = CMMotionManager()
    
    var registered = false
    var enabled    = false
    
    let lock = NSLock()
    let deviceTelemetryLock = NSLock()
    
    var iotParams = [String: IotParameter]()
    
    var deviceTelemetry = [Telemetry]()
    var deviceTelemetryDict = [SensorType: Telemetry]()
    
    var delegate: DeviceDelegate?
    
    init(userHid: String, gatewayHid: String) {
        self.userHid    = userHid
        self.gatewayHid = gatewayHid
        
        deviceTelemetry = [
            Telemetry(type: SensorType.accelerometerX, label: "Accelerometer"),
            Telemetry(type: SensorType.accelerometerY, label: ""),
            Telemetry(type: SensorType.accelerometerZ, label: ""),
            Telemetry(type: SensorType.gyroscopeX, label: "Gyroscope"),
            Telemetry(type: SensorType.gyroscopeY, label: ""),
            Telemetry(type: SensorType.gyroscopeZ, label: ""),
            Telemetry(type: SensorType.magnetometerX, label: "Magnetometer"),
            Telemetry(type: SensorType.magnetometerY, label: ""),
            Telemetry(type: SensorType.magnetometerZ, label: "")
        ]
        
        for telemetry in deviceTelemetry  {
            deviceTelemetryDict[telemetry.type] = telemetry
        }
    }
    
    func enable() {
        
        enabled = true
        
        registerDevice()
        
        startPollingTimer()
        
        startAccelerometer()
        startGyroscope()
        startMagnetometer()
    }
    
    func disable() {
        
        enabled = false
        
        stopPollingTimer()
        
        motionManager.stopAccelerometerUpdates()
        motionManager.stopGyroUpdates()
        motionManager.stopMagnetometerUpdates()
    }
    
    func registerDevice() {
        IotConnectService.sharedInstance.registerDevice(device: self) { (deviceId, externalId, error) in
            if deviceId != nil {
                self.deviceId = deviceId
                self.externalId = externalId
                self.registered = true
            }
        }
    }
    
    func getTelemetryForDisplay(type: SensorType) -> TelemetryDisplay {
        let result = TelemetryDisplay()
        synchronized(deviceTelemetryLock) {
            if let telemetry = self.deviceTelemetryDict[type] {
                result.label = telemetry.label
                result.value = telemetry.value
            }
        }
        return result
    }
    
    func putIotParams(params: [IotParameter]) {
        if registered {
            synchronized(lock) {
                for param in params {
                    self.iotParams[param.key] = param
                }
            }
        }
    }

    func getIotParams() -> [IotParameter] {
        var result = [IotParameter]()
        synchronized(lock) {
            for param in self.iotParams.values {
                result.append(param)
            }
            self.iotParams.removeAll()
        }
        return result
    }
    
    func processSensorData(data: SensorDataProtocol) {
        let values: [SensorType: String] = data.formatDisplay()
        synchronized(deviceTelemetryLock) {
            for type in values.keys {
                self.deviceTelemetryDict[type]!.setValue(newValue: values[type]!)
            }
        }        
        delegate?.telemetryUpdated()
        putIotParams(params: data.writeIot())
    }
    
    func startAccelerometer() {
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.1
            motionManager.startAccelerometerUpdates(to: OperationQueue.main) { [weak self] (data, error) in
                if let acceleration = data?.acceleration {
                    self?.processSensorData(data: AccelerometerData(Vector(x: acceleration.x, y: acceleration.y, z: acceleration.z)))
                }
            }
        }
    }
    
    func startGyroscope() {
        if motionManager.isGyroAvailable {
            motionManager.gyroUpdateInterval = 0.1
            motionManager.startGyroUpdates(to: OperationQueue.main) { [weak self] (data, error) in
                if let rotationRate = data?.rotationRate {
                    self?.processSensorData(data: GyroscopeData(Vector(x: rotationRate.x, y: rotationRate.y, z: rotationRate.z)))
                }
            }
        }
    }
    
    func startMagnetometer() {
        if motionManager.isMagnetometerAvailable {
            motionManager.magnetometerUpdateInterval = 0.1
            motionManager.startMagnetometerUpdates(to: OperationQueue.main) { [weak self] (data, error) in
                if let magneticField = data?.magneticField {
                    self?.processSensorData(data: MagnetometerData(Vector(x: magneticField.x, y: magneticField.y, z: magneticField.z)))
                    
                }
            }
        }
    }
    
    func startPollingTimer() {
        stopPollingTimer()

        pollingTimer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(IPhoneDevice.timerTask),
            userInfo: nil,
            repeats: true)
    }
    
    func stopPollingTimer() {
        pollingTimer?.invalidate()
        pollingTimer = nil
    }
    
    func timerTask() {
        let params = getIotParams()
        
        if params.count > 0 {
            let dataLoad = IotDataLoad(
                deviceId:   deviceId!,
                externalId: externalId ?? "",
                deviceType: deviceTypeName,
                timestamp:  Int64(NSDate().timeIntervalSince1970) * 1000,
                location:   nil,
                parameters: params)
            
            IotDataPublisher.sharedInstance.sendData(data: dataLoad)
        }
    }
}
