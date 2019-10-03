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
        // セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func loadData() {
        Alamofire.request("https://f9960ea4.ngrok.io/api/myposts/", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).response { response in
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
}
