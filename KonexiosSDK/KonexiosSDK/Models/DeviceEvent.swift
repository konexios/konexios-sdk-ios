//
//  DeviceEvent.swift
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

public class DeviceEvent {
    
    public var dateString: String {
        return createdDate?.dateString ?? ""
    }
    
    public var timeString: String {
        return createdDate?.timeString ?? ""
    }
    
    public var createdDate: Date?
    public var criteria: String
    public var deviceActionTypeName: String?
    public var status: String
    
    init (json: [String : AnyObject]) {
        createdDate          = (json["createdDate"] as? String)?.date
        deviceActionTypeName = json["deviceActionTypeName"] as? String
        criteria             = json["criteria"] as? String ?? ""
        status               = json["status"] as? String ?? ""
    }
    
}
