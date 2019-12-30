//
//  ContactModel.swift
//  KonexiosSDK
//
//  Copyright (c) 2017 Arrow Electronics, Inc.
//  All rights reserved. This program and the accompanying materials
//  are made available under the terms of the Apache License 2.0
//  which accompanies this distribution, and is available at
//  http://apache.org/licenses/LICENSE-2.0
//
//  Contributors: Arrow Electronics, Inc.
//                Konexios, Inc.
//

public struct ContactModel {
    public var firstName: String
    public var lastName: String
    public var sipUri: String
    public var email: String
    public var home: String
    public var office: String
    public var cell: String
    public var fax: String
    public var monitorExt: String
    
    init(json: [String : AnyObject]) {
        firstName = json["firstName"] as? String ?? ""
        lastName = json["lastName"] as? String ?? ""
        sipUri = json["sipUri"] as? String ?? ""
        email = json["email"] as? String ?? ""
        home = json["home"] as? String ?? ""
        office = json["office"] as? String ?? ""
        cell = json["cell"] as? String ?? ""
        fax = json["fax"] as? String ?? ""
        monitorExt = json["monitorExt"] as? String ?? ""
    }
}
