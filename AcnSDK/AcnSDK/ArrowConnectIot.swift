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

public protocol DeviceCommandDelegate: class {
    func startDevice(hid: String)
    func stopDevice(hid: String)
    func commandDevice(hid: String)
    func updateDeviceProperty(hid: String, commandID: String, parameters: [String: AnyObject])
    func requestDeviceState(hid: String, transHid: String, parameters: [String: Any])
    func updateDeviceSoftware(model: SoftwareReleaseCommandModel)
}

public protocol GatewayCommandDelegate: class {
    func updateGatewaySoftware(model: SoftwareReleaseCommandModel)
}

public class ArrowConnectIot: NSObject, MQTTServiceMessageDelegate {
    
    public weak var deviceCommandDelegate: DeviceCommandDelegate?
    public weak var gatewayCommandDelegate: GatewayCommandDelegate?
    
    var IotUrl: String?
    var ArrowConnectUrl: String?
    
    var DefaultApiKey: String?
    var DefaultSecretKey: String?
    
    var gatewayId: String?
    
    let TelemetryPostUrl = "/api/v1/kronos/telemetries"
    let TelemetryApplicationUrl = "/api/v1/kronos/telemetries/applications/%@"
    let TelemetryDeviceUrl = "/api/v1/kronos/telemetries/devices/%@"
    let TelemetryCountDeviceUrl = "/api/v1/kronos/telemetries/devices/%@/count"
    let TelemetryAvgDeviceUrl = "/api/v1/kronos/telemetries/devices/%@/avg"
    let TelemetryLatestDeviceUrl = "/api/v1/kronos/telemetries/devices/%@/latest"
    let TelemetryMaxDeviceUrl = "/api/v1/kronos/telemetries/devices/%@/max"
    let TelemetryMinDeviceUrl = "/api/v1/kronos/telemetries/devices/%@/min"
    let TelemetryNodeUrl = "/api/v1/kronos/telemetries/nodes/%@"
    let BatchTelemetryPostUrl = "/api/v1/kronos/telemetries/batch"
    
    let AccountRegisterUrl = "/api/v1/kronos/accounts"
    
    let HeartbeatUrl = "/api/v1/kronos/gateways/%@/heartbeat"
    
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
    
    let MQTTSendTopic = "krs.tel.gts"
    let MQTTSendBatchTopic = "krs.tel.bat.gts"
    let MQTTCommandTopic = "krs.cmd.stg"
    
    var mqttService: MQTTService?
    
    var MQTTServiceAvailable = true
    
    var queue = IotDataLoadQueue()
    public var sendingDevicesCount = 0
    
    // MARK: API modules
    public let nodeApi = NodeApi()
    public let coreApi = CoreApi()
    public let gateApi = GatewayApi()
    public let deviceApi = DeviceApi()
    
    // MARK: Singleton
    public static let sharedInstance = ArrowConnectIot()
    
    private override init() {
        super.init()
    }
    
    public func setupConnection(arrowConnectUrl: String, iotUrl: String, mqtt: String, mqttPort: UInt16, mqttVHost: String) {
        ArrowConnectUrl = arrowConnectUrl
        IotUrl = iotUrl
        MQTTServerHost = mqtt
        MQTTServerPort = mqttPort
        MQTTVHost = mqttVHost
    }
    
