//
//  ResultModel.swift
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

public class ResultModel: ModelAbstract {
    
    public var message: String
    
    init(hid: String, message: String) {
        self.message = message
        super.init(hid: hid)        
    }
}
