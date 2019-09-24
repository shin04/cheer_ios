//
//  LoginViewController.swift
//  cheer_ios
//
//  Created by 梶原大進 on 2019/09/24.
//  Copyright © 2019年 梶原大進. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    var username: String?
    var password: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        usernameTextField.tag = 1
        passwordTextField.tag = 2
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 1 {
            username = usernameTextField.text!
        } else if textField.tag == 2 {
            password = passwordTextField.text!
        }
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func login(_ sender: Any) {
        if username != nil || password != nil {
            let parameters: [String: Any] = [
                "username": username!,
                "password": password!,
                ]
            
            Alamofire.request("https://aa479ca6.ngrok.io/api/rest-auth/login/",
                              method: .post,
                              parameters: parameters,
                              encoding: JSONEncoding.default, headers: nil)
                .responseJSON { response in
                    do {
                        let result = response.result.value as? [String: Any]
                        print(result!)
                    } catch {
                        print(error)
                    }
            }
        }
    }

}
