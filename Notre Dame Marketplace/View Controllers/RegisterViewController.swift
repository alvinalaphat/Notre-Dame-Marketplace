//
//  RegisterViewController.swift
//  ND Marketplace
//
//  Created by Eddie Cunningham on 12/3/19.
//  Copyright © 2019 Irish Intel. All rights reserved.
//

import Foundation
import UIKit
import SwiftProtobuf
import SocketSwift

class RegisterViewController: UIViewController {
    private var signedUp: Bool = false
    private var finishedSuccessfully: Bool = false

    private let dorms = ["Duncan", "Dillon", "Ryan", "McGlenn", "Dunne", "Dillon", "B.P.", "Cavanaugh"]
    private let majors = ["Computer Science", "Marketing", "Chemical Engineering", "Finance", "PLS", "FTT", "Others"]
    private let years = ["2020", "2021", "2022", "2023", "2024", "2025"]
    
    @IBOutlet weak var InformationView: UIView!
    @IBOutlet weak var VerificationView: UIView!
    @IBOutlet weak var pickerViews: UIView!
    @IBOutlet weak var dormPicker: UIPickerView!
    @IBOutlet weak var majorPicker: UIPickerView!
    @IBOutlet weak var yearPicker: UIPickerView!
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var retypedPassword: UITextField!
    
    @IBOutlet weak var auth: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dormPicker.dataSource = self;
        dormPicker.delegate = self;
        
        majorPicker.dataSource = self;
        majorPicker.delegate = self;
        
        yearPicker.dataSource = self;
        yearPicker.delegate = self;
        
        dormPicker.isHidden = true
        majorPicker.isHidden = true
        yearPicker.isHidden = true
    }
    
    @IBAction func pickDorm(_ sender: Any) {
        if (dormPicker.isHidden) {
            // Success
            UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut], animations: {
                self.pickerViews.frame.origin.x = 0
            }, completion: nil)
            dormPicker.isHidden = false
        } else {
            // Success
            UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut], animations: {
                self.pickerViews.frame.origin.x = 414
            }, completion: nil)
            dormPicker.isHidden = true
        }
    }
    
    @IBAction func pickMajor(_ sender: Any) {
        if (majorPicker.isHidden) {
            // Success
            UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut], animations: {
                self.pickerViews.frame.origin.x = 0
            }, completion: nil)
            majorPicker.isHidden = false
        } else {
            // Success
            UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut], animations: {
                self.pickerViews.frame.origin.x = 414
            }, completion: nil)
            majorPicker.isHidden = true
        }
    }
    
    @IBAction func pickYear(_ sender: Any) {
        if (yearPicker.isHidden) {
            // Success
            UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut], animations: {
                self.pickerViews.frame.origin.x = 0
            }, completion: nil)
            yearPicker.isHidden = false
        } else {
            // Success
            UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut], animations: {
                self.pickerViews.frame.origin.x = 414
            }, completion: nil)
            yearPicker.isHidden = true
        }
    }
    
    @IBAction func register(_ sender: Any) {
        if email.text!.count > 0 && email.text!.contains("@nd.edu") {
            let registrationRequest = StartUserRegistrationRequest.Builder()
            registrationRequest.setEmail(email.text!)
            
            let buildData: Data = try! registrationRequest.build().data()
            
            let initialClientConnector = ClientConnector(port: 7000)
            let responseData = initialClientConnector.connectAndSend(data: buildData) as Data
            
            guard let response: StartUserRegistrationResponse = try? StartUserRegistrationResponse.Builder().mergeFrom(data: responseData).build() else {
                                let alert = UIAlertController(title: "Failure to create user!", message: "Something went terribly wrong when creating your profile. Please try again.", preferredStyle: .alert)
                                
                                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                                self.present(alert, animated: true)
                return
            }
            
            if (response.hasStatus && response.status) {
                // Success
                UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut], animations: {
                    self.VerificationView.frame.origin.x = 0
                }, completion: nil)
            }
        } else if (email.text!.count > 0 && !email.text!.contains("@nd.edu")) {
            let alert = UIAlertController(title: "Invalid Email",
                                          message: "You must use your Notre Dame issued email when creating an account.",
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "Incomplete Application",
                                          message: "You must fill out all of the fields",
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func verify(_ sender: Any) {
        if email.text != nil && firstName.text != nil && lastName.text != nil {
            let dormIndex = dormPicker.selectedRow(inComponent: 0)
            let majorIndex = majorPicker.selectedRow(inComponent: 0)
            let yearIndex = yearPicker.selectedRow(inComponent: 0)
            let newUser = User.Builder()
            
            newUser.setEmail(email.text!)
            newUser.setDorm(dorms[dormIndex])
            newUser.setMajor(majors[majorIndex])
            newUser.setGraduationYear(years[yearIndex])
            newUser.setFirstName(firstName.text!)
            newUser.setLastName(lastName.text!)
            
            
            let finishRegis = FinishUserRegistrationRequest.Builder()
            finishRegis.setUser(try! newUser.build())
            finishRegis.setPassword(password.text!)
            finishRegis.setAuthCode(auth.text ?? "000000")
            
            let buildData = try! finishRegis.build().data()
            let finalClientConnector = ClientConnector(port: 7001)
            let responseData = finalClientConnector.connectAndSend(data: buildData) as Data
            
            guard let response: FinishUserRegistrationResponse = try? FinishUserRegistrationResponse.Builder().mergeFrom(data: responseData).build() else {
                let alert = UIAlertController(title: "Failure to create user!", message: "Something went terribly wrong when creating your profile. Please try again.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true)
                return
            }
        
            if (response.status) {
                signedUp = true
                let user: User = (response.user)
                UserDefaults.standard.set(user.data(), forKey: "user_profile")
                UserDefaults.standard.set(true, forKey: "is_logged_in")
                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BuyViewController") as UIViewController

                self.present(viewController, animated: false, completion: nil)
            } else {
                signedUp = false
                let alert = UIAlertController(title: "Registration Failure",
                                              message: "We were unable to create an account with these credentials at this time.",
                                              preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        } else {
            let alert = UIAlertController(title: "Incomplete Application",
                                          message: "You must fill out all of the fields",
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    
}

extension RegisterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == dormPicker {
            return dorms.count
        }
        if pickerView == majorPicker {
            return majors.count
        }
        if pickerView == yearPicker {
            return years.count
        }
        return dorms.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == dormPicker {
            return dorms[row]
        }
        if pickerView == majorPicker {
            return majors[row]
        }
        if pickerView == yearPicker {
            return years[row]
        }
        return dorms[row]
    }
}
