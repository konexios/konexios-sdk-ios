//
//  UserAppAuthenticationModel.swift
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

public class UserAppAuthenticationModel: UserAuthenticationModel {
    public var applicationCode: String
    
    public init(username: String, password: String, applicationCode: String) {
        self.applicationCode = applicationCode
        super.init(username: username, password: password)
    }
    
    override var params: [String : AnyObject] {
        var result = super.params
        result["applicationCode"] = applicationCode as AnyObject
        return result
    }
}
