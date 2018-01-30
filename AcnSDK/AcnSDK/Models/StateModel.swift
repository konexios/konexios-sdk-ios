//
//  StateModel.swift
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

public class StateModel: RequestModel {
    
    public var timestamp: String
    public var states: [String : Any]
    
    public override var params: [String : AnyObject] {
        return [
            "timestamp" : timestamp as AnyObject,
            "states"    : states as AnyObject
        ]
    }
    
    public init (states: [String : Any]) {
        self.timestamp = Date().formatted
        self.states = states
    }    
}
