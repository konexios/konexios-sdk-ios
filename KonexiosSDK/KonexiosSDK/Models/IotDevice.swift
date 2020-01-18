//
//  IotDevice.swift
//  KonexiosSDK
//
//  Copyright (c) 2017 Arrow Electronics, Inc.
//  All rights reserved. This program and the accompanying materials
//  are made available under the terms of the Apache License 2.0
//  which accompanies this distribution, and is available at
//  http://apache.org/licenses/LICENSE-2.0
//
//  Contributors: Arrow Electronics, Inc.
//                Konexios, Inc.
//

import Foundation

public protocol IotDevice {
    var deviceUid: String? { get }
    var userHid: String { get }
    var gatewayHid: String { get }
    var deviceTypeName: String { get }
    var deviceName: String { get }
    var properties: [String: AnyObject] { get }
    var softwareName: String { get }
    var softwareVersion: String { get }
}
