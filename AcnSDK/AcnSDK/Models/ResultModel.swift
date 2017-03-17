//
//  ResultModel.swift
//  AcnSDK
//
//  Created by Michael Kalinin on 15/04/16.
//  Copyright © 2016 Arrow Electronics. All rights reserved.
//

import Foundation

public class ResultModel: ModelAbstract {
    
    public var message: String
    
    init(hid: String, message: String) {
        self.message = message
        super.init(hid: hid)        
    }
}
