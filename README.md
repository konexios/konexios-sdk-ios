# AcnSDK #

### Add AcnSDK to Project ###

1. Open your Xcode project for iOS application.
2. Create Frameworks group in your project.
3. Drag the **AcnSDK.framework** file into the created Frameworks group.

### Create new account or login if the account already exists ###

    import AcnSDK
    
    ...
    
    let accountModel = AccountRegistrationModel(name: "name", email: "email", password: "password", code: "app code")
        
    IotConnectService.sharedInstance.registerAccount(accountModel) { response in
            
    }

### Register with IoTConnect cloud ###

You need to register with IoTConnect cloud when connect the first time.

    import AcnSDK
    
    ...

    IotConnectService.sharedInstance.registerGateway { (hid, error) -> Void in
       
    }

### Register a new device ###

You can register a new device

    import AcnSDK
    
    ...

    IotConnectService.sharedInstance.registerDevice(device) { (deviceId, error) in
            
    }

**device** class must conform to IotDevice protocol

    public protocol IotDevice {
        var deviceUid: String? { get }
        var deviceTypeName: String { get }
        var deviceName: String { get }
        var properties: [String: AnyObject] { get }
    
    }


### Send telemetry data ###

    import AcnSDK
    
    ...

    // Example of telemetry data
    let params = [IotParameter(key: "f|humidity", value: "40.2"),
                  IotParameter(key: "f|temperature", value: "25.2"),
                  IotParameter(key: "i|heartRate", value: "80")]
            
    // Build dataLoad to send
    let dataLoad = IotDataLoad(
        deviceId: "your-device-id", // deviceId from device registartion step
        iotDeviceUID: "your-device-uid",
        timestamp: Int64(NSDate().timeIntervalSince1970) * 1000,
        location: Location.sharedInstance.currentLocation(),
        parameters: params)
            
    // Send data
    IotDataPublisher.sharedInstance.sendData(dataLoad)
