//
//  SettingsViewModel.swift
//  MyPexels
//
//  Created by Artem Pavlov on 25.10.2022.
//

import Foundation

protocol SettingViewModelProtocol {
    var numberOfPhotoItems: Box<String> { get }
    var numberOfFavoriteItems: Box<String> { get }
    func clearButtonTapped()
    func logoutButtonTapped()
    func changeNumberOfPhotoItemsTapped()
    func changeNumberOfFavoriteItemsTapped()
}

class SettingsViewModel: SettingViewModelProtocol {
    
    //MARK: - Public Properties
    var numberOfPhotoItems: Box<String>
    
    var numberOfFavoriteItems: Box<String>
    
    //MARK: - Init
    required init() {
        numberOfPhotoItems = Box(
            String(
                UserSettingManager.shared.getCountOfPhotosPerRowFor(
                    photoCollectionView: true)
            )
        )
        numberOfFavoriteItems = Box(
            String(
                UserSettingManager.shared.getCountOfPhotosPerRowFor(
                    photoCollectionView: false)
            )
        )
    }
    
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
            photoCollectionView: true
        ) {
        case 1:
            UserSettingManager.shared.changeCountOfPhotosPerRowFor(
                photoCollectionView: true,
                to: 2
            )
            numberOfPhotoItems.value = String(
                UserSettingManager.shared.getCountOfPhotosPerRowFor(
                    photoCollectionView: true)
            )
        case 2:
            UserSettingManager.shared.changeCountOfPhotosPerRowFor(
                photoCollectionView: true,
                to: 3
            )
            numberOfPhotoItems.value = String(
                UserSettingManager.shared.getCountOfPhotosPerRowFor(
                    photoCollectionView: true)
            )
        default:
            UserSettingManager.shared.changeCountOfPhotosPerRowFor(
                photoCollectionView: true,
                to: 1
            )
            numberOfPhotoItems.value = String(
                UserSettingManager.shared.getCountOfPhotosPerRowFor(
                    photoCollectionView: true)
            )
        }
    }
    
    func changeNumberOfFavoriteItemsTapped() {
        switch UserSettingManager.shared.getCountOfPhotosPerRowFor(
            photoCollectionView: false
        ) {
        case 1:
            UserSettingManager.shared.changeCountOfPhotosPerRowFor(
                photoCollectionView: false,
                to: 2
            )
            numberOfFavoriteItems.value = String(
                UserSettingManager.shared.getCountOfPhotosPerRowFor(
                    photoCollectionView: false)
            )
        case 2:
            UserSettingManager.shared.changeCountOfPhotosPerRowFor(
                photoCollectionView: false,
                to: 3
            )
            numberOfFavoriteItems.value = String(
                UserSettingManager.shared.getCountOfPhotosPerRowFor(
                    photoCollectionView: false)
            )
        default:
            UserSettingManager.shared.changeCountOfPhotosPerRowFor(
                photoCollectionView: false,
                to: 1
            )
            numberOfFavoriteItems.value = String(
                UserSettingManager.shared.getCountOfPhotosPerRowFor(
                    photoCollectionView: false)
            )
        }
    }
}
