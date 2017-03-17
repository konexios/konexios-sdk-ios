//
//  DeviceEvent.swift
//  AcnSDK
//
//  Created by Michael Kalinin on 02/08/16.
//  Copyright © 2016 Arrow Electronics. All rights reserved.
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
