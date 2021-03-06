//
//  SoftwareReleaseApi.swift
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

public class SoftwareReleaseApi {
    let ScheduleUrl = "/api/v1/kronos/software/releases/schedules"
    let ScheduleStartUrl = "/api/v1/kronos/software/releases/schedules/start" // POST
    let ScheduleHidUrl = "/api/v1/kronos/software/releases/schedules/%@"
    let ScheduleHidTransUrl = "/api/v1/kronos/software/releases/schedules/%@/transactions"

    let TransactionUrl = "/api/v1/kronos/software/releases/transactions"
    let TransactionDeviceUpgradeUrl = "/api/v1/kronos/software/releases/transactions/devices/upgrade"
    let TransactionGatewayUpgradeUrl = "/api/v1/kronos/software/releases/transactions/gateways/upgrade"
    let TransactionFailedUrl = "/api/v1/kronos/software/releases/transactions/%@/failed"
    let TransactionReceivedUrl = "/api/v1/kronos/software/releases/transactions/%@/received"
    let TransactionStartUrl = "/api/v1/kronos/software/releases/transactions/%@/start"
    let TransactionSucceededUrl = "/api/v1/kronos/software/releases/transactions/%@/succeeded"
    let TransactionFileUrl = "/api/v1/kronos/software/releases/transactions/%@/%@/file"

    /// holds download requests for temporary file tokens
    public var downloadRequests = [String: DownloadRequest]()

    // MARK: Software Release Schedule

