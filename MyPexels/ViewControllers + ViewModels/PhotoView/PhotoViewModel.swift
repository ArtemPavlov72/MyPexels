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
    
    //MARK: - Public Properties
    var photoWidth: Int {
        return photo != nil
        ? photo?.width ?? 0
        : Int(favoritePhoto?.width ?? 0)
    }
    
    var photoHeight: Int {
        return photo != nil
        ? photo?.height ?? 0
        : Int(favoritePhoto?.height ?? 0)
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
        return photo != nil
        ? photo?.src?.original
        : favoritePhoto?.originalSizeOfPhoto
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
    
    //MARK: - Public Methods
    func loadingImage() {
        imageIsLoaded.toggle()
    }
}

