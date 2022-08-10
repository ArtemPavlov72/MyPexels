//
//  PicturesCollectionViewController.swift
//  MyPexels
//
//  Created by Artem Pavlov on 22.05.2022.
//

import UIKit

protocol PhotoCollectionViewControllerDelegate {
    func changeNumberOfItemsPerRow(_ number: CGFloat, size: SizeOfPhoto)
}

class PhotoCollectionViewController: UICollectionViewController {
    
    //MARK: - Private Properties
    private var pexelsData: Pexels?
    private let cellID = "cell"
    private var activityIndicator: UIActivityIndicatorView?
    private let numberOfPhotosOnPage = 20
    private var numberOfPage = 1
    private var photos: [Photo]?
    private var sizeOfPhoto = SizeOfPhoto.medium
    private var numberOfUtemsPerRow: CGFloat = {
        var items: CGFloat = 1
        if UserDefaults.standard.value(forKey: "itemsPhotoVC") as? CGFloat == 1 {
            items = 1
        } else if UserDefaults.standard.value(forKey: "itemsPhotoVC") as? CGFloat == 2 {
            items = 2
        } else {
            items = 3
        }
        return items
    }()
    
    
    //MARK: - Public Properties
    var favoritePhotos: [PexelsPhoto] = []
    var delegateTabBarVC: TabBarStartViewControllerDelegate?
    var delegateFavoriteVC: FavoriteCollectionViewControllerDelegate?
    
    //MARK: - Lify Cycles Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.register(PhotoViewCell.self, forCellWithReuseIdentifier: cellID)
        loadPexelsData()
    }
    
    //MARK: - Private Methods
    private func loadPexelsData() {
        activityIndicator = showSpinner(in: view)
        
        NetworkManager.shared.fetchData(from: Link.pexelsCuratedPhotos.rawValue, withNumberOfPhotosOnPage: numberOfPhotosOnPage, numberOfPage: numberOfPage) { result in
            switch result {
            case .success(let pexelsData):
                self.pexelsData = pexelsData
                self.activityIndicator?.stopAnimating()
                self.photos = pexelsData.photos
                self.numberOfPage += 1
                self.collectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! PhotoViewCell
        if let photo = photos?[indexPath.item] {
            switch sizeOfPhoto {
            case .small:
                cell.configureCell(with: photo.src?.small ?? "")
            case .medium:
                cell.configureCell(with: photo.src?.medium ?? "")
            case .large:
                cell.configureCell(with: photo.src?.large ?? "")
            }
        }
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1 {
            
            NetworkManager.shared.fetchData(from: Link.pexelsCuratedPhotos.rawValue, withNumberOfPhotosOnPage: numberOfPhotosOnPage, numberOfPage: numberOfPage) { result in
                switch result {
                case .success(let pexelsData):
                    self.pexelsData = pexelsData
                    self.photos? += pexelsData.photos ?? []
                    self.numberOfPage += 1
                    self.collectionView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = photos?[indexPath.item]
        let photoDetailVC = PhotoDetailsViewController()
        photoDetailVC.photo = photo
        photoDetailVC.delegateTabBarVC = delegateTabBarVC
        photoDetailVC.delegateFavoriteVC = delegateFavoriteVC
        photoDetailVC.favoritePhotos = favoritePhotos
        show(photoDetailVC, sender: nil)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension PhotoCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingWidth = 20 * (numberOfUtemsPerRow + 1)
        let avaibleWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = avaibleWidth / numberOfUtemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
}

//MARK: - PhotoCollectionViewControllerDelegate
extension PhotoCollectionViewController: PhotoCollectionViewControllerDelegate {
    func changeNumberOfItemsPerRow(_ number: CGFloat, size: SizeOfPhoto) {
        numberOfUtemsPerRow = number
        sizeOfPhoto = size
        collectionView.reloadData()
    }
}



