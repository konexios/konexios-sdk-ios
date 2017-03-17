//
//  IotDevice.swift
//  AcnSDK
//
//  Created by Michael Kalinin on 21/09/16.
//  Copyright © 2016 Arrow. All rights reserved.
//

import Foundation

public protocol IotDevice {
    var deviceUid: String? { get }
    var userHid: String { get }
    var gatewayHid: String { get }
    var deviceTypeName: String { get }
    var deviceName: String { get }
    var properties: [String: AnyObject] { get }
    
}
