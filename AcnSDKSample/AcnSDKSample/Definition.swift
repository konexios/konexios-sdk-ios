//
//  Definition.swift
//  AcnSDKSample
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

enum SensorType {
    case accelerometerX
    case accelerometerY
    case accelerometerZ
    case gyroscopeX
    case gyroscopeY
    case gyroscopeZ
    case magnetometerX
    case magnetometerY
    case magnetometerZ
}

struct Connection {
    static let IoTConnectUrl         = "http://pgsdev01.arrowconnect.io:12001"
    static let MQTTServerHost        = "pgsdev01.arrowconnect.io"
    static let MQTTServerPort:UInt16 = 1883
    static let MQTTVHost             = "/themis.dev"
}

struct Constants {
    
    struct Keys {
        static let DefaultApiKey = ""
        static let DefaultSecretKey = ""
    }
}
