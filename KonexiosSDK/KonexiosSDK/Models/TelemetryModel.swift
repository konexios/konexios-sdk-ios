//
//  TelemetryModel.swift
//  KonexiosSDK
//
//  Copyright (c) 2017 Arrow Electronics, Inc.
//  All rights reserved. This program and the accompanying materials
//  are made available under the terms of the Apache License 2.0
//  which accompanies this distribution, and is available at
//  http://apache.org/licenses/LICENSE-2.0
//
//  Contributors: Arrow Electronics, Inc.
//                Konexios, Inc.
//

import Foundation

public class TelemetryModel {
    
    public var hid: String
    public var name: String
    public var type: String
    public var deviceHid: String
    public var pri: String
    
    public var timestamp: Double
    
    public var binaryValue: String?
    public var boolValue: Bool?
    public var dateValue: String?
    public var datetimeValue: String?
    
    public var floatCubeValue: String?
    public var floatSqrValue: String?
    public var floatValue: Double?
    
    public var intCubeValue: String?
    public var intSqrValue: String?
    public var intValue: Int?
    
    public var strValue: String?
    
    init (json: [String : AnyObject]) {
        hid       = json["hid"] as? String ?? ""
        name      = json["name"] as? String ?? ""
        type      = json["type"] as? String ?? ""
        deviceHid = json["deviceHid"] as? String ?? ""
        pri       = json["pri"] as? String ?? ""
        
        timestamp = json["timestamp"] as? Double ?? 0

        binaryValue   = json["binaryValue"] as? String
        boolValue     = json["boolValue"] as? Bool
        dateValue     = json["dateValue"] as? String
        datetimeValue = json["datetimeValue"] as? String
        
        floatCubeValue = json["floatCubeValue"] as? String
        floatSqrValue  = json["floatSqrValue"] as? String
        floatValue     = json["floatValue"] as? Double
        
        intCubeValue = json["intCubeValue"] as? String
        intSqrValue  = json["intSqrValue"] as? String
        intValue     = json["intValue"] as? Int
        
        strValue = json["strValue"] as? String
    }
}
