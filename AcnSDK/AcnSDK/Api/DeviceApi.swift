//
//  DeviceApi.swift
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

public class DeviceApi {
    
    let DeviceUrl = "/api/v1/kronos/devices"
    let DeviceUrlHid = "/api/v1/kronos/devices/%@"
    let DeviceEventsUrl = "/api/v1/kronos/devices/%@/events"
    let DeviceLogsUrl = "/api/v1/kronos/devices/%@/logs"
    let DeviceErrorUrl = "/api/v1/kronos/devices/%@/errors"
    
    let DeviceStateUrl = "/api/v1/kronos/devices/%@/state"
    let DeviceStateRequestUrl = "/api/v1/kronos/devices/%@/state/request"
    let DeviceStateFailedUrl = "/api/v1/kronos/devices/%@/state/trans/%@/failed"
    let DeviceStateReceivedUrl = "/api/v1/kronos/devices/%@/state/trans/%@/received"
    let DeviceStateSucceededUrl = "/api/v1/kronos/devices/%@/state/trans/%@/succeeded"
    let DeviceStateUpdateUrl = "/api/v1/kronos/devices/%@/state/update"
    
    let DeviceTypesUrl = "/api/v1/kronos/devices/types"
    let DeviceTypesUrlHid = "/api/v1/kronos/devices/types/%@"
    
    let DeviceActionTypesUrl = "/api/v1/kronos/devices/actions/types"
    let DeviceActionsUrl = "/api/v1/kronos/devices/%@/actions"
    let DeviceActionUpdateUrl = "/api/v1/kronos/devices/%@/actions/%@"
    
    let DeviceSoftwareReleasesUrl = "/api/v1/kronos/devices/%@/firmware/available"
    
    // MARK: Device
    