    public func setKeys(apiKey: String, secretKey: String) {
        DefaultApiKey = apiKey
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
        signer.method = HTTPMethod.POST.rawValue
        signer.uri = BatchTelemetryPostUrl
        signer.apiKey = apiKey
        signer.timestamp = dateString
        signer.payload = queue.batchPayload()!
        
        var urlRequest = createURLRequest(urlString: BatchTelemetryPostUrl, date: dateString, signature: signer.signV1())
        urlRequest.httpBody = queue.batchData()!
        
        request(urlRequest).responseJSON { response in
            if response.response != nil {
                print("[IotConnect] Send Batch Telemetries - response code: \(response.response!.statusCode)")
                if response.response!.statusCode == 200 {
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
        sendCommonRequest(baseUrlString: IotUrl!, urlString: TelemetryPostUrl, method: .POST, model: data, info: "Send Telemetries") { _, success in
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
            "toTimestamp": toDate.formatted,
            "_page": page
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
        
        sendCommonRequest(baseUrlString: IotUrl!, urlString: requestUrl!, method: .GET, model: nil, info: "Get telemetries") { json, success in
            if success && json != nil {
                response = TelemetryListResponse(json: json as! [String: AnyObject])
            }
            semaphore.signal()
        }
        
        semaphore.wait()
        
        return response
    }
    
    public func deviceTelemetryCount(hid: String, telemetry: String, fromDate: Date, toDate: Date, completionHandler: @escaping (TelemetryCountModel?) -> Void) {
        
        let parameters: Parameters = [
            "fromTimestamp": fromDate.formatted,
            "toTimestamp": toDate.formatted,
            "telemetryName": telemetry
        ]
        
        let formatUrl = String(format: TelemetryCountDeviceUrl, hid)
        let requestUrl = queryString(urlString: formatUrl, parameters: parameters)
        
        sendCommonRequest(baseUrlString: IotUrl!, urlString: requestUrl!, method: .GET, model: nil, info: "Telemetry Count") { json, success in
            if success && json != nil {
                if let data = json as? [String: AnyObject] {
                    completionHandler(TelemetryCountModel(json: data))
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    public func deviceTelemetryAvg(hid: String, telemetry: String, itemType: String, fromDate: Date, toDate: Date, completionHandler: @escaping (TelemetryCountModel?) -> Void) {
        
        let parameters: Parameters = [
            "fromTimestamp": fromDate.formatted,
            "toTimestamp": toDate.formatted,
            "telemetryName": telemetry,
            "telemetryItemType": itemType
        ]
        
        let formatUrl = String(format: TelemetryAvgDeviceUrl, hid)
        let requestUrl = queryString(urlString: formatUrl, parameters: parameters)
        
        sendCommonRequest(baseUrlString: IotUrl!, urlString: requestUrl!, method: .GET, model: nil, info: "Telemetry Avg") { json, success in
            if success && json != nil {
                if let data = json as? [String: AnyObject] {
                    completionHandler(TelemetryCountModel(json: data))
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    public func deviceTelemetryLast(hid: String, completionHandler: @escaping ([TelemetryModel]?) -> Void) {
        
        let formatUrl = String(format: TelemetryLatestDeviceUrl, hid)
        
        sendCommonRequest(baseUrlString: IotUrl!, urlString: formatUrl, method: .GET, model: nil, info: "Telemetry Last") { json, success in
            if success && json != nil {
                if let data = json as? [String: AnyObject] {
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
    
    public func deviceTelemetryMax(hid: String, telemetry: String, itemType: String, fromDate: Date, toDate: Date, completionHandler: @escaping (TelemetryCountModel?) -> Void) {
        
        let parameters: Parameters = [
            "fromTimestamp": fromDate.formatted,
            "toTimestamp": toDate.formatted,
            "telemetryName": telemetry,
            "telemetryItemType": itemType
        ]
        
        let formatUrl = String(format: TelemetryMaxDeviceUrl, hid)
        let requestUrl = queryString(urlString: formatUrl, parameters: parameters)
        
        sendCommonRequest(baseUrlString: IotUrl!, urlString: requestUrl!, method: .GET, model: nil, info: "Telemetry Max") { json, success in
            if success && json != nil {
                if let data = json as? [String: AnyObject] {
                    completionHandler(TelemetryCountModel(json: data))
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    public func deviceTelemetryMin(hid: String, telemetry: String, itemType: String, fromDate: Date, toDate: Date, completionHandler: @escaping (TelemetryCountModel?) -> Void) {
        
        let parameters: Parameters = [
            "fromTimestamp": fromDate.formatted,
            "toTimestamp": toDate.formatted,
            "telemetryName": telemetry,
            "telemetryItemType": itemType
        ]
        
        let formatUrl = String(format: TelemetryMinDeviceUrl, hid)
        let requestUrl = queryString(urlString: formatUrl, parameters: parameters)
        
        sendCommonRequest(baseUrlString: IotUrl!, urlString: requestUrl!, method: .GET, model: nil, info: "Telemetry Min") { json, success in
            if success && json != nil {
                if let data = json as? [String: AnyObject] {
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
        sendCommonRequest(baseUrlString: IotUrl!, urlString: AccountRegisterUrl, method: .POST, model: accountModel, info: "Register Account") { result, success in
            if success && result != nil {
                let response = AccountRegistrationResponse(json: result as! [String: AnyObject])
                completionHandler(response)
            } else {
                completionHandler(nil)
            }
        }
    }
    
    // MARK: Heartbeat
    
    public func startHeartbeat(interval: Double, gatewayId: String) {
        stopHeartbeat()
        
        heartbeatTimer = Timer(timeInterval: interval, target: self, selector: #selector(ArrowConnectIot.sendHeartbeat), userInfo: ["gatewayId": gatewayId], repeats: true)
        RunLoop.current.add(heartbeatTimer!, forMode: RunLoopMode.defaultRunLoopMode)
    }
    
    public func stopHeartbeat() {
        heartbeatTimer?.invalidate()
        heartbeatTimer = nil
    }
    
    func sendHeartbeat(timer: Timer) {
        let userInfo = timer.userInfo as! [String: AnyObject]
        let gatewayId = userInfo["gatewayId"] as! String
        let formatURL = String(format: HeartbeatUrl, gatewayId)
        sendCommonRequest(baseUrlString: IotUrl!, urlString: formatURL, method: .PUT, model: nil, info: "Heartbeat") { _, _ in }
    }
    
    // MARK: MQTTServiceMessageDelegate
    
    func messageArrived(message: AnyObject, toTopic topic: String) {
        var commandTopic = "\(MQTTCommandTopic).\(gatewayId!)"
        commandTopic = commandTopic.replacingOccurrences(of: ".", with: "/")
        
        if topic == commandTopic {
            if let dictionary = message as? [String: Any] {
                
                let command = GatewayCommand(json: dictionary)
                let eventHid = command.hid
                coreApi.coreEventReceived(hid: eventHid, completionHandler: { _ in })
                var error = ""
                if let signature = command.signature {
                    let signer = GatewayPayloadSignature(command: command)
                    if signature == signer.sign() {
                        error = process(gatewayCommand: command)
                    } else {
                        error = "Invalid digital signature"
                    }
                } else {
                    error = process(gatewayCommand: command)
                }
                
                if error.isEmpty {
                    coreApi.coreEventSucceeded(hid: eventHid, completionHandler: { _ in })
                } else {
                    coreApi.coreEventFailed(hid: eventHid, error: error, completionHandler: { _ in })
                }
            }
        }
    }
    
    func process(gatewayCommand: GatewayCommand) -> String {
        let params = gatewayCommand.parameters
        let eventHid = gatewayCommand.hid
        
        if let command = gatewayCommand.command {
            let deviceHid = params["deviceHid"] as? String ?? ""
            switch command {
            case ServerToGatewayCommand.DeviceStart:
                if !deviceHid.isEmpty {
                    if deviceCommandDelegate != nil {
                        deviceCommandDelegate!.startDevice(hid: deviceHid)
                    } else {
                        return "not implemented"
                    }
                } else {
                    return "deviceHid is missing"
                }
            case ServerToGatewayCommand.DeviceStop:
                if !deviceHid.isEmpty {
                    if deviceCommandDelegate != nil {
                        deviceCommandDelegate!.stopDevice(hid: deviceHid)
                    } else {
                        return "not implemented"
                    }
                } else {
                    return "deviceHid is missing"
                }
            case ServerToGatewayCommand.DevicePropertyChange:
                if !deviceHid.isEmpty {
                    if deviceCommandDelegate != nil {
                        deviceCommandDelegate!.updateDeviceProperty(hid: deviceHid, commandID: eventHid, parameters: params)
                    } else {
                        return "not implemented"
                    }
                } else {
                    return "deviceHid is missing"
                }
            case ServerToGatewayCommand.DeviceStateRequest:
                if !deviceHid.isEmpty {
                    if let transHid = params["transHid"] as? String {
                        if let payload = (params["payload"] as? String)?.dictionary() {
                            deviceApi.deviceStateReceived(hid: deviceHid, transHid: transHid) { _ in }
                            if deviceCommandDelegate != nil {
                                deviceCommandDelegate!.requestDeviceState(hid: deviceHid, transHid: transHid, parameters: payload)
                            } else {
                                return "not implemented"
                            }
                        } else {
                            return "payload is missing"
                        }
                    } else {
                        return "transHid is missing"
                    }
                } else {
                    return "deviceHid is missing"
                }
            case ServerToGatewayCommand.DeviceCommand:
                if !deviceHid.isEmpty {
                    if deviceCommandDelegate != nil {
                        deviceCommandDelegate!.commandDevice(hid: deviceHid)
                    } else {
                        return "not implemented"
                    }
                } else {
                    return "deviceHid is missing"
                }
            case ServerToGatewayCommand.DeviceSoftwareUpdate:
                if deviceCommandDelegate != nil {
                    deviceCommandDelegate!.updateDeviceSoftware(model: SoftwareReleaseCommandModel(json: params))
                } else {
                    return "not implemented"
                }
            case ServerToGatewayCommand.GatewaySoftwareUpdate:
                if gatewayCommandDelegate != nil {
                    gatewayCommandDelegate!.updateGatewaySoftware(model: SoftwareReleaseCommandModel(json: params))
                } else {
                    return "not implemented"
                }
            }
        } else {
            return "command is missing"
        }
        
        return ""
    }
    
    // MARK: Pegasus User API
    
    public func authenticate2(model: UserAppAuthenticationModel, completionHandler: @escaping (UserAppModel?) -> Void) {
        sendCommonRequest(baseUrlString: ArrowConnectUrl!, urlString: Auth2Url, method: .POST, model: model, info: "Authenticate 2") { result, success in
            if success && result != nil {
                let response = UserAppModel(json: result as! [String: AnyObject])
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
    
    private func createHeaders(date: String, signature: String) -> [String: String] {
        let headers: [String: String] = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            IotConnectConstants.Api.XArrowApiKey: apiKey,
            IotConnectConstants.Api.XArrowDate: date,
            IotConnectConstants.Api.XArrowVersion: IotConnectConstants.Api.XArrowVersion_1,
            IotConnectConstants.Api.XArrowSignature: signature
        ]
        
        return headers
    }
    
    private func createURLRequest(urlString: String, date: String, signature: String) -> URLRequest {
        
        let requestURLString = IotUrl! + urlString
        let url = URL(string: requestURLString)!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        request.setValue(apiKey, forHTTPHeaderField: IotConnectConstants.Api.XArrowApiKey)
        request.setValue(date, forHTTPHeaderField: IotConnectConstants.Api.XArrowDate)
        request.setValue(IotConnectConstants.Api.XArrowVersion_1, forHTTPHeaderField: IotConnectConstants.Api.XArrowVersion)
        request.setValue(signature, forHTTPHeaderField: IotConnectConstants.Api.XArrowSignature)
        
        return request
    }
    
    func sendCommonRequest(baseUrlString: String, urlString: String, method: HTTPMethod, model: RequestModel?, info: String, completionHandler: @escaping (_ result: AnyObject?, _ success: Bool) -> Void) {
        
        print("[IotConnect] \(info) ...")
        
        let requestURL = baseUrlString + urlString
        
        let dateString = Date().formatted
        let signer = ApiRequestSigner()
        signer.secretKey = secretKey
        signer.method = method.rawValue
        signer.uri = urlString
        signer.apiKey = apiKey
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
}
