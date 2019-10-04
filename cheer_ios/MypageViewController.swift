//
//  MypageViewController.swift
//  cheer_ios
//
//  Created by 梶原大進 on 2019/10/03.
//  Copyright © 2019年 梶原大進. All rights reserved.
//

import UIKit
import Alamofire

class MypageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    
    var posts: [Post]?
    var drafts: [Post]?
    var comments: [Comment]?
    var username: String?
    var email: String?
    var token: String = ""
    var header: [String: String]?
    var sectionTitles: [String] = ["投稿", "応援一覧", "草稿"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.header?.updateValue(self.token, forKey: "token")
        self.loadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if ((posts?.count) != nil) {
                return (posts?.count)!
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
        } else {
            if ((drafts?.count) != nil) {
                return (drafts?.count)!
            } else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel!.text = posts?[indexPath.row].title
            
            return cell
        } else if indexPath.section == 1 {
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel!.text = comments?[indexPath.row].text
            
            return cell
        } else {
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel!.text = drafts?[indexPath.row].title
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let postDetail = self.storyboard?.instantiateViewController(withIdentifier: "postDetail") as! PostDetailViewController
        if indexPath.section == 0 {
            postDetail.postTitle = posts![indexPath.row].title
            postDetail.postText = posts![indexPath.row].text
            postDetail.username = posts![indexPath.row].author.username
        } else if indexPath.section == 1 {
            postDetail.comment = comments![indexPath.row].text
        } else {
            postDetail.postTitle = drafts![indexPath.row].title
            postDetail.postText = drafts![indexPath.row].text
            postDetail.username = drafts![indexPath.row].author.username
        }
        self.navigationController?.pushViewController(postDetail, animated: true)
    }
    
    func loadData() {
        Alamofire.request("https://5dad2dd7.ngrok.io/api/myposts/", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).response { response in
            guard let data = response.data else {
                return
            }
            let decoder  = JSONDecoder()
            do {
                let allposts: [Post] = try decoder.decode([Post].self, from: data)
                var posts: [Post] = []
                var drafts: [Post] = []
                for post in allposts {
                    if post.published_date != nil {
                        posts.append(post)
                    } else {
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
    
    @IBAction func postViewAC(_ sender: Any) {
        let newpost = self.storyboard?.instantiateViewController(withIdentifier: "newpost") as! NewPostViewController
        newpost.username = self.username
        newpost.email = self.email
        newpost.token = self.token
        self.navigationController?.pushViewController(newpost, animated: true)
    }
}
