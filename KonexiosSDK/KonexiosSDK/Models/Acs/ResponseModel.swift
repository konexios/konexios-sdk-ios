//
//  ModelAbstract.swift
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

open class ResponseModel {
    
    public var hid: String
    public var pri: String
        
    init(json: [String : AnyObject]) {
        hid = json["hid"] as? String ?? ""
        pri = json["pri"] as? String ?? ""
    }
}
