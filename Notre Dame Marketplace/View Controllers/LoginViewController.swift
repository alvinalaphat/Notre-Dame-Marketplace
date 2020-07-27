//
//  LoginViewController.swift
//  ND Marketplace
//
//  Created by Eddie Cunningham on 12/3/19.
//  Copyright © 2019 Irish Intel. All rights reserved.
//

import Foundation
import UIKit
import SwiftProtobuf
import SocketSwift

class LoginViewController: UIViewController {
    var signedUp: Bool = false
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
    super.viewDidLoad()
    }
    
    @IBAction func login(_ sender: Any) {
        
        if email.text!.count == 0 || password.text!.count == 0 {
            let alert = UIAlertController(title: "Missing Fields",
                                          message: "You must fill in a username and password!",
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true)
        } else if !email.text!.contains("@nd.edu"){
            let alert = UIAlertController(title: "Invalid Email",
                                          message: "You must use your Notre Dame issued email when creating an account.",
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true)
        } else {
            let userCredentials = UserAuthenticationRequest.Builder()
            userCredentials.setEmail(email.text!)
            userCredentials.setPassword(password.text!)
            
            let buildData: Data = try! userCredentials.build().data()
            
            let clientConnector = ClientConnector(port: 7002)
            
            // Hangs for 2 seconds while it tries to connect and send data.
            let responseData = clientConnector.connectAndSend(data: buildData) as Data
            
            guard let response: UserAuthenticationResponse = try? UserAuthenticationResponse.Builder().mergeFrom(data: responseData).build() else {
                let alert = UIAlertController(title: "Failure to create user!",
                                              message: "Something went terribly wrong when creating your profile. Please try again.",
                                              preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true)
                return
            }
            
            if (response.hasUser && response.hasStatus && response.status) {
                signedUp = true
                let user: User = (response.user)
                UserDefaults.standard.set(user.data(), forKey: "user_profile")
                print("Set Profile")
                UserDefaults.standard.set(true, forKey: "is_logged_in")
                print("Set login status")
                
                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BuyViewController") as UIViewController

                self.present(viewController, animated: false, completion: nil)
            } else {
                signedUp = false
                let alert = UIAlertController(title: "Failure to login user!",
                                              message: "It appears that there could be an account that is already in this name. Try using another email",
                                              preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
}