    public func schedules(completionHandler: @escaping (_ devices: [SoftwareReleaseScheduleModel]?) -> Void) {
        KonexiosIot.sharedInstance.sendIotCommonRequest(
            urlString: ScheduleUrl,
            method: .get,
            model: nil,
            info: "Get schedules"
        ) { json, success in
            if success && json != nil {
                if let data = json!["data"] as? [[String: AnyObject]] {
                    var schedules = [SoftwareReleaseScheduleModel]()
                    for jsonDevice in data {
                        schedules.append(SoftwareReleaseScheduleModel(json: jsonDevice))
                    }
                    completionHandler(schedules)
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }

    public func findSchedule(hid: String, completionHandler: @escaping (_ device: SoftwareReleaseScheduleModel?) -> Void) {
        let formatURL = String(format: ScheduleHidUrl, hid)
        KonexiosIot.sharedInstance.sendIotCommonRequest(
            urlString: formatURL,
            method: .get,
            model: nil,
            info: "Find device"
        ) { json, success in
            if success && json != nil {
                if let data = json as? [String: AnyObject] {
                    completionHandler(SoftwareReleaseScheduleModel(json: data))
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    /// create software release update schedule and start it
    /// - parameter category: device category
    /// - parameter releaseHid: software release hid
    /// - parameter deviceHids: array of device hids to update
    /// - parameter userHid: user hid
    /// - parameter completionHandler: completion handler (success, errroMessage?)
    public func createScheduleAndStart(category: AcnDeviceCategory, releaseHid: String, deviceHids: [String], userHid: String, completionHandler: @escaping (_ success: Bool, _ errorMessage: String?) -> Void) {
        
        let requestModel = SoftwareReleaseScheduleStartModel(category: category, releaseHid: releaseHid, userHid: userHid, deviceHids: deviceHids)
        
        KonexiosIot.sharedInstance.sendIotCommonRequest(urlString: ScheduleStartUrl, method: .post, model: requestModel, info: "Software release scheduel and start") { resp, success in
            
            guard success else {
                if let json = resp as? [String: Any], let errorMessage = json["message"] as? String {
                    completionHandler(false, errorMessage)
                }
                else {
                    completionHandler(false, "Unknown error")
                }
                
                return
            }
            
            completionHandler(true, nil)
        }
    }

    /// create software release update schedule
    public func createSchedule(node: CreateSoftwareReleaseScheduleModel, completionHandler: @escaping (_ success: Bool) -> Void) {
        KonexiosIot.sharedInstance.sendIotCommonRequest(
            urlString: ScheduleUrl,
            method: .post,
            model: node,
            info: "Create schedule"
        ) { _, success in
            completionHandler(success)
        }
    }

    public func updateSchedule(hid: String, node: UpdateSoftwareReleaseScheduleModel, completionHandler: @escaping (_ success: Bool) -> Void) {
        let formatURL = String(format: ScheduleHidUrl, hid)
        KonexiosIot.sharedInstance.sendIotCommonRequest(
            urlString: formatURL,
            method: .put,
            model: node,
            info: "Update schedule"
        ) { _, success in
            completionHandler(success)
        }
    }

    public func scheduleTransactions(hid: String, completionHandler: @escaping (_ devices: [SoftwareReleaseTransModel]?) -> Void) {
        let formatURL = String(format: ScheduleHidTransUrl, hid)
        KonexiosIot.sharedInstance.sendIotCommonRequest(
            urlString: formatURL,
            method: .get,
            model: nil,
            info: "Get schedule transactions"
        ) { json, success in
            if success && json != nil {
                if let data = json!["data"] as? [[String: AnyObject]] {
                    var transactions = [SoftwareReleaseTransModel]()
                    for jsonDevice in data {
                        transactions.append(SoftwareReleaseTransModel(json: jsonDevice))
                    }
                    completionHandler(transactions)
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }

    // MARK: Software Release Transaction

    public func createTransaction(node: CreateSoftwareReleaseTransModel, completionHandler: @escaping (_ success: Bool) -> Void) {
        KonexiosIot.sharedInstance.sendIotCommonRequest(
            urlString: TransactionUrl,
            method: .post,
            model: node,
            info: "Create transaction"
        ) { _, success in
            completionHandler(success)
        }
    }

    public func createDeviceUpgradeTransaction(node: SoftwareReleaseUpdateModel, completionHandler: @escaping (_ success: Bool) -> Void) {
        KonexiosIot.sharedInstance.sendIotCommonRequest(
            urlString: TransactionDeviceUpgradeUrl,
            method: .post,
            model: node,
            info: "Create device upgrade transaction"
        ) { _, success in
            completionHandler(success)
        }
    }

    public func createGatewayUpgradeTransaction(node: SoftwareReleaseUpdateModel, completionHandler: @escaping (_ success: Bool) -> Void) {
        KonexiosIot.sharedInstance.sendIotCommonRequest(
            urlString: TransactionGatewayUpgradeUrl,
            method: .post,
            model: node,
            info: "Create gateway upgrade transaction"
        ) { _, success in
            completionHandler(success)
        }
    }

    public func startTransaction(hid: String, completionHandler: @escaping (_ success: Bool) -> Void) {
        let formatURL = String(format: TransactionStartUrl, hid)
        KonexiosIot.sharedInstance.sendIotCommonRequest(
            urlString: formatURL,
            method: .post,
            model: nil,
            info: "Start transaction"
        ) { _, success in
            completionHandler(success)
        }
    }

    /// Tell that given transaction has failed
    /// - parameter hid: transaction id
    /// - parameter error: transaction fail message
    /// - parameter completionHandler: completion handler to be invoked upon request
    public func transactionFailed(hid: String, error: String, completionHandler: @escaping (_ success: Bool) -> Void) {
        let formatURL = String(format: TransactionFailedUrl, hid)
        let errorModel = ErrorModel(error: error)
        KonexiosIot.sharedInstance.sendIotCommonRequest(
            urlString: formatURL,
            method: .put,
            model: errorModel,
            info: "Transaction failed"
        ) { _, success in
            completionHandler(success)
        }
    }

    /// Tell that givent transaction is received successfully
    public func transactionReceived(hid: String, completionHandler: @escaping (_ success: Bool) -> Void) {
        let formatURL = String(format: TransactionReceivedUrl, hid)
        KonexiosIot.sharedInstance.sendIotCommonRequest(
            urlString: formatURL,
            method: .put,
            model: nil,
            info: "Transaction received"
        ) { _, success in
            completionHandler(success)
        }
    }

    public func transactionSucceeded(hid: String, completionHandler: @escaping (_ success: Bool) -> Void) {
        let formatURL = String(format: TransactionSucceededUrl, hid)
        KonexiosIot.sharedInstance.sendIotCommonRequest(
            urlString: formatURL,
            method: .put,
            model: nil,
            info: "Transaction succeeded"
        ) { _, success in
            completionHandler(success)
        }
    }
    
    /// Download software release file for given transaction and file token. Token can be used only once
    /// for getting the file
    /// - parameter hid: transaction id
    /// - parameter fileToken: transaction temporary token, used only once
    /// - parameter progressHandler: progress handler to handle the download progress (0..1)
    /// - parameter completionHandler: completion handler (success, url) that will be invoked upon request
    public func transactionDownloadFile(hid: String, fileToken: String, progressHandler: @escaping (_ progress: Double) -> Void, completionHandler: @escaping (_ success: Bool, _ fileUrl: URL?) -> Void) {
        let formatURL = String(format: TransactionFileUrl, hid, fileToken)
        
        let request = KonexiosIot.sharedInstance.sendIotDownloadRequest(
            urlString: formatURL, method: .get,
            model: nil,
            info: "Transaction get file for token \(fileToken)",
            progressHandler: progressHandler,
            completionHandler: completionHandler)
        
        // save this request to the requests dictionary
        downloadRequests[fileToken] = request
    }
}
