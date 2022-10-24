//
//  TabBarStartViewControllerModel.swift
//  MyPexels
//
//  Created by Artem Pavlov on 22.10.2022.
//

import Foundation

protocol TabBarStartViewModelProtocol {
    func loadFavoriteData()
    func getFavoritePhotos() -> [PexelsPhoto]
    func photoCollectionViewModel() -> PhotoCollectionViewModelProtocol
    func favoriteCollectionViewModel() -> FavoriteCollectionViewModelProtocol
}

class TabBarStartViewModel: TabBarStartViewModelProtocol {
    //MARK: - Private Properties
    private var favoritePhotos: [PexelsPhoto] = []
    
    //MARK: - Public Methods
    func getFavoritePhotos() -> [PexelsPhoto] {
        favoritePhotos
    }
    
    func photoCollectionViewModel() -> PhotoCollectionViewModelProtocol {
        return PhotoCollectionViewModel()
    }
    
    func favoriteCollectionViewModel() -> FavoriteCollectionViewModelProtocol {
        return FavoriteCollectionViewModel()
    }
    
    func loadFavoriteData() {
        StorageManager.shared.fetchFavoritePhotos { result in
            switch result {
            case .success(let photos):
                self.favoritePhotos = photos
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
