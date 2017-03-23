//
//  SensorData.swift
//  AcnSDKSample
//
//  Copyright (c) 2017 Arrow Electronics, Inc.
//  All rights reserved. This program and the accompanying materials
//  are made available under the terms of the Apache License 2.0
//  which accompanies this distribution, and is available at
//  http://apache.org/licenses/LICENSE-2.0
//
//  Contributors: Arrow Electronics, Inc.
//

import Foundation
import AcnSDK

struct Vector {
    var x, y, z : Double
    
    init(x: Double, y: Double, z: Double) {
        self.x = x
        self.y = y
        self.z = z
    }
}

protocol SensorDataProtocol {
    func writeIot() -> [IotParameter]
    func formatDisplay() -> [SensorType: String]
}

class SensorData<Type> : SensorDataProtocol {
    var data: Type
    
    init(_ data: Type) {
        self.data = data
    }
    
    func writeIot() -> [IotParameter] {
        preconditionFailure("abstract method!")
    }
    
    func formatDisplay() -> [SensorType: String] {
        preconditionFailure("abstract method!")
    }
}

class AccelerometerData : SensorData<Vector> {
    
    override init(_ data: Vector) {
        super.init(data)
    }
    
    override func writeIot() -> [IotParameter] {
        return [
            IotParameter(key: "f|accelerometerX", value: String(format: "%.9f", data.x)),
            IotParameter(key: "f|accelerometerY", value: String(format: "%.9f", data.y)),
            IotParameter(key: "f|accelerometerZ", value: String(format: "%.9f", data.z))]
    }
    
    override func formatDisplay() -> [SensorType: String] {
        return [
            SensorType.accelerometerX: String(format: "%.9f m/s\u{00B2}", data.x),
            SensorType.accelerometerY: String(format: "%.9f m/s\u{00B2}", data.y),
            SensorType.accelerometerZ: String(format: "%.9f m/s\u{00B2}", data.z)]
    }
}

class GyroscopeData : SensorData<Vector> {
    
    override init(_ data: Vector) {
        super.init(data)
    }
    
    override func writeIot() -> [IotParameter] {
        return [
            IotParameter(key: "f|gyrometerX", value: String(format: "%.9f", data.x)),
            IotParameter(key: "f|gyrometerY", value: String(format: "%.9f", data.y)),
            IotParameter(key: "f|gyrometerZ", value: String(format: "%.9f", data.z))]
    }
    
    override func formatDisplay() -> [SensorType: String] {
        return [
            SensorType.gyroscopeX: String(format: "%.9f \u{00B0}/s", data.x),
            SensorType.gyroscopeY: String(format: "%.9f \u{00B0}/s", data.y),
            SensorType.gyroscopeZ: String(format: "%.9f \u{00B0}/s", data.z)]
    }
}

class MagnetometerData : SensorData<Vector> {
    
    override init(_ data: Vector) {
        super.init(data)
    }
    
    override func writeIot() -> [IotParameter] {
        return [
            IotParameter(key: "f|magnetometerX", value: String(format: "%.9f", data.x)),
            IotParameter(key: "f|magnetometerY", value: String(format: "%.9f", data.y)),
            IotParameter(key: "f|magnetometerZ", value: String(format: "%.9f", data.z))]
    }
    
    override func formatDisplay() -> [SensorType: String] {
        return [
            SensorType.magnetometerX: String(format: "%.9f uT", data.x),
            SensorType.magnetometerY: String(format: "%.9f uT", data.y),
            SensorType.magnetometerZ: String(format: "%.9f uT", data.z)]
    }
}
