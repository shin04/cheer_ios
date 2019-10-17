//
//  MyPagePresenter.swift
//  cheer_ios
//
//  Created by 梶原大進 on 2019/10/17.
//  Copyright © 2019年 梶原大進. All rights reserved.
//

import Foundation

class MyPagePresenter {
    weak var view: MyPageViewInterface?
    
    let authModel: AuthModel
    let postModel: PostModel
    
    var login_user: Who?
    var posts: [Post]?
    var drafts: [Post]?
    var achievePosts: [Post]?
    var comments: [Comment]?
    
    init(with view: MyPageViewInterface) {
        self.view = view
        self.authModel = AuthModel()
        self.postModel = PostModel()
        authModel.delegate = self
        postModel.delegate = self
    }
    
    func isUserVerified() {
        authModel.isUserVerified()
    }
    
    func reload(user: Who?) {
        if user != nil {
            login_user = user
        }
    }
    
    func loadMyPosts() {
        postModel.loadMyPosts()
    }
    
    func reloadMyPosts(posts: [Post]?, drafts: [Post]?, achievePost: [Post]?) {
        self.posts = posts
        self.drafts = drafts
        self.achievePosts = achievePost
        view?.reloadData()
    }
    
    func loadUserComments() {
        postModel.loadUserComments()
    }
    
    func reloadUserComments(comments: [Comment]?) {
        self.comments = comments
        view?.reloadData()
    }
}

extension MyPagePresenter: AuthModelDelegate {
    func didSignUp(token: String) {}
    
    func didLogin(token: String) {}
    
    func didVerifiedUser(user: Who?) {
        self.reload(user: user)
    }
}

extension MyPagePresenter: PostModelDelegate {
    func didEditPost() {}
    
    func didCreatePost() {}
    
    func didLoadUserComments(comments: [Comment]?) {
        self.reloadUserComments(comments: comments)
    }
    
    func didPost(posts: [Post]?) {}
    
    func didLoadMyPosts(posts: [Post]?, drafts: [Post]?, achievePost: [Post]?) {
        self.reloadMyPosts(posts: posts, drafts: drafts, achievePost: achievePosts)
    }
    
    func didLoadComments(comments: [Comment]?, comment_index: [Int]) {}
    
    func didCreateComment() {}
}
