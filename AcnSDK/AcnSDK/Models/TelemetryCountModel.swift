//
//  TelemetryCountModel.swift
//  AcnSDK
//
//  Created by Michael Kalinin on 31/03/2017.
//  Copyright © 2017 Arrow. All rights reserved.
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
