//
//  SignUpPresenter.swift
//  cheer_ios
//
//  Created by 梶原大進 on 2019/10/15.
//  Copyright © 2019年 梶原大進. All rights reserved.
//

import Foundation

class SignUpPresenter {
    let authModel: AuthModel
    weak var view: SignUpViewInterface?
    
    init(with view: SignUpViewInterface) {
        self.view = view
        self.authModel = AuthModel()
        authModel.delegate = self as? AuthModelDelegate
    }
    
    func signupButtonTapped() {
        guard let parameters = view?.parameters else { return }
        
        authModel.signUp(parameters: parameters)
    }
}
