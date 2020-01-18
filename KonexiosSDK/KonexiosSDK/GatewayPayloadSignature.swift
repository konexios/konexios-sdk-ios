//
//  GatewayPayloadSignature.swift
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

class GatewayPayloadSignature {
    
    let signatureVersion = "1"
    
    var apiKey: String?
    var secretKey: String?
    
    var hid: String?
    var name: String?
    var encrypted: String?
    var parameters: [String : String]?
    
    init() {
        apiKey = KonexiosIot.sharedInstance.apiKey
        secretKey = KonexiosIot.sharedInstance.secretKey
    }
    
    convenience init(command: GatewayCommand) {
        self.init()
        hid = command.hid
        name = command.name
        encrypted = String(command.encrypted)
        parameters = command.parameters as? [String : String]
    }
    
    func sign() -> String {
        
        var stringToSign = buildCanonicalRequest().sha256()
        stringToSign += "\n"
        
        if apiKey != nil {
            stringToSign += apiKey!
            stringToSign += "\n"
        }
        
        stringToSign += signatureVersion

        
        let signingKey = secretKey!.hmac(algorithm: .SHA256, key: apiKey!)
                                   .hmac(algorithm: .SHA256, key: signatureVersion)
        
        return stringToSign.hmac(algorithm: .SHA256, key: signingKey)
    }

    
    func buildCanonicalRequest() -> String {
        var result = ""
        
        if hid != nil {
            result += hid!
            result += "\n"
        }
        
        if name != nil {
            result += name!
            result += "\n"
        }
        
        if encrypted != nil {
            result += encrypted!
            result += "\n"
        }
        
        if parameters != nil {
            var canonicalParameterString = ""
            for parameter in parameters!.sorted(by: { $0.0 < $1.0 }) {
                canonicalParameterString += parameter.key.lowercased() + "=" + parameter.value + "\n"
            }
            result += canonicalParameterString            
        }
        
        return result
    }
    
}

