//
//  AccountRegistrationResponse.swift
//  AcnSDK
//
//  Created by Michael Kalinin on 15/04/16.
//  Copyright © 2016 Arrow Electronics. All rights reserved.
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
