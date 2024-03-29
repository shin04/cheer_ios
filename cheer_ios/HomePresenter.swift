//
//  HomePresenter.swift
//  cheer_ios
//
//  Created by 梶原大進 on 2019/10/16.
//  Copyright © 2019年 梶原大進. All rights reserved.
//

import Foundation

class HomePresenter {
    let authModel: AuthModel
    let postModel: PostModel
    
    weak var view: HomeViewInterface?
    
    var login_user: Who?
    var posts: [Post]?
    
    init(with view: HomeViewInterface) {
        self.view = view
        self.authModel = AuthModel()
        self.postModel = PostModel()
        
        authModel.delegate = self
        postModel.delegate = self
    }
    
    func isUserVerified() {
        authModel.isUserVerified()
    }
    
    func reloadLoginUser(user: Who?) {
        if user != nil {
            login_user = user
            view?.reloadUserData()
        }
    }
    
    func loadPosts() {
        postModel.loadPosts()
    }
    
    func reloadPostData(posts: [Post]?) {
        if posts?.count != nil {
            self.posts = posts
            view?.reloadPostsData()
        }
    }
    
    func comment(parameters: [String: Any], headers: [String: String]) {
        postModel.createComment(parameters: parameters, headers: headers)
    }
}

extension HomePresenter: AuthModelDelegate {
    func didSignUp(token: String) {}
    
    func didLogin(token: String) {}
    
    func didVerifiedUser(user: Who?) {
        self.reloadLoginUser(user: user)
    }
}

extension HomePresenter: PostModelDelegate {
    func didEditPost() {}
    
    func didCreatePost() {}
    
    func didLoadUserComments(comments: [Comment]?) {}
    
    func didLoadMyPosts(posts: [Post]?, drafts: [Post]?, achievePosts: [Post]?) {}
    
    func didCreateComment() {}
    
    func didLoadComments(comments: [Comment]?, comment_index: [Int]) {}
    
    func didPost(posts: [Post]?) {
        self.reloadPostData(posts: posts)
    }
}
