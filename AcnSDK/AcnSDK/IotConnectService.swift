//
//  IotConnectService.swift
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

import Foundation

public protocol IotConnectServiceCommandDelegate: class {
    func startCommand(deviceID: String)
    func stopCommand(deviceID: String)
    func propertyChangeCommand(deviceID: String, commandID: String, parameters: [String : AnyObject])
    func deviceStateRequest(deviceID: String, transHid: String, parameters: [String : Any])
}

public class IotConnectService: NSObject, MQTTServiceMessageDelegate {
    
    public weak var commandDelegate: IotConnectServiceCommandDelegate?
    
    var IoTConnectUrl: String?
    var ArrowConnectUrl: String?
    
    var DefaultApiKey: String?
    var DefaultSecretKey: String?
    
    var gatewayId: String?
    
    let TelemetryPostUrl         = "/api/v1/kronos/telemetries"
    let TelemetryApplicationUrl  = "/api/v1/kronos/telemetries/applications/%@"
    let TelemetryDeviceUrl       = "/api/v1/kronos/telemetries/devices/%@"
    let TelemetryCountDeviceUrl  = "/api/v1/kronos/telemetries/devices/%@/count"
    let TelemetryAvgDeviceUrl    = "/api/v1/kronos/telemetries/devices/%@/avg"
    let TelemetryLatestDeviceUrl = "/api/v1/kronos/telemetries/devices/%@/latest"
    let TelemetryMaxDeviceUrl    = "/api/v1/kronos/telemetries/devices/%@/max"
    let TelemetryMinDeviceUrl    = "/api/v1/kronos/telemetries/devices/%@/min"
    let TelemetryNodeUrl         = "/api/v1/kronos/telemetries/nodes/%@"
    let BatchTelemetryPostUrl    = "/api/v1/kronos/telemetries/batch"
    
    let AccountRegisterUrl = "/api/v1/kronos/accounts"
    
    let GatewayUrl              = "/api/v1/kronos/gateways"
    let GatewayUrlHid           = "/api/v1/kronos/gateways/%@"
    let GatewayCheckinUrl       = "/api/v1/kronos/gateways/%@/checkin"
    let GatewayDeviceCommandUrl = "/api/v1/kronos/gateways/%@/commands/device-command"
    let GatewayConfigUrl        = "/api/v1/kronos/gateways/%@/config"
    let GatewayLogsUrl          = "/api/v1/kronos/gateways/%@/logs"
    let GatewayDevicesUrl       = "/api/v1/kronos/gateways/%@/devices"
    let GatewayErrorUrl         = "/api/v1/kronos/gateways/%@/errors"
    
    let DeviceUrl       = "/api/v1/kronos/devices"
    let DeviceUrlHid    = "/api/v1/kronos/devices/%@"
    let DeviceEventsUrl = "/api/v1/kronos/devices/%@/events"
    let DeviceLogsUrl   = "/api/v1/kronos/devices/%@/logs"
    let DeviceErrorUrl  = "/api/v1/kronos/devices/%@/errors"
    
    let CoreEventFailedUrl    = "/api/v1/core/events/%@/failed"
    let CoreEventReceivedUrl  = "/api/v1/core/events/%@/received"
    let CoreEventSucceededUrl = "/api/v1/core/events/%@/succeeded"
    
    let DeviceStateUrl          = "/api/v1/kronos/devices/%@/state"
    let DeviceStateRequestUrl   = "/api/v1/kronos/devices/%@/state/request"
    let DeviceStateFailedUrl    = "/api/v1/kronos/devices/%@/state/trans/%@/failed"
    let DeviceStateReceivedUrl  = "/api/v1/kronos/devices/%@/state/trans/%@/received"
    let DeviceStateSucceededUrl = "/api/v1/kronos/devices/%@/state/trans/%@/succeeded"
    let DeviceStateUpdateUrl    = "/api/v1/kronos/devices/%@/state/update"
    
    let DeviceTypesUrl    = "/api/v1/kronos/devices/types"
    let DeviceTypesUrlHid = "/api/v1/kronos/devices/types/%@"
    
    let NodeUrl    = "/api/v1/kronos/nodes"
    let NodeUrlHid = "/api/v1/kronos/nodes/%@"
    
    let NodeTypesUrl    = "/api/v1/kronos/nodes/types"
    let NodeTypesUrlHid = "/api/v1/kronos/nodes/types/%@"
    
    let PropertyChangeAcknowledgeUrl = "/api/v1/core/events/%@/received"
    let PropertyChangeSuccessfulUrl  = "/api/v1/core/events/%@/succeeded"
    let PropertyChangeFailureUrl     = "/api/v1/core/events/%@/failed"
    
    let HeartbeatUrl = "/api/v1/kronos/gateways/%@/heartbeat"
    
    let DeviceActionTypesUrl  = "/api/v1/kronos/devices/actions/types"
    let DeviceActionsUrl      = "/api/v1/kronos/devices/%@/actions"
    let DeviceActionUpdateUrl = "/api/v1/kronos/devices/%@/actions/%@"
    
    let Auth2Url = "/api/v1/pegasus/users/auth2"
    
    var apiKey: String {
        if Profile.sharedInstance.cloudConfig != nil {
            return Profile.sharedInstance.cloudConfig!.iotConnectConfig.apiKey
        } else {
            return DefaultApiKey!
        }
    }
    
