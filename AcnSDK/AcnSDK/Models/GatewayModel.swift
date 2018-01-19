//
//  File.swift
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

public class GatewayModel: RequestModel {
    
    enum GatewayType : String {
        case Local
        case Cloud
        case Mobile
    }

    public var hid: String
    public var uid: String
    public var name: String
    public var type: String
    public var userHid: String
    public var applicationHid: String
    public var osName: String
    public var softwareName: String
    public var softwareVersion: String
    public var sdkVersion: String
    
    override var params: [String: AnyObject] {
        return [
            "uid"             : uid as AnyObject,
            "name"            : name as AnyObject,
            "type"            : type as AnyObject,
            "userHid"         : userHid as AnyObject,
            "applicationHid"  : applicationHid as AnyObject,
            "osName"          : osName as AnyObject,
            "softwareName"    : softwareName as AnyObject,
            "softwareVersion" : softwareVersion as AnyObject,
            "sdkVersion"      : sdkVersion as AnyObject
        ]
    }
    
    override public init () {
        let device = UIDevice.current
        
        hid             = ""
        uid             = UIDevice.UUID()
        name            = device.model
        type            = GatewayType.Mobile.rawValue
        userHid         = ""
        applicationHid  = ""
        osName          = "\(device.systemName) \(device.systemVersion)"
        softwareName    = ""
        softwareVersion = ""
        sdkVersion      = String(AcnSDKVersionNumber)
    }
    
    init(dictionary: [String : AnyObject]) {
        hid             = dictionary["hid"] as? String ?? ""
        uid             = dictionary["uid"] as? String ?? ""
        name            = dictionary["name"] as? String ?? ""
        type            = dictionary["type"] as? String ?? ""
        userHid         = dictionary["userHid"] as? String ?? ""
        applicationHid  = dictionary["applicationHid"] as? String ?? ""
        osName          = dictionary["osName"] as? String ?? ""
        softwareName    = dictionary["softwareName"] as? String ?? ""
        softwareVersion = dictionary["softwareVersion"] as? String ?? ""
        sdkVersion      = dictionary["sdkVersion"] as? String ?? ""
    }
}
