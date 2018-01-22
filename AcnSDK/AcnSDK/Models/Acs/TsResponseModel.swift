//
//  TsModelAbstract.swift
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

public class TsResponseModel: ResponseModel {
    public var createdDate: Date?
    public var createdBy: String
    
    override init(json: [String : AnyObject]) {
        createdDate = (json["createdDate"] as? String)?.date
        createdBy = json["createdBy"] as? String ?? ""
        super.init(json: json)
    }
}
