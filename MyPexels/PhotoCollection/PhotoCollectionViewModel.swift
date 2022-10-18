//
//  PhotoCollectionViewModel.swift
//  MyPexels
//
//  Created by Artem Pavlov on 15.10.2022.
//

import Foundation

protocol PhotoCollectionViewModelProtocol {
    func fetchPexelsData(from url: String,withNumberOfPhotosOnPage numberOfPhotos: Int,numberOfPage: Int, completion: @escaping() -> Void)
    func numberOfRows() -> Int
    func cellViewModel(at indexPath: IndexPath) -> PhotoViewCellViewModelProtocol
    init(favoritePhotos: [PexelsPhoto])
    func photoDetailsViewModel(at indexPath: IndexPath) -> PhotoDetailsViewModelProtocol
}

class PhotoCollectionViewModel: PhotoCollectionViewModelProtocol {
    
    //MARK: - Private Properties
    private var pexelsData: Pexels?
    private var photo: Photo?
    private var photos: [Photo] = []
    private var numberOfPage = 1
    private var favoritePhotos: [PexelsPhoto]
    
    //MARK: - Init
    required init(favoritePhotos: [PexelsPhoto]) {
        self.favoritePhotos = favoritePhotos
    }
    
    //MARK: - Public Methods
    func photoDetailsViewModel(at indexPath: IndexPath) -> PhotoDetailsViewModelProtocol {
        let photo = photos[indexPath.item]
        return PhotoDetailsViewModel(
            photo: photo,
            favoritePhoto: nil,
            favoritePhotos: favoritePhotos
        )
    }
    
    func cellViewModel(at indexPath: IndexPath) -> PhotoViewCellViewModelProtocol {
        let photo = photos[indexPath.item]
        return PhotoViewCellViewModel(photo: photo, favoritePhoto: nil)
    }
    
    func numberOfRows() -> Int {
        photos.count
    }
    
    func fetchPexelsData(from url: String,
                         withNumberOfPhotosOnPage numberOfPhotos: Int,
                         numberOfPage: Int,
                         completion: @escaping () -> Void) {
        NetworkManager.shared.fetchData(
            from: url,
            withNumberOfPhotosOnPage: numberOfPhotos,
            numberOfPage: numberOfPage
        )
        {
            [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let pexelsData):
                self.pexelsData = pexelsData
                if self.photos.isEmpty {
                    self.photos = pexelsData.photos ?? []
                } else {
                    self.photos += pexelsData.photos ?? []
                }
                self.numberOfPage += 1
                completion()
            case .failure(let error):
                print(error)
            }
        }
    }
}
