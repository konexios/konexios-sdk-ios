//
//  DeviceStateModels.swift
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

public enum DeviceStateValueType : String {
    case String = "String"
    case StringList = "StringList"
    case Integer = "Integer"
    case IntegerList = "IntegerList"
    case Float = "Float"
    case Boolean = "Boolean"
}

public struct DeviceStateValueModel {
    public var value: String
    public var timestamp: String
    
    init (json: [String : AnyObject]) {
        value = json["value"] as? String ?? ""
        timestamp = json["timestamp"] as? String ?? ""
    }
}

public struct DeviceStateValueMetadataModel {
    public var name: String
    public var description: String
    public var type: DeviceStateValueType
    
    init(name: String, description: String, type: DeviceStateValueType) {
        self.name = name
        self.description = description
        self.type = type
    }
    
    init(json: [String: AnyObject]) {
        self.name = json["name"] as? String ?? ""
        self.description = json["description"] as? String ?? ""
        self.type = json["type"] as? DeviceStateValueType ?? DeviceStateValueType.String
    }
    
    var params: [String: AnyObject] {
        return [
            "name" : name as AnyObject,
            "description" : description as AnyObject,
            "type" : type.rawValue as AnyObject
        ]
    }
}

public class DeviceStateRequestModel: RequestModel {
    public var states: [String: String]
    public var timestamp: String
    
    init(states: [String: String], timestamp: String) {
        self.states = states
        self.timestamp = timestamp
    }
    
    override public var params: [String : AnyObject] {
        var result = super.params
        result["states"] = states as AnyObject
        result["timestamp"] = timestamp as AnyObject
        return result
    }
}

public class DeviceStateUpdateModel: DeviceStateRequestModel {
}

public class DeviceStateModel: ResponseModel {
    
    public var deviceHid: String
    public var states: [String : DeviceStateValueModel]
    
    override init (json: [String : AnyObject]) {
        deviceHid = json["deviceHid"] as? String ?? ""
        states = [String: DeviceStateValueModel]()
        if let data = json["states"] as? [String: [String: AnyObject]] {
            for key in data.keys {
                states[key] = DeviceStateValueModel(json: data[key]!)
            }
        }
        super.init(json: json)
    }
}
