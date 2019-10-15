//
//  AuthModel.swift
//  cheer_ios
//
//  Created by 梶原大進 on 2019/10/15.
//  Copyright © 2019年 梶原大進. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct Who: Codable {
    let id: Int?
    let username: String?
    let email: String?
    let token: String?
}

struct User: Codable {
    var username: String?
    var email: String?
}

@objc protocol AuthModelDelegate {
    func didSignUp(token: String)
    func didLogin(token: String)
}

class AuthModel {
    weak var delegate: AuthModelDelegate?
    
    var url = CheerUrl.shared.baseUrl
    
    func signUp(parameters: [String: Any]) {
        var token: String?
        
        Alamofire.request(url + "api/rest-auth/registration/", method: .post,
                          parameters: parameters, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                do {
                    let result = response.result.value as? [String: Any]
                    token = result?["key"] as? String
                } catch {
                    print(error)
                }
        }
        self.delegate?.didSignUp(token: token!)
    }
    
    func login(parameters: [String: Any]) {
        var token: String?
        
        Alamofire.request(url + "api/rest-auth/login/", method: .post,
                          parameters: parameters, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                do {
                    let result = response.result.value as? [String: Any]
                    token = result?["key"] as? String
                } catch {
                    print(error)
                }
        }
        self.delegate?.didLogin(token: token!)
    }
    
    func isUserVerified() -> Who {
        var user: Who?
        Alamofire.request(url + "api/who", method: .get,
                          parameters: nil, encoding: JSONEncoding.default, headers: nil).response { reponse in
            guard let data = reponse.data else {
                return
            }
            let decoder  = JSONDecoder()
            do {
                let who: Who = try decoder.decode(Who.self, from: data)
                user = who
            } catch {
                print(error)
            }
        }
        return user!
    }
}
