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

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    
    var posts: [Post]?
    var token: String?
    var header: [String: String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.header?.updateValue(token!, forKey: "token")
        
        self.loadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ((posts?.count) != nil) {
            return (posts?.count)!
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel!.text = posts?[indexPath.row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
        let postDetail = self.storyboard?.instantiateViewController(withIdentifier: "postDetail") as! PostDetailViewController
        postDetail.postTitle = posts?[indexPath.row].title
        postDetail.postText = posts?[indexPath.row].text
        postDetail.username = posts?[indexPath.row].author.username
        self.navigationController?.pushViewController(postDetail, animated: true)
    }
    
    func loadData() {
        Alamofire.request("https://87cfdc05.ngrok.io/api/posts/", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).response { response in
            guard let data = response.data else {
                return
            }
            let decoder  = JSONDecoder()
            do {
                let posts: [Post] = try decoder.decode([Post].self, from: data)
                self.posts = posts
                self.tableView.reloadData()
            } catch {
                print(error)
            }
        }
    }
    
    @IBAction func loginAC(_ sender: Any) {
        let login = self.storyboard?.instantiateViewController(withIdentifier: "login") as! LoginViewController
        self.navigationController?.pushViewController(login, animated: true)
//        let parameters: [String: Any] = [
//            "username": "admin",
//            "password": "admin"
//        ]
//
//        Alamofire.request("https://aa479ca6.ngrok.io/api/rest-auth/login/",
//                          method: .post,
//                          parameters: parameters,
//                          encoding: JSONEncoding.default, headers: nil)
//            .responseJSON { response in
//                do {
//                    let result = response.result.value as? [String: Any]
//                    print(result!)
//                } catch {
//                    print(error)
//                }
//        }
    }

}
