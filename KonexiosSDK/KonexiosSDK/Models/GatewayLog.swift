//
//  GatewayLog.swift
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

public class GatewayLog {

    public var createdBy: String
    public var createdDate: Date?
    public var objectHid: String
    public var productName: String
    public var type: String
    
    public var parameters: [String : AnyObject]
    
    init (json: [String : AnyObject]) {
        
        createdBy   = json["createdBy"] as? String ?? ""
        createdDate = (json["createdDate"] as? String)?.date
        objectHid   = json["objectHid"] as? String ?? ""
        productName = json["productName"] as? String ?? ""
        type        = json["type"] as? String ?? ""
        parameters  = json["parameters"] as? [String : AnyObject] ?? [String : AnyObject]()
    }
    
}
