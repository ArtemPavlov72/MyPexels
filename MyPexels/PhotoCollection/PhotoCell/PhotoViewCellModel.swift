//
//  PhotoCellModel.swift
//  MyPexels
//
//  Created by Artem Pavlov on 17.10.2022.
//

import Foundation

protocol PhotoViewCellViewModelProtocol {
    var pexelPhotoURL: String? { get }
    init(photo: Photo?, favoritePhoto: PexelsPhoto?, numberOfItem: NumberOfItemsOnRow)
}

class PhotoViewCellViewModel: PhotoViewCellViewModelProtocol {
    
    var pexelPhotoURL: String? {
        if photo != nil {
            switch numberOfItem {
            case .one, .two:
                return photo?.src?.large
            default:
                return photo?.src?.medium
            }
        } else {
            return favoritePhoto?.mediumSizeOfPhoto
        }
    }
    
    private var photo: Photo?
    private var favoritePhoto: PexelsPhoto?
    private var numberOfItem: NumberOfItemsOnRow?
    
    required init(photo: Photo?, favoritePhoto: PexelsPhoto?, numberOfItem: NumberOfItemsOnRow) {
        self.photo = photo
        self.favoritePhoto = favoritePhoto
        self.numberOfItem = numberOfItem
    }
}
