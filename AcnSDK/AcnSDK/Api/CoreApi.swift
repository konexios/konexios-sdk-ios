//
//  CoreApi.swift
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

public class CoreApi {
    let CoreEventFailedUrl = "/api/v1/core/events/%@/failed"
    let CoreEventReceivedUrl = "/api/v1/core/events/%@/received"
    let CoreEventSucceededUrl = "/api/v1/core/events/%@/succeeded"
    
    // MARK: CoreEvent
    
    public func coreEventFailed(hid: String, error: String, completionHandler: @escaping (_ success: Bool) -> Void) {
        let formatURL = String(format: CoreEventFailedUrl, hid)
        let errorModel = ErrorModel(error: error)
        ArrowConnectIot.sharedInstance.sendCommonRequest(baseUrlString: ArrowConnectIot.sharedInstance.IotUrl!,
                                                         urlString: formatURL,
                                                         method: .PUT,
                                                         model: errorModel,
                                                         info: "Core event failed") { _, success in
            completionHandler(success)
        }
    }
    
    public func coreEventReceived(hid: String, completionHandler: @escaping (_ success: Bool) -> Void) {
        let formatURL = String(format: CoreEventReceivedUrl, hid)
        ArrowConnectIot.sharedInstance.sendCommonRequest(baseUrlString: ArrowConnectIot.sharedInstance.IotUrl!,
                                                         urlString: formatURL,
                                                         method: .PUT,
                                                         model: nil,
                                                         info: "Core event received") { _, success in
            completionHandler(success)
        }
    }
    
    public func coreEventSucceeded(hid: String, completionHandler: @escaping (_ success: Bool) -> Void) {
        let formatURL = String(format: CoreEventSucceededUrl, hid)
        ArrowConnectIot.sharedInstance.sendCommonRequest(baseUrlString: ArrowConnectIot.sharedInstance.IotUrl!,
                                                         urlString: formatURL,
                                                         method: .PUT,
                                                         model: nil,
                                                         info: "Core event succeeded") { _, success in
            completionHandler(success)
        }
    }
}

