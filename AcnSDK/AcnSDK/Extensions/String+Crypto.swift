//
//  String+Crypto.swift
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
//import CommonCrypto

enum CryptoAlgorithm {
    
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
    
//    var HMACAlgorithm: CCHmacAlgorithm {
//        var result: Int = 0
//        switch self {
//        case .MD5:      result = kCCHmacAlgMD5
//        case .SHA1:     result = kCCHmacAlgSHA1
//        case .SHA224:   result = kCCHmacAlgSHA224
//        case .SHA256:   result = kCCHmacAlgSHA256
//        case .SHA384:   result = kCCHmacAlgSHA384
//        case .SHA512:   result = kCCHmacAlgSHA512
//        }
//        return CCHmacAlgorithm(result)
//    }
//
//    var digestLength: Int {
//        var result: Int32 = 0
//        switch self {
//        case .MD5:      result = CC_MD5_DIGEST_LENGTH
//        case .SHA1:     result = CC_SHA1_DIGEST_LENGTH
//        case .SHA224:   result = CC_SHA224_DIGEST_LENGTH
//        case .SHA256:   result = CC_SHA256_DIGEST_LENGTH
//        case .SHA384:   result = CC_SHA384_DIGEST_LENGTH
//        case .SHA512:   result = CC_SHA512_DIGEST_LENGTH
//        }
//        return Int(result)
//    }
}

extension String {
    
    var date: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return dateFormatter.date(from: self)
    }
    
    var base64: String {
        return Data(self.utf8).base64EncodedString()
    }
    
    var base64Decode: Data? {        
        return Data(base64Encoded: self)
    }
    
    func encodeURIComponent() -> String? {
        let characterSet = NSMutableCharacterSet.alphanumeric()
        characterSet.addCharacters(in: "-_.!~*'()")
        
        return self.addingPercentEncoding(withAllowedCharacters: characterSet as CharacterSet)
    }
    
    func hmac(algorithm: CryptoAlgorithm, key: String) -> String {
        let str = self as NSString
        return str.hmac(forKey: key)
//        let str = self.cString(using: String.Encoding.utf8)
//        let strLen = Int(self.lengthOfBytes(using: String.Encoding.utf8))
//
//        let digestLen = algorithm.digestLength
//        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
//        let keyStr = key.cString(using: String.Encoding.utf8)
//        let keyLen = Int(key.lengthOfBytes(using: String.Encoding.utf8))
//
//        CCHmac(algorithm.HMACAlgorithm, keyStr!, keyLen, str!, strLen, result)
//
//        let digest = stringFromResult(result: result, length: digestLen)
//
//        result.deallocate(capacity: digestLen)
//
//        return digest
    }
    
    func hmac(algorithm: CryptoAlgorithm, key: Data) -> String {
        let str = self as NSString
        return str.hmac(forKeyData: key)
//        let str = self.cString(using: String.Encoding.utf8)
//        let strLen = Int(self.lengthOfBytes(using: String.Encoding.utf8))
//
//        let digestLen = algorithm.digestLength
//        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
//
//        CCHmac(algorithm.HMACAlgorithm, (key as NSData).bytes, key.count, str!, strLen, result)
//
//        let data = Data(bytes: UnsafePointer(result), count: digestLen)
//        let base64EncodedData = data.base64EncodedData()
//        return String(data: base64EncodedData, encoding: String.Encoding.utf8)!
    }
    
    func sha256() -> String {
        let str = self as NSString
        return str.sha256
//        let data = self.data(using: String.Encoding.utf8)!
//        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
//        //CC_SHA256(data.bytes, CC_LONG(data.count), &hash)
//        data.withUnsafeBytes {
//            _ = CC_SHA256($0, CC_LONG(data.count), &hash)
//        }
//
//        let output = NSMutableString(capacity: Int(CC_SHA1_DIGEST_LENGTH))
//        for byte in hash {
//            output.appendFormat("%02x", byte)
//        }
//        return output as String
    }
    
    func dictionary() -> [String : Any]? {
        if let data = self.data(using: String.Encoding.utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions())
                return json as? [String : Any]
            } catch let error as NSError {
                print("JSON Exception: \(error)")
                return nil
            }
        } else {
            return nil
        }
    }
    
    private func stringFromResult(result: UnsafeMutablePointer<CUnsignedChar>, length: Int) -> String {
        let hash = NSMutableString()
        for i in 0..<length {
            hash.appendFormat("%02x", result[i])
        }
        return String(hash)
    }
    
}
