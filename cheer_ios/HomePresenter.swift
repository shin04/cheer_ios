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
    
    weak var view: HomeViewInterface?
    
    var login_user: Who?
    
    init(with view: HomeViewInterface) {
        self.view = view
        self.authModel = AuthModel()
        authModel.delegate = self
    }
    
    func isUserVerified() /*-> Who?*/ {
        //guard let verifiedUser: Who = authModel.isUserVerified() else { return nil }
        //return verifiedUser
        authModel.isUserVerified()
    }
    
    func reloadLoginUser(user: Who?) {
        if user != nil {
            login_user = user
            view?.reloadUserData()
        }
    }
}

extension HomePresenter: AuthModelDelegate {
    func didSignUp(token: String) {}
    
    func didLogin(token: String) {}
    
    func didVerifiedUser(user: Who?) {
        self.reloadLoginUser(user: user)
    }
}
