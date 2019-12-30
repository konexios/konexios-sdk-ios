//
//  Data + Extension.swift
//  KonexiosSDK
//
//  Created by Alexey Chechetkin on 27/03/2018.
//  Copyright © 2018 Arrow. All rights reserved.
//

import Foundation

extension Data {
    public var md5: String {
        return (self as NSData).md5
    }
}
