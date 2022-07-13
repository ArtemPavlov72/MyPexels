//
//  FavouriteCollectionViewController.swift
//  MyPexels
//
//  Created by Artem Pavlov on 22.05.2022.
//

import UIKit
import CoreData

protocol FavoriteCollectionViewControllerDelegate {
    func reloadData()
}

class FavoriteCollectionViewController: UICollectionViewController {
    
    //MARK: - Private Properties
    private let cellID = "cell"
    
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
        cell.configureCell(with: photo.mediumSizeOfPhoto ?? "")
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

//MARK: - FavoriteCollectionViewControllerDelegate
extension FavoriteCollectionViewController: FavoriteCollectionViewControllerDelegate {
    func reloadData() {
        collectionView.reloadData()
    }
}
