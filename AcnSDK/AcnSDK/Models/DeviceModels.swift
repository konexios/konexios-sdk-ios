//
//  DeviceRegistrationModel.swift
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

public class CreateDeviceModel: RequestModel {
    public var uid: String
    public var type: String
    public var name: String
    public var userHid: String
    public var gatewayHid: String
    public var enabled: Bool
    
    public var info = [String: AnyObject]()
    public var properties = [String: AnyObject]()
    public var tags = [String]()
    
    public init(device: IotDevice) {
        uid = device.deviceUid!
        type = device.deviceTypeName
        name = device.deviceName
        userHid = device.userHid
        gatewayHid = device.gatewayHid
        enabled = true
        
        let deviceInfo = DeviceInfoModel(device: device)
        info = deviceInfo.params
        properties = device.properties
    
        super.init()
    }
    
    public override var params: [String: AnyObject] {
        return [
            "uid"        : uid as AnyObject,
            "type"       : type as AnyObject,
            "name"       : name as AnyObject,
            "userHid"    : userHid as AnyObject,
            "gatewayHid" : gatewayHid as AnyObject,
            "enabled"    : enabled as AnyObject,
            "info"       : info as AnyObject,
            "properties" : properties as AnyObject,
            "tags"       : tags as AnyObject
        ]
    }
}

public class UpdateDeviceModel: CreateDeviceModel {
}

public class DeviceModel: AuditResponseModel {
    public var uid: String
    public var type: String
    public var name: String
    public var userHid: String
    public var gatewayHid: String
    public var enabled: Bool
    
    public var info: [String: AnyObject]
    public var properties: [String: AnyObject]
    public var tags: [String]
    
    override init(json: [String : AnyObject]) {
        uid         = json["uid"] as? String ?? ""
        type        = json["type"] as? String ?? ""
        name        = json["name"] as? String ?? ""
        userHid     = json["userHid"] as? String ?? ""
        gatewayHid  = json["gatewayHid"] as? String ?? ""
        enabled     = json["enabled"] as? Bool ?? false
        info        = json["info"] as? [String : AnyObject] ?? [String : AnyObject]()
        properties  = json["properties"] as? [String : AnyObject] ?? [String : AnyObject]()
        tags        = json["tags"] as? [String] ?? [String]()
        super.init(json: json)
    }
}
