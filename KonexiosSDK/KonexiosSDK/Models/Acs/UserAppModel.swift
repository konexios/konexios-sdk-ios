//
//  UserAppModel.swift
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

public class UserAppModel: UserModel {
    public var applicationHid: String
    public var zoneSystemName: String
    
    override init(json: [String : AnyObject]) {
        applicationHid = json["applicationHid"] as? String ?? ""
        zoneSystemName = json["zoneSystemName"] as? String ?? ""
        super.init(json: json)
    }
}
