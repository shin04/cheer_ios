//
//  PostDetailViewController.swift
//  cheer_ios
//
//  Created by 梶原大進 on 2019/09/15.
//  Copyright © 2019年 梶原大進. All rights reserved.
//

import UIKit
import Alamofire

class PostDetailViewController: UIViewController {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    
    var postId: Int!
    var postTitle: String!
    var postText: String!
    var username: String!
    var token: String!
    
    var comments: [Comment]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleLabel.text = postTitle
        self.textLabel.text = postText
        self.usernameLabel.text = username
        
        self.load_comment()
    }
    
    func load_comment() {
        Alamofire.request("https://72b6c690.ngrok.io/api/postcomment/?query_param=\(String(self.postId))", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).response { response in
            guard let data = response.data else {
                return
            }
            let decoder = JSONDecoder()
            do {
                let comments: [Comment] = try decoder.decode([Comment].self, from: data)
                self.comments = comments
                print(self.comments!)
            } catch {
                print(error)
            }
        }
    }

}
