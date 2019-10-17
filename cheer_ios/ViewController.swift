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

protocol HomeViewInterface: class {
    func reloadUserData()
    func reloadPostsData()
}

class ViewController: UIViewController, HomeViewInterface {
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var registerBtn: UIButton!
    @IBOutlet var mypageBtn: UIButton!
    @IBOutlet var toDetailBtn: UIButton!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var swipeCard: SwipeCardView!
    @IBOutlet var swipeCard2: SwipeCardView!
    
    var presenter: HomePresenter!
    
    var url = CheerUrl.shared.baseUrl
    
    /* MVP完全移行したら消す */
    var posts: [Post]?
    var drafts: [Post]?
    var token: String = ""
    var header: [String: String]?
    var id: Int? // ユーザID
    var username: String = ""
    var email:String = ""
    /* ここまで */
    
    var currentCardNumber: Int?
    
    var divisor: CGFloat! // swipe card の角度の計算用
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = HomePresenter(with: self)
        
        divisor = (view.frame.width) / 2 / 0.61 // swipe card の角度の計算用
        
        swipeCard.cheerImageView.alpha = 0
        swipeCard2.cheerImageView.alpha = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.isUser()
        self.loadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPostDetail" {
            let postDetail = segue.destination as! PostDetailViewController
            postDetail.postId = presenter.posts![currentCardNumber!].id
            postDetail.token = (presenter.login_user?.token)!
            postDetail.user = (presenter.login_user?.username)!
            postDetail.userId = presenter.login_user?.id
            postDetail.postTitle = presenter.posts![currentCardNumber!].title
            postDetail.postText = presenter.posts![currentCardNumber!].text
            postDetail.username = presenter.posts![currentCardNumber!].author.username
            postDetail.achievement = false
        }
    }
    
    func isUser() {
        presenter.isUserVerified()
    }
    
    func reloadUserData() {
        self.usernameLabel.text = "こんにちは、\(presenter.login_user!.username!)さん"
    }

    func loadData() {
        presenter.loadPosts()
    }
    
    func reloadPostsData() {
        self.currentCardNumber = 0
        self.swipeCard.setCard(post: presenter.posts![0])
        self.swipeCard2.setCard(post: presenter.posts![1])
    }
    
    func setSwipeCard() {
        self.currentCardNumber = self.currentCardNumber! + 1
        if self.currentCardNumber! + 1 == (presenter.posts?.count)! {
            self.swipeCard2.authorLabel.text = "投稿がありません"
            self.swipeCard2.titleLabel.text = ""
            self.swipeCard2.cheerLabel.text = ""
            self.swipeCard.setCard(post: presenter.posts![currentCardNumber!])
        } else if self.currentCardNumber! + 1 > (presenter.posts?.count)!  {
            self.swipeCard.alpha = 0
            self.toDetailBtn.alpha = 0
        } else {
            self.swipeCard.setCard(post: presenter.posts![currentCardNumber!])
            self.swipeCard2.setCard(post: presenter.posts![currentCardNumber!+1])
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
    
    @IBAction func notCheerBtn(_ sender :UIButton) {
        self.swipeCard.cheerImageView.image = UIImage(named: "cheer")
        self.swipeCard.cheerImageView.tintColor = UIColor.green
        self.cardFadeOut(card: self.swipeCard, x: self.swipeCard.center.x - 200, y: self.swipeCard.center.y + 75)
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
