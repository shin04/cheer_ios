//
//  ViewController.swift
//  cheer_ios
//
//  Created by 梶原大進 on 2019/08/10.
//  Copyright © 2019年 梶原大進. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func takeData() {
        // APIにアクセスする
        Alamofire.request("").responseJSON {response in
            
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Result: \(String(describing: response.result))")
            
            if let json = response.result.value {
                print("JSON: \(json)")  // serialized json response
            }
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")  // original server data as UTF8 String
                
                var mess:String = ""
                mess += "Data: \(utf8Text)"
                print(mess)
                self.textView.text = mess
                
            }
        }
    }

}

