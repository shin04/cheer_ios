//
//  NewPostViewController.swift
//  cheer_ios
//
//  Created by 梶原大進 on 2019/10/04.
//  Copyright © 2019年 梶原大進. All rights reserved.
//

import UIKit
import Alamofire
import Foundation

protocol NewPostViewInterface: class {
    func toHome()
}

class NewPostViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, NewPostViewInterface {
    @IBOutlet var titleField: UITextField!
    @IBOutlet var textView: UITextView!
    
    var url = CheerUrl.shared.baseUrl
    
    var presenter: NewPostPresenter!
    
    var id: Int?
    var username: String?
    var email: String?
    var token: String = ""
    var postTitle: String = ""
    var postText: String = ""
    var publish_date: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = NewPostPresenter(with: self)
        
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
    
    func toHome() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postAC(_ sender: Any) {
        self.postText = textView.text!
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
        let headers = ["Cookie": "", "Authorization": "Token \(self.token)"]
        presenter.createPost(parameters: parameters, headers: headers)
    }
}
