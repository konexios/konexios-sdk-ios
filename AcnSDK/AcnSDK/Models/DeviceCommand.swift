//
//  DeviceCommand.swift
//  AcnSDK
//
//  Created by Michael Kalinin on 12/10/2016.
//  Copyright © 2016 Arrow. All rights reserved.
//

import Foundation

public enum IotConnectServiceCommand: String {
    case Start = "ServerToGateway_DeviceStart"
    case Stop = "ServerToGateway_DeviceStop"
    case PropertyChange = "ServerToGateway_DevicePropertyChange"
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
