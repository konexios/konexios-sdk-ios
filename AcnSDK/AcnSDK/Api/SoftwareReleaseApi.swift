//
//  SoftwareReleaseApi.swift
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

public class SoftwareReleaseApi {
    let ScheduleUrl = "/api/v1/kronos/software/releases/schedules"
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

    // MARK: Software Release Schedule

    public func schedules(completionHandler: @escaping (_ devices: [SoftwareReleaseScheduleModel]?) -> Void) {
        ArrowConnectIot.sharedInstance.sendCommonRequest(baseUrlString: ArrowConnectIot.sharedInstance.IotUrl!,
                                                         urlString: ScheduleUrl,
                                                         method: .GET,
                                                         model: nil,
                                                         info: "Get schedules") { json, success in
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
        ArrowConnectIot.sharedInstance.sendCommonRequest(baseUrlString: ArrowConnectIot.sharedInstance.IotUrl!,
                                                         urlString: formatURL,
                                                         method: .GET,
                                                         model: nil,
                                                         info: "Find device") { json, success in
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

    public func createSchedule(node: CreateSoftwareReleaseScheduleModel, completionHandler: @escaping (_ success: Bool) -> Void) {
        ArrowConnectIot.sharedInstance.sendCommonRequest(baseUrlString: ArrowConnectIot.sharedInstance.IotUrl!,
                                                         urlString: ScheduleUrl,
                                                         method: .POST,
                                                         model: node,
                                                         info: "Create schedule") { _, success in
            completionHandler(success)
        }
    }

    public func updateSchedule(hid: String, node: UpdateSoftwareReleaseScheduleModel, completionHandler: @escaping (_ success: Bool) -> Void) {
        let formatURL = String(format: ScheduleHidUrl, hid)
        ArrowConnectIot.sharedInstance.sendCommonRequest(baseUrlString: ArrowConnectIot.sharedInstance.IotUrl!,
                                                         urlString: formatURL,
                                                         method: .PUT,
                                                         model: node,
                                                         info: "Update schedule") { _, success in
            completionHandler(success)
        }
    }

    public func scheduleTransactions(hid: String, completionHandler: @escaping (_ devices: [SoftwareReleaseTransModel]?) -> Void) {
        let formatURL = String(format: ScheduleHidTransUrl, hid)
        ArrowConnectIot.sharedInstance.sendCommonRequest(baseUrlString: ArrowConnectIot.sharedInstance.IotUrl!,
                                                         urlString: formatURL,
                                                         method: .GET,
                                                         model: nil,
                                                         info: "Get schedule transactions") { json, success in
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
        ArrowConnectIot.sharedInstance.sendCommonRequest(baseUrlString: ArrowConnectIot.sharedInstance.IotUrl!,
                                                         urlString: TransactionUrl,
                                                         method: .POST,
                                                         model: node,
                                                         info: "Create transaction") { _, success in
            completionHandler(success)
        }
    }

    public func createDeviceUpgradeTransaction(node: SoftwareReleaseUpdateModel, completionHandler: @escaping (_ success: Bool) -> Void) {
        ArrowConnectIot.sharedInstance.sendCommonRequest(baseUrlString: ArrowConnectIot.sharedInstance.IotUrl!,
                                                         urlString: TransactionDeviceUpgradeUrl,
                                                         method: .POST,
                                                         model: node,
                                                         info: "Create device upgrade transaction") { _, success in
            completionHandler(success)
        }
    }

    public func createGatewayUpgradeTransaction(node: SoftwareReleaseUpdateModel, completionHandler: @escaping (_ success: Bool) -> Void) {
        ArrowConnectIot.sharedInstance.sendCommonRequest(baseUrlString: ArrowConnectIot.sharedInstance.IotUrl!,
                                                         urlString: TransactionGatewayUpgradeUrl,
                                                         method: .POST,
                                                         model: node,
                                                         info: "Create gateway upgrade transaction") { _, success in
            completionHandler(success)
        }
    }

    public func startTransaction(hid: String, completionHandler: @escaping (_ success: Bool) -> Void) {
        let formatURL = String(format: TransactionStartUrl, hid)
        ArrowConnectIot.sharedInstance.sendCommonRequest(baseUrlString: ArrowConnectIot.sharedInstance.IotUrl!,
                                                         urlString: formatURL,
                                                         method: .POST,
                                                         model: nil,
                                                         info: "Start transaction") { _, success in
            completionHandler(success)
        }
    }

    public func transactionFailed(hid: String, error: String, completionHandler: @escaping (_ success: Bool) -> Void) {
        let formatURL = String(format: TransactionFailedUrl, hid)
        let errorModel = ErrorModel(error: error)
        ArrowConnectIot.sharedInstance.sendCommonRequest(baseUrlString: ArrowConnectIot.sharedInstance.IotUrl!,
                                                         urlString: formatURL,
                                                         method: .PUT,
                                                         model: errorModel,
                                                         info: "Transaction failed") { _, success in
            completionHandler(success)
        }
    }

    public func transactionReceived(hid: String, completionHandler: @escaping (_ success: Bool) -> Void) {
        let formatURL = String(format: TransactionReceivedUrl, hid)
        ArrowConnectIot.sharedInstance.sendCommonRequest(baseUrlString: ArrowConnectIot.sharedInstance.IotUrl!,
                                                         urlString: formatURL,
                                                         method: .PUT,
                                                         model: nil,
                                                         info: "Transaction received") { _, success in
            completionHandler(success)
        }
    }

    public func transactionSucceeded(hid: String, completionHandler: @escaping (_ success: Bool) -> Void) {
        let formatURL = String(format: TransactionSucceededUrl, hid)
        ArrowConnectIot.sharedInstance.sendCommonRequest(baseUrlString: ArrowConnectIot.sharedInstance.IotUrl!,
                                                         urlString: formatURL,
                                                         method: .PUT,
                                                         model: nil,
                                                         info: "Transaction succeeded") { _, success in
            completionHandler(success)
        }
} }
