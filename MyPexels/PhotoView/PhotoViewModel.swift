//
//  PhotoViewModel.swift
//  MyPexels
//
//  Created by Artem Pavlov on 13.10.2022.
//

import Foundation

protocol PhotoViewModelProtocol {
    var pexelsImageURL: String? { get }
    var imageIsLoaded: Bool { get }
    var photoWidth: Int { get }
    var photoHeight: Int { get }
    init(photo: Photo?, favoritePhoto: PexelsPhoto?)
    func loadingImage()
}

class PhotoViewModel: PhotoViewModelProtocol {
  
    var photoWidth: Int {
        if photo != nil {
            return photo?.width ?? 0
        } else {
            return Int(favoritePhoto?.width ?? 0)
        }
    }
    
    var photoHeight: Int {
        if photo != nil {
            return photo?.height ?? 0
        } else {
            return Int(favoritePhoto?.height ?? 0)
        }
    }
    
    var imageIsLoaded: Bool{
        get {
            isLoaded
        }
        set {
            isLoaded = newValue
        }
    }
    
    var pexelsImageURL: String? {
        if photo != nil {
            return photo?.src?.original
        } else {
            return favoritePhoto?.originalSizeOfPhoto
        }
    }
    
    //MARK: - Private Properties
    private var photo: Photo?
    private var favoritePhoto: PexelsPhoto?
    private var isLoaded = false
    
    //MARK: - Init
    required init(photo: Photo?, favoritePhoto: PexelsPhoto?) {
        self.photo = photo
        self.favoritePhoto = favoritePhoto
    }
    
    func loadingImage() {
        imageIsLoaded.toggle()
    }
}

