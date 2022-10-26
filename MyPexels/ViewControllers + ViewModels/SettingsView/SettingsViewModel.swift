//
//  SettingsViewModel.swift
//  MyPexels
//
//  Created by Artem Pavlov on 25.10.2022.
//

import Foundation

protocol SettingViewModelProtocol {
    var numberOfPhotoItems: String { get }
    var numberOfFavoriteItems: String { get }
    var viewModelDidChange: ((SettingViewModelProtocol) -> Void)? { get set }
    func clearButtonTapped()
    func logoutButtonTapped()
    func changeNumberOfPhotoItemsTapped()
    func changeNumberOfFavoriteItemsTapped()
}

class SettingsViewModel: SettingViewModelProtocol {
    
    //MARK: - Public Properties
    var numberOfPhotoItems: String {
        get {
            String(UserSettingManager.shared.getCountOfPhotosPerRowFor(
                photoCollectionView: true))
        } set {
            viewModelDidChange?(self)
        }
    }
    
    var numberOfFavoriteItems: String {
        get {
            String(UserSettingManager.shared.getCountOfPhotosPerRowFor(
                photoCollectionView: false))
        } set {
            viewModelDidChange?(self)
        }
    }
    
    var viewModelDidChange: ((SettingViewModelProtocol) -> Void)?
    
    //MARK: - Public Methods
    func clearButtonTapped() {
        StorageManager.shared.deleteFavoritePhotos()
    }
    
    func logoutButtonTapped() {
        UserSettingManager.shared.deleteUserData()
        AppDelegate.shared.rootViewController.switchToLogout()
        StorageManager.shared.deleteFavoritePhotos()
    }
    
    func changeNumberOfPhotoItemsTapped() {
        switch UserSettingManager.shared.getCountOfPhotosPerRowFor(
            photoCollectionView: true) {
        case 1:
            UserSettingManager.shared.changeCountOfPhotosPerRowFor(
                photoCollectionView: true, to: 2)
            numberOfPhotoItems = "2"
        case 2:
            UserSettingManager.shared.changeCountOfPhotosPerRowFor(
                photoCollectionView: true, to: 3)
            numberOfPhotoItems = "3"
        default:
            UserSettingManager.shared.changeCountOfPhotosPerRowFor(
                photoCollectionView: true, to: 1)
            numberOfPhotoItems = "1"
        }
    }
    
    func changeNumberOfFavoriteItemsTapped() {
        switch UserSettingManager.shared.getCountOfPhotosPerRowFor(
            photoCollectionView: false) {
        case 1:
            UserSettingManager.shared.changeCountOfPhotosPerRowFor(
                photoCollectionView: false, to: 2)
            numberOfFavoriteItems = "2"
        case 2:
            UserSettingManager.shared.changeCountOfPhotosPerRowFor(
                photoCollectionView: false, to: 3)
            numberOfFavoriteItems = "3"
        default:
            UserSettingManager.shared.changeCountOfPhotosPerRowFor(
                photoCollectionView: false, to: 1)
            numberOfFavoriteItems = "1"
        }
    }
}
