//
//  IotFoundation.swift
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

import Foundation

class WatsonIot {
    
    let IbmIoTServerAddress = "%@.messaging.internetofthings.ibmcloud.com"
    let IbmIoTServerPort: UInt16 = 8883
    let IbmIoTClientId = "g:%@:%@:%@"
    let IbmIoTTopic = "iot-2/type/%@/id/%@/evt/telemetry/fmt/json"
    
    let IbmIoTDeviceUsername = "use-token-auth"
    
    var mqttService: MQTTService?
    
    // singleton
    static let sharedInstance = WatsonIot()
    
    private  init() {
        
    }
    
    func sendTelemetries(data: IotDataLoad, completionHandler: @escaping (_ success: Bool) -> Void) {
        print("[IotFoundation] Send Telemetries MQTT ...")
        if mqttService != nil {
            if let payload = data.payloadString {
                let topic = String(format: IbmIoTTopic, data.deviceType, data.externalId)
                mqttService!.sendPayload(payload: payload, topic: topic)
                completionHandler(true)
            } else {
                completionHandler(false)
            }
        } else {
            completionHandler(false)
        }
    }

    func connect() {
        print("[IotFoundation] Connect ...")
        let ibmConfig = Profile.sharedInstance.cloudConfig?.ibmConfig
        if ibmConfig != nil {
            let serverAddress = String(format: IbmIoTServerAddress, ibmConfig!.organizationId)
            let clientId      = String(format: IbmIoTClientId, ibmConfig!.organizationId, ibmConfig!.gatewayType, ibmConfig!.gatewayId)
            
            print("[IotFoundation] serverAddress: \(serverAddress), clientId: \(clientId)")
            mqttService = MQTTService(host: serverAddress, port: IbmIoTServerPort, clientId: clientId, user: IbmIoTDeviceUsername, password: ibmConfig!.authToken, secureMQTT: true)
            mqttService?.connect()
        }
    }
    
    func disconnect() {
        mqttService?.disconnect()
    }
    
    func isConnected() -> Bool {
        if mqttService != nil {
            return mqttService!.isConnected()
        } else {
            return false
        }
    }

}