    var secretKey: String {
        if Profile.sharedInstance.cloudConfig != nil {
            return Profile.sharedInstance.cloudConfig!.iotConnectConfig.secretKey
        } else {
            return DefaultSecretKey!
        }
    }

    var heartbeatTimer: Timer?
    
    // MARK: MQTT
    
    let SecureMQTTPort: UInt16 = 8883
    
    var MQTTServerHost: String?
    var MQTTServerPort: UInt16?
    var MQTTVHost: String?

    let MQTTSendTopic      = "krs.tel.gts"
    let MQTTSendBatchTopic = "krs.tel.bat.gts"
    let MQTTCommandTopic   = "krs.cmd.stg"
    
    var mqttService: MQTTService?
    
    var MQTTServiceAvailable = true
    
    var queue = IotDataLoadQueue()
    public var sendingDevicesCount = 0
    

    // MARK: Singleton
    public static let sharedInstance = IotConnectService()
    
    private override init() {
        super.init()
    }
    
    public func setupConnection(arrowConnectdUrl: String, iotConnectUrl: String, mqtt: String, mqttPort: UInt16, mqttVHost: String) {
        ArrowConnectUrl = arrowConnectdUrl
        IoTConnectUrl  = iotConnectUrl
        MQTTServerHost = mqtt
        MQTTServerPort = mqttPort
        MQTTVHost      = mqttVHost
    }
    
    public func setKeys(apiKey: String, secretKey: String) {
        DefaultApiKey    = apiKey
        DefaultSecretKey = secretKey
    }
    
    public func connectMQTT(gatewayId: String) {
        self.gatewayId = gatewayId
        
        let user = "\(MQTTVHost!):\(gatewayId)"
        let password = apiKey

        print("[connectMQTT] host: \(MQTTServerHost!)")
        
        let secureMQTT = (MQTTServerPort == SecureMQTTPort) ? true : false
        
        mqttService = MQTTService(host: MQTTServerHost!, port: MQTTServerPort!, clientId: gatewayId, user: user, password: password, secureMQTT: secureMQTT)
        mqttService?.messageDelegate = self
        mqttService?.connect()
        
        let topic = "\(MQTTCommandTopic).\(gatewayId)"
        mqttService?.subscribe(topic: topic)
    }
    
    func isMQTTConnected() -> Bool {
        if mqttService != nil {
            return mqttService!.isConnected()
        } else {
            return false
        }
    }
    
    func reconnectMQTT() {
        if gatewayId != nil {
            if mqttService == nil {
                connectMQTT(gatewayId: gatewayId!)
            } else {
                print("[reconnectMQTT ...")
                mqttService?.disconnect()
                mqttService?.connect()
                
                let topic = "\(MQTTCommandTopic).\(gatewayId!)"
                mqttService?.subscribe(topic: topic)
            }
        }
    }
    
    // MARK: Telemetry API
    
    func sendTelemetries(data: IotDataLoad, completionHandler: @escaping (_ success: Bool) -> Void) {
        
        if sendingDevicesCount > 1 || queue.queueSize() != 0 {
            sendTelemetriesBatch(data: data) { success -> Void in
                completionHandler(success)
            }
        } else {
            sendTelemetriesSingle(data: data) { success -> Void in
                completionHandler(success)
            }
        }
    }
    
    func sendTelemetriesBatch(data: IotDataLoad, completionHandler: @escaping (_ success: Bool) -> Void) {
        queue.addToQueue(data: data)
        if queue.queueSize() >= sendingDevicesCount || sendingDevicesCount <= 1 {
            if MQTTServiceAvailable {
                sendBatchTelemetriesMQTT()
                completionHandler(true)
            } else {
                sendBatchTelemetriesREST { success -> Void in
                    completionHandler(success)
                }
            }
        } else {
            completionHandler(true)
        }
    }
    
    func sendTelemetriesSingle(data: IotDataLoad, completionHandler: @escaping (_ success: Bool) -> Void) {
        if MQTTServiceAvailable {
            sendTelemetriesMQTT(data: data)
            completionHandler(true)
        } else {
            sendTelemetriesREST(data: data) { success in
                completionHandler(success)
            }
        }
    }
    
    func sendBatchTelemetriesREST(completionHandler: (_ success: Bool) -> Void) {
        
        let dateString = Date().formatted
        let signer = ApiRequestSigner()
        signer.secretKey = secretKey
        signer.method    = HTTPMethod.post.rawValue
        signer.uri       = BatchTelemetryPostUrl
        signer.apiKey    = apiKey
        signer.timestamp = dateString
        signer.payload   = queue.batchPayload()!

        var urlRequest = createURLRequest(urlString: BatchTelemetryPostUrl, date: dateString, signature: signer.signV1())
        urlRequest.httpBody = queue.batchData()!
        
        request(urlRequest).responseJSON { response in
            if response.response != nil {
                print("[IotConnect] Send Batch Telemetries - response code: \(response.response!.statusCode)")
                if (response.response!.statusCode == 200) {
                    let json = response.result.value!
                    print("[IotConnect] Send Batch Telemetries - Success: \(json)")
                    
                } else if let json = response.result.value {
                    print("[IotConnect] Send Batch Telemetries - Error: \(json)")
                }
            }
        }
       
        queue.clearQueue()
    }
    
