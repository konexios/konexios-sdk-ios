//
//  IotDataLoad.swift
//  AcnSDK
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
import CoreLocation

public struct IotParameter {
    public var key: String
    public var value: String
    
    public init(key: String, value: String) {
        self.key = key
        self.value = value
    }
}

class IotDataLoadQueue {

    var params = [[String : AnyObject]]()
    
    func addToQueue(data: IotDataLoad) {
        params.append(data.params)
    }
    
    func clearQueue() {
        params.removeAll()
    }
    
    func queueSize() -> Int {
        return params.count
    }
    
    func batchPayload() -> String? {
        
        let payloadString: String?
        
        do {
            let payloadData = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions())
            payloadString = String(data: payloadData, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            print("[IotDataLoadQueue] JSON Exception: \(error)")
            payloadString = nil
        }
        
        return payloadString
    }
    
    func batchData() -> Data? {
        do {
            let payloadData = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions())
            return payloadData
        } catch let error as NSError {
            print("[IotDataLoadQueue] JSON Exception: \(error)")
            return nil
        }
    }
}

public class IotDataLoad: RequestModel {
    
    var deviceId: String
    var externalId: String
    var deviceType: String
    var timestamp: Int64
    var location: CLLocation?
    var parameters: [IotParameter]
    
    override var params: [String: AnyObject] {
        var dataDict = [String: AnyObject]()
        
        dataDict["_|deviceHid"] = deviceId as AnyObject?
        dataDict["_|timestamp"] = String(timestamp) as AnyObject?
        
        if location != nil {
            dataDict["f|longitude"] = String(location!.coordinate.longitude) as AnyObject?
            dataDict["f|latitude"] = String(location!.coordinate.latitude) as AnyObject?
            dataDict["f2|latlong"] = "\(location!.coordinate.latitude)|\(location!.coordinate.longitude)" as AnyObject?
        }
        
        for param in parameters {
            // dataDict["s|\(param.key)"] = param.value
            dataDict[param.key] = param.value as AnyObject?            
        }
        return dataDict
    }
    
    public init(deviceId: String, externalId: String, deviceType: String, timestamp: Int64, location: CLLocation?, parameters: [IotParameter]) {
        self.deviceId = deviceId
        self.externalId = externalId
        self.deviceType = deviceType
        self.timestamp = timestamp
        self.location = location
        self.parameters = parameters
    }
    
    init(dataDict: [String: AnyObject]) {
        
        self.deviceId = dataDict["deviceId"] as! String
        self.externalId = dataDict["externalId"] as! String
        self.deviceType = dataDict["deviceType"] as! String
        self.timestamp = (dataDict["timestamp"] as! NSString).longLongValue
        
        let location_long = dataDict["location_long"]
        let location_lat = dataDict["location_lat"]
        
        if (location_long != nil && location_lat != nil) {
            self.location = CLLocation(latitude: (location_lat as! NSString).doubleValue, longitude: (location_long as! NSString).doubleValue)
        }
        
        self.parameters = [IotParameter]()
        let params = dataDict["parameters"] as! [[String: String]]
        
        for param in params {
            self.parameters.append(IotParameter(key: param["key"]!, value: param["value"]!))
        }
    }
    
    func toDataDict() -> [String: AnyObject] {
        
        var dataDict = [String: AnyObject]()
        
        dataDict["deviceId"] = deviceId as AnyObject?
        dataDict["externalId"] = externalId as AnyObject?
        dataDict["deviceType"] = deviceType as AnyObject?
        dataDict["timestamp"] = String(timestamp) as AnyObject?
        
        if location != nil {
            dataDict["location_long"] = String(location!.coordinate.longitude) as AnyObject?
            dataDict["location_lat"] = String(location!.coordinate.latitude) as AnyObject?
        }
        
        var params = [[String: String]]()
        for param in parameters {
            params.append(["key"   : param.key,
                "value" : param.value])
        }
        
        dataDict["parameters"] = params as AnyObject?
        
        return dataDict
    }
    
    func toMqttString() -> String? {
        var params = [String: AnyObject]()
        if location != nil {
            params["longitude"] = location!.coordinate.longitude as AnyObject?
            params["latitude"] = location!.coordinate.latitude as AnyObject?
        }
        for param in parameters {
            var key = param.key
            let range = key.startIndex..<key.index(key.startIndex, offsetBy: 2)
            key.removeSubrange(range)
            params[key] = param.value as AnyObject?
        }
        let dict = ["d" : params]
        var result: String?
        do {
            let data = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions())
            result = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String?
        } catch let error {
            print("toMqttString() ERROR: \(error)")
        }
        return result
    }
}
