//
//  AccountRegistrationResponse.swift
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

public class AccountRegistrationResponse: ResultModel {
    
    public var email: String
    public var name: String
    public var applicationHid: String
    
    override init(json: [String : AnyObject]) {
        email          = json["email"] as? String ?? ""
        name           = json["name"] as? String ?? ""
        applicationHid = json["applicationHid"] as? String ?? ""
        super.init(json: json)
    }
}
