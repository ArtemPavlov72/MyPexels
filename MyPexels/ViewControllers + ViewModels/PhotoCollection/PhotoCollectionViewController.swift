//
//  PicturesCollectionViewController.swift
//  MyPexels
//
//  Created by Artem Pavlov on 22.05.2022.
//

import UIKit

class PhotoCollectionViewController: UICollectionViewController {
    
    //MARK: - Public Properties
    //после каждого изменения модели (лайк убрали) происходит обновление контроллера.. сделать лучше
    var viewModel: PhotoCollectionViewModelProtocol! {
        didSet {
            viewModel.fetchPexelsData() {
                self.loadFirstData()
            }
        }
    }
    
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
    
    //MARK: - Lify Cycles Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(PhotoViewCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupSearchController()
        collectionView.reloadData() // обновляется при каждом переходе на вью, переделать, чтобы обновлялось только при смене количества ячеек на строчке
    }
    
    //MARK: - Private Methods
    //может убрать логику в дидсет вьюмодели?
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
    
    private func showSpinner(in view: UIView) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(frame: view.bounds)
        activityIndicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        return activityIndicator
    }
    
    // MARK: - UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        isFiltering ? viewModel.numberOfFilteredRows() : viewModel.numberOfRows()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! PhotoViewCell
        cell.viewModel = viewModel.cellViewModel(at: indexPath)
 
        if isFiltering {
            if indexPath.item == viewModel.numberOfFilteredRows() - 2 {
                viewModel.updateSerchingData()
                viewModel.fetchSerchingData(from: searchController.searchBar.text!) {
                    self.collectionView.reloadData()
                }
            }
        } else {
            if indexPath.item == viewModel.numberOfRows() - 2 {
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
        photoDetailVC.viewModel = viewModel.photoDetailsViewModel(at: indexPath)
        show(photoDetailVC, sender: nil)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension PhotoCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let countOfItems = CGFloat(viewModel.numberOfItemsPerRow)
        let paddingWidth = 20 * (countOfItems + 1)
        let avaibleWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = avaibleWidth / countOfItems
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
