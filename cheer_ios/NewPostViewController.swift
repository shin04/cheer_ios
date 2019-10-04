//
//  NewPostViewController.swift
//  cheer_ios
//
//  Created by 梶原大進 on 2019/10/04.
//  Copyright © 2019年 梶原大進. All rights reserved.
//

import UIKit
import Alamofire

class NewPostViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var titleField: UITextField!
    @IBOutlet var textField: UITextField!
    
    var username: String?
    var email: String?
    var token: String = ""
    var user = User()
    var postTitle: String = ""
    var postText: String = ""
    var header: [String: String]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleField.delegate = self
        textField.delegate = self
        titleField.tag = 1
        textField.tag = 2
        
        self.user.username = self.username
        self.user.email = self.email
        
        self.header?.updateValue(self.token, forKey: "token")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 1 {
            postTitle = titleField.text!
        } else if textField.tag == 2 {
            postText = textField.text!
        }
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func postAC(_ sender: Any) {
        let parameters: [String: Any] = [
            "author": user,
            "title": postTitle,
            "text": postText,
            ]
        
        Alamofire.request("https://444aa3d4.ngrok.io/api/posts/",
                          method: .post,
                          parameters: parameters,
                          encoding: JSONEncoding.default,
                          headers: header)
            .responseJSON { response in
                do {
                    let result = response.result.value
                    print(result!)
                } catch {
                    print(error)
                }
        }
    }
}