    public func devices(completionHandler: @escaping (_ devices: [DeviceModel]?) -> Void) {
        ArrowConnectIot.sharedInstance.sendIotCommonRequest(
            urlString: DeviceUrl,
            method: .GET,
            model: nil,
            info: "Get devices"
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
    
    public func registerDevice(device: IotDevice, completionHandler: @escaping (_ deviceId: String?, _ externalId: String?, _ error: String?) -> Void) {
        let deviceModel = CreateDeviceModel(device: device)
        ArrowConnectIot.sharedInstance.sendIotCommonRequest(
            urlString: DeviceUrl,
            method: .POST,
            model: deviceModel,
            info: "Register Device"
        ) { json, success in
            if success {
                if json != nil {
                    let hid = json!.value(forKeyPath: "hid") as? String
                    let externalId = json!.value(forKeyPath: "externalId") as? String
                    completionHandler(hid, externalId, nil)
                } else {
                    completionHandler(nil, nil, nil)
                }
            } else {
                if json != nil {
                    let message = json!.value(forKeyPath: "message") as? String
                    completionHandler(nil, nil, message)
                } else {
                    completionHandler(nil, nil, nil)
                }
            }
        }
    }
    
    public func findDevice(hid: String, completionHandler: @escaping (_ device: DeviceModel?) -> Void) {
        let formatURL = String(format: DeviceUrlHid, hid)
        ArrowConnectIot.sharedInstance.sendIotCommonRequest(
            urlString: formatURL,
            method: .GET,
            model: nil,
            info: "Find device"
        ) { json, success in
            if success && json != nil {
                if let data = json as? [String: AnyObject] {
                    completionHandler(DeviceModel(json: data))
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    public func updateDevice(hid: String, device: UpdateDeviceModel, completionHandler: @escaping (_ success: Bool) -> Void) {
        let formatURL = String(format: DeviceUrlHid, hid)
        ArrowConnectIot.sharedInstance.sendIotCommonRequest(
            urlString: formatURL,
            method: .PUT,
            model: device,
            info: "Update device"
        ) { _, success in
            completionHandler(success)
        }
    }
    
    public func deviceEvents(hid: String, completionHandler: @escaping (_ events: [DeviceEvent]?) -> Void) {
        let formatURL = String(format: DeviceEventsUrl, hid)
        ArrowConnectIot.sharedInstance.sendIotCommonRequest(
            urlString: formatURL,
            method: .GET,
            model: nil,
            info: "Device events"
        ) { (result, success) -> Void in
            if success && result != nil {
                if let data = result!["data"] as? [[String: AnyObject]] {
                    var events = [DeviceEvent]()
                    for jsonEvent in data {
                        events.append(DeviceEvent(json: jsonEvent))
                    }
                    completionHandler(events)
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    public func deviceLogs(hid: String, completionHandler: @escaping (_ logs: [GatewayLog]?) -> Void) {
        let formatURL = String(format: DeviceLogsUrl, hid)
        ArrowConnectIot.sharedInstance.sendIotCommonRequest(
            urlString: formatURL,
            method: .GET,
            model: nil,
            info: "Device logs"
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
    
    public func deviceError(hid: String, error: String, completionHandler: @escaping (_ success: Bool) -> Void) {
        let formatURL = String(format: DeviceErrorUrl, hid)
        let errorModel = ErrorModel(error: error)
        ArrowConnectIot.sharedInstance.sendIotCommonRequest(
            urlString: formatURL,
            method: .POST,
            model: errorModel,
            info: "Device error"
        ) { _, success in
            completionHandler(success)
        }
    }
    
    /// Return device releases available
    /// - parameter hid: device hid
    /// - parameter completionHandler: completion handler with the list of releases or nil
    public func deviceSoftwareReleases(hid: String, completionHandler: @escaping (_ firmwares: [DeviceSoftwareRelease]?, _ errorMessage: String?) -> Void) -> Void {
        
        let formatURL = String(format: DeviceSoftwareReleasesUrl, hid)
        
        ArrowConnectIot.sharedInstance.sendIotCommonRequest(
            urlString: formatURL,
            method: .GET, model: nil,
            info: "Device software releases"
        ) { data, success in
            
            guard success, let json = data as? [[String : Any]] else {
                
                if let respJson = data as? [String: Any], let errorMessage = respJson["message"] as? String {
                    completionHandler(nil, errorMessage)
                }
                else {
                    completionHandler(nil, "Unknown error")
                }
                return
            }
            
            var result = [DeviceSoftwareRelease]()
            json.forEach { result.append( DeviceSoftwareRelease(json: $0) ) }
            
            completionHandler(result, nil)
        }
    }
    
    // MARK: Device State
    
    public func deviceState(hid: String, completionHandler: @escaping (_ state: DeviceStateModel?) -> Void) {
        let formatURL = String(format: DeviceStateUrl, hid)
        ArrowConnectIot.sharedInstance.sendIotCommonRequest(
            urlString: formatURL,
            method: .GET,
            model: nil,
            info: "Device state"
        ) { json, success in
            if success && json != nil {
                if let data = json as? [String: AnyObject] {
                    completionHandler(DeviceStateModel(json: data))
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    public func deviceStateRequest(hid: String, state: StateModel, completionHandler: @escaping (_ success: Bool) -> Void) {
        let formatURL = String(format: DeviceStateRequestUrl, hid)
        ArrowConnectIot.sharedInstance.sendIotCommonRequest(
            urlString: formatURL,
            method: .POST,
            model: state,
            info: "Device state request"
        ) { _, success in
            completionHandler(success)
        }
    }
    
    public func deviceStateSucceeded(hid: String, transHid: String, completionHandler: @escaping (_ success: Bool) -> Void) {
        let formatURL = String(format: DeviceStateSucceededUrl, hid, transHid)
        ArrowConnectIot.sharedInstance.sendIotCommonRequest(
            urlString: formatURL,
            method: .PUT,
            model: nil,
            info: "Device state succeeded"
        ) { _, success in
            completionHandler(success)
        }
    }
    
    public func deviceStateFailed(hid: String, transHid: String, error: String, completionHandler: @escaping (_ success: Bool) -> Void) {
        let formatURL = String(format: DeviceStateFailedUrl, hid, transHid)
        let errorModel = ErrorModel(error: error)
        ArrowConnectIot.sharedInstance.sendIotCommonRequest(
            urlString: formatURL,
            method: .PUT,
            model: errorModel,
            info: "Device state failed"
        ) { _, success in
            completionHandler(success)
        }
    }
    
    public func deviceStateReceived(hid: String, transHid: String, completionHandler: @escaping (_ success: Bool) -> Void) {
        let formatURL = String(format: DeviceStateReceivedUrl, hid, transHid)
        ArrowConnectIot.sharedInstance.sendIotCommonRequest(
            urlString: formatURL,
            method: .PUT,
            model: nil,
            info: "Device state received"
        ) { _, success in
            completionHandler(success)
        }
    }
    
    public func deviceStateUpdate(hid: String, state: StateModel, completionHandler: @escaping (_ success: Bool) -> Void) {
        let formatURL = String(format: DeviceStateUpdateUrl, hid)
        ArrowConnectIot.sharedInstance.sendIotCommonRequest(
            urlString: formatURL,
            method: .POST,
            model: state,
            info: "Device state update"
        ) { _, success in
            completionHandler(success)
        }
    }
    
    // MARK: Device Type
    
    public func deviceTypes(completionHandler: @escaping (_ deviceTypes: [DeviceTypeModel]?) -> Void) {
        ArrowConnectIot.sharedInstance.sendIotCommonRequest(
            urlString: DeviceTypesUrl,
            method: .GET,
            model: nil,
            info: "Get device types"
        ) { json, success in
            if success && json != nil {
                if let data = json!["data"] as? [[String: AnyObject]] {
                    var deviceTypes = [DeviceTypeModel]()
                    for jsonDeviceType in data {
                        deviceTypes.append(DeviceTypeModel(json: jsonDeviceType))
                    }
                    completionHandler(deviceTypes)
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    public func createDeviceType(deviceType: CreateDeviceTypeModel, completionHandler: @escaping (_ success: Bool) -> Void) {
        ArrowConnectIot.sharedInstance.sendIotCommonRequest(
            urlString: DeviceTypesUrl,
            method: .POST,
            model: deviceType,
            info: "Create device type"
        ) { _, success in
            completionHandler(success)
        }
    }
    
    public func updateDeviceType(hid: String, deviceType: UpdateDeviceTypeModel, completionHandler: @escaping (_ success: Bool) -> Void) {
        let formatURL = String(format: DeviceTypesUrlHid, hid)
        ArrowConnectIot.sharedInstance.sendIotCommonRequest(
            urlString: formatURL,
            method: .PUT,
            model: deviceType,
            info: "Update device type"
        ) { _, success in
            completionHandler(success)
        }
    }
    
    // MARK: Device Action
    
    public func deviceActions(hid: String, completionHandler: @escaping (_ actions: [ActionModel]?) -> Void) {
        let formatURL = String(format: DeviceActionsUrl, hid)
        ArrowConnectIot.sharedInstance.sendIotCommonRequest(
            urlString: formatURL,
            method: .GET,
            model: nil,
            info: "Device actions"
        ) { (result, success) -> Void in
            if success && result != nil {
                if let data = result!["data"] as? [[String: AnyObject]] {
                    var actions = [ActionModel]()
                    for jsonAction in data {
                        actions.append(ActionModel(json: jsonAction))
                    }
                    completionHandler(actions)
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    public func addDeviceAction(hid: String, action: ActionModel) {
        let formatURL = String(format: DeviceActionsUrl, hid)
        ArrowConnectIot.sharedInstance.sendIotCommonRequest(
            urlString: formatURL,
            method: .POST,
            model: action,
            info: "Add Device Action"
        ) { _, _ in }
    }
    
    public func updateDeviceAction(hid: String, action: ActionModel) {
        let formatURL = String(format: DeviceActionUpdateUrl, hid, String(action.index))
        ArrowConnectIot.sharedInstance.sendIotCommonRequest(
            urlString: formatURL,
            method: .PUT,
            model: action,
            info: "Update Device Action"
        ) { _, _ in }
    }
    
    public func deleteDeviceAction(hid: String, action: ActionModel) {
        let formatURL = String(format: DeviceActionUpdateUrl, hid, String(action.index))
        ArrowConnectIot.sharedInstance.sendIotCommonRequest(
            urlString: formatURL,
            method: .DELETE,
            model: action,
            info: "Delete Device Action"
        ) { _, _ in }
    }
}
