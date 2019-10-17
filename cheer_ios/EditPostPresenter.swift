//
//  EditPostPresenter.swift
//  cheer_ios
//
//  Created by 梶原大進 on 2019/10/17.
//  Copyright © 2019年 梶原大進. All rights reserved.
//

import Foundation

class EditPostPresenter {
    weak var view: EditPostViewInterface?
    var postModel: PostModel
    
    init(with view: EditPostViewInterface) {
        self.view = view
        postModel = PostModel()
        postModel.delegate = self
    }
    
    func editPost(postId: Int, parameters: [String: Any], headers: [String: String]) {
        postModel.editPost(postId: postId, parameters: parameters, headers: headers)
    }
}

extension EditPostPresenter: PostModelDelegate {
    func didPost(posts: [Post]?) {}
    
    func didLoadMyPosts(posts: [Post]?, drafts: [Post]?, achievePosts: [Post]?) {}
    
    func didCreatePost() {}
    
    func didEditPost() {
        view?.toMypage()
    }
    
    func didLoadComments(comments: [Comment]?, comment_index: [Int]) {}
    
    func didLoadUserComments(comments: [Comment]?) {}
    
    func didCreateComment() {}
}
