//
//  PhotoCollectionViewModel.swift
//  MyPexels
//
//  Created by Artem Pavlov on 15.10.2022.
//

import Foundation

protocol PhotoCollectionViewModelProtocol {
    var numberOfItemsPerRow: Int { get }
    func numberOfRows() -> Int
    func numberOfFilteredRows() -> Int
    func fetchPexelsData(completion: @escaping() -> Void)
    func fetchSerchingData(from serchingText: String, completion: @escaping () -> Void)
    func cellViewModel(at indexPath: IndexPath) -> PhotoViewCellViewModelProtocol
    func serchingNewData()
    func updateSerchingData()
    func photoDetailsViewModel(at indexPath: IndexPath) -> PhotoDetailsViewModelProtocol
}

class PhotoCollectionViewModel: PhotoCollectionViewModelProtocol {
    //MARK: - Public Properties
    var numberOfItemsPerRow: Int {
        UserSettingManager.shared.getCountOfPhotosPerRowFor(photoCollectionView: true)
    }
    
    //MARK: - Private Properties
    private var pexelsData: Pexels?
    private var photo: Photo?
    private var photos: [Photo] = []
    private var numberOfPage = 1
    private var numberOfSearchingPage = 1
    private var searchingText: String?
    private var filteredPhotos: [Photo] = []
    private var newSearh = false
    private let numberOfPhotosOnPage = 30
        
    //MARK: - Public Methods
    func photoDetailsViewModel(at indexPath: IndexPath) -> PhotoDetailsViewModelProtocol {
        let photo: Photo
        
        photo = filteredPhotos.isEmpty
        ? photos[indexPath.item]
        : filteredPhotos[indexPath.item]
        
        return PhotoDetailsViewModel(photo: photo, favoritePhoto: nil)
    }
    
    func cellViewModel(at indexPath: IndexPath) -> PhotoViewCellViewModelProtocol {
        let photo: Photo
        
        photo = filteredPhotos.isEmpty
        ? photos[indexPath.item]
        : filteredPhotos[indexPath.item]
        
        return PhotoViewCellViewModel(
            photo: photo,
            favoritePhoto: nil,
            numberOfItem: NumberOfItemsOnRow(rawValue: numberOfItemsPerRow) ?? .one
        )
    }
    
    func numberOfRows() -> Int {
        photos.count
    }
    
    func numberOfFilteredRows() -> Int {
        filteredPhotos.count
    }
    
    func serchingNewData() {
        newSearh = true
    }
    
    func updateSerchingData() {
        newSearh = false
    }
    
    func fetchPexelsData(completion: @escaping () -> Void) {
        NetworkManager.shared.fetchData(
            from: Link.pexelsCuratedPhotos.rawValue,
            withNumberOfPhotosOnPage: numberOfPhotosOnPage,
            numberOfPage: numberOfPage
        )
        { [weak self] result in
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
    
    func fetchSerchingData(from serchingText: String, completion: @escaping () -> Void) {
        
        NetworkManager.shared.fetchSearchingPhoto(
            serchingText,
            from: Link.pexelsSearchingPhotos.rawValue,
            withNumberOfPhotosOnPage: numberOfPhotosOnPage,
            numberOfPage: numberOfPage
        )
        { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let pexelsData):
                self.pexelsData = pexelsData
                if self.newSearh {
                    self.numberOfSearchingPage = 1
                    self.filteredPhotos = pexelsData.photos ?? []
                } else {
                    self.filteredPhotos += pexelsData.photos ?? []
                }
                completion()
                self.numberOfSearchingPage += 1
            case .failure(let error):
                print(error)
            }
        }
    }
}
