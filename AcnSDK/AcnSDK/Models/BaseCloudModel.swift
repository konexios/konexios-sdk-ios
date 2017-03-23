//
//  BaseCloudModel.swift
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

public class BaseCloudModel {
    
    var params: [String: AnyObject] {
        preconditionFailure("[BaseCloudModel] - Abstract property: params")
    }
    
    var payloadString: String? {
        do {
            let payloadData = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions())
            return String(data: payloadData, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            print("[GatewayModel] JSON Exception: \(error)")
            return nil
        }
    }
}
