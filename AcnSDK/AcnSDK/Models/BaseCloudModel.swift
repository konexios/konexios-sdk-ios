//
//  BaseCloudModel.swift
//  AcnSDK
//
//  Created by Michael Kalinin on 15/04/16.
//  Copyright © 2016 Arrow Electronics. All rights reserved.
//

import Foundation

public class BaseCloudModel {
    
    var params: [String: AnyObject] {
        preconditionFailure("[BaseCloudModel] - Abstract property: params")
    }
    
    var payloadString: String? {
        do {
            let payloadData = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions())
            return String(data: payloadData, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            print("[GatewayModel] JSON Exception: \(error)")
            return nil
        }
    }
}
