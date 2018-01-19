//
//  DeviceInfoModel.swift
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

class DeviceInfoModel: RequestModel {
    
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
