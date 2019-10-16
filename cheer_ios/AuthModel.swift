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

protocol AuthModelDelegate {
    func didSignUp(token: String)
    func didLogin(token: String)
    func didVerifiedUser(user: Who?)
}

class AuthModel {
    var delegate: AuthModelDelegate?
    
    var url = CheerUrl.shared.baseUrl
    
    func signUp(parameters: [String: Any]) {
        var token: String?
        
        Alamofire.request(url + "api/rest-auth/registration/", method: .post,
                          parameters: parameters, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                do {
                    let result = response.result.value as? [String: Any]
                    token = result?["key"] as? String
                    self.delegate?.didSignUp(token: token!)
                } catch {
                    print(error)
                }
        }
    }
    
    func login(parameters: [String: Any]) {
        var token: String?
        
        Alamofire.request(url + "api/rest-auth/login/", method: .post,
                          parameters: parameters, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                do {
                    let result = response.result.value as? [String: Any]
                    token = result?["key"] as? String
                    self.delegate?.didLogin(token: token!)
                } catch {
                    print(error)
                }
        }
        
    }
    
    func isUserVerified() {
        var login_user: Who?
        Alamofire.request(url + "api/who", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).response { reponse in
            guard let data = reponse.data else { return }
            let decoder  = JSONDecoder()
            do {
                let who: Who? = try decoder.decode(Who.self, from: data)
                login_user = who
                self.delegate?.didVerifiedUser(user: login_user)
            } catch {
                print(error)
            }
        }
    }
}
