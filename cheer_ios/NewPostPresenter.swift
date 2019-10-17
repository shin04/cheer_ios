//
//  NewPostPresenter.swift
//  cheer_ios
//
//  Created by 梶原大進 on 2019/10/17.
//  Copyright © 2019年 梶原大進. All rights reserved.
//

import Foundation

class NewPostPresenter {
    weak var view: NewPostViewInterface?
    var postModel: PostModel
    
    init(with view: NewPostViewInterface) {
        self.view = view
        postModel = PostModel()
        postModel.delegate = self
    }
    
    func createPost(parameters: [String: Any], headers: [String: String]) {
        postModel.createPost(parameters: parameters, headers: headers)
    }
}

extension NewPostPresenter: PostModelDelegate {
    func didPost(posts: [Post]?) {}
    
    func didLoadMyPosts(posts: [Post]?, drafts: [Post]?, achievePost: [Post]?) {}
    
    func didCreatePost() {
        view?.toHome()
    }
    
    func didLoadComments(comments: [Comment]?, comment_index: [Int]) {}
    
    func didLoadUserComments(comments: [Comment]?) {}
    
    func didCreateComment() {}
}
