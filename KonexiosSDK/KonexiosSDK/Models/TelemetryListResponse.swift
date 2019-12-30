//
//  TelemetryListResponse.swift
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

class TelemetryListResponse {
    
    var page: Int
    var size: Int
    var totalPages: Int
    var totalSize: Int
    
    var telemetries = [TelemetryModel]()
    
    init (json: [String : AnyObject]) {

        page       = json["page"] as? Int ?? 0
        size       = json["size"] as? Int ?? 0
        totalPages = json["totalPages"] as? Int ?? 0
        totalSize  = json["totalSize"] as? Int ?? 0
        
        if let data = json["data"] as? [[String : AnyObject]] {
            for jsonTelemetry in data {
                telemetries.append(TelemetryModel(json: jsonTelemetry))
            }
        }
    }
    
}
