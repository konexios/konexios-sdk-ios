//
//  AzureService.swift
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

class AzureService {
    
    let deviceId = UIDevice.UUID()
    
    var mqttService: MQTTService?

    static let sharedInstance = AzureService()
    
    private  init() {
        
    }
    
    func isConnected() -> Bool {
        if mqttService != nil {
            return mqttService!.isConnected()
        } else {
            return false
        }
    }
    
    func connect() {
        print("[AzureService] Connect ...")
        
        let azureConfig = Profile.sharedInstance.cloudConfig?.azureConfig
        if azureConfig != nil {
            
            let accessKey = azureConfig!.accessKey
            let host = azureConfig!.host
            
            let clientId = deviceId

            let username = "\(host)/\(deviceId)"
            let endpoint = "\(host)/devices/\(deviceId)"
            
            let SASToken = generateSasToken(uri: endpoint, signingKey: accessKey)
            
            mqttService = MQTTService(host: host, port: 8883, clientId: clientId, user: username, password: SASToken, secureMQTT: true)
            mqttService?.connect()
        }
    }
    
    func sendTelemetries(data: IotDataLoad, completionHandler: @escaping (_ success: Bool) -> Void) {
        print("[AzureService] Send Telemetries ...")
        if mqttService != nil {
            if let payload = data.payloadString {
                let topic = "devices/" + deviceId + "/messages/events/"
                mqttService!.sendPayload(payload: payload, topic: topic)
                completionHandler(true)
            } else {
                completionHandler(false)
            }
        } else {
            completionHandler(false)
        }
    }
    
    func generateSasToken(uri: String, signingKey: String) -> String {
        
        let encodeUri = uri.encodeURIComponent()!
        
        let expiresInSec = 24 * 60 * 60
        let expires = Int(Date().timeIntervalSince1970) + expiresInSec
        
        let toSign = encodeUri + "\n" + "\(expires)"
        
        let hmac = toSign.hmac(algorithm: .SHA256, key: signingKey.base64Decode!)
        let base64UriEncoded = hmac.encodeURIComponent()!
        
        let token = "SharedAccessSignature sr=" + encodeUri + "&sig=" + base64UriEncoded + "&se=" + "\(expires)"

        return token
        
    }
    
    
    
}
