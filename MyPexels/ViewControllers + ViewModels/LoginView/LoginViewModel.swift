//
//  LoginViewModel.swift
//  MyPexels
//
//  Created by Artem Pavlov on 24.10.2022.
//

import Foundation

protocol LoginViewModelProtocol {
    func enterButtonPressed(with userName: String)
    func tabBarStartViewModel() -> TabBarStartViewModelProtocol
}

class LoginViewViewModel: LoginViewModelProtocol {
    
    //MARK: - Public Methods
    func enterButtonPressed(with userName: String) {
        let user = User(
            name: userName,
            isRegistered: true,
            pexelsImageCountPerRow: 2,
            favoriteImageCountPerRow: 2
        )
        UserSettingManager.shared.save(user: user)
    }
    
    func tabBarStartViewModel() -> TabBarStartViewModelProtocol {
        TabBarStartViewModel()
    }
}
