//
//  AccountModel.swift
//  AcnSDK
//
//  Created by Michael Kalinin on 15/04/16.
//  Copyright © 2016 Arrow Electronics. All rights reserved.
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
