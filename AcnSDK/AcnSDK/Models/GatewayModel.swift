//
//  File.swift
//  AcnSDK
//
//  Created by Michael Kalinin on 15/04/16.
//  Copyright © 2016 Arrow Electronics. All rights reserved.
//

import Foundation

public class GatewayModel: BaseCloudModel {
    
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
    
    override var params: [String: AnyObject] {
        return [
            "uid"             : uid as AnyObject,
            "name"            : name as AnyObject,
            "type"            : type as AnyObject,
            "userHid"         : userHid as AnyObject,
            "applicationHid"  : applicationHid as AnyObject,
            "osName"          : osName as AnyObject,
            "softwareName"    : softwareName as AnyObject,
            "softwareVersion" : softwareVersion as AnyObject
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
    }
}
