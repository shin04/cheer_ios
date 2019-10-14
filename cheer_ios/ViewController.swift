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

class ViewController: UIViewController{
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
    
    var currentCardNumber: Int?
    
    var divisor: CGFloat! // swipe card の角度の計算用
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        divisor = (view.frame.width) / 2 / 0.61 // swipe card の角度の計算用
        
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
                self.currentCardNumber = 0
                self.swipeCard.setCard(post: self.posts![0])
                self.swipeCard2.setCard(post: self.posts![1])
            } catch {
                print(error)
            }
        }
    }
    
    func setSwipeCard() {
        self.currentCardNumber = self.currentCardNumber! + 1
        if self.currentCardNumber! + 1 == (self.posts?.count)! {
            self.swipeCard2.authorLabel.text = "投稿がありません"
            self.swipeCard2.titleLabel.text = ""
            self.swipeCard2.cheerLabel.text = ""
            self.swipeCard.setCard(post: self.posts![currentCardNumber!])
        } else if self.currentCardNumber! + 1 > (self.posts?.count)!  {
            self.swipeCard.alpha = 0
        } else {
            self.swipeCard.setCard(post: self.posts![currentCardNumber!])
            self.swipeCard2.setCard(post: self.posts![currentCardNumber!+1])
        }
    }
    
    func returnCard(duration: Double, card: SwipeCardView) {
        UIView.animate(withDuration: duration) {
            card.center = self.view.center
            card.alpha = 1
            card.cheerImageView.alpha = 0
            card.transform = .identity
        }
    }
    
    func cardFadeOut(card: SwipeCardView, x: CGFloat, y: CGFloat) {
        UIView.animate(withDuration: 0.3, animations: {
            card.center = CGPoint(x: x, y: y)
            card.alpha = 0
        }, completion: {(finished:Bool) in
            self.returnCard(duration: 0, card: card)
            self.setSwipeCard()
        })
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
                self.cardFadeOut(card: card as! SwipeCardView, x: card.center.x - 200, y: card.center.y + 75)
                return
            } else if card.center.x > (view.frame.width - 75) {
                //右側に消える
                self.cardFadeOut(card: card as! SwipeCardView, x: card.center.x + 200, y: card.center.y + 75)
                return
            }
            self.returnCard(duration: 0.3, card: card as! SwipeCardView)
        }
    }
    
    @IBAction func cheerBtn(_ sender: UIButton) {
        self.swipeCard.cheerImageView.image = UIImage(named: "cheer")
        self.swipeCard.cheerImageView.tintColor = UIColor.green
        self.cardFadeOut(card: self.swipeCard, x: self.swipeCard.center.x + 200, y: self.swipeCard.center.y + 75)
    }
    
    @IBAction func notCheerBtn(_sender :UIButton) {
        self.swipeCard.cheerImageView.image = UIImage(named: "cheer")
        self.swipeCard.cheerImageView.tintColor = UIColor.green
        self.cardFadeOut(card: self.swipeCard, x: self.swipeCard.center.x - 200, y: self.swipeCard.center.y + 75)
    }
    
    @IBAction func toPostDetail(_ sender: UIButton) {
        let postDetail = self.storyboard?.instantiateViewController(withIdentifier: "postDetail") as! PostDetailViewController
        postDetail.postId = posts![currentCardNumber!].id
        postDetail.token = self.token
        postDetail.user = self.username
        postDetail.userId = self.id
        postDetail.postTitle = posts![currentCardNumber!].title
        postDetail.postText = posts![currentCardNumber!].text
        postDetail.username = posts![currentCardNumber!].author.username
        postDetail.achievement = false
        self.navigationController?.pushViewController(postDetail, animated: true)
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
