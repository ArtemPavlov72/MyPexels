//
//  FavouriteCollectionViewController.swift
//  MyPexels
//
//  Created by Artem Pavlov on 22.05.2022.
//

import UIKit
import CoreData

protocol FavoriteCollectionViewControllerDelegate {
    func changeNumberOfItemsPerRow(_ number: CGFloat, size: SizeOfPhoto)
    func reloadData()
}

class FavoriteCollectionViewController: UICollectionViewController {
    
    //MARK: - Private Properties
    private let cellID = "cell"
    private var sizeOfPhoto = SizeOfPhoto.medium
    private var numberOfUtemsPerRow: CGFloat = {
        return CGFloat(UserSettingManager.shared.getCountOfPhotosPerRowFor(photoCollectionView: false))
    }()
    
    
    //MARK: - Public Properties
    var favoritePhotos: [PexelsPhoto] = []
    var delegateTabBarVC: TabBarStartViewControllerDelegate?
    
    //MARK: - Life Cycles Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.register(PhotoViewCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    // MARK: - UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoritePhotos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! PhotoViewCell
        let photo = favoritePhotos[indexPath.item]
        switch sizeOfPhoto {
        case .small:
            cell.configureCell(with: photo.smallSizeOfPhoto ?? "")
        case .medium:
            cell.configureCell(with: photo.mediumSizeOfPhoto ?? "")
        case .large:
            cell.configureCell(with: photo.largeSizeOfPhoto ?? "")
        }
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let favouritePhoto = favoritePhotos[indexPath.item]
        let photoDetailVC = PhotoDetailsViewController()
        photoDetailVC.favoritePhoto = favouritePhoto
        photoDetailVC.favoritePhotos = favoritePhotos
        photoDetailVC.delegateTabBarVC = delegateTabBarVC
        photoDetailVC.delegateFavoriteVC = self
        show(photoDetailVC, sender: nil)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension FavoriteCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingWidth = 20 * (numberOfUtemsPerRow + 1)
        let avaibleWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = avaibleWidth / numberOfUtemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
}

//MARK: - FavoriteCollectionViewControllerDelegate
extension FavoriteCollectionViewController: FavoriteCollectionViewControllerDelegate {
    func changeNumberOfItemsPerRow(_ number: CGFloat, size: SizeOfPhoto) {
        numberOfUtemsPerRow = number
        sizeOfPhoto = size
        reloadData()
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
}
