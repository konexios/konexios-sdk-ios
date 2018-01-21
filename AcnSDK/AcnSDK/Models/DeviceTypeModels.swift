//
//  DeviceTypeModel.swift
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

public enum AcnDeviceCategory : String {
    case GATEWAY
    case DEVICE
}

public class DeviceTypeTelemetryModel {
    public var name: String
    public var description: String
    public var type: String
    public var variables = [String: String]()
    
    init(name: String, description: String, type: String, variables: [String: String]) {
        self.name = name
        self.description = description
        self.type = type
        self.variables = variables
    }
    
    init(json: [String: AnyObject]) {
        self.name = json["name"] as? String ?? ""
        self.description = json["description"] as? String ?? ""
        self.type = json["type"] as? String ?? ""
        self.variables = json["variables"] as? [String: String] ?? [String: String]()
    }
    
    var params: [String: AnyObject] {
        return [
            "name" : name as AnyObject,
            "description" : description as AnyObject,
            "type" : type as AnyObject,
            "variables" : variables as AnyObject
        ]
    }
}

public class CreateDeviceTypeModel : RequestModel {
    public var name: String
    public var description: String
    public var telemetries = [DeviceTypeTelemetryModel]()
    public var stateMetadata = [String: DeviceStateValueMetadataModel]()
    public var enabled: Bool
    public var deviceCategory: AcnDeviceCategory
    
    init(name: String, description: String, telemetries: [DeviceTypeTelemetryModel], stateMetadata: [String: DeviceStateValueMetadataModel], enabled: Bool, deviceCategory: AcnDeviceCategory) {
        self.name = name
        self.description = description
        self.telemetries = telemetries
        self.stateMetadata = stateMetadata
        self.enabled = enabled
        self.deviceCategory = deviceCategory
    }
    
    override var params: [String : AnyObject] {
        var params = [
            "name" : name as AnyObject,
            "description" : description as AnyObject,
            "enabled" : enabled as AnyObject,
            "deviceCategory" : deviceCategory as AnyObject
        ]
        
        var jsonTelemetries = [[String: AnyObject]]()
        for telemetry in telemetries {
            jsonTelemetries.append(telemetry.params)
        }
        params["telemetries"] = jsonTelemetries as AnyObject
        
        var jsonStateMetadata = [String: [String: AnyObject]]()
        for key in stateMetadata.keys {
            jsonStateMetadata[key] = stateMetadata[key]!.params
        }
        params["stateMetadata"] = jsonStateMetadata as AnyObject
        return params
    }
}

public class UpdateDeviceTypeModel : CreateDeviceTypeModel {
}

public class DeviceTypeModel: DefinitionResponseModel {
    public var deviceCategory: AcnDeviceCategory
    public var telemetries = [DeviceTypeTelemetryModel]()
    public var stateMetadata = [String: DeviceStateValueMetadataModel]()
    
    override init(json: [String : AnyObject]) {
        deviceCategory = json["deviceCategory"] as? AcnDeviceCategory ?? AcnDeviceCategory.GATEWAY
        if let jsonTelemetries = json["telemetries"] as? [[String : AnyObject]] {
            for jsonTelemetry in jsonTelemetries {
                telemetries.append(DeviceTypeTelemetryModel(json: jsonTelemetry))
            }
        }
        if let jsonStateMetadata = json["stateMetadata"] as? [String: [String: AnyObject]] {
            for key in jsonStateMetadata.keys {
                stateMetadata[key] = DeviceStateValueMetadataModel(json: jsonStateMetadata[key]!)
            }
        }
        super.init(json: json)
    }
    
}
