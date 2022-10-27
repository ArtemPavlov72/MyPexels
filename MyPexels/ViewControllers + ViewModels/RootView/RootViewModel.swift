//
//  RootViewModel.swift
//  MyPexels
//
//  Created by Artem Pavlov on 25.10.2022.
//

import Foundation

protocol RootViewModelDelegate {
    func tabBarStartViewModel() -> TabBarStartViewModelProtocol
    func loginViewModel() -> LoginViewModelProtocol
}

class RootViewModel: RootViewModelDelegate {
    func loginViewModel() -> LoginViewModelProtocol {
        LoginViewViewModel()
    }
    
    func tabBarStartViewModel() -> TabBarStartViewModelProtocol {
        TabBarStartViewModel()
    }
}
