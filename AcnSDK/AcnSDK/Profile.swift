//
//  Profile.swift
//  AcnSDK
//
//  Created by Tam Nguyen on 10/5/15.
//  Copyright © 2015 Arrow Electronics. All rights reserved.
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
