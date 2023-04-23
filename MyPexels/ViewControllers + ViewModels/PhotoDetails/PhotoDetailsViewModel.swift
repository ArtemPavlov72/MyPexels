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
    var isFavorte: Box<Bool> { get }
    var photoLink: NSURL { get }
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
    
    var isFavorte: Box<Bool> = Box(false)
    
    //MARK: - Private Properties
    private var photo: Photo?
    private var favoritePhoto: PexelsPhoto?
    private var favoritePhotos: [PexelsPhoto] = []
    
    
    //MARK: - Init
    required init(photo: Photo?, favoritePhoto: PexelsPhoto?) {
        self.photo = photo
        self.favoritePhoto = favoritePhoto
        self.isFavorte = Box(setStatus())
    }
    
    //MARK: - Public Methods
    func favoriteButtonPressed() {
        guard let pexelsPhoto = photo else { return }
        if !isFavorte.value {
            _ = favoritePhotos.map { photo in
                guard pexelsPhoto.id != Int(photo.id) else {return}
            }
            StorageManager.shared.savePhoto(pexelsPhoto: pexelsPhoto)
            isFavorte.value = true
        } else {
            StorageManager.shared.deletePhoto(photo: pexelsPhoto)
            isFavorte.value = false
        }
    }
    
    func photoViewModel() -> PhotoViewModelProtocol {
        return PhotoViewModel(photo: photo, favoritePhoto: favoritePhoto)
    }
    
    //MARK: - Private Methods
    private func loadFavoritePhotos() {
        StorageManager.shared.fetchFavoritePhotos { [weak self] result in
            switch result {
            case .success(let photos):
                self?.favoritePhotos = photos
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func loadPhoto() {
        NetworkManager.shared.fetchData(
            from: Link.pexelsPhotoById.rawValue,
            usingId: Int(favoritePhoto?.id ?? 0),
            completion: { [weak self] result in
                switch result {
                case .success(let photo):
                    self?.photo = photo
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        )
    }
    
    private func setStatus() -> Bool {
        var liked = false
        loadFavoritePhotos()
        
        if favoritePhoto != nil {
            loadPhoto()
            liked.toggle()
        } else {
            guard let pexelsPhotoId = photo?.id else { return liked }
            _ = favoritePhotos.map { photo in
                if pexelsPhotoId == Int(photo.id) {
                    liked.toggle()
                }
            }
        }
        return liked
    }
}
