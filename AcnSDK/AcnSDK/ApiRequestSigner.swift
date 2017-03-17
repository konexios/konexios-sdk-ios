//
//  ApiRequestSigner.swift
//  AcnSDK
//
//  Created by Michael Kalinin on 08/04/16.
//  Copyright © 2016 Arrow Electronics. All rights reserved.
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
