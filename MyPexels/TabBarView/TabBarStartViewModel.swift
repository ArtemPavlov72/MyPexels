//
//  TabBarStartViewControllerModel.swift
//  MyPexels
//
//  Created by Artem Pavlov on 22.10.2022.
//

import Foundation

protocol TabBarStartViewModelProtocol {
    func photoCollectionViewModel() -> PhotoCollectionViewModelProtocol
    init (favoritePhotos: [PexelsPhoto])
}

class TabBarStartViewModel: TabBarStartViewModelProtocol {
    //MARK: - Public Properties
    var favoritePhotos: [PexelsPhoto] = []
    
    //MARK: - Public Methods
    func photoCollectionViewModel() -> PhotoCollectionViewModelProtocol {
        return PhotoCollectionViewModel(favoritePhotos: favoritePhotos)
    }
    
    //MARK: - Init
    required init(favoritePhotos: [PexelsPhoto]) {
        self.favoritePhotos = favoritePhotos
    }
}
