//
//  DeviceTelemetryModel.swift
//  AcnSDK
//
//  Created by Michael Kalinin on 17/10/2016.
//  Copyright © 2016 Arrow. All rights reserved.
//

import Foundation

public class DeviceTelemetryModel: BaseCloudModel {

    public var name: String
    public var type: String
    public var description: String
    public var controllable: Bool
    
    override var params: [String: AnyObject] {
        return [
            "name"          : name as AnyObject,
            "type"          : type as AnyObject,
            "description"   : description as AnyObject,
            "controllable"  : controllable as AnyObject
        ]
    }
    
    public init (name: String, type: String, description: String, controllable: Bool) {
        self.name = name
        self.type = type
        self.description = description
        self.controllable = controllable
    }
    
    init (json: [String : AnyObject]) {
        name         = json["name"] as? String ?? ""
        type         = json["type"] as? String ?? ""
        description  = json["description"] as? String ?? ""
        controllable = json["controllable"] as? Bool ?? false
    }
    

}
