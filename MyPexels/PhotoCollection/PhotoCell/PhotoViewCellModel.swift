//
//  PhotoCellModel.swift
//  MyPexels
//
//  Created by Artem Pavlov on 17.10.2022.
//

import Foundation

protocol PhotoViewCellViewModelProtocol {
    var pexelPhotoURL: String? { get }
    init(photo: Photo?, favoritePhoto: PexelsPhoto?)
}

class PhotoViewCellViewModel: PhotoViewCellViewModelProtocol {
    
    var pexelPhotoURL: String? {
        if photo != nil {
            return photo?.src?.large
        } else {
            return favoritePhoto?.mediumSizeOfPhoto
        }
    }
    
    private var photo: Photo?
    private var favoritePhoto: PexelsPhoto?
    
    required init(photo: Photo?, favoritePhoto: PexelsPhoto?) {
        self.photo = photo
        self.favoritePhoto = favoritePhoto
    }
}
