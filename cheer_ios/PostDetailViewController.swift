//
//  PostDetailViewController.swift
//  cheer_ios
//
//  Created by 梶原大進 on 2019/09/15.
//  Copyright © 2019年 梶原大進. All rights reserved.
//

import UIKit
import Alamofire

protocol PostDetailViewInterface: class {
    func loadComment()
    func reloadComments()
}

class PostDetailViewController: UIViewController, PostDetailViewInterface {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var commentTableView: UITableView!
    @IBOutlet var cheerBtn: UIButton!
    @IBOutlet var editBtn: UIButton!
    
    var presenter: PostDetailPresenter!
    
    var url = CheerUrl.shared.baseUrl
    
    var user: String = "" // ログイン中のユーザ
    var userId: Int! // ログイン中のユーザのID
    var token: String = ""
    
    var postId: Int!
    var postTitle: String!
    var postText: String!
    var username: String! // 投稿したユーザ
    var achievement: Bool!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = PostDetailPresenter(with: self)
        
        commentTableView.dataSource = self
        
        self.titleLabel.text = postTitle
        self.textLabel.text = postText
        self.usernameLabel.text = username
        
        if achievement == true {
            self.cheerBtn.alpha = 0
            self.editBtn.alpha = 0
        }
        
        if self.user != self.username {
            self.editBtn.alpha = 0
        }
        
        self.loadComment()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditPostFromDetail" {
            let edit = segue.destination as! EditPostViewController
            edit.id = self.userId
            edit.username = self.username
            edit.token = self.token
            edit.postId = self.postId
            edit.postTitle = self.postTitle
            edit.postText = self.postText
        }
    }
    
    func loadComment() {
        presenter.loadComments(postId: self.postId)
    }
    
    func reloadComments() {
        self.commentTableView.reloadData()
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
            var headers = [String: String]()
            if self.token != "" {
                headers.updateValue("", forKey: "Cookie")
            }
            self.presenter.comment(parameters: parameters, headers: headers)
        })
        
        let cancelBtn: UIAlertAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        
        alert.addAction(postBtn)
        alert.addAction(cancelBtn)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func toPostEdit(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toEditPostFromDetail", sender: nil)
    }
}

extension PostDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (presenter.comment_index.count != 0) {
            return presenter.comment_index.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel!.text = presenter.comments![presenter.comment_index[indexPath.row]].text
        
        return cell
    }
}
