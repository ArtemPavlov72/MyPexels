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
    init(photo: Photo?, favoritePhoto: PexelsPhoto?)
}

class PhotoDetailsViewModel: PhotoDetailsViewModelProtocol {
    
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
    
    private var photo: Photo?
    private var favoritePhoto: PexelsPhoto?
    
    required init(photo: Photo?, favoritePhoto: PexelsPhoto?) {
        self.photo = photo
        self.favoritePhoto = favoritePhoto
    }
}
