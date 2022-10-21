//
//  PicturesCollectionViewController.swift
//  MyPexels
//
//  Created by Artem Pavlov on 22.05.2022.
//

import UIKit

class PhotoCollectionViewController: UICollectionViewController {
    
    //MARK: - Public Properties
    var viewModel: PhotoCollectionViewModelProtocol!
    
    //MARK: - Private Properties
    private let cellID = "cell"
    private var activityIndicator: UIActivityIndicatorView?
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else {return false}
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    //MARK: - Public Properties
    var favoritePhotos: [PexelsPhoto] = []
    var delegateTabBarVC: TabBarStartViewControllerDelegate?
    var delegateFavoriteVC: FavoriteCollectionViewControllerDelegate?
    
    //MARK: - Lify Cycles Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = PhotoCollectionViewModel(favoritePhotos: favoritePhotos)
        collectionView.register(PhotoViewCell.self, forCellWithReuseIdentifier: cellID)
        loadFirstData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupSearchController()
    }
    
    //MARK: - Private Methods
    private func loadFirstData() {
        activityIndicator = showSpinner(in: view)
        
        viewModel.fetchPexelsData() {
            self.activityIndicator?.stopAnimating()
            self.collectionView.reloadData()
        }
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationController?.navigationBar.topItem?.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.topItem?.searchController = searchController
        definesPresentationContext = true
    }
    
    // MARK: - UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        isFiltering ? viewModel.numberOfFilteredRows() : viewModel.numberOfRows()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! PhotoViewCell
        cell.viewModel = isFiltering
        ? viewModel.filteringCellViewModel(at: indexPath)
        : viewModel.cellViewModel(at: indexPath)
        
//                switch sizeOfPhoto {
//                case .small, .medium:
//                    cell.configureCell(with: photo.src?.medium ?? "")
//                case .large:
//                    cell.configureCell(with: photo.src?.large ?? "")
//                }
        
        if isFiltering {
            if indexPath.item == viewModel.numberOfFilteredRows() - 10 {
                viewModel.updateSerchingData()
                viewModel.fetchSerchingData(from: searchController.searchBar.text!) {
                    self.collectionView.reloadData()
                }
            }
        } else {
            if indexPath.item == viewModel.numberOfRows() - 10 {
                viewModel.fetchPexelsData() {
                    self.collectionView.reloadData()
                }
            }
        }
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoDetailVC = PhotoDetailsViewController()
        
        photoDetailVC.viewModel = isFiltering
        ? viewModel.filteredPhotoDetailsViewModel(at: indexPath)
        : viewModel.photoDetailsViewModel(at: indexPath)
        
        photoDetailVC.delegateTabBarVC = delegateTabBarVC
        photoDetailVC.delegateFavoriteVC = delegateFavoriteVC
        show(photoDetailVC, sender: nil)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension PhotoCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingWidth = 20 * (CGFloat(viewModel.numberOfItemsPerRow) + 1)
        let avaibleWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = avaibleWidth / CGFloat(viewModel.numberOfItemsPerRow)
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
}

// MARK: - UISearchResultsUpdating
extension PhotoCollectionViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.serchingNewData()
        viewModel.fetchSerchingData(from: searchController.searchBar.text!) {
            self.collectionView.reloadData()
        }
    }
}
