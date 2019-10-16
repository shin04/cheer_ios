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
