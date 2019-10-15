//
//  SignUpViewController.swift
//  cheer_ios
//
//  Created by 梶原大進 on 2019/10/02.
//  Copyright © 2019年 梶原大進. All rights reserved.
//

import UIKit
import Alamofire

protocol SignUpViewInterface: class {
    var parameters: [String: Any]? { get }
}

class SignUpViewController: UIViewController, UITextFieldDelegate, SignUpViewInterface {
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var confirmField: UITextField!
    
    var parameters: [String : Any]?
    var presenter: SignUpPresenter!
    
    var url = CheerUrl.shared.baseUrl
    
    var username: String?
    var email: String?
    var password: String?
    var confirm: String?
    
    var token: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = SignUpPresenter(with: self)
        
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
            
            self.parameters = parameters
            
            presenter.signupButtonTapped()
        }
    }

}
