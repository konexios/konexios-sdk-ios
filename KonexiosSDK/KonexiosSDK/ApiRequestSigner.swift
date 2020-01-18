//
//  ApiRequestSigner.swift
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

class ApiRequestSigner {
    
    var secretKey: String?
    var method: String?
    var uri: String?
    var apiKey: String?
    var timestamp: String?
    var payload: String?
    var parameters: [String]?
    
    func signV1() -> String {
        
        var buffer = buildCanonicalRequest()
        buffer += payload!.sha256()
        
        var stringToSign = buffer.sha256()
        stringToSign += "\n"
        
        if apiKey != nil {
            stringToSign += apiKey!
            stringToSign += "\n"
        }
        
        if timestamp != nil {
            stringToSign += timestamp!
            stringToSign += "\n"
        }
        
        stringToSign += IotConnectConstants.Api.XArrowVersion_1
        
        let signingKey = secretKey!.hmac(algorithm: .SHA256, key: apiKey!)
                                   .hmac(algorithm: .SHA256, key: timestamp!)
                                   .hmac(algorithm: .SHA256, key: IotConnectConstants.Api.XArrowVersion_1)
        
        return stringToSign.hmac(algorithm: .SHA256, key: signingKey)
    }
    
    func signV2() -> String {
        
        var buffer = buildCanonicalRequest()
        buffer += payload!.sha256()
        
        var stringToSign = buffer.sha256()
        stringToSign += "\n"
        
        if apiKey != nil {
            stringToSign += apiKey!
            stringToSign += "\n"
        }
        
        if timestamp != nil {
            stringToSign += timestamp!
            stringToSign += "\n"
        }
        
        stringToSign += IotConnectConstants.Api.XArrowVersion_2
        
        let signingKey = apiKey!.hmac(algorithm: .SHA256, key: secretKey!)
                                .hmac(algorithm: .SHA256, key: timestamp!)
                                .hmac(algorithm: .SHA256, key: IotConnectConstants.Api.XArrowVersion_2)
        
        return stringToSign.hmac(algorithm: .SHA256, key: signingKey)
    }

    private func buildCanonicalRequest() -> String {
        var result = ""
        
        if method != nil {
            result += method!
            result += "\n"
        }
        
        if uri != nil {
            result += uri!
            result += "\n"
        }
        
        if parameters != nil {
            parameters! = parameters!.sorted {$0 < $1}
            
            for parameter in parameters! {
                result += parameter
                result += "\n"
            }
        }
        
        return result
    }
    
}
