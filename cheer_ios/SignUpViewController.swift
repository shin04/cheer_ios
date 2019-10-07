//
//  SignUpViewController.swift
//  cheer_ios
//
//  Created by 梶原大進 on 2019/10/02.
//  Copyright © 2019年 梶原大進. All rights reserved.
//

import UIKit
import Alamofire

class SignUpViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var confirmField: UITextField!
    
    var username: String?
    var email: String?
    var password: String?
    var confirm: String?
    
    var token: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        confirmField.delegate = self
        
        usernameField.tag = 1
        emailField.tag = 2
        passwordField.tag = 3
        confirmField.tag = 4
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 1 {
            username = usernameField.text!
        } else if textField.tag == 2 {
            email = emailField.text!
        } else if textField.tag == 3 {
            password = passwordField.text!
        } else if textField.tag == 4 {
            confirm = confirmField.text!
        }
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func signUpAC(_ sender: Any) {
        if username != nil || password != nil {
            let parameters: [String: Any] = [
                "username": username!,
                "email": email!,
                "password1": password!,
                "password2": confirm!,
                ]
            
            Alamofire.request("https://3419f63e.ngrok.io/api/rest-auth/registration/",
                              method: .post,
                              parameters: parameters,
                              encoding: JSONEncoding.default, headers: nil)
                .responseJSON { response in
                    do {
                        let result = response.result.value as? [String: Any]
                        self.token = result?["key"] as? String
                        print(result!)
                        print(self.token!)
                        
                        let nav = self.navigationController
                        let home = nav?.viewControllers[(nav?.viewControllers.count)!-2] as! ViewController
                        home.token = self.token!
                        self.navigationController?.popViewController(animated: true)
                    } catch {
                        print(error)
                    }
            }
        }
    }

}
