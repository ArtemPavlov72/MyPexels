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
    private let numberOfPhotosOnPage = 30
    private var numberOfPage = 1
    private var photos: [Photo]?
    private var sizeOfPhoto = SizeOfPhoto.medium
    private var numberOfItemsPerRow: CGFloat = {
        return CGFloat(UserSettingManager.shared.getCountOfPhotosPerRowFor(photoCollectionView: true))
    }()
    
    private var filteredPhotos: [Photo] = []
    private var numberOfSearchingPage = 1
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
        
        loadPexelsData(
            from: Link.pexelsCuratedPhotos.rawValue,
            withNumberOfPhotosOnPage: numberOfPhotosOnPage,
            numberOfPage: numberOfPage
        )
        {
            self.activityIndicator?.stopAnimating()
            self.photos = self.pexelsData?.photos
        }
    }
    
    private func loadPexelsData(
        from url: String,
        withNumberOfPhotosOnPage numberOfPhotos: Int,
        numberOfPage: Int,
        completion: (() -> Void)?
    )
    {
        NetworkManager.shared.fetchData(
            from: url,
            withNumberOfPhotosOnPage: numberOfPhotos,
            numberOfPage: numberOfPage
        )
        {
            [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let pexelsData):
                self.pexelsData = pexelsData
                if let completion = completion {
                    completion()
                }
                self.collectionView.reloadData()
                self.numberOfPage += 1
            case .failure(let error):
                print(error)
            }
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
        isFiltering ? filteredPhotos.count : photos?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! PhotoViewCell
        
        if let photo = isFiltering ? filteredPhotos[indexPath.item] : photos?[indexPath.item] {
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
       
        if isFiltering {
            
            if indexPath.row == filteredPhotos.count - 10 {
                loadFilteredDataFromText(
                    searchController.searchBar.text!,
                    from: Link.pexelsSearchingPhotos.rawValue,
                    withNumberOfPhotosOnPage: numberOfPhotosOnPage,
                    numberOfPage: numberOfSearchingPage
                )
                {
                    self.filteredPhotos += self.pexelsData?.photos ?? []
                }
            }
            
        } else {
            if indexPath.row == (photos?.count ?? 0) - 10 {
                loadPexelsData(
                    from: Link.pexelsCuratedPhotos.rawValue,
                    withNumberOfPhotosOnPage: numberOfPhotosOnPage,
                    numberOfPage: numberOfPage
                )
                {
                    self.photos? += self.pexelsData?.photos ?? []
                }
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = isFiltering ? filteredPhotos[indexPath.item] : photos?[indexPath.item]
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
 
        numberOfSearchingPage = 1

        loadFilteredDataFromText(
            searchController.searchBar.text!,
            from: Link.pexelsSearchingPhotos.rawValue,
            withNumberOfPhotosOnPage: numberOfPhotosOnPage,
            numberOfPage: numberOfPage
        )
        {
            self.filteredPhotos = self.pexelsData?.photos ?? []
        }
    }
    
    private func loadFilteredDataFromText(
        _ searchText: String,
        from url: String,
        withNumberOfPhotosOnPage numberOfPhotos: Int,
        numberOfPage: Int,
        completion: (() -> Void)?
    )
    {
        NetworkManager.shared.fetchSearchingPhoto(
            searchText,
            from: url,
            withNumberOfPhotosOnPage: numberOfPhotos,
            numberOfPage: numberOfSearchingPage
        )
        {
            [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let pexelsData):
                self.pexelsData = pexelsData
                if let completion = completion {
                    completion()
                }
                self.collectionView.reloadData()
                self.numberOfSearchingPage += 1
            case .failure(let error):
                print(error)
            }
        }
    }
}



