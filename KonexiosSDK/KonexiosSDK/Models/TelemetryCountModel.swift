//
//  TelemetryCountModel.swift
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

public class TelemetryCountModel {
    
    public var deviceHid: String
    public var name: String
    public var value: Int
    
    init (json: [String : AnyObject]) {
        deviceHid = json["deviceHid"] as? String ?? ""
        name      = json["name"] as? String ?? ""
        
        if let stringValue = json["value"] as? String {
            value = Int(stringValue) ?? 0
        } else {
            value = 0
        }
    }

}
