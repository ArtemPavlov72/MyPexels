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
    //MARK: - Private Properties
    private var favoritePhotos: [PexelsPhoto] = []
    
    //MARK: - Public Methods
    func photoCollectionViewModel() -> PhotoCollectionViewModelProtocol {
        return PhotoCollectionViewModel()
    }
    
    func favoriteCollectionViewModel() -> FavoriteCollectionViewModelProtocol {
        return FavoriteCollectionViewModel()
    }
}
