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
    var publish_date: String?
    var comment: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        titleField.delegate = self
        
        self.titleField.text = self.postTitle
        self.textView.text = self.postText
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
        var parameters: [String: Any] = [
            "author_id": self.id!,
            "title": self.postTitle,
            "text": self.postText,
            ]
        
        if (sender as AnyObject).tag == 2 {
            let now = Date()
            let formatter = ISO8601DateFormatter()
            self.publish_date = formatter.string(from: now)
            parameters.updateValue(self.publish_date!, forKey: "published_date")
        }
        
        self.postText = textView.text!
        let headers = ["Cookie": "", "Authorization": "Token \(self.token)"]
        
        Alamofire.request("https://f988b296.ngrok.io/api/posts/\(String(self.postId))/",
                          method: .put,
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
