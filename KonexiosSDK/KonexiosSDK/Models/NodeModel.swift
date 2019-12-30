//
//  NodeModel.swift
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

public class NodeModel: DefinitionResponseModel {
    
    public var nodeTypeHid: String
    public var parentNodeHid: String
    
    override init (json: [String : AnyObject]) {
        nodeTypeHid      = json["nodeTypeHid"] as? String ?? ""
        parentNodeHid    = json["parentNodeHid"] as? String ?? ""
        super.init(json: json)
    }
}
