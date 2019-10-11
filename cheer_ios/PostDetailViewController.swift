//
//  PostDetailViewController.swift
//  cheer_ios
//
//  Created by 梶原大進 on 2019/09/15.
//  Copyright © 2019年 梶原大進. All rights reserved.
//

import UIKit
import Alamofire

class PostDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var commentTableView: UITableView!
    
    var url = CheerUrl.shared.baseUrl
    
    var postId: Int!
    var postTitle: String!
    var postText: String!
    var username: String!
    var token: String = ""
    
    var comments: [Comment]?
    var comment_index: [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentTableView.delegate = self
        commentTableView.dataSource = self
        
        self.titleLabel.text = postTitle
        self.textLabel.text = postText
        self.usernameLabel.text = username
        
        self.load_comment()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (comment_index.count != 0) {
            return comment_index.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel!.text = comments![comment_index[indexPath.row]].text
        
        return cell
    }
    
    func load_comment() {
        Alamofire.request(url + "api/postcomment/?query_param=\(String(self.postId))", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).response { response in
            guard let data = response.data else {
                return
            }
            let decoder = JSONDecoder()
            do {
                let comments: [Comment] = try decoder.decode([Comment].self, from: data)
                self.comments = comments
                if comments.count != 0 {
                    for i in 0 ..< comments.count {
                        if comments[i].text != "" {
                            self.comment_index.append(i)
                        }
                    }
                }
                self.commentTableView.reloadData()
            } catch {
                print(error)
            }
        }
    }
    
    @IBAction func post_comment() {
        let alert: UIAlertController = UIAlertController(title: "応援", message: "応援メッセージを入力してください", preferredStyle: .alert)
        
        var authorField: UITextField!
        var commentField: UITextField!
        alert.addTextField(configurationHandler: { (textField) -> Void in
            authorField = textField
        })
        alert.addTextField(configurationHandler: { (textField) -> Void in
            commentField = textField
        })
        
        let postBtn: UIAlertAction = UIAlertAction(title: "送信", style: .default, handler:{
            (action: UIAlertAction!) -> Void in
            let parameters: [String: Any] = [
                "post_id": self.postId!,
                "author": authorField.text!,
                "text": commentField.text!,
                ]
            
            let headers = ["Cookie": "", "Authorization": "Token \(self.token)"]
            print(headers)
            
            Alamofire.request(self.url + "api/comment/",
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
        })
        
        let cancelBtn: UIAlertAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        
        alert.addAction(postBtn)
        alert.addAction(cancelBtn)
        present(alert, animated: true, completion: nil)
    }

}
