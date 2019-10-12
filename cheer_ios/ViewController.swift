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
    let id: Int?
    let username: String?
    let email: String?
    let token: String?
}

struct User: Codable {
    var username: String?
    var email: String?
}

struct Post: Codable {
    let id: Int
    let author: User
    let title: String
    let text: String
    let created_date: String
    let published_date: String?
    let achievement: Bool
}

struct Comment: Codable {
    let id: Int
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
    @IBOutlet var swipeCard: SwipeCardView!
    @IBOutlet var swipeCard2: SwipeCardView!
    
    var url = CheerUrl.shared.baseUrl
    var posts: [Post]?
    var drafts: [Post]?
    var token: String = ""
    var header: [String: String]?
    var id: Int? // ユーザID
    var username: String = ""
    var email:String = ""
    
    var divisor: CGFloat! // swipe card の角度の計算用
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        divisor = (view.frame.width) / 2 / 0.61 // swipe card の角度の計算用
        
        tableView.delegate = self
        tableView.dataSource = self
        
        swipeCard.cheerImageView.alpha = 0
        swipeCard2.cheerImageView.alpha = 0
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
        if (posts?.count != nil) {
            return (posts!.count)
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel!.text = posts![indexPath.row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
        let postDetail = self.storyboard?.instantiateViewController(withIdentifier: "postDetail") as! PostDetailViewController
        postDetail.postId = posts![indexPath.row].id
        postDetail.token = self.token
        postDetail.user = self.username
        postDetail.userId = self.id
        postDetail.postTitle = posts![indexPath.row].title
        postDetail.postText = posts![indexPath.row].text
        postDetail.username = posts![indexPath.row].author.username
        postDetail.achievement = false
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
                self.id = who.id
                self.username = who.username!
                self.email = who.email!
                self.token = who.token!
                self.usernameLabel.text = "こんにちは、\(self.username)さん"
                self.loginBtn.alpha = 0
                self.registerBtn.alpha = 0
                self.mypageBtn.alpha = 1
                print(self.id!)
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
                let allposts: [Post] = try decoder.decode([Post].self, from: data)
                var posts: [Post] = []
                var drafts: [Post] = []
                for post in allposts {
                    if post.achievement == false && post.published_date != nil {
                        posts.append(post)
                    } else if post.achievement == false && post.published_date == nil {
                        drafts.append(post)
                    }
                }
                self.posts = posts
                self.drafts = drafts
                self.tableView.reloadData()
            } catch {
                print(error)
            }
        }
    }
    
    func resetCard() {
        UIView.animate(withDuration: 0) {
            self.swipeCard.center = self.view.center
            self.swipeCard.alpha = 1
            self.swipeCard.cheerImageView.alpha = 0
            self.swipeCard.transform = .identity
        }
    }
    
    @IBAction func restAC(_ sender: UIButton) {
        self.resetCard()
    }
    
    @IBAction func panCard(_ sender: UIPanGestureRecognizer) {
        let card = sender.view!
        let point = sender.translation(in: view)
        let xFromCenter = card.center.x - view.center.x // カードの中心とviewの中心の距離
        
        card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        
        // 回転
        card.transform = CGAffineTransform(rotationAngle: xFromCenter/divisor)
        
        if xFromCenter > 0 {
            // 右にドラッグされたら応援
            swipeCard.cheerImageView.image = UIImage(named: "cheer")
            swipeCard.cheerImageView.tintColor = UIColor.green
        } else {
            // 左にドラッグされたら応援しない
            swipeCard.cheerImageView.image = UIImage(named: "not_cheer")
            swipeCard.cheerImageView.tintColor = UIColor.red
        }
        
        swipeCard.cheerImageView.alpha = abs(xFromCenter) / view.center.x
        
        if sender.state == UIGestureRecognizer.State.ended {
            if card.center.x < 75 {
                // 左側に消える
                UIView.animate(withDuration: 0.3, animations: {
                    card.center = CGPoint(x: card.center.x - 200, y: card.center.y + 75)
                    card.alpha = 0
                })
                return
            } else if card.center.x > (view.frame.width - 75) {
                //右側に消える
                UIView.animate(withDuration: 0.3) {
                    card.center = CGPoint(x: card.center.x + 200, y: card.center.y + 75)
                    card.alpha = 0
                }
                return
            }
            
            UIView.animate(withDuration: 0.2, animations: {
                card.center = self.view.center
                self.swipeCard.cheerImageView.alpha = 0
            })
            self.resetCard()
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
        mypage.id = self.id
        mypage.username = self.username
        mypage.email = self.email
        mypage.token = self.token
        self.navigationController?.pushViewController(mypage, animated: true)
    }

}
