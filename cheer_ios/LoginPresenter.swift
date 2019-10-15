//
//  LoginPresenter.swift
//  cheer_ios
//
//  Created by 梶原大進 on 2019/10/15.
//  Copyright © 2019年 梶原大進. All rights reserved.
//

import Foundation

class LoginPresenter {
    let authModel: AuthModel
    weak var view: LoginViewInterface?
    
    init(with view: LoginViewInterface) {
        self.view = view
        self.authModel = AuthModel()
        authModel.delegate = self as? AuthModelDelegate
    }
    
    func loginButtonTapped() {
        guard let parameters = view?.parameters else { return }
        
        authModel.login(parameters: parameters)
    }
}
