//
//  DeviceCommand.swift
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

public enum IotConnectServiceCommand: String {
    case Start = "ServerToGateway_DeviceStart"
    case Stop = "ServerToGateway_DeviceStop"
    case PropertyChange = "ServerToGateway_DevicePropertyChange"
    case StateRequest = "ServerToGateway_DeviceStateRequest"
}

public class DeviceCommand: BaseCloudModel {

    public var command: String
    public var deviceHid: String
    public var payload: String
    
    override var params: [String: AnyObject] {
        return [
            "command"   : command as AnyObject,
            "deviceHid" : deviceHid as AnyObject,
            "payload"   : payload as AnyObject
        ]
    }
    
    public init (command: IotConnectServiceCommand, deviceHid: String) {
        self.command   = command.rawValue
        self.deviceHid = deviceHid
        self.payload   = ""
    }
    
}
