//
//  MypageViewController.swift
//  cheer_ios
//
//  Created by 梶原大進 on 2019/10/03.
//  Copyright © 2019年 梶原大進. All rights reserved.
//

import UIKit
import Alamofire

protocol MyPageViewInterface: class {
    func loadData()
    func reloadData()
}

class MypageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MyPageViewInterface {
    @IBOutlet var tableView: UITableView!
    
    var url = CheerUrl.shared.baseUrl
    
    var presenter: MyPagePresenter!
    
    var posts: [Post]?
    var drafts: [Post]?
    var achievePosts: [Post]?
    var comments: [Comment]?
    var id: Int?
    var username: String?
    var email: String?
    var token: String = ""
    var sectionTitles: [String] = ["投稿", "応援一覧", "草稿", "達成した目標"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MyPagePresenter(with: self)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.isUser()
        self.loadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if ((presenter.posts?.count) != nil) {
                return (presenter.posts?.count)!
            } else {
                return 0
            }
        }
        else if section == 1 {
            if ((comments?.count) != nil) {
                return (comments?.count)!
            } else {
                return 0
            }
        } else if section == 2 {
            if ((presenter.drafts?.count) != nil) {
                return (presenter.drafts?.count)!
            } else {
                return 0
            }
        } else {
            if ((presenter.achievePosts?.count) != nil) {
                return (presenter.achievePosts?.count)!
            } else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel!.text = presenter.posts?[indexPath.row].title
            
            return cell
        } else if indexPath.section == 1 {
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel!.text = comments?[indexPath.row].text
            
            return cell
        } else if indexPath.section == 2{
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel!.text = presenter.drafts?[indexPath.row].title
            return cell
        } else {
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel!.text = presenter.achievePosts?[indexPath.row].title
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let edit = self.storyboard?.instantiateViewController(withIdentifier: "editpost") as! EditPostViewController
        let detail = self.storyboard?.instantiateViewController(withIdentifier: "postDetail") as! PostDetailViewController
        edit.id = self.id
        edit.token = self.token
        if indexPath.section == 0 {
            edit.postId = posts![indexPath.row].id
            edit.postTitle = posts![indexPath.row].title
            edit.postText = posts![indexPath.row].text
            edit.username = posts![indexPath.row].author.username
            self.toPostEditOrDetail(view: edit)
        } else if indexPath.section == 1 {
            edit.comment = comments![indexPath.row].text
            self.toPostEditOrDetail(view: edit)
        } else if indexPath.section == 2{
            edit.postId = drafts![indexPath.row].id
            edit.postTitle = drafts![indexPath.row].title
            edit.postText = drafts![indexPath.row].text
            edit.username = drafts![indexPath.row].author.username
            self.toPostEditOrDetail(view: edit)
        } else {
            detail.postId = achievePosts![indexPath.row].id
            detail.token = self.token
            detail.postTitle = achievePosts![indexPath.row].title
            detail.postText = achievePosts![indexPath.row].text
            detail.username = achievePosts![indexPath.row].author.username
            detail.achievement = true
            self.toPostEditOrDetail(view: detail)
        }
    }
    
    func toPostEditOrDetail(view: UIViewController) {
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    func isUser() {
        presenter.isUserVerified()
    }
    
    func loadData() {
        presenter.loadMyPosts()
        presenter.loadUserComments()
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    @IBAction func postViewAC(_ sender: Any) {
        let newpost = self.storyboard?.instantiateViewController(withIdentifier: "newpost") as! NewPostViewController
        newpost.id = self.id
        newpost.username = self.username
        newpost.email = self.email
        newpost.token = self.token
        self.navigationController?.pushViewController(newpost, animated: true)
    }
}
