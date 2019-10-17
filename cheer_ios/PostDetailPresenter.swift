//
//  PostDetailPresenter.swift
//  cheer_ios
//
//  Created by 梶原大進 on 2019/10/16.
//  Copyright © 2019年 梶原大進. All rights reserved.
//

import Foundation

class PostDetailPresenter {
    weak var view: PostDetailViewInterface?
    
    let postModel: PostModel
    
    var comments: [Comment]?
    var comment_index: [Int] = []
    
    init(with view: PostDetailViewInterface) {
        self.view = view
        self.postModel = PostModel()
        
        postModel.delegate = self
    }
    
    func loadComments(postId: Int) {
        postModel.loadComments(postId: postId)
    }
    
    func reloadComments(comments: [Comment]?, comment_index: [Int]) {
        if comment_index.count != 0 {
            self.comments = comments
            self.comment_index = comment_index
            view?.reloadComments()
        }
    }
    
    func comment(parameters: [String: Any], headers: [String: String]) {
        postModel.createComment(parameters: parameters, headers: headers)
    }
    
}

extension PostDetailPresenter: PostModelDelegate {
    func didEditPost() {}
    
    func didCreatePost() {}
    
    func didLoadUserComments(comments: [Comment]?) {}
    
    func didLoadMyPosts(posts: [Post]?, drafts: [Post]?, achievePost: [Post]?) {}
    
    func didPost(posts: [Post]?) {}
    
    func didLoadComments(comments: [Comment]?, comment_index: [Int]) {
        self.reloadComments(comments: comments, comment_index: comment_index)
    }
    
    func didCreateComment() {
        view?.loadComment()
    }
    
}
