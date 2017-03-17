//
//  NodeModel.swift
//  AcnSDK
//
//  Created by Michael Kalinin on 13/10/2016.
//  Copyright © 2016 Arrow. All rights reserved.
//

import Foundation

public class NodeModel: BaseCloudModel {
    
    public var hid: String
    public var createdBy: String
    public var createdDate: Date?
    public var lastModifiedBy: String
    public var lastModifiedDate: Date?
    public var name: String
    public var description: String
    public var enabled: Bool    
    public var nodeTypeHid: String
    public var parentNodeHid: String
    
    override var params: [String: AnyObject] {
        return [
            "name"          : name as AnyObject,
            "description"   : description as AnyObject,
            "enabled"       : enabled as AnyObject,
            "nodeTypeHid"   : nodeTypeHid as AnyObject,
            "parentNodeHid" : parentNodeHid as AnyObject
        ]
    }
    
    public init (name: String, description: String, enabled: Bool, nodeTypeHid: String, parentNodeHid: String) {
        self.name = name
        self.description = description
        self.enabled = enabled
        self.nodeTypeHid = nodeTypeHid
        self.parentNodeHid = parentNodeHid
        
        hid = ""
        createdBy = ""
        createdDate = nil
        lastModifiedBy = ""
        lastModifiedDate = nil        
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
        nodeTypeHid      = json["nodeTypeHid"] as? String ?? ""
        parentNodeHid    = json["parentNodeHid"] as? String ?? ""
    }
    
}
