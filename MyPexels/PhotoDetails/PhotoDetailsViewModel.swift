//
//  PhotoDetailsViewModel.swift
//  MyPexels
//
//  Created by Artem Pavlov on 18.09.2022.
//

import Foundation

protocol PhotoDetailsViewModelProtocol {
    var photogtapherNameLabel: String? { get }
    var descriptionLabel: String? { get }
    var pexelsImageURL: String? { get }
    var isFavorte: Bool { get }
    var photoLink: NSURL { get }
    var viewModelDidChange: ((PhotoDetailsViewModelProtocol) -> Void)? { get set }
    //убрать из инициализатора массив фаворит
    init(photo: Photo?, favoritePhoto: PexelsPhoto?, favoritePhotos: [PexelsPhoto])
    func favoriteButtonPressed()
    func photoViewModel() -> PhotoViewModelProtocol
}

class PhotoDetailsViewModel: PhotoDetailsViewModelProtocol {

    //MARK: - Public Properties
    var photoLink: NSURL {
        if photo != nil {
            guard let link = NSURL(string: photo?.url ?? "") else {
                return NSURL(fileURLWithPath: "")
            }
            return link
        } else {
            guard let link = NSURL(string: favoritePhoto?.pexelsUrl ?? "") else {
                return NSURL(fileURLWithPath: "")
            }
            return link
        }
    }
    
    var pexelsImageURL: String? {
        if photo != nil {
            return photo?.src?.large
        } else {
            return favoritePhoto?.mediumSizeOfPhoto
        }
    }
    
    var photogtapherNameLabel: String? {
        if photo != nil {
            return photo?.photographer
        } else {
            return favoritePhoto?.photographer
        }
    }
    
    var descriptionLabel: String? {
        if photo != nil {
            return photo?.alt
        } else {
            return favoritePhoto?.descriptionOfPhoto
        }
    }
    
    // do better in future
    var isFavorte: Bool {
        get {
            if favoritePhoto != nil {
                var liked = false
                loadFavoritePhotos()
                for favor in favoritePhotos {
                    if favoritePhoto == favor {
                        liked.toggle()
                    }
                }
                return liked
            } else {
                var liked = false
                guard let pexelsPhotoId = photo?.id else { return liked }
                loadFavoritePhotos()
                for favoritePhoto in favoritePhotos {
                    if pexelsPhotoId == Int(favoritePhoto.id) {
                        liked.toggle()
                    }
                }
                return liked
            }
        } set {
            if newValue == true {
                if favoritePhoto != nil {
                    StorageManager.shared.savePexelsPhoto(pexelsPhoto: favoritePhoto)
                    viewModelDidChange?(self)
                } else {
                    guard let pexelsPhotoId = photo?.id else { return }
                    for favorPhoto in favoritePhotos {
                        if pexelsPhotoId == Int(favorPhoto.id) {
                            return
                        }
                    }
                    StorageManager.shared.savePhoto(pexelsPhoto: photo)
                    viewModelDidChange?(self)
                }
            } else {
                if favoritePhoto != nil {
                    StorageManager.shared.deletePhoto(photo: favoritePhoto)
                    viewModelDidChange?(self)
                } else {
                StorageManager.shared.deletePhoto2(photo: photo)
                viewModelDidChange?(self)
                }
            }
        }
    }
    
    var viewModelDidChange: ((PhotoDetailsViewModelProtocol) -> Void)?
    
    //MARK: - Private Properties
    private var photo: Photo?
    private var favoritePhoto: PexelsPhoto?
    private var favoritePhotos: [PexelsPhoto]
    
    //MARK: - Init
    required init(
        photo: Photo?,
        favoritePhoto: PexelsPhoto?,
        favoritePhotos: [PexelsPhoto]
    )
    {
        self.photo = photo
        self.favoritePhoto = favoritePhoto
        self.favoritePhotos = favoritePhotos
    }
    
    //MARK: - Public Methods
    func favoriteButtonPressed() {
        isFavorte.toggle()
    }
    
    func photoViewModel() -> PhotoViewModelProtocol {
        return PhotoViewModel(photo: photo, favoritePhoto: favoritePhoto)
    }
    
    //MARK: - Private Methods
    private func loadFavoritePhotos() {
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
