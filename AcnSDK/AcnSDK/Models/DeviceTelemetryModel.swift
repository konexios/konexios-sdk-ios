//
//  DeviceTelemetryModel.swift
//  AcnSDK
//
//  Copyright (c) 2017 Arrow Electronics, Inc.
//  All rights reserved. This program and the accompanying materials
//  are made available under the terms of the Apache License 2.0
//  which accompanies this distribution, and is available at
//  http://apache.org/licenses/LICENSE-2.0
//
//  Contributors: Arrow Electronics, Inc.
//

import Foundation

public class DeviceTelemetryModel: RequestModel {

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
