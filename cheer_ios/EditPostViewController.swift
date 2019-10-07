//
//  EditPostViewController.swift
//  cheer_ios
//
//  Created by 梶原大進 on 2019/10/07.
//  Copyright © 2019年 梶原大進. All rights reserved.
//

import UIKit
import Alamofire

class EditPostViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    @IBOutlet var titleField: UITextField!
    @IBOutlet var textView: UITextView!
    
    var id: Int?
    var username: String?
    var email: String?
    var token: String = ""
    var postId: Int = 0
    var postTitle: String = ""
    var postText: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        titleField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        postTitle = titleField.text!
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.textView.isFirstResponder) {
            self.textView.resignFirstResponder()
        }
    }
    
    @IBAction func postAC(_ sender: Any) {
        self.postText = textView.text!
        let headers = ["Cookie": "", "Authorization": "Token \(self.token)"]
        let parameters: [String: Any] = [
            "title": self.postTitle,
            "text": self.postText,
            ]
        
        Alamofire.request("https://3419f63e.ngrok.io/api/posts/"+String(self.postId),
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
