//
//  TabBarViewController.swift
//  MyPexels
//
//  Created by Artem Pavlov on 22.05.2022.
//

import UIKit

protocol TabBarStartViewControllerDelegate {
    func reloadFavoriteData()
}
                            
class TabBarStartViewController: UITabBarController {
    
    //MARK: - Public Properties
    var viewModel: TabBarStartViewModelProtocol!
    
    //MARK: - Private Properties
    private let photosVC = PhotoCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
    private let favoriteVC = FavoriteCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
    private let settingsVC = SettingsViewController()
    private var favoritePhotos: [PexelsPhoto] = []
    
    //MARK: - Life Cycles Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadFavouritePhotos()
        viewModel = TabBarStartViewModel(favoritePhotos: favoritePhotos)
        setupTabBar()
        updateFavotiteData(for: photosVC)
        updateFavotiteData(for: favoriteVC)
        updateFavotiteData(for: settingsVC)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    //MARK: - TabBar Setup
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        navigationItem.title = item.title
    }
    
    //MARK: - Private Methods
    private func setupTabBar() {
        photosVC.tabBarItem = UITabBarItem(title: "Pexels", image: UIImage(systemName: "house"), tag: 1)
        favoriteVC.tabBarItem = UITabBarItem(title: "Favorite", image: UIImage(systemName: "heart"), tag: 2)
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "slider.vertical.3"), tag: 3) 
        viewControllers = [photosVC, favoriteVC, settingsVC]
    }
    
    private func updateFavotiteData(for favoriteViewController: FavoriteCollectionViewController) {
        favoriteViewController.favoritePhotos = favoritePhotos
        favoriteViewController.delegateTabBarVC = self
    }
    
    private func updateFavotiteData(for photoViewController: PhotoCollectionViewController) {
        
        photoViewController.viewModel = viewModel.photoCollectionViewModel()
        photoViewController.delegateFavoriteVC = favoriteVC
        photoViewController.delegateTabBarVC = self
    }
    
    private func updateFavotiteData(for userViewController: SettingsViewController) {
        userViewController.delegateTabBarVC = self
        userViewController.delegateFavoriteVC = favoriteVC
       // userViewController.delegatePhotoCollectionVC = photosVC
    }
    
    private func setupNavigationBar() {
        title = tabBar.selectedItem?.title
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func loadFavouritePhotos() {
        StorageManager.shared.fetchFavoritePhotos { result in
            switch result {
            case .success(let photos):
                self.favoritePhotos = photos
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

//MARK: - TabBarStartViewControllerDelegate
extension TabBarStartViewController: TabBarStartViewControllerDelegate {
    func reloadFavoriteData() {
        loadFavouritePhotos()
        updateFavotiteData(for: favoriteVC)
        updateFavotiteData(for: photosVC)
    }
}
