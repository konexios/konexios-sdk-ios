//
//  DeviceRegistrationModel.swift
//  AcnSDK
//
//  Created by Michael Kalinin on 21/04/16.
//  Copyright © 2016 Arrow Electronics. All rights reserved.
//

import Foundation

public class DeviceModel: BaseCloudModel {
    
    public var createdDate: Date?
    public var hid: String
    public var uid: String
    public var type: String
    public var name: String
    public var userHid: String
    public var gatewayHid: String
    public var enabled: Bool
    
    public var info: [String: AnyObject]
    public var properties: [String: AnyObject]
    
    override var params: [String: AnyObject] {
        return [
            "uid"        : uid as AnyObject,
            "type"       : type as AnyObject,
            "name"       : name as AnyObject,
            "userHid"    : userHid as AnyObject,
            "gatewayHid" : gatewayHid as AnyObject,
            "info"       : info as AnyObject,
            "properties" : properties as AnyObject
        ]
    }
    
    init (device: IotDevice) {
        
        hid = ""
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
    
    init (json: [String : AnyObject]) {
        
        createdDate = (json["createdDate"] as? String)?.date
        
        hid         = json["hid"] as? String ?? ""
        uid         = json["uid"] as? String ?? ""
        type        = json["type"] as? String ?? ""
        name        = json["name"] as? String ?? ""
        userHid     = json["userHid"] as? String ?? ""
        gatewayHid  = json["gatewayHid"] as? String ?? ""
        enabled     = json["enabled"] as? Bool ?? false
        
        info        = json["info"] as? [String : AnyObject] ?? [String : AnyObject]()
        properties  = json["properties"] as? [String : AnyObject] ?? [String : AnyObject]()
    }
}
