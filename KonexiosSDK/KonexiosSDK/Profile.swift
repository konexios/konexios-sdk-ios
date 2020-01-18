//
//  Profile.swift
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

import Foundation

public enum CloudPlatform: String {
    case IotConnect     = "IotConnect"
    case Ibm            = "Ibm"
    case Aws            = "Aws"
    case Azure          = "Azure"
}

public class Profile {
    // Singleton
    public static let sharedInstance = Profile()
    
    static let KeyCloudConfig = "cloud-config"
    public var cloudConfig: GatewayConfigResponse?
    
    public func reload() {
        let defaults = UserDefaults.standard
        if let data = defaults.data(forKey: Profile.KeyCloudConfig) {
            cloudConfig = NSKeyedUnarchiver.unarchiveObject(with: data) as? GatewayConfigResponse
        }
    }
    
    // MARK: Cloud Configuration
    
    public func saveCloudConfig(config: GatewayConfigResponse) -> Profile {
        let defaults = UserDefaults.standard
        defaults.set(NSKeyedArchiver.archivedData(withRootObject: config), forKey: Profile.KeyCloudConfig)
        defaults.synchronize()
        return self;
    }
    
    // MARK: Private
    
    private init() {
    }
}