    func sendBatchTelemetriesMQTT() {
        if mqttService != nil {
            print("[IotConnect] Send Telemetries Batch MQTT ...")
            
            if !mqttService!.isConnected() {
                mqttService!.connect()
            }
            
            let payload = queue.batchPayload()
            queue.clearQueue()
            let topic = "\(MQTTSendBatchTopic).\(gatewayId!)"
            mqttService!.sendPayload(payload: payload!, topic: topic)
        }
    }
    
    func sendTelemetriesREST(data: IotDataLoad, completionHandler: @escaping (_ success: Bool) -> Void) {
        sendCommonRequest(baseUrlString: IoTConnectUrl!, urlString: TelemetryPostUrl, method: .post, model: data, info: "Send Telemetries") { (json, success) in
            completionHandler(success)
        }
    }
    
    func sendTelemetriesMQTT(data: IotDataLoad) {
        if mqttService != nil {
            print("[IotConnect] Send Telemetries MQTT ...")
            
            if !mqttService!.isConnected() {
                mqttService!.connect()
            }
            
            let payload = data.payloadString
            let topic = "\(MQTTSendTopic).\(gatewayId!)"
            mqttService!.sendPayload(payload: payload!, topic: topic)
        }
    }
    
    public func applicationTelemetries(hid: String, fromDate: Date, toDate: Date, size: Int = 0, telemetry: String? = nil, completionHandler: @escaping ([TelemetryModel]?) -> Void) {
        getTelemetries(urlString: TelemetryApplicationUrl, hid: hid, fromDate: fromDate, toDate: toDate, size: size, telemetry: telemetry) { telemetries in
            completionHandler(telemetries)
        }
    }
    
    public func deviceTelemetries(hid: String, fromDate: Date, toDate: Date, size: Int = 0, telemetry: String? = nil, completionHandler: @escaping ([TelemetryModel]?) -> Void) {
        getTelemetries(urlString: TelemetryDeviceUrl, hid: hid, fromDate: fromDate, toDate: toDate, size: size, telemetry: telemetry) { telemetries in
            completionHandler(telemetries)
        }
    }
    
    public func nodeTelemetries(hid: String, fromDate: Date, toDate: Date, size: Int = 0, telemetry: String? = nil, completionHandler: @escaping ([TelemetryModel]?) -> Void) {
        getTelemetries(urlString: TelemetryNodeUrl, hid: hid, fromDate: fromDate, toDate: toDate, size: size, telemetry: telemetry) { telemetries in
            completionHandler(telemetries)
        }
    }
    
