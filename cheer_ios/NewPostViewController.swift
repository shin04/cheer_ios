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
    
    var id: Int?
    var username: String?
    var email: String?
    var token: String = ""
    var postTitle: String = ""
    var postText: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleField.delegate = self
        textField.delegate = self
        titleField.tag = 1
        textField.tag = 2
        
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
        let headers = ["Cookie": "", "Authorization": "Token \(self.token)"]
        let parameters: [String: Any] = [
            "author_id": self.id!,
            "title": self.postTitle,
            "text": self.postText,
            ]
        
        Alamofire.request("https://f853a982.ngrok.io/api/posts/",
                          method: .post,
                          parameters: parameters,
                          encoding: JSONEncoding.default,
                          headers: headers)
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
