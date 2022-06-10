//
//  PicturesCollectionViewController.swift
//  MyPexels
//
//  Created by Artem Pavlov on 22.05.2022.
//

import UIKit

class PhotoCollectionViewController: UICollectionViewController {
    
    //MARK: - Private Properties
    private let itemsPerRow: CGFloat = 2
    private let sectionInserts = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    private var pexelsData: Pexels?
    private let cellID = "cell"
    private var activityIndicator: UIActivityIndicatorView?
    private var numberOfPhotosOnPage = 20
    private var numberOfPage = 1
    private var photos: [Photo]?
    
    //MARK: - Lify Cycles Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(PhotoViewCell.self, forCellWithReuseIdentifier: cellID)
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
            cell.configureCell(with: photo)
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
        show(photoDetailVC, sender: nil)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension PhotoCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingWidth = sectionInserts.left * (itemsPerRow + 1)
        let avaibleWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = avaibleWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        sectionInserts
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        sectionInserts.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        sectionInserts.left
    }
}

