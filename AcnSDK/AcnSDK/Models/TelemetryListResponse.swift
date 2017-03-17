//
//  TelemetryListResponse.swift
//  AcnSDK
//
//  Created by Michael Kalinin on 27/12/2016.
//  Copyright © 2016 Arrow. All rights reserved.
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
