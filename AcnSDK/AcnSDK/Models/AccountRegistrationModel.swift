//
//  AccountModel.swift
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

public class AccountRegistrationModel: BaseCloudModel {
    
    var name: String
    var email: String
    var password: String
    var code: String
    
    override var params: [String: AnyObject] {
        return [
            "name"     : name as AnyObject,
            "email"    : email as AnyObject,
            "password" : password as AnyObject,
            "code"     : code as AnyObject
        ]
    }
    
    public init(name: String, email: String, password: String, code: String) {
        self.name = name
        self.email = email
        self.password = password
        self.code = code
    }

}
