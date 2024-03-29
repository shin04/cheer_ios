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
    func didLoadMyPosts(posts: [Post]?, drafts: [Post]?, achievePosts: [Post]?)
    func didCreatePost()
    func didEditPost()
    func didLoadComments(comments: [Comment]?, comment_index: [Int])
    func didLoadUserComments(comments: [Comment]?)
    func didCreateComment()
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
                
                var randomPosts: [Post] = []
                for _ in 0..<posts.count {
                    let index = Int(arc4random_uniform(UInt32(posts.count)))
                    randomPosts.append(posts[index])
                    posts.remove(at: index)
                }
                self.delegate?.didPost(posts: randomPosts)
            } catch {
                print(error)
            }
        }
    }
    
    func loadMyPosts() {
        Alamofire.request(url + "api/myposts/", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).response { response in
            guard let data = response.data else {
                return
            }
            let decoder  = JSONDecoder()
            do {
                let allposts: [Post] = try decoder.decode([Post].self, from: data)
                var posts: [Post] = []
                var drafts: [Post] = []
                var achievePosts: [Post] = []
                for post in allposts {
                    if post.achievement == true {
                        achievePosts.append(post)
                    } else if post.published_date != nil {
                        posts.append(post)
                    } else {
                        drafts.append(post)
                    }
                }
                self.delegate?.didLoadMyPosts(posts: posts, drafts: drafts, achievePosts: achievePosts)
            } catch {
                print(error)
            }
        }
    }
    
    func createPost(parameters: [String: Any], headers: [String: String]) {
        Alamofire.request(url + "api/posts/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            do {
                let result = response.result.value
                print(result!)
                self.delegate?.didCreatePost()
            } catch {
                print(error)
            }
        }
    }
    
    func editPost(postId: Int, parameters: [String: Any], headers: [String: String]) {
        Alamofire.request(url + "api/posts/\(String(postId))/", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers) .responseJSON { response in
            do {
                let result = response.result.value
                print(result!)
                self.delegate?.didEditPost()
            } catch {
                print(error)
            }
        }
    }
    
    func loadComments(postId: Int) {
        Alamofire.request(url + "api/postcomment/?query_param=\(postId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).response { response in
            guard let data = response.data else {
                return
            }
            let decoder = JSONDecoder()
            do {
                let comments: [Comment] = try decoder.decode([Comment].self, from: data)
                var comment_index: [Int] = []
                if comments.count != 0 {
                    for i in 0 ..< comments.count {
                        if comments[i].text != "" {
                            comment_index.append(i)
                        }
                    }
                }
                self.delegate?.didLoadComments(comments: comments, comment_index: comment_index)
            } catch {
                print(error)
            }
        }
    }
    
    func loadUserComments() {
        Alamofire.request(url + "api/usercomment", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).response { response in
            guard let data = response.data else {
                return
            }
            let decoder = JSONDecoder()
            do {
                let comments: [Comment] = try decoder.decode([Comment].self, from: data)
                self.delegate?.didLoadUserComments(comments: comments)
            } catch {
                print(error)
            }
        }
    }
    
    func createComment(parameters: [String: Any], headers: [String: String]) {
        Alamofire.request(self.url + "api/comment/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            do {
                let result = response.result.value
                print(result!)
                self.delegate?.didCreateComment()
            } catch {
                print(error)
            }
        }
    }
}
