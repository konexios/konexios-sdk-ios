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
    
    init(dictionary: [String : AnyObject]) {
        email          = dictionary["email"] as? String ?? ""
        name           = dictionary["name"] as? String ?? ""
        applicationHid = dictionary["applicationHid"] as? String ?? ""
        let message    = dictionary["message"] as? String ?? ""
        let hid        = dictionary["hid"] as? String ?? ""
        super.init(hid: hid, message: message)
    }
}
