//
//  NewPostViewController.swift
//  cheer_ios
//
//  Created by 梶原大進 on 2019/10/04.
//  Copyright © 2019年 梶原大進. All rights reserved.
//

import UIKit
import Alamofire

class NewPostViewController: UIViewController {
    var username: String?
    var email: String?
    var token: String = ""
    var header: [String: String]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.header?.updateValue(self.token, forKey: "token")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
