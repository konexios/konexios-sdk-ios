//
//  NodeTypeRequestModel.swift
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

public class NodeTypeRequestModel: RequestModel {
    public var name: String
    public var description: String
    public var deviceCategoryHid: String
    public var enabled: Bool
    
    public init(name: String, description: String, deviceCategoryHid: String, enabled: Bool) {
        self.name = name
        self.description = description
        self.deviceCategoryHid = deviceCategoryHid
        self.enabled = enabled
    }
    
    public override var params: [String : AnyObject] {
        return [
            "name" : name as AnyObject,
            "description" : description as AnyObject,
            "deviceCategoryHid" : deviceCategoryHid as AnyObject,
            "enabled" : enabled as AnyObject
        ]
    }
}
