//
//  AddressModel.swift
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

public struct AddressModel {
    public var address1: String
    public var address2: String
    public var city: String
    public var state: String
    public var zip: String
    public var country: String
    
    init(json: [String : AnyObject]) {
        address1 = json["address1"] as? String ?? ""
        address2 = json["address2"] as? String ?? ""
        city = json["city"] as? String ?? ""
        state = json["state"] as? String ?? ""
        zip = json["zip"] as? String ?? ""
        country = json["country"] as? String ?? ""
    }
}
