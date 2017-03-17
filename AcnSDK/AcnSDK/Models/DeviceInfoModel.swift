//
//  DeviceInfoModel.swift
//  AcnSDK
//
//  Created by Michael Kalinin on 10/06/16.
//  Copyright © 2016 Arrow Electronics. All rights reserved.
//

import Foundation

class DeviceInfoModel: BaseCloudModel {
    
    var uid: String
    var type: String
    var name: String
    var bleAddress: String
    
    override var params: [String: AnyObject] {
        return [
            "uid"        : uid as AnyObject,
            "type"       : type as AnyObject,
            "name"       : name as AnyObject,
            "bleAddress" : bleAddress as AnyObject
        ]
    }
    
    init (device: IotDevice) {
        
        uid = device.deviceUid!
        type = device.deviceTypeName
        name = device.deviceName
        bleAddress = ""
        
        super.init()
    }
    
    
}
