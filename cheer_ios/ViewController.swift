//
//  ViewController.swift
//  cheer_ios
//
//  Created by 梶原大進 on 2019/08/10.
//  Copyright © 2019年 梶原大進. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

struct Who: Codable {
    let username: String?
    let token: String?
}

struct User: Codable {
    let username: String
    let email: String?
}

struct Post: Codable {
    let author: User
    let title: String
    let text: String
    let created_date: String
    let published_date: String?
    let pk: Int
}

struct Comment: Codable {
    let post: Post
    let author: String?
    let text: String?
    let created_date: String
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var registerBtn: UIButton!
    @IBOutlet var mypageBtn: UIButton!
    @IBOutlet var usernameLabel: UILabel!
    
    let url: String = "https://88f64a2f.ngrok.io/"
    var posts: [Post] = []
    var drafts: [Post] = []
    var token: String = ""
    var header: [String: String]?
    var username: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.isUser()
        if self.token != "" {
            self.loginBtn.alpha = 0
            self.registerBtn.alpha = 0
            self.mypageBtn.alpha = 1
        } else {
            self.loginBtn.alpha = 1
            self.registerBtn.alpha = 1
            self.mypageBtn.alpha = 0
            self.username = "ゲスト"
        }
        self.header?.updateValue(self.token, forKey: "token")
        self.loadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ((posts.count) != nil) {
            return (posts.count)
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel!.text = posts[indexPath.row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
        let postDetail = self.storyboard?.instantiateViewController(withIdentifier: "postDetail") as! PostDetailViewController
        postDetail.postTitle = posts[indexPath.row].title
        postDetail.postText = posts[indexPath.row].text
        postDetail.username = posts[indexPath.row].author.username
        self.navigationController?.pushViewController(postDetail, animated: true)
    }
    
    func isUser() {
        Alamofire.request(url + "api/who", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).response { reponse in
            guard let data = reponse.data else {
                return
            }
            let decoder  = JSONDecoder()
            do {
                let who: Who = try decoder.decode(Who.self, from: data)
                self.username = who.username!
                self.token = who.token!
                self.usernameLabel.text = "こんにちは、\(self.username)さん"
                self.loginBtn.alpha = 0
                self.registerBtn.alpha = 0
                self.mypageBtn.alpha = 1
                print(self.username)
                print(self.token)
            } catch {
                print(error)
            }
        }
    }
    
    func loadData() {
        Alamofire.request(url + "api/posts/", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).response { response in
            guard let data = response.data else {
                return
            }
            let decoder  = JSONDecoder()
            do {
                let posts: [Post] = try decoder.decode([Post].self, from: data)
                //self.posts = posts
                for post in posts {
                    if post.published_date != nil {
                        self.posts.append(post)
                    } else {
                        self.drafts.append(post)
                    }
                }
                self.tableView.reloadData()
            } catch {
                print(error)
            }
        }
    }
    
    @IBAction func loginAC(_ sender: Any) {
        let login = self.storyboard?.instantiateViewController(withIdentifier: "login") as! LoginViewController
        self.navigationController?.pushViewController(login, animated: true)
    }
    
    @IBAction func signupAC(_ sender: Any) {
        let signup = self.storyboard?.instantiateViewController(withIdentifier: "signup") as! SignUpViewController
        self.navigationController?.pushViewController(signup, animated: true)
    }
    
    @IBAction func mypageAC(_ sender: Any) {
        let mypage = self.storyboard?.instantiateViewController(withIdentifier: "mypage") as! MypageViewController
        mypage.posts = self.posts
        mypage.drafts = self.drafts
        mypage.username = self.username
        self.navigationController?.pushViewController(mypage, animated: true)
    }

}
