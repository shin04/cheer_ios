//
//  PostModel.swift
//  cheer_ios
//
//  Created by 梶原大進 on 2019/10/16.
//  Copyright © 2019年 梶原大進. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

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

protocol PostModelDelegate {
    func didPost(posts: [Post]?)
}

class PostModel {
    var url = CheerUrl.shared.baseUrl
    
    var delegate: PostModelDelegate?
    
    func loadPosts() {
        Alamofire.request(url + "api/posts/", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).response { response in
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
                self.delegate?.didPost(posts: posts)
            } catch {
                print(error)
            }
        }

    }
}
