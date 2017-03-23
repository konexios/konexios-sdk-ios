//
//  GatewayConfigResponse.swift
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

public class IotConnectConfig : NSObject, NSCoding {
    
    var apiKey: String
    var secretKey: String
    
    init(dictionary: [String : AnyObject]) {
        apiKey    = dictionary["apiKey"] as! String
        secretKey = dictionary["secretKey"] as! String
    }
    
    required public init(coder decoder: NSCoder) {
        self.apiKey = decoder.decodeObject(forKey: "apiKey") as? String ?? ""
        self.secretKey = decoder.decodeObject(forKey: "secretKey") as? String ?? ""
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(apiKey, forKey: "apiKey")
        coder.encode(secretKey, forKey: "secretKey")
    }
}

public class AwsConfig : NSObject, NSCoding {
    
    var caCert: String
    var clientCert: String
    var host: String
    var port: Int
    var privateKey: String
    
    init(dictionary: [String : AnyObject]) {
        caCert     = dictionary["caCert"] as! String
        clientCert = dictionary["clientCert"] as! String
        host       = dictionary["host"] as! String
        port       = dictionary["port"] as! Int
        privateKey = dictionary["privateKey"] as! String
    }

    required public init(coder decoder: NSCoder) {
        self.caCert = decoder.decodeObject(forKey: "caCert") as? String ?? ""
        self.clientCert = decoder.decodeObject(forKey: "clientCert") as? String ?? ""
        self.host = decoder.decodeObject(forKey: "host") as? String ?? ""
        self.port = decoder.decodeInteger(forKey: "port")
        self.privateKey = decoder.decodeObject(forKey: "privateKey") as? String ?? ""
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(caCert, forKey: "caCert")
        coder.encode(clientCert, forKey: "clientCert")
        coder.encode(host, forKey: "host")
        coder.encode(port, forKey: "port")
        coder.encode(privateKey, forKey: "privateKey")
    }
}

public class IbmConfig : NSObject, NSCoding {
    
    var authMethod: String
    var authToken: String
    var gatewayId: String
    var gatewayType: String
    var organizationId: String
    
    init(dictionary: [String : AnyObject]) {
        authMethod     = dictionary["authMethod"] as! String
        authToken      = dictionary["authToken"] as! String
        gatewayId      = dictionary["gatewayId"] as! String
        gatewayType    = dictionary["gatewayType"] as! String
        organizationId = dictionary["organizationId"] as! String
    }
    
    required public init(coder decoder: NSCoder) {
        self.authMethod = decoder.decodeObject(forKey: "authMethod") as? String ?? ""
        self.authToken = decoder.decodeObject(forKey: "authToken") as? String ?? ""
        self.gatewayId = decoder.decodeObject(forKey: "gatewayId") as? String ?? ""
        self.gatewayType = decoder.decodeObject(forKey: "gatewayType") as? String ?? ""
        self.organizationId = decoder.decodeObject(forKey: "organizationId") as? String ?? ""
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(authMethod, forKey: "authMethod")
        coder.encode(authToken, forKey: "authToken")
        coder.encode(gatewayId, forKey: "gatewayId")
        coder.encode(gatewayType, forKey: "gatewayType")
        coder.encode(organizationId, forKey: "organizationId")
    }
}

public class AzureConfig : NSObject, NSCoding {
    
    var accessKey: String
    var host: String
    
    init(dictionary: [String : AnyObject]) {
        accessKey = dictionary["accessKey"] as? String ?? ""
        host      = dictionary["host"] as? String ?? ""
    }
    
    required public init(coder decoder: NSCoder) {
        self.accessKey = decoder.decodeObject(forKey: "accessKey") as? String ?? ""
        self.host = decoder.decodeObject(forKey: "host") as? String ?? ""
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(accessKey, forKey: "accessKey")
        coder.encode(host, forKey: "host")
    }
}


public class GatewayConfigResponse : NSObject, NSCoding {
    var cloudPlatform: String
    var iotConnectConfig: IotConnectConfig
    var awsConfig: AwsConfig?
    var ibmConfig: IbmConfig?
    var azureConfig: AzureConfig?
    
    init(dictionary: [String : AnyObject]) {
        cloudPlatform = dictionary["cloudPlatform"] as! String
        iotConnectConfig = IotConnectConfig(dictionary: dictionary["key"] as! [String : AnyObject])
        
        if let aws = dictionary["aws"] as? [String : AnyObject] {
            awsConfig = AwsConfig(dictionary: aws)
        }
        
        if let ibm = dictionary["ibm"] as? [String : AnyObject] {
            ibmConfig = IbmConfig(dictionary: ibm)
        }
        
        if let azure = dictionary["azure"] as? [String : AnyObject] {
            azureConfig = AzureConfig(dictionary: azure)
        }
    }

    required public init(coder decoder: NSCoder) {
        self.cloudPlatform = decoder.decodeObject(forKey: "cloudPlatform") as? String ?? ""
        self.iotConnectConfig = decoder.decodeObject(forKey: "iotConnectConfig") as! IotConnectConfig
        self.awsConfig = decoder.decodeObject(forKey: "awsConfig") as? AwsConfig
        self.ibmConfig = decoder.decodeObject(forKey: "ibmConfig") as? IbmConfig
        self.azureConfig = decoder.decodeObject(forKey: "azureConfig") as? AzureConfig
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(cloudPlatform, forKey: "cloudPlatform")
        coder.encode(iotConnectConfig, forKey: "iotConnectConfig")
        if awsConfig != nil {
            coder.encode(awsConfig, forKey: "awsConfig")
        }
        if ibmConfig != nil {
            coder.encode(ibmConfig, forKey: "ibmConfig")
        }
        if azureConfig != nil {
            coder.encode(azureConfig, forKey: "azureConfig")
        }
    }
}
