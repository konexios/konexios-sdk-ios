//
//  UIDevice+Extension.swift
//  AcnSDK
//
//  Created by Michael Kalinin on 01/08/16.
//  Copyright © 2016 Arrow Electronics. All rights reserved.
//

import Foundation

public extension UIDevice {
    
    public class func UUID() -> String {
        
        let bundleName = Bundle.main.infoDictionary!["CFBundleName"] as! String
        let accountName = "incoding"
        
        var applicationUUID = SAMKeychain.password(forService: bundleName, account: accountName)
        
        if applicationUUID == nil {
            
            applicationUUID = UIDevice.current.identifierForVendor!.uuidString
            
            // Save applicationUUID in keychain without synchronization
            let query = SAMKeychainQuery()
            query.service = bundleName
            query.account = accountName
            query.password = applicationUUID
            query.synchronizationMode = SAMKeychainQuerySynchronizationMode.no
            
            do {
                try query.save()
            } catch let error as NSError {
                print("SAMKeychainQuery Exception: \(error)")
            }
        }
        
        return applicationUUID!
    }
    
}
