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
    var token: String?
    
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
            
            Alamofire.request("https://f853a982.ngrok.io/api/rest-auth/login/",
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
