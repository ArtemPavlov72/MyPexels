//
//  TabBarViewController.swift
//  MyPexels
//
//  Created by Artem Pavlov on 22.05.2022.
//

import UIKit

class TabBarStartViewController: UITabBarController {
    
    //MARK: - Public Properties
    var viewModel: TabBarStartViewModelProtocol! {
        didSet {
            photosVC.viewModel = viewModel.photoCollectionViewModel()
            favoriteVC.viewModel = viewModel.favoriteCollectionViewModel()
        }
    }
    
    //MARK: - Private Properties
    private let photosVC = PhotoCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
    private let favoriteVC = FavoriteCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
    private let settingsVC = SettingsViewController()
    
    //MARK: - Life Cycles Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
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
    
    private func setupNavigationBar() {
        title = tabBar.selectedItem?.title
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
