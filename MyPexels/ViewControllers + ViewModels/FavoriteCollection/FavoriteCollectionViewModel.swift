//
//  FavoriteCollectionViewModel.swift
//  MyPexels
//
//  Created by Artem Pavlov on 23.10.2022.
//

import Foundation

protocol FavoriteCollectionViewModelProtocol {
    var numberOfItemsPerRow: Int { get }
    func numberOfRows() -> Int
    func cellViewModel(at indexPath: IndexPath) -> PhotoViewCellViewModelProtocol
    func photoDetailsViewModel(at indexPath: IndexPath) -> PhotoDetailsViewModelProtocol
}

class FavoriteCollectionViewModel: FavoriteCollectionViewModelProtocol {
    
    //MARK: - Public Properties
    var numberOfItemsPerRow: Int {
        UserSettingManager.shared.getCountOfPhotosPerRowFor(photoCollectionView: false)
    }
    
    //MARK: - Private Properties
    private var favoritePhotos: [PexelsPhoto] = []
    
    //MARK: - Public Methods
    func cellViewModel(at indexPath: IndexPath) -> PhotoViewCellViewModelProtocol {
        let photo = favoritePhotos[indexPath.item]
        return PhotoViewCellViewModel(
            photo: nil,
            favoritePhoto: photo,
            numberOfItem: NumberOfItemsOnRow(rawValue: numberOfItemsPerRow) ?? .one
        )
    }
    
    func photoDetailsViewModel(at indexPath: IndexPath) -> PhotoDetailsViewModelProtocol {
        let photo = favoritePhotos[indexPath.item]
        return PhotoDetailsViewModel(
            photo: nil,
            favoritePhoto: photo
        )
    }
    
    func numberOfRows() -> Int {
        loadFavoriteData()
        return favoritePhotos.count
    }
    
    //MARK: - Private Methods
    private func loadFavoriteData() {
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
