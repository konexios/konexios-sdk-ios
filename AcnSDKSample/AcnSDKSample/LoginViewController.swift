//
//  LoginViewController.swift
//  AcnSDKSample
//
//  Created by Michael Kalinin on 24/11/2016.
//  Copyright © 2016 Arrow. All rights reserved.
//

import UIKit
import AcnSDK

class LoginViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func signInButtonClicked(_ sender: UIButton) {
        
        let accountModel = AccountRegistrationModel(name:     nameTextField.text!,
                                                    email:    emailTextField.text!.lowercased(),
                                                    password: passwordTextField.text!,
                                                    code:     "")
        
        
        IotConnectService.sharedInstance.registerAccount(accountModel: accountModel) { response in
            
            if response != nil {
                let gatewayModel = GatewayModel()
                gatewayModel.userHid         = response!.hid
                gatewayModel.applicationHid  = response!.applicationHid
                gatewayModel.softwareName    = "AcnSDKSample"
                gatewayModel.softwareVersion = "1.0"
                
                IotConnectService.sharedInstance.registerGateway(gateway: gatewayModel) { (hid, error) in
                    if hid != nil {
                        if let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController {
                            mainViewController.gatewayId = hid
                            mainViewController.userId    = response!.hid
                            self.navigationController?.pushViewController(mainViewController, animated: true)
                        }
                    }
                }
            }
        }
        
    }
}
