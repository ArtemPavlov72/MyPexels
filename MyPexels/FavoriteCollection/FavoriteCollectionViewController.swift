//
//  FavouriteCollectionViewController.swift
//  MyPexels
//
//  Created by Artem Pavlov on 22.05.2022.
//

import UIKit

protocol FavoriteCollectionViewControllerDelegate {
    func reloadData()
}

class FavoriteCollectionViewController: UICollectionViewController {
    
    //MARK: - Public Properties
    var delegateTabBarVC: TabBarStartViewControllerDelegate?
    var viewModel: FavoriteCollectionViewModelProtocol!
    
    //MARK: - Private Properties
    private let cellID = "cell"
    private var sizeOfPhoto = SizeOfPhoto.medium
    
    //MARK: - Life Cycles Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.register(PhotoViewCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.topItem?.searchController = nil
        collectionView.reloadData()
    }
    
    // MARK: - UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! PhotoViewCell
        cell.viewModel = viewModel.cellViewModel(at: indexPath)
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoDetailVC = PhotoDetailsViewController()
        photoDetailVC.viewModel = viewModel.photoDetailsViewModel(at: indexPath)
        photoDetailVC.delegateTabBarVC = delegateTabBarVC
        photoDetailVC.delegateFavoriteVC = self
        show(photoDetailVC, sender: nil)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension FavoriteCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let countOfItems = CGFloat(viewModel.numberOfItemsPerRow)
        let paddingWidth = 20 * (countOfItems + 1)
        let avaibleWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = avaibleWidth / countOfItems
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
}

//MARK: - FavoriteCollectionViewControllerDelegate
extension FavoriteCollectionViewController: FavoriteCollectionViewControllerDelegate {
    func reloadData() {
        collectionView.reloadData()
    }
}
