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
    init(photo: Photo?, favoritePhoto: PexelsPhoto?)
    func favoriteButtonPressed()
    func photoViewModel() -> PhotoViewModelProtocol
}

class PhotoDetailsViewModel: PhotoDetailsViewModelProtocol {

    //MARK: - Public Properties
    var photoLink: NSURL {
        let link = photo != nil
        ? NSURL(string: photo?.url ?? "")
        : NSURL(string: favoritePhoto?.pexelsUrl ?? "")
        return link ?? NSURL(fileURLWithPath: "")
    }
    
    var pexelsImageURL: String? {
        let url = photo != nil
        ? photo?.src?.large
        : favoritePhoto?.mediumSizeOfPhoto
        return url
    }
    
    var photogtapherNameLabel: String? {
        let nameLabel = photo != nil
        ? photo?.photographer
        : favoritePhoto?.photographer
        return nameLabel
    }
    
    var descriptionLabel: String? {
        let descriptionLabel = photo != nil
        ? photo?.alt
        : favoritePhoto?.descriptionOfPhoto
        return descriptionLabel
    }
    
    var isFavorte: Bool {
        get {
            var liked = false
            loadFavoritePhotos()
            if favoritePhoto != nil {
                loadPhoto()
                liked.toggle()
            } else {
                guard let pexelsPhotoId = photo?.id else { return liked }
                for photo in favoritePhotos {
                    if pexelsPhotoId == Int(photo.id) {
                        liked.toggle()
                    }
                }
            }
            return liked
        } set {
            if newValue == true {
                if favoritePhoto == nil {
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
                    favoritePhoto = nil
                } else {
                    StorageManager.shared.deletePhoto(photo: photo)
                }
            }
            viewModelDidChange?(self)
        }
    }
    
    var viewModelDidChange: ((PhotoDetailsViewModelProtocol) -> Void)?
    
    //MARK: - Private Properties
    private var photo: Photo?
    private var favoritePhoto: PexelsPhoto?
    private var favoritePhotos: [PexelsPhoto] = []
    
    //MARK: - Init
    required init(photo: Photo?, favoritePhoto: PexelsPhoto?) {
        self.photo = photo
        self.favoritePhoto = favoritePhoto
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
    
    private func loadPhoto() {
        NetworkManager.shared.fetchData(
            from: Link.pexelsPhotoById.rawValue,
            usingId: Int(favoritePhoto?.id ?? 0),
            completion: { result in
                switch result {
                case .success(let photo):
                    self.photo = photo
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        )
    }
}
