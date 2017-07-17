# AcnSDK

# Installation

### Add AcnSDK to Project ###

1. Open your Xcode project for iOS application.
2. Create Frameworks group in your project.
3. Drag the **AcnSDK.framework** file into the created Frameworks group.

# Usage

### Initialize AcnSDK

1. Import the AcnSDK
2. Configure connection url in your application's **application:didFinishLaunchingWithOptions:** method
3. Set API and Secret keys in your application's **application:didFinishLaunchingWithOptions:** method
4. Start IotDataPublisher service

```swift
// 1.
import AcnSDK

...

class AppDelegate: UIResponder, UIApplicationDelegate {    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // 2.
        IotConnectService.sharedInstance.setupConnection(http: ConnectUrl,
                                                         mqtt: MQTTServerHost,
                                                         mqttPort: MQTTServerPort,
                                                         mqttVHost: MQTTVHost)
        
        // 3.
        IotConnectService.sharedInstance.setKeys(apiKey: ApiKey,
                                                 secretKey: SecretKey)
        
        // 4.
        IotDataPublisher.sharedInstance.start()
        
        return true
    }
    
    ...
}
```

### Create new account or login if the account already exists ###

```swift
import AcnSDK
    
...
    
let accountModel = AccountRegistrationModel(name: "name", email: "email", password: "password", code: "app code")
        
IotConnectService.sharedInstance.registerAccount(accountModel) { response in

}

```

### Register with IoTConnect cloud ###

You need to register with IoTConnect cloud when connect the first time.

```swift
import AcnSDK
    
...

let gatewayModel = GatewayModel()

gatewayModel.userHid         = userId // from previous step
gatewayModel.applicationHid  = applicationHid // from previous step
gatewayModel.softwareName    = "SoftwareName"
gatewayModel.softwareVersion = "SoftwareVersion"
                
IotConnectService.sharedInstance.registerGateway(gateway: gatewayModel) { (hid, error) -> Void in
    // save gateway hid
}
```
### Get gateway configuration ###

You need to update gateway configuration after registartion step using gateway hid

```swift
IotConnectService.sharedInstance.gatewayConfig(hid: hid) { success in

}
```

### Register a new device ###

You need to register iot device for sending data to the cloud

```swift
import AcnSDK
    
...

IotConnectService.sharedInstance.registerDevice(device) { (deviceId, error) in
    // save deviceId
}
```

**device** class must conform to IotDevice protocol

```swift
public protocol IotDevice {
    var deviceUid: String? { get }
    var deviceTypeName: String { get }
    var deviceName: String { get }
    var properties: [String: AnyObject] { get }    
}
```

### Send telemetry data ###

```swift
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
    location: location, // CLLocation instance
    parameters: params)
            
// Send data
IotDataPublisher.sharedInstance.sendData(dataLoad)
```
