//
//  PhotoCollectionViewModel.swift
//  MyPexels
//
//  Created by Artem Pavlov on 15.10.2022.
//

import Foundation

protocol PhotoCollectionViewModelProtocol {
    func fetchPexelsData(completion: @escaping() -> Void)
    func numberOfRows() -> Int
    func numberOfFilteredRows() -> Int
    func cellViewModel(at indexPath: IndexPath) -> PhotoViewCellViewModelProtocol
    func filteringCellViewModel(at indexPath: IndexPath) -> PhotoViewCellViewModelProtocol
    func fetchSerchingData(from serchingText: String, completion: @escaping () -> Void)
    func serchingNewData()
    func updateSerchingData()
    func photoDetailsViewModel(at indexPath: IndexPath) -> PhotoDetailsViewModelProtocol
    func filteredPhotoDetailsViewModel(at indexPath: IndexPath) -> PhotoDetailsViewModelProtocol
    
    //func changeNumberOfItemsPerRow(_ number: NumberOfItemsOnRow, size: SizeOfPhoto)
    var numberOfItemsPerRow: Int { get }
    
    init (favoritePhotos: [PexelsPhoto])
}

class PhotoCollectionViewModel: PhotoCollectionViewModelProtocol {
    
    var numberOfItemsPerRow: Int {
        UserSettingManager.shared.getCountOfPhotosPerRowFor(photoCollectionView: true)
    }
    
//    func changeNumberOfItemsPerRow(_ number: NumberOfItemsOnRow, size: SizeOfPhoto) {
//        
//    }
    
    
    //MARK: - Private Properties
    private var pexelsData: Pexels?
    private var photo: Photo?
    private var photos: [Photo] = []
    private var searchingText: String?
    private var filteredPhotos: [Photo] = []
    private var newSearh = false
    private var numberOfSearchingPage = 1
    private let numberOfPhotosOnPage = 30
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
    
    func filteredPhotoDetailsViewModel(at indexPath: IndexPath) -> PhotoDetailsViewModelProtocol {
        let photo = filteredPhotos[indexPath.item]
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
    
    func filteringCellViewModel(at indexPath: IndexPath) -> PhotoViewCellViewModelProtocol {
        let filteredPhoto = filteredPhotos[indexPath.item]
        return PhotoViewCellViewModel(photo: filteredPhoto, favoritePhoto: nil)
    }
    
    func numberOfRows() -> Int {
        photos.count
    }
    
    func numberOfFilteredRows() -> Int {
        filteredPhotos.count
    }
    
    func fetchPexelsData(completion: @escaping () -> Void) {
        NetworkManager.shared.fetchData(
            from: Link.pexelsCuratedPhotos.rawValue,
            withNumberOfPhotosOnPage: numberOfPhotosOnPage,
            numberOfPage: numberOfPage
        )
        {
            result in
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
        numberOfSearchingPage = 1
        NetworkManager.shared.fetchSearchingPhoto(serchingText, from: Link.pexelsSearchingPhotos.rawValue, withNumberOfPhotosOnPage: numberOfPhotosOnPage, numberOfPage: numberOfSearchingPage) { result in
            switch result {
            case .success(let pexelsData):
                self.pexelsData = pexelsData
                if self.newSearh {
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
    
    func serchingNewData() {
        newSearh = true
    }
    
    func updateSerchingData() {
        newSearh = false
    }
}