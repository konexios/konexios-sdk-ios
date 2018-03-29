//
//  DeviceSoftwareRelease.swift
//  AcnSDK
//
//  Copyright © 2018 Arrow. All rights reserved.
//

import Foundation

public class DeviceSoftwareRelease {
    
    public var releaseHid: String
    public var releaseLabelName: String = ""
    public var releaseVersion: String = ""
    
    public var releaseName: String {
        didSet {
            let arr = releaseName.split(separator: " ")
            if arr.count == 2 {
                releaseLabelName = arr[0]
                releaseVersion = arr[1]
            }
        }
    }
    
    init(json: [String: Any]) {
        releaseHid = (json["softwareReleaseHID"] as? String) ?? ""
        releaseName = (json["softwareReleaseName"] as? String) ?? ""
    }
}
