//
//  NodeRequestModel.swift
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

public class NodeRequestModel: RequestModel {
    public var name: String
    public var description: String
    public var parentNodeHid: String
    public var nodeTypeHid: String
    public var enabled: Bool
    
    init(name: String, description: String, parentNodeHid: String, nodeTypeHid: String, enabled: Bool) {
        self.name = name
        self.description = description
        self.parentNodeHid = parentNodeHid
        self.nodeTypeHid = nodeTypeHid
        self.enabled = enabled
    }
    
    public override var params: [String : AnyObject] {
        return [
            "name" : name as AnyObject,
            "description" : description as AnyObject,
            "parentNodeHid" : parentNodeHid as AnyObject,
            "nodeTypeHid" : nodeTypeHid as AnyObject,
            "enabled" : enabled as AnyObject
        ]
    }
}
