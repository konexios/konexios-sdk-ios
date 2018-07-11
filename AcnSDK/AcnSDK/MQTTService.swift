//
//  MQTTService.swift
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

protocol MQTTServiceMessageDelegate: class {
    func messageArrived(message: AnyObject, toTopic topic: String)
}

class MQTTService: NSObject, CocoaMQTTDelegate {
    
    let connectTimeout = 5
    
    weak var messageDelegate: MQTTServiceMessageDelegate?
    
    var cocoaMQTT: CocoaMQTT
    var semaphore : DispatchSemaphore?
    
    init(host: String, port: UInt16, clientId: String, user: String, password: String, secureMQTT: Bool = false) {
        
        cocoaMQTT = CocoaMQTT(clientId: clientId, host: host, port: port)
        cocoaMQTT.username = user
        cocoaMQTT.password = password
        cocoaMQTT.secureMQTT = secureMQTT
        cocoaMQTT.cleanSess = false
        
        super.init()
        cocoaMQTT.delegate = self
    }
    
    
    func connect() {
        
        print("[MQTTService] Connect ...")
        
        semaphore = DispatchSemaphore(value: 0)
        
        cocoaMQTT.connect()
        
        let dispatchTime = DispatchTime.now() + .seconds(connectTimeout)
        let ret = semaphore!.wait(timeout: dispatchTime)
        
        if (ret != .success) {
            print("[MQTTService] Error: Connect TIMEOUT!")
        } else {
            print("[MQTTService] Connected!")
        }
    }
    
    func disconnect() {
        if isConnected() {
            print("[MQTTService] Disconnect ...")
            
            semaphore = DispatchSemaphore(value: 0)
            
            cocoaMQTT.disconnect()
            
            let dispatchTime = DispatchTime.now() + .seconds(connectTimeout)
            let ret = semaphore!.wait(timeout: dispatchTime)
            
            if (ret != .success) {
                print("[MQTTService] Error: Disconnect TIMEOUT!")
            }
        }
    }
    
    func subscribe(topic: String) {
        if isConnected() {
            print("[MQTTService] Subscribe to topic: \(topic)")
            
            semaphore = DispatchSemaphore(value: 0)
            
            cocoaMQTT.subscribe(topic)
            
            let dispatchTime = DispatchTime.now() + .seconds(connectTimeout)
            let ret = semaphore!.wait(timeout: dispatchTime)
            
            if (ret != .success) {
                print("[MQTTService] Error: Subscribe TIMEOUT!")
            }
        }
    }
    
    func sendPayload(payload: String, topic: String) {
        if isConnected() {
            print("[MQTTService] sending payload to: \(topic)")
            let message = CocoaMQTTMessage(topic: topic, string: payload)
            cocoaMQTT.publish(message)
        }
    }
    
    func isConnected() -> Bool {
        print("[MQTTService] isConnected \(cocoaMQTT.connState)")
        return cocoaMQTT.connState == .connected
    }
    
    // MARK: CocoaMQTTDelegate
    
    func mqtt(_ mqtt: CocoaMQTT, didConnect host: String, port: Int) {
        print("[MQTTService] didConnect")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        print("[MQTTService] didConnectAck \(ack)")
        semaphore?.signal()
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        print("[MQTTService] didPublishMessage")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        print("[MQTTService] didPublishAck")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16 ) {
        print("[MQTTService] didReceiveMessage")
        if let data = message.string?.data(using: String.Encoding.utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions())
                messageDelegate?.messageArrived(message: json as AnyObject, toTopic: message.topic)
                print(json)
            } catch let error as NSError {
                print("[MQTTService] JSON Exception: \(error)")
            }
        }
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topic: String) {
        print("[MQTTService] didSubscribeTopic \(topic)")
        semaphore?.signal()
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        print("[MQTTService] didUnsubscribeTopic")
    }
    
    func mqttDidPing(_ mqtt: CocoaMQTT) {
    }
    
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        print("[MQTTService] mqttDidDisconnect")
        semaphore?.signal()
    }
}

