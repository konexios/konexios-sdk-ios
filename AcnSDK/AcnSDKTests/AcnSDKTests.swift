//
//  AcnSDK.swift
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

import XCTest
@testable import AcnSDK

class AcnSDKTests: XCTestCase {
    let PegasusUrl = "http://pgsdev01.arrowconnect.io:11003"
    let KronosUrl = "http://pgsdev01.arrowconnect.io:12001"
    let KronosMqttHost = "tcp://pgsdev01.arrowconnect.io"
    let KronosMqttPort = 1883
    let KronosVHost = "/themis.dev"
    let ApiKey = ""
    let SecretKey = ""
    
    override func setUp() {
        super.setUp()
        ArrowConnectIot.sharedInstance.setupConnection(arrowConnectdUrl: PegasusUrl, iotConnectUrl: KronosUrl, mqtt: KronosMqttHost, mqttPort: UInt16(KronosMqttPort), mqttVHost: KronosVHost)
        ArrowConnectIot.sharedInstance.setKeys(apiKey: ApiKey, secretKey: SecretKey)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testListDeviceTypes() {
        let exp = XCTestExpectation()
        ArrowConnectIot.sharedInstance.deviceTypes { (models) in
            XCTAssertTrue(models!.count > 0, "should find some device types")
            for model in models! {
                XCTAssertTrue(model.name != "", "name should be populated")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 20.0)
    }
    
    func testAuth2() {
        let exp = XCTestExpectation()
        let model = UserAppAuthenticationModel(username: "tnguyen@arrowsi.com", password: "$Th@lm@nn8689$", applicationCode: "TNGUYEN")
        ArrowConnectIot.sharedInstance.authenticate2(model: model) { (userApp) in
            XCTAssertNotNil(userApp!.applicationHid, "applicationHid should be populated")
            exp.fulfill()
        }
        wait(for: [exp], timeout: 20.0)
    }
}
