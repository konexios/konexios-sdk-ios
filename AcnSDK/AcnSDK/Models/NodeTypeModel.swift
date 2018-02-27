//
//  NodeTypeModel.swift
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

public class NodeTypeModel: DefinitionResponseModel {

    public var deviceCategoryHid: String
    
    override init (json: [String : AnyObject]) {
        deviceCategoryHid = json["deviceCategoryHid"] as? String ?? ""
        super.init(json: json)
    }
}
