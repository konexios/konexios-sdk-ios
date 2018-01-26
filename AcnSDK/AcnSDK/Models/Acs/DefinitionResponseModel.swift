//
//  DefinitionModelAbstract.swift
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

open class DefinitionResponseModel: AuditResponseModel {
    public var name: String
    public var description: String
    public var enabled: Bool
    
    override init(json: [String : AnyObject]) {
        name = json["name"] as? String ?? ""
        description = json["description"] as? String ?? ""
        enabled = json["enabled"] as? Bool ?? false
        super.init(json: json)
    }
}
