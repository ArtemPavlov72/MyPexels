//
//  PhotoDetailsViewModel.swift
//  MyPexels
//
//  Created by Артем Павлов on 18.09.2022.
//

import Foundation

protocol PhotoDetailsViewModelProtocol {
    var photogtapherNameLabel: String { get }
    init(photo: Photo)
}

class PhotoDetailsViewModel: PhotoDetailsViewModelProtocol {
    var photogtapherNameLabel: String {
        photo.photographer ?? ""
    }
    
    private let photo: Photo
    
    required init(photo: Photo) {
        self.photo = photo
    }
    
    
}
