//
//  UserModel.swift
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

public class UserModel: AuditResponseModel {
    public var login: String
    public var status: String
    public var companyHid: String
    public var contact: ContactModel
    public var address: AddressModel
    public var roleHids: [String]
    
    override init(json: [String : AnyObject]) {
        login = json["login"] as? String ?? ""
        status = json["status"] as? String ?? ""
        companyHid = json["companyHid"] as? String ?? ""
        contact = ContactModel(json: json)
        address = AddressModel(json: json)
        roleHids = json["roleHids"] as? [String] ?? [String]()
        super.init(json: json)
    }
}
