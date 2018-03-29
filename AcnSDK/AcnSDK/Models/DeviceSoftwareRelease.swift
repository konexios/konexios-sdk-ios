//
//  DeviceSoftwareRelease.swift
//  AcnSDK
//
//  Copyright © 2018 Arrow. All rights reserved.
//

import Foundation

public class DeviceSoftwareRelease: CustomStringConvertible {
    
    public var releaseHid: String
    public var releaseLabelName: String = ""
    public var releaseVersion: String = ""
    
    public var releaseName: String {
        didSet {
            let arr = releaseName.split(separator: " ")
            if arr.count == 2 {
                releaseLabelName = String(arr[0])
                releaseVersion = String(arr[1])
            }
        }
    }
    
    init(json: [String: Any]) {
        releaseHid = (json["softwareReleaseHID"] as? String) ?? ""
        releaseName = (json["softwareReleaseName"] as? String) ?? ""
    }
    
    public var description: String {
        return """
        DeviceSoftwareRelease { \n
            hid: \(releaseHid),\n
            name: \(releaseName),\n
            label: \(releaseLabelName),\n
            version: \(releaseVersion)\n
        }
        """
    }
}
