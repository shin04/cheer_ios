//
//  PostDetailViewController.swift
//  cheer_ios
//
//  Created by 梶原大進 on 2019/09/15.
//  Copyright © 2019年 梶原大進. All rights reserved.
//

import UIKit

class PostDetailViewController: UIViewController {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    
    var postTitle: String!
    var postText: String!
    var username: String!
    
    var comment: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleLabel.text = postTitle
        self.textLabel.text = postText
        self.usernameLabel.text = username
    }

}
