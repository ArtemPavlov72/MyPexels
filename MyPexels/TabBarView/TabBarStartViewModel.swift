//
//  TabBarStartViewControllerModel.swift
//  MyPexels
//
//  Created by Artem Pavlov on 22.10.2022.
//

import Foundation

protocol TabBarStartViewModelProtocol {
    func loadFavoriteData(completion: @escaping () -> Void)
    func getFavoritePhotos() -> [PexelsPhoto]
    func photoCollectionViewModel() -> PhotoCollectionViewModelProtocol
}

class TabBarStartViewModel: TabBarStartViewModelProtocol {
    func getFavoritePhotos() -> [PexelsPhoto] {
        favoritePhotos
    }
    
    //MARK: - Private Properties
    private var favoritePhotos: [PexelsPhoto] = []
    
    //MARK: - Public Methods
    func photoCollectionViewModel() -> PhotoCollectionViewModelProtocol {
        return PhotoCollectionViewModel()
    }
    
    func loadFavoriteData(completion: @escaping () -> Void) {
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
