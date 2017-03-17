//
//  NodeTypeModel.swift
//  AcnSDK
//
//  Created by Michael Kalinin on 17/10/2016.
//  Copyright © 2016 Arrow. All rights reserved.
//

import Foundation

public class NodeTypeModel: BaseCloudModel {
    
    public var hid: String
    public var createdBy: String
    public var createdDate: Date?
    public var lastModifiedBy: String
    public var lastModifiedDate: Date?
    public var name: String
    public var description: String
    public var enabled: Bool
    public var pri: String

    
    override var params: [String: AnyObject] {
        return [
            "name"          : name as AnyObject,
            "description"   : description as AnyObject,
            "enabled"       : enabled as AnyObject,
        ]
    }
    
    public init (name: String, description: String, enabled: Bool) {
        self.name = name
        self.description = description
        self.enabled = enabled
        
        hid = ""
        createdBy = ""
        createdDate = nil
        lastModifiedBy = ""
        lastModifiedDate = nil
        pri = ""
    }
    
    init (json: [String : AnyObject]) {
        hid              = json["hid"] as? String ?? ""
        createdBy        = json["createdBy"] as? String ?? ""
        createdDate      = (json["createdDate"] as? String)?.date
        lastModifiedBy   = json["lastModifiedBy"] as? String ?? ""
        lastModifiedDate = (json["lastModifiedDate"] as? String)?.date
        name             = json["name"] as? String ?? ""
        description      = json["description"] as? String ?? ""
        enabled          = json["enabled"] as? Bool ?? false
        pri              = json["pri"] as? String ?? ""
    }
    
}