    private func getTelemetries(urlString: String, hid: String, fromDate: Date, toDate: Date, size: Int, telemetry: String?, completionHandler: @escaping ([TelemetryModel]?) -> Void) {
        
        DispatchQueue.global().async {
            if let response = self.getTelemetries(urlString: urlString, hid: hid, fromDate: fromDate, toDate: toDate, page: 0, size: size, telemetry: telemetry) {
                if response.totalPages <= 1 {
                    completionHandler(response.telemetries)
                } else {
                    var telemetries = response.telemetries
                    for i in 1..<response.totalPages {
                        if let response = self.getTelemetries(urlString: urlString, hid: hid, fromDate: fromDate, toDate: toDate, page: i, size: size, telemetry: telemetry) {
                            telemetries.append(contentsOf: response.telemetries)
                        }
                    }
                    completionHandler(telemetries)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    private func getTelemetries(urlString: String, hid: String, fromDate: Date, toDate: Date, page: Int, size: Int, telemetry: String?) -> TelemetryListResponse? {
        
        var parameters: Parameters = [
            "fromTimestamp": fromDate.formatted,
            "toTimestamp"  : toDate.formatted,
            "_page"        : page
        ]
        
        if size > 0 {
            parameters["_size"] = size
        }
        
        if telemetry != nil {
            parameters["telemetryNames"] = telemetry
        }

        
        let formatUrl = String(format: urlString, hid)
        let requestUrl = queryString(urlString: formatUrl, parameters: parameters)
        
        let semaphore = DispatchSemaphore(value: 0)
        var response: TelemetryListResponse?
        
        sendCommonRequest(baseUrlString: IoTConnectUrl!, urlString: requestUrl!, method: .get, model: nil, info: "Get telemetries") { (json, success) in
            if success && json != nil {
                response = TelemetryListResponse(json: json as! [String : AnyObject])
            }
            semaphore.signal()
        }
        
        semaphore.wait()
        
        return response
    }
    
    public func deviceTelemetryCount (hid: String, telemetry: String, fromDate: Date, toDate: Date, completionHandler: @escaping (TelemetryCountModel?) -> Void) {
        
        let parameters: Parameters = [
            "fromTimestamp" : fromDate.formatted,
            "toTimestamp"   : toDate.formatted,
            "telemetryName" : telemetry
        ]
        
        let formatUrl = String(format: TelemetryCountDeviceUrl, hid)
        let requestUrl = queryString(urlString: formatUrl, parameters: parameters)
        
        sendCommonRequest(baseUrlString: IoTConnectUrl!, urlString: requestUrl!, method: .get, model: nil, info: "Telemetry Count") { (json, success) in
            if success && json != nil {
                if let data = json as? [String : AnyObject] {
                    completionHandler(TelemetryCountModel(json: data))
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }        
    }
    
    public func deviceTelemetryAvg (hid: String, telemetry: String, itemType: String, fromDate: Date, toDate: Date, completionHandler: @escaping (TelemetryCountModel?) -> Void) {
        
        let parameters: Parameters = [
            "fromTimestamp"     : fromDate.formatted,
            "toTimestamp"       : toDate.formatted,
            "telemetryName"     : telemetry,
            "telemetryItemType" : itemType
        ]
        
        let formatUrl = String(format: TelemetryAvgDeviceUrl, hid)
        let requestUrl = queryString(urlString: formatUrl, parameters: parameters)
        
        sendCommonRequest(baseUrlString: IoTConnectUrl!, urlString: requestUrl!, method: .get, model: nil, info: "Telemetry Avg") { (json, success) in
            if success && json != nil {
                if let data = json as? [String : AnyObject] {
                    completionHandler(TelemetryCountModel(json: data))
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    public func deviceTelemetryLast (hid: String, completionHandler: @escaping ([TelemetryModel]?) -> Void) {
        
        let formatUrl = String(format: TelemetryLatestDeviceUrl, hid)
        
        sendCommonRequest(baseUrlString: IoTConnectUrl!, urlString: formatUrl, method: .get, model: nil, info: "Telemetry Last") { (json, success) in
            if success && json != nil {
                if let data = json as? [String : AnyObject] {
                    let telemetries = TelemetryListResponse(json: data)
                    completionHandler(telemetries.telemetries)
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    public func deviceTelemetryMax (hid: String, telemetry: String, itemType: String, fromDate: Date, toDate: Date, completionHandler: @escaping (TelemetryCountModel?) -> Void) {
        
        let parameters: Parameters = [
            "fromTimestamp"     : fromDate.formatted,
            "toTimestamp"       : toDate.formatted,
            "telemetryName"     : telemetry,
            "telemetryItemType" : itemType
        ]
        
        let formatUrl = String(format: TelemetryMaxDeviceUrl, hid)
        let requestUrl = queryString(urlString: formatUrl, parameters: parameters)
        
        sendCommonRequest(baseUrlString: IoTConnectUrl!, urlString: requestUrl!, method: .get, model: nil, info: "Telemetry Max") { (json, success) in
            if success && json != nil {
                if let data = json as? [String : AnyObject] {
                    completionHandler(TelemetryCountModel(json: data))
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    public func deviceTelemetryMin (hid: String, telemetry: String, itemType: String, fromDate: Date, toDate: Date, completionHandler: @escaping (TelemetryCountModel?) -> Void) {
        
        let parameters: Parameters = [
            "fromTimestamp"     : fromDate.formatted,
            "toTimestamp"       : toDate.formatted,
            "telemetryName"     : telemetry,
            "telemetryItemType" : itemType
        ]
        
        let formatUrl = String(format: TelemetryMinDeviceUrl, hid)
        let requestUrl = queryString(urlString: formatUrl, parameters: parameters)
        
        sendCommonRequest(baseUrlString: IoTConnectUrl!, urlString: requestUrl!, method: .get, model: nil, info: "Telemetry Min") { (json, success) in
            if success && json != nil {
                if let data = json as? [String : AnyObject] {
                    completionHandler(TelemetryCountModel(json: data))
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    // MARK: Account API
    
    public func registerAccount(accountModel: AccountRegistrationModel, completionHandler: @escaping (AccountRegistrationResponse?) -> Void) {
        sendCommonRequest(baseUrlString: IoTConnectUrl!, urlString: AccountRegisterUrl, method: .post, model: accountModel, info: "Register Account") { (result, success) in
            if success && result != nil {
                let response = AccountRegistrationResponse(json: result as! [String : AnyObject])
                completionHandler(response)
            } else {
                completionHandler(nil)
            }
        }
    }
    
    // MARK: Gateway API
    
    public func gateways(completionHandler: @escaping (_ gateways: [GatewayModel]?) -> Void) {
        sendCommonRequest(baseUrlString: IoTConnectUrl!, urlString: GatewayUrl, method: .get, model: nil, info: "Get gateways") { (json, success) in
            if success && json != nil {
                if let data = json as? [[String : AnyObject]] {
                    var gateways = [GatewayModel]()
                    for jsonGateway in data {
                        gateways.append(GatewayModel(dictionary: jsonGateway))
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
    
    public func registerGateway(gateway: GatewayModel, completionHandler: @escaping (_ hid: String?, _ error: String?) -> Void) {        
        sendCommonRequest(baseUrlString: IoTConnectUrl!, urlString: GatewayUrl, method: .post, model: gateway, info: "Register Gateway") { (json, success) in
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
        sendCommonRequest(baseUrlString: IoTConnectUrl!, urlString: formatURL, method: .get, model: nil, info: "Find Gateway") { (json, success) in
            if success && json != nil {
                if let data = json as? [String : AnyObject] {
                    completionHandler(GatewayModel(dictionary: data))
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    public func updateGateway(hid: String, gateway: GatewayModel, completionHandler: @escaping (_ success: Bool) -> Void) {
        let formatURL = String(format: GatewayUrlHid, hid)
        sendCommonRequest(baseUrlString: IoTConnectUrl!, urlString: formatURL, method: .put, model: gateway, info: "Update Gateway") { (json, success) in
            completionHandler(success)
        }
    }
    
    public func checkinGateway(hid: String, completionHandler: @escaping (_ success: Bool) -> Void) {
        let checkinURL = String(format: GatewayCheckinUrl, hid)
        sendCommonRequest(baseUrlString: IoTConnectUrl!, urlString: checkinURL, method: .put, model: nil, info: "Checkin Gateway") { (json, success) in
            completionHandler(success)
        }
    }
    
    public func sendDeviceCommand(hid: String, command: DeviceCommand, completionHandler: @escaping (_ success: Bool) -> Void) {
        let formatURL = String(format: GatewayDeviceCommandUrl, hid)
        sendCommonRequest(baseUrlString: IoTConnectUrl!, urlString: formatURL, method: .post, model: command, info: "Send device comand") { (json, success) in
            completionHandler(success)
        }        
    }
    
    public func gatewayConfig(hid: String, completionHandler: @escaping (_ success: Bool) -> Void) {
        let configURL = String(format: GatewayConfigUrl, hid)
        sendCommonRequest(baseUrlString: IoTConnectUrl!, urlString: configURL, method: .get, model: nil, info: "Gateway config") { (json, success) in
            if success && json != nil {
                let config = GatewayConfigResponse(dictionary: json as! [String : AnyObject])
                Profile.sharedInstance.saveCloudConfig(config: config).reload()
                completionHandler(true)
            } else {
                completionHandler(false)
            }
        }
    }
    
    public func gatewayLogs(hid: String, completionHandler: @escaping (_ logs: [GatewayLog]?) -> Void) {
        let formatURL = String(format: GatewayLogsUrl, hid)
        sendCommonRequest(baseUrlString: IoTConnectUrl!, urlString: formatURL, method: .get, model: nil, info: "Gateway logs") { (json, success) in
            if success && json != nil {
                if let data = json!["data"] as? [[String : AnyObject]] {
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
        sendCommonRequest(baseUrlString: IoTConnectUrl!, urlString: formatURL, method: .get, model: nil, info: "Get gateway devices") { (json, success) in
            if success && json != nil {
                if let data = json!["data"] as? [[String : AnyObject]] {
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
        sendCommonRequest(baseUrlString: IoTConnectUrl!, urlString: formatURL, method: .post, model: errorModel, info: "Gateway error") { (json, success) in
            completionHandler(success)
        }
    }
    
    // MARK: Device API
    
    public func devices(completionHandler: @escaping (_ devices: [DeviceModel]?) -> Void) {
        sendCommonRequest(baseUrlString: IoTConnectUrl!, urlString: DeviceUrl, method: .get, model: nil, info: "Get devices") { (json, success) in
            if success && json != nil {
                if let data = json!["data"] as? [[String : AnyObject]] {
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
    
    public func registerDevice(device: IotDevice, completionHandler: @escaping (_ deviceId: String?, _ externalId: String?, _ error: String?) -> ()) {
        let deviceModel = DeviceModel(device: device)
        sendCommonRequest(baseUrlString: IoTConnectUrl!, urlString: DeviceUrl, method: .post, model: deviceModel, info: "Register Device") { (json, success) in
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
        sendCommonRequest(baseUrlString: IoTConnectUrl!, urlString: formatURL, method: .get, model: nil, info: "Find device") { (json, success) in
            if success && json != nil {
                if let data = json as? [String : AnyObject] {
                    completionHandler(DeviceModel(json: data))
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    public func updateDevice(hid: String, device: DeviceModel, completionHandler: @escaping (_ success: Bool) -> Void) {
        let formatURL = String(format: DeviceUrlHid, hid)
        sendCommonRequest(baseUrlString: IoTConnectUrl!, urlString: formatURL, method: .put, model: device, info: "Update device") { (json, success) in
            completionHandler(success)
        }
    }
    
    public func deviceEvents(hid: String, completionHandler: @escaping (_ events: [DeviceEvent]?) -> Void) {
        let formatURL = String(format: DeviceEventsUrl, hid)
        sendCommonRequest(baseUrlString: IoTConnectUrl!, urlString: formatURL, method: .get, model: nil, info: "Device events") { (result, success) -> Void in
            if success && result != nil {
                if let data = result!["data"] as? [[String : AnyObject]] {
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
        sendCommonRequest(baseUrlString: IoTConnectUrl!, urlString: formatURL, method: .get, model: nil, info: "Device logs") { (json, success) in
            if success && json != nil {
                if let data = json!["data"] as? [[String : AnyObject]] {
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
        sendCommonRequest(baseUrlString: IoTConnectUrl!, urlString: formatURL, method: .post, model: errorModel, info: "Device error") { (json, success) in
            completionHandler(success)
        }
    }
    
    // MARK: Core event API
    
    public func coreEventFailed(hid: String, error: String, completionHandler: @escaping (_ success: Bool) -> Void) {
        let formatURL = String(format: CoreEventFailedUrl, hid)
        let errorModel = ErrorModel(error: error)
        sendCommonRequest(baseUrlString: IoTConnectUrl!, urlString: formatURL, method: .put, model: errorModel, info: "Core event failed") { (json, success) in
            completionHandler(success)
        }
    }
    
    public func coreEventReceived(hid: String, completionHandler: @escaping (_ success: Bool) -> Void) {
        let formatURL = String(format: CoreEventReceivedUrl, hid)
        sendCommonRequest(baseUrlString: IoTConnectUrl!, urlString: formatURL, method: .put, model: nil, info: "Core event received") { (json, success) in
            completionHandler(success)
        }
    }
    
    public func coreEventSucceeded(hid: String, completionHandler: @escaping (_ success: Bool) -> Void) {
        let formatURL = String(format: CoreEventSucceededUrl, hid)
        sendCommonRequest(baseUrlString: IoTConnectUrl!, urlString: formatURL, method: .put, model: nil, info: "Core event succeeded") { (json, success) in
            completionHandler(success)
        }
    }
    
    // MARK: Device state API
    
    public func deviceState(hid: String, completionHandler: @escaping (_ state: DeviceState?) -> Void) {
        let formatURL = String(format: DeviceStateUrl, hid)
        sendCommonRequest(baseUrlString: IoTConnectUrl!, urlString: formatURL, method: .get, model: nil, info: "Device state") { (json, success) in
            if success && json != nil {
                if let data = json as? [String : AnyObject] {
                    completionHandler(DeviceState(json: data))
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
        sendCommonRequest(baseUrlString: IoTConnectUrl!, urlString: formatURL, method: .post, model: state, info: "Device state request") { (json, success) in
            completionHandler(success)
        }
    }
    
    public func deviceStateSucceeded(hid: String, transHid: String, completionHandler: @escaping (_ success: Bool) -> Void) {
        let formatURL = String(format: DeviceStateSucceededUrl, hid, transHid)
        sendCommonRequest(baseUrlString: IoTConnectUrl!, urlString: formatURL, method: .put, model: nil, info: "Device state succeeded") { (json, success) in
            completionHandler(success)
        }
    }
    
    public func deviceStateFailed(hid: String, transHid: String, error: String, completionHandler: @escaping (_ success: Bool) -> Void) {
        let formatURL = String(format: DeviceStateFailedUrl, hid, transHid)
        let errorModel = ErrorModel(error: error)
        sendCommonRequest(baseUrlString: IoTConnectUrl!, urlString: formatURL, method: .put, model: errorModel, info: "Device state failed") { (json, success) in
            completionHandler(success)
        }
    }
    
    public func deviceStateReceived(hid: String, transHid: String, completionHandler: @escaping (_ success: Bool) -> Void) {
        let formatURL = String(format: DeviceStateReceivedUrl, hid, transHid)
        sendCommonRequest(baseUrlString: IoTConnectUrl!, urlString: formatURL, method: .put, model: nil, info: "Device state received") { (json, success) in
            completionHandler(success)
        }
    }
    
    public func deviceStateUpdate(hid: String, state: StateModel, completionHandler: @escaping (_ success: Bool) -> Void) {
        let formatURL = String(format: DeviceStateUpdateUrl, hid)
        sendCommonRequest(baseUrlString: IoTConnectUrl!, urlString: formatURL, method: .post, model: state, info: "Device state update") { (json, success) in
            completionHandler(success)
        }
    }
    
    // MARK: Device type API
    
    public func deviceTypes(completionHandler: @escaping (_ deviceTypes: [DeviceTypeModel]?) -> Void) {
        sendCommonRequest(baseUrlString: IoTConnectUrl!, urlString: DeviceTypesUrl, method: .get, model: nil, info: "Get device types") { (json, success) in
            if success && json != nil {
                if let data = json!["data"] as? [[String : AnyObject]] {
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
    
    public func createDeviceType(deviceType: DeviceTypeModel, completionHandler: @escaping (_ success: Bool) -> Void) {
        sendCommonRequest(baseUrlString: IoTConnectUrl!, urlString: DeviceTypesUrl, method: .post, model: deviceType, info: "Create device type") { (json, success) in
            completionHandler(success)
        }        
    }
    
    public func updateDeviceType(hid: String, deviceType: DeviceTypeModel, completionHandler: @escaping (_ success: Bool) -> Void) {
        let formatURL = String(format: DeviceTypesUrlHid, hid)
        sendCommonRequest(baseUrlString: IoTConnectUrl!, urlString: formatURL, method: .put, model: deviceType, info: "Update device type") { (json, success) in
            completionHandler(success)
        }
    }
    
    // MARK: Node API
    
    public func nodes(completionHandler: @escaping (_ nodes: [NodeModel]?) -> Void) {
        sendCommonRequest(baseUrlString: IoTConnectUrl!, urlString: NodeUrl, method: .get, model: nil, info: "Get nodes") { (json, success) in
            if success && json != nil {
                if let data = json!["data"] as? [[String : AnyObject]] {
                    var nodes = [NodeModel]()
                    for jsonNode in data {
                        nodes.append(NodeModel(json: jsonNode))
                    }
                    completionHandler(nodes)
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }        
    }
    
    public func createNode(node: NodeRequestModel, completionHandler: @escaping (_ success: Bool) -> Void) {
        sendCommonRequest(baseUrlString: IoTConnectUrl!, urlString: NodeUrl, method: .post, model: node, info: "Create node") { (json, success) in
            completionHandler(success)
        }
    }
    
    public func updateNode(hid: String, node: NodeRequestModel, completionHandler: @escaping (_ success: Bool) -> Void) {
        let formatURL = String(format: NodeUrlHid, hid)
        sendCommonRequest(baseUrlString: IoTConnectUrl!, urlString: formatURL, method: .put, model: node, info: "Update node") { (json, success) in
            completionHandler(success)
        }        
    }
    
    // MARK: Node type API
    
    public func nodeTypes(completionHandler: @escaping (_ nodeTypes: [NodeTypeModel]?) -> Void) {
        sendCommonRequest(baseUrlString: IoTConnectUrl!, urlString: NodeTypesUrl, method: .get, model: nil, info: "Get node types") { (json, success) in
            if success && json != nil {
                if let data = json!["data"] as? [[String : AnyObject]] {
                    var nodeTypes = [NodeTypeModel]()
                    for jsonNodeType in data {
                        nodeTypes.append(NodeTypeModel(json: jsonNodeType))
                    }
                    completionHandler(nodeTypes)
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    public func createNodeType(node: NodeTypeRequestModel, completionHandler: @escaping (_ success: Bool) -> Void) {
        sendCommonRequest(baseUrlString: IoTConnectUrl!, urlString: NodeTypesUrl, method: .post, model: node, info: "Create node type") { (json, success) in
            completionHandler(success)
        }
    }
    
    public func updateNodeType(hid: String, node: NodeTypeRequestModel, completionHandler: @escaping (_ success: Bool) -> Void) {
        let formatURL = String(format: NodeTypesUrlHid, hid)
        sendCommonRequest(baseUrlString: IoTConnectUrl!, urlString: formatURL, method: .put, model: node, info: "Update node type") { (json, success) in
            completionHandler(success)
        }
    }
    
    // MARK: Property change API
    
    public func sendPropertyChangeAcknowledge(hid: String) {
        sendPropertyChangeCommon(hid: hid, url: PropertyChangeAcknowledgeUrl, info: "Property Change Acknowledge")
    }
    
    public func sendPropertyChangeSuccessful(hid: String) {
        sendPropertyChangeCommon(hid: hid, url: PropertyChangeSuccessfulUrl, info: "Property Change Successful")
    }
    
    public func sendPropertyChangeFailure(hid: String) {
        sendPropertyChangeCommon(hid: hid, url: PropertyChangeFailureUrl, info: "Property Change Failure")
    }
    
    // MARK: Heartbeat
    
    public func startHeartbeat(interval: Double, gatewayId: String) {
        stopHeartbeat()

        heartbeatTimer = Timer(timeInterval: interval, target: self, selector: #selector(IotConnectService.sendHeartbeat), userInfo: ["gatewayId" : gatewayId], repeats: true)
        RunLoop.current.add(heartbeatTimer!, forMode: RunLoopMode.defaultRunLoopMode)
    }
    
    public func stopHeartbeat() {
        heartbeatTimer?.invalidate()
        heartbeatTimer = nil
    }
    
    func sendHeartbeat(timer: Timer) {
        let userInfo = timer.userInfo as! [String : AnyObject]
        let gatewayId = userInfo["gatewayId"] as! String
        let formatURL = String(format: HeartbeatUrl, gatewayId)
        sendCommonRequest(baseUrlString: IoTConnectUrl!, urlString: formatURL, method: .put, info: "Heartbeat")
    }
    
    // MARK: Device actions API
    
    public func deviceActions(hid: String, completionHandler: @escaping (_ actions: [ActionModel]?) -> Void) {
        let formatURL = String(format: DeviceActionsUrl, hid)
        sendCommonRequest(baseUrlString: IoTConnectUrl!, urlString: formatURL, method: .get, model: nil, info: "Device actions") { (result, success) -> Void in
            if success && result != nil {
                if let data = result!["data"] as? [[String : AnyObject]] {
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
        sendCommonRequest(baseUrlString: IoTConnectUrl!, urlString: formatURL, method: .post, model: action, info: "Add Device Action")

    }
    
    public func updateDeviceAction(hid: String, action: ActionModel) {
        let formatURL = String(format: DeviceActionUpdateUrl, hid, String(action.index))
        sendCommonRequest(baseUrlString: IoTConnectUrl!, urlString: formatURL, method: .put, model: action, info: "Update Device Action")
    }
    
    public func deleteDeviceAction(hid: String, action: ActionModel) {
        let formatURL = String(format: DeviceActionUpdateUrl, hid, String(action.index))
        sendCommonRequest(baseUrlString: IoTConnectUrl!, urlString: formatURL, method: .delete, model: action, info: "Delete Device Action")
    }
    
    // MARK: MQTTServiceMessageDelegate
    
    func messageArrived(message: AnyObject, toTopic topic: String) {
        var commandTopic = "\(MQTTCommandTopic).\(gatewayId!)"
        commandTopic = commandTopic.replacingOccurrences(of: ".", with: "/")
        
        if topic == commandTopic {
            if let dictionary = message as? [String : Any] {
                
                let command = GatewayCommand(json: dictionary)
                
                if let signature = command.signature {
                    
                    let signer = GatewayPayloadSignature(command: command)
                    if signature == signer.sign() {
                        process(gatewayCommand: command)
                    } else {
                        // TODO: Core event failed.
                    }
                } else {
                    process(gatewayCommand: command)
                }
            }
        }
    }
    
    func process(gatewayCommand: GatewayCommand) {
        if let command = gatewayCommand.command {
            let params = gatewayCommand.parameters
            let deviceID = params["deviceHid"] as? String ?? ""
            let commandID = gatewayCommand.hid
            
            switch command {
            case .Start:
                commandDelegate?.startCommand(deviceID: deviceID)
            case .Stop:
                commandDelegate?.stopCommand(deviceID: deviceID)
            case .PropertyChange:
                sendPropertyChangeAcknowledge(hid: commandID)
                commandDelegate?.propertyChangeCommand(deviceID: deviceID, commandID: commandID, parameters: params)
            case .StateRequest:
                if let transHid = params["transHid"] as? String {
                    if let payload = (params["payload"] as? String)?.dictionary() {
                        deviceStateReceived(hid: deviceID, transHid: transHid) { success in }
                        commandDelegate?.deviceStateRequest(deviceID: deviceID, transHid: transHid, parameters: payload)
                    }
                }
            case .DeviceCommand:
                print("[IotConnectService] - DeviceCommand")
            }
        }
    }
    
    // MARK: Pegasus User API
    
    public func authenticate2(model: UserAppAuthenticationModel, completionHandler: @escaping (UserAppModel?) -> Void) {
        sendCommonRequest(baseUrlString: ArrowConnectUrl!, urlString: Auth2Url, method: .post, model: model, info: "Authenticate 2") { (result, success) in
            if success && result != nil {
                let response = UserAppModel(json: result as! [String : AnyObject])
                completionHandler(response)
            } else {
                completionHandler(nil)
            }
        }
    }

    // MARK: Private
    
    private func queryString(urlString: String, parameters: Parameters) -> String? {
        
        let url = URL(string: urlString)!
        let urlRequest = URLRequest(url: url)
        
        do {
            let encodedURLRequest = try URLEncoding.queryString.encode(urlRequest, with: parameters)
            return encodedURLRequest.url?.absoluteString
        } catch let error as NSError {
            print("URLEncoding error \(error)")
            return nil
        }
    }
    
    private func createHeaders(date: String, signature: String) -> [String : String] {
        let headers : [String : String] = [
            "Content-Type"    : "application/json",
            "Accept"          : "application/json",
            IotConnectConstants.Api.XArrowApiKey    : apiKey,
            IotConnectConstants.Api.XArrowDate      : date,
            IotConnectConstants.Api.XArrowVersion   : IotConnectConstants.Api.XArrowVersion_1,
            IotConnectConstants.Api.XArrowSignature : signature
        ]
        
        return headers
    }
    
    private func createURLRequest(urlString: String, date: String, signature: String) -> URLRequest {
        
        let requestURLString = IoTConnectUrl! + urlString
        let url = URL(string: requestURLString)!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        request.setValue(apiKey,                                  forHTTPHeaderField: IotConnectConstants.Api.XArrowApiKey)
        request.setValue(date,                                    forHTTPHeaderField: IotConnectConstants.Api.XArrowDate)
        request.setValue(IotConnectConstants.Api.XArrowVersion_1, forHTTPHeaderField: IotConnectConstants.Api.XArrowVersion)
        request.setValue(signature,                               forHTTPHeaderField: IotConnectConstants.Api.XArrowSignature)
        
        return request
    }
    
    private func sendCommonRequest(baseUrlString: String, urlString: String, method: HTTPMethod, model: RequestModel?, info: String, completionHandler: @escaping (_ result: AnyObject?, _ success: Bool) -> Void) {
        
        print("[IotConnect] \(info) ...")
        
        let requestURL = baseUrlString + urlString
        
        let dateString = Date().formatted
        let signer = ApiRequestSigner()
        signer.secretKey = secretKey
        signer.method    = method.rawValue
        signer.uri       = urlString
        signer.apiKey    = apiKey
        signer.timestamp = dateString
        
        if model != nil {
            signer.payload = model!.payloadString
        } else {
            signer.payload = ""
        }
        
        
        let headers = createHeaders(date: dateString, signature: signer.signV1())
        
        request(requestURL, method: method, parameters: model?.params, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                
                if response.response != nil {
                    print("[IotConnect] \(info) - response code: \(response.response!.statusCode)")
                    if response.response!.statusCode == 200 {
                        if let json = response.result.value {
                            print("[IotConnect] \(info) - Success: \(json)")
                            completionHandler(json as AnyObject?, true)
                        } else {
                            completionHandler(nil, false)
                        }
                    } else {
                        if let json = response.result.value {
                            print("[IotConnect] \(info) - Error: \(json)")
                            completionHandler(json as AnyObject?, false)
                        } else {
                            completionHandler(nil, false)
                        }
                    }
                }
        }
    }
    
    private func sendCommonRequest(baseUrlString: String, urlString: String, method: HTTPMethod, model: RequestModel, info: String) {
        sendCommonRequest(baseUrlString: baseUrlString, urlString: urlString, method: method, model: model, info: info) { (result, success) in }
    }
    
    private func sendCommonRequest(baseUrlString: String, urlString: String, method: HTTPMethod, info: String) {
        sendCommonRequest(baseUrlString: baseUrlString, urlString: urlString, method: method, model: nil, info: info) { (result, success) in }
    }
    
    private func sendPropertyChangeCommon(hid: String, url: String, info: String) {
        let formatURL = String(format: url, hid)
        sendCommonRequest(baseUrlString: IoTConnectUrl!, urlString: formatURL, method: .put, info: info)
    }
}
