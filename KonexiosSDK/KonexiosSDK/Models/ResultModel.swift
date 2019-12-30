//
//  ResultModel.swift
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

public class ResultModel: ResponseModel {
    public var message: String
    
    override init (json: [String : AnyObject]) {
        message = json["message"] as? String ?? ""
        super.init(json: json)
    }
}
