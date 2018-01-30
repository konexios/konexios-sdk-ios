//
//  GatewayModels.swift
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

public enum GatewayType : String {
    case Local = "Local"
    case Cloud = "Cloud"
    case Mobile = "Mobile"
}

public class GatewayModel: AuditResponseModel {   
    public var uid: String
    public var name: String
    public var type: String
    public var deviceType: String
    public var userHid: String
    public var osName: String
    public var softwareName: String
    public var softwareVersion: String
    public var sdkVersion: String
    public var applicationHid: String
  
    override init(json: [String : AnyObject]) {
        self.uid             = json["uid"] as? String ?? ""
        self.name            = json["name"] as? String ?? ""
        self.type            = json["type"] as? String ?? ""
        self.deviceType      = json["deviceType"] as? String ?? ""
        self.userHid         = json["userHid"] as? String ?? ""
        self.osName          = json["osName"] as? String ?? ""
        self.softwareName    = json["softwareName"] as? String ?? ""
        self.softwareVersion = json["softwareVersion"] as? String ?? ""
        self.sdkVersion      = json["sdkVersion"] as? String ?? ""
        self.applicationHid  = json["applicationHid"] as? String ?? ""
        super.init(json: json)
    }
}

public class CreateGatewayModel: RequestModel {
    let DefaultDeviceType = "default-gateway"
    
    public var uid: String
    public var name: String
    public var type: GatewayType
    public var deviceType: String
    public var userHid: String
    public var osName: String
    public var softwareName: String
    public var softwareVersion: String
    public var sdkVersion: String
    public var applicationHid: String
    
    public override var params: [String: AnyObject] {
        return [
            "uid"             : uid as AnyObject,
            "name"            : name as AnyObject,
            "type"            : type.rawValue as AnyObject,
            "deviceType"      : deviceType as AnyObject,
            "userHid"         : userHid as AnyObject,
            "osName"          : osName as AnyObject,
            "softwareName"    : softwareName as AnyObject,
            "softwareVersion" : softwareVersion as AnyObject,
            "sdkVersion"      : sdkVersion as AnyObject,
            "applicationHid"  : applicationHid as AnyObject
        ]
    }
    
    override public init () {
        let device = UIDevice.current
        
        uid             = UIDevice.UUID()
        name            = device.model
        type            = GatewayType.Mobile
        deviceType      = DefaultDeviceType
        userHid         = ""
        applicationHid  = ""
        osName          = "\(device.systemName) \(device.systemVersion)"
        softwareName    = ""
        softwareVersion = ""
        sdkVersion      = String(AcnSDKVersionNumber)
    }
}

public class UpdateGatewayModel: CreateGatewayModel {
    public var hid: String
    
    public override var params: [String : AnyObject] {
        var result = super.params
        result["hid"] = hid as AnyObject
        return result;
    }
    
    override public init() {
        hid = ""
        super.init()
    }
}
