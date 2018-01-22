//
//  IotDataPublisher.swift
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

public class IotDataPublisher: NSObject, EDQueueDelegate {
    
    let UploadTaskIdentifier = "upload_task"
    
    var reachability: Reachability?
    
    // singleton
    public static let sharedInstance = IotDataPublisher()

    private override init() {        
        
    }
    
    public func start() {
        EDQueue.sharedInstance().delegate = self
        EDQueue.sharedInstance().start()
        
        setupReachability()
    }
    
    func setupReachability() {
       
        reachability = Reachability()

        reachability?.whenReachable = { reachability in
            EDQueue.sharedInstance().start()
        }
        reachability?.whenUnreachable = { reachability in
            EDQueue.sharedInstance().stop()
        }
        
        do {
            try reachability?.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    public func sendData(data: IotDataLoad) {
        EDQueue.sharedInstance().enqueue(withData: data.toDataDict(), forTask: UploadTaskIdentifier)
    }
    
    // MARK: EDQueueDelegate
    
    public func queue(_ queue: EDQueue!, processJob job: [AnyHashable : Any]!, completion block: AcnSDK.EDQueueCompletionBlock!) {
        print("[EDQueue] - EDQueueDelegate ...")
        let dataLoad = IotDataLoad(dataDict: (job["data"] as! [String: AnyObject]))
        doSendData(dataLoad: dataLoad, completion: block)
    }
   
    // MARK: private
    
    private func doSendData(dataLoad: IotDataLoad, completion block: AcnSDK.EDQueueCompletionBlock!) {
        var cloudPlatform = CloudPlatform.IotConnect
        if Profile.sharedInstance.cloudConfig != nil {
            cloudPlatform = CloudPlatform(rawValue: Profile.sharedInstance.cloudConfig!.cloudPlatform)!
        }
        switch cloudPlatform {
        case .Ibm:
            print("[doSendData] send to IBM ...")
            if Profile.sharedInstance.cloudConfig?.ibmConfig != nil {
                if !WatsonIot.sharedInstance.isConnected() {
                    WatsonIot.sharedInstance.connect()
                }
                WatsonIot.sharedInstance.sendTelemetries(data: dataLoad) { (success) -> Void in
                    if block != nil {
                        if (success) {
                            block(EDQueueResult.success)
                        } else {
                            block(EDQueueResult.fail)
                        }
                    }
                }
            } else {
                print("[doSendData] IBM configuration not found")
            }
        case .IotConnect:
            print("[doSendData] send to IotConnect ...")
            if !ArrowConnectIot.sharedInstance.isMQTTConnected() {
                ArrowConnectIot.sharedInstance.reconnectMQTT()
            }
            ArrowConnectIot.sharedInstance.sendTelemetries(data: dataLoad) { (success) -> Void in
                if block != nil {
                    if (success) {
                        block(EDQueueResult.success)
                    } else {
                        block(EDQueueResult.fail)
                    }
                }
            }
        case .Azure:
            print("[doSendData] send to Azure ...")
            if Profile.sharedInstance.cloudConfig?.azureConfig != nil {
                if !AzureIot.sharedInstance.isConnected() {
                    AzureIot.sharedInstance.connect()
                }
                AzureIot.sharedInstance.sendTelemetries(data: dataLoad) { success in
                    if block != nil {
                        if success {
                            block(EDQueueResult.success)
                        } else {
                            block(EDQueueResult.fail)
                        }
                    }
                }
            } else {
                print("[doSendData] Azure configuration not found")
            }
        default:
            print("[queue] cloudPlatform not supported: \(cloudPlatform)")
        }
    }
}
