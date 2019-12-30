//
//  CoreApi.swift
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

public class CoreApi {
    let CoreEventFailedUrl = "/api/v1/core/events/%@/failed"
    let CoreEventReceivedUrl = "/api/v1/core/events/%@/received"
    let CoreEventSucceededUrl = "/api/v1/core/events/%@/succeeded"
    
    // MARK: CoreEvent
    
    public func coreEventFailed(hid: String, error: String, completionHandler: @escaping (_ success: Bool) -> Void) {
        let formatURL = String(format: CoreEventFailedUrl, hid)
        let errorModel = ErrorModel(error: error)
        KonexiosIot.sharedInstance.sendIotCommonRequest(
            urlString: formatURL,
            method: .put,
            model: errorModel,
            info: "Core event failed"
        ) { _, success in
            completionHandler(success)
        }
    }
    
    public func coreEventReceived(hid: String, completionHandler: @escaping (_ success: Bool) -> Void) {
        let formatURL = String(format: CoreEventReceivedUrl, hid)
        KonexiosIot.sharedInstance.sendIotCommonRequest(
            urlString: formatURL,
            method: .put,
            model: nil,
            info: "Core event received"
        ) { _, success in
            completionHandler(success)
        }
    }
    
    public func coreEventSucceeded(hid: String, completionHandler: @escaping (_ success: Bool) -> Void) {
        let formatURL = String(format: CoreEventSucceededUrl, hid)
        KonexiosIot.sharedInstance.sendIotCommonRequest(
            urlString: formatURL,
            method: .put,
            model: nil,
            info: "Core event succeeded"
        ) { _, success in
            completionHandler(success)
        }
    }
}
