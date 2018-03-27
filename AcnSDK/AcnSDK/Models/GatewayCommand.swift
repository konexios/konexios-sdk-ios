//
//  GatewayCommand.swift
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

public enum ServerToGatewayCommand: String {
    case DeviceStart = "ServerToGateway_DeviceStart"
    case DeviceStop = "ServerToGateway_DeviceStop"
    case DevicePropertyChange = "ServerToGateway_DevicePropertyChange"
    case DeviceStateRequest = "ServerToGateway_DeviceStateRequest"
    case DeviceCommand = "ServerToGateway_DeviceCommand"
    case GatewaySoftwareUpdate = "ServerToGateway_GatewaySoftwareUpdate"
    case DeviceSoftwareUpdate = "ServerToGateway_DeviceSoftwareUpdate"
    case DeviceSoftwareRelease = "ServerToGateway_DeviceSoftwareRelease"
}

class GatewayCommand {
    
    var command: ServerToGatewayCommand?
    
    var hid: String
    var name: String
    var encrypted: Bool
    
    var parameters: [String : AnyObject]
    
    var signature: String?
    var signatureVersion: String?

    
    init (json: [String : Any]) {
        hid = json["hid"] as? String ?? ""
        name = json["name"] as? String ?? ""
        encrypted = json["encrypted"] as? Bool ?? true
        
        parameters = json["parameters"] as? [String : AnyObject] ?? [String : AnyObject]()
        
        signature = json["signature"] as? String
        signatureVersion = json["signatureVersion"] as? String
        
        command = ServerToGatewayCommand(rawValue: name)
    }
}
