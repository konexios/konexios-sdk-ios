//
//  DeviceSoftwareRelease.swift
//  AcnSDK
//
//  Copyright © 2018 Arrow. All rights reserved.
//

import Foundation

public class DeviceSoftwareRelease: CustomStringConvertible {
    
    public var releaseHid: String
    public var releaseName: String
    
    public var releaseLabel: String = ""
    public var releaseVersion: String = ""
    
    init(json: [String: Any]) {
        releaseHid = (json["softwareReleaseHID"] as? String) ?? ""
        releaseName = (json["softwareReleaseName"] as? String) ?? ""
        
        let arr = releaseName.split(separator: " ")
        if arr.count > 1 {
            releaseLabel = String(arr[0])
            releaseVersion = String(arr[1])
        }
    }
    
    
    public var description: String {
        return """
        DeviceSoftwareRelease {
            hid: \(releaseHid),
            name: \(releaseName),
            label: \(releaseLabel),
            version: \(releaseVersion) }
        """
    }
}
