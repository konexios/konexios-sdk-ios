//
//  GatewayApi.swift
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

public class GatewayApi {
    let GatewayUrl = "/api/v1/kronos/gateways"
    let GatewayUrlHid = "/api/v1/kronos/gateways/%@"
    let GatewayCheckinUrl = "/api/v1/kronos/gateways/%@/checkin"
    let GatewayDeviceCommandUrl = "/api/v1/kronos/gateways/%@/commands/device-command"
    let GatewayConfigUrl = "/api/v1/kronos/gateways/%@/config"
    let GatewayLogsUrl = "/api/v1/kronos/gateways/%@/logs"
    let GatewayDevicesUrl = "/api/v1/kronos/gateways/%@/devices"
    let GatewayErrorUrl = "/api/v1/kronos/gateways/%@/errors"
    
    public func gateways(completionHandler: @escaping (_ gateways: [GatewayModel]?) -> Void) {
        KonexiosIot.sharedInstance.sendIotCommonRequest(
            urlString: GatewayUrl,
            method: .get,
            model: nil,
            info: "Get gateways"
        ) { json, success in
            if success && json != nil {
                if let data = json as? [[String: AnyObject]] {
                    var gateways = [GatewayModel]()
                    for jsonGateway in data {
                        gateways.append(GatewayModel(json: jsonGateway))
                    }
                    completionHandler(gateways)
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    public func registerGateway(gateway: CreateGatewayModel, completionHandler: @escaping (_ hid: String?, _ error: String?) -> Void) {
        KonexiosIot.sharedInstance.sendIotCommonRequest(
            urlString: GatewayUrl,
            method: .post,
            model: gateway,
            info: "Register Gateway"
        ) { json, success in
            if success {
                if json != nil {
                    let hid = json!.value(forKeyPath: "hid") as? String
                    completionHandler(hid, nil)
                } else {
                    completionHandler(nil, nil)
                }
            } else {
                if json != nil {
                    let message = json!.value(forKeyPath: "message") as? String
                    completionHandler(nil, message)
                } else {
                    completionHandler(nil, nil)
                }
            }
        }
    }
    
    public func findGateway(hid: String, completionHandler: @escaping (_ gateway: GatewayModel?) -> Void) {
        let formatURL = String(format: GatewayUrlHid, hid)
        KonexiosIot.sharedInstance.sendIotCommonRequest(
            urlString: formatURL,
            method: .get,
            model: nil,
            info: "Find Gateway"
        ) { json, success in
            if success && json != nil {
                if let data = json as? [String: AnyObject] {
                    completionHandler(GatewayModel(json: data))
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    public func updateGateway(hid: String, gateway: UpdateGatewayModel, completionHandler: @escaping (_ success: Bool) -> Void) {
        let formatURL = String(format: GatewayUrlHid, hid)
        KonexiosIot.sharedInstance.sendIotCommonRequest(
            urlString: formatURL,
            method: .put,
            model: gateway,
            info: "Update Gateway"
        ) { _, success in
            completionHandler(success)
        }
    }
    
    public func checkinGateway(hid: String, completionHandler: @escaping (_ success: Bool) -> Void) {
        let checkinURL = String(format: GatewayCheckinUrl, hid)
        KonexiosIot.sharedInstance.sendIotCommonRequest(
            urlString: checkinURL,
            method: .put,
            model: nil,
            info: "Checkin Gateway"
        ) { _, success in
            completionHandler(success)
        }
    }
    
    public func sendDeviceCommand(hid: String, command: DeviceCommand, completionHandler: @escaping (_ success: Bool) -> Void) {
        let formatURL = String(format: GatewayDeviceCommandUrl, hid)
        KonexiosIot.sharedInstance.sendIotCommonRequest(
            urlString: formatURL,
            method: .post,
            model: command,
            info: "Send device comand"
        ) { _, success in
            completionHandler(success)
        }
    }
    
    public func gatewayConfig(hid: String, completionHandler: @escaping (_ success: Bool) -> Void) {
        let configURL = String(format: GatewayConfigUrl, hid)
        KonexiosIot.sharedInstance.sendIotCommonRequest(
            urlString: configURL,
            method: .get,
            model: nil,
            info: "Gateway config"
        ) { json, success in
            if success && json != nil {
                let config = GatewayConfigResponse(dictionary: json as! [String: AnyObject])
                Profile.sharedInstance.saveCloudConfig(config: config).reload()
                completionHandler(true)
            } else {
                completionHandler(false)
            }
        }
    }
    
    public func gatewayLogs(hid: String, completionHandler: @escaping (_ logs: [GatewayLog]?) -> Void) {
        let formatURL = String(format: GatewayLogsUrl, hid)
        KonexiosIot.sharedInstance.sendIotCommonRequest(
            urlString: formatURL,
            method: .get,
            model: nil,
            info: "Gateway logs"
        ) { json, success in
            if success && json != nil {
                if let data = json!["data"] as? [[String: AnyObject]] {
                    var logs = [GatewayLog]()
                    for jsonLog in data {
                        logs.append(GatewayLog(json: jsonLog))
                    }
                    completionHandler(logs)
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    public func gatewayDevices(hid: String, completionHandler: @escaping (_ devices: [DeviceModel]?) -> Void) {
        let formatURL = String(format: GatewayDevicesUrl, hid)
        KonexiosIot.sharedInstance.sendIotCommonRequest(
            urlString: formatURL,
            method: .get,
            model: nil,
            info: "Get gateway devices"
        ) { json, success in
            if success && json != nil {
                if let data = json!["data"] as? [[String: AnyObject]] {
                    var devices = [DeviceModel]()
                    for jsonDevice in data {
                        devices.append(DeviceModel(json: jsonDevice))
                    }
                    completionHandler(devices)
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    public func gatewayError(hid: String, error: String, completionHandler: @escaping (_ success: Bool) -> Void) {
        let formatURL = String(format: GatewayErrorUrl, hid)
        let errorModel = ErrorModel(error: error)
        KonexiosIot.sharedInstance.sendIotCommonRequest(
            urlString: formatURL,
            method: .post,
            model: errorModel,
            info: "Gateway error"
        ) { _, success in
            completionHandler(success)
        }
    }
}
