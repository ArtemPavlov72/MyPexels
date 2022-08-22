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
    private var numberOfItemsPerRow: CGFloat = {
        return CGFloat(UserSettingManager.shared.getCountOfPhotosPerRowFor(photoCollectionView: true))
    }()
    
    private var filteredPhotos: [Photo]? = []
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
        self.collectionView?.register(PhotoViewCell.self, forCellWithReuseIdentifier: cellID)
        loadPexelsData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupSearchController()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.topItem?.searchController = nil
        //navigationController?.navigationBar.topItem?.hidesSearchBarWhenScrolling = true
    }
    
    //MARK: - Private Methods
    private func loadPexelsData() {
        activityIndicator = showSpinner(in: view)
        
        NetworkManager.shared.fetchData(from: Link.pexelsCuratedPhotos.rawValue, withNumberOfPhotosOnPage: numberOfPhotosOnPage, numberOfPage: numberOfPage) { [weak self] result in
            switch result {
            case .success(let pexelsData):
                self?.pexelsData = pexelsData
                self?.activityIndicator?.stopAnimating()
                self?.photos = pexelsData.photos
                self?.numberOfPage += 1
                self?.collectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationController?.navigationBar.topItem?.searchController = searchController
        navigationController?.navigationBar.topItem?.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    // MARK: - UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       isFiltering ? filteredPhotos?.count ?? 0 : photos?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! PhotoViewCell
        
        if let photo = isFiltering ? filteredPhotos?[indexPath.item] : photos?[indexPath.item] {
            switch sizeOfPhoto {
            case .small:
                cell.configureCell(with: photo.src?.medium ?? "")
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
            
            if isFiltering {
                
                NetworkManager.shared.fetchSearchingPhoto(searchController.searchBar.text!, from: Link.pexelsSearchingPhotos.rawValue, withNumberOfPhotosOnPage: numberOfPhotosOnPage, numberOfPage: numberOfPage) { [weak self] result in
                    switch result {
                    case .success(let pexelsData):
                        self?.pexelsData = pexelsData
                        self?.filteredPhotos? += pexelsData.photos ?? []
                        self?.numberOfPage += 1
                        self?.collectionView.reloadData()
                    case .failure(let error):
                        print(error)
                    }
                }
                
            } else {
                
                NetworkManager.shared.fetchData(from: Link.pexelsCuratedPhotos.rawValue, withNumberOfPhotosOnPage: numberOfPhotosOnPage, numberOfPage: numberOfPage) { [weak self] result in
                    guard let self = self else { return }
                    
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
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //let photo = photos?[indexPath.item]
        let photo = isFiltering ? filteredPhotos?[indexPath.item] : photos?[indexPath.item]
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
        let paddingWidth = 20 * (numberOfItemsPerRow + 1)
        let avaibleWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = avaibleWidth / numberOfItemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
}

//MARK: - PhotoCollectionViewControllerDelegate
extension PhotoCollectionViewController: PhotoCollectionViewControllerDelegate {
    func changeNumberOfItemsPerRow(_ number: CGFloat, size: SizeOfPhoto) {
        numberOfItemsPerRow = number
        sizeOfPhoto = size
        collectionView.reloadData()
    }
}

// MARK: - UISearchResultsUpdating
extension PhotoCollectionViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        NetworkManager.shared.fetchSearchingPhoto(searchText, from: Link.pexelsSearchingPhotos.rawValue, withNumberOfPhotosOnPage: numberOfPhotosOnPage, numberOfPage: numberOfPage) { [weak self] result in
            switch result {
            case .success(let pexelsData):
                self?.pexelsData = pexelsData
                self?.filteredPhotos = pexelsData.photos
                self?.numberOfPage += 1
                self?.collectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }      
    }
}



