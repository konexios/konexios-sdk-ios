//
//  GatewayLog.swift
//  AcnSDK
//
//  Created by Michael Kalinin on 12/10/2016.
//  Copyright © 2016 Arrow. All rights reserved.
//

import Foundation

public class GatewayLog {

    public var createdBy: String
    public var createdDate: Date?
    public var objectHid: String
    public var productName: String
    public var type: String
    
    public var parameters: [String : AnyObject]
    
    init (json: [String : AnyObject]) {
        
        createdBy   = json["createdBy"] as? String ?? ""
        createdDate = (json["createdDate"] as? String)?.date
        objectHid   = json["objectHid"] as? String ?? ""
        productName = json["productName"] as? String ?? ""
        type        = json["type"] as? String ?? ""
        parameters  = json["parameters"] as? [String : AnyObject] ?? [String : AnyObject]()
    }
    
}
