//
//  TabBarStartViewControllerModel.swift
//  MyPexels
//
//  Created by Artem Pavlov on 22.10.2022.
//

import Foundation

protocol TabBarStartViewModelProtocol {
    func photoCollectionViewModel() -> PhotoCollectionViewModelProtocol
    func favoriteCollectionViewModel() -> FavoriteCollectionViewModelProtocol
}

class TabBarStartViewModel: TabBarStartViewModelProtocol {
    
    //MARK: - Public Methods
    func photoCollectionViewModel() -> PhotoCollectionViewModelProtocol {
        PhotoCollectionViewModel()
    }
    
    func favoriteCollectionViewModel() -> FavoriteCollectionViewModelProtocol {
        FavoriteCollectionViewModel()
    }
}
