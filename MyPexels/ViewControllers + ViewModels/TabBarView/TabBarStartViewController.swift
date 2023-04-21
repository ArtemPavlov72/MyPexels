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
            settingsVC.viewModel = viewModel.settingsViewModel()
        }
    }
    
    //MARK: - Private Properties
    private let photosVC = PhotoCollectionViewController(
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    private let favoriteVC = FavoriteCollectionViewController(
        collectionViewLayout: UICollectionViewFlowLayout()
    )
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
        addTabBarItem(for: photosVC, title: "Pexels", image: "house", tag: 1)
        addTabBarItem(for: favoriteVC, title: "Favorite", image: "heart", tag: 2)
        addTabBarItem(for: settingsVC, title: "Settings", image: "slider.vertical.3", tag: 3)
        viewControllers = [photosVC, favoriteVC, settingsVC]
    }
    
    private func addTabBarItem(
        for viewController: UIViewController,
        title: String,
        image: String,
        tag: Int
    ) {
        viewController.tabBarItem = UITabBarItem(
            title: title,
            image: UIImage(systemName: image),
            tag: tag
        )
    }
    
    private func setupNavigationBar() {
        title = tabBar.selectedItem?.title
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
