//
//  Definition.swift
//  AcnSDKSample
//
//  Created by Michael Kalinin on 25/11/2016.
//  Copyright © 2016 Arrow. All rights reserved.
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
