//
//  TabBarViewController.swift
//  MyPexels
//
//  Created by Artem Pavlov on 22.05.2022.
//

import UIKit

class TabBarStartViewController: UITabBarController {
    
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
        let photosVC = PhotoCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let favoriteVC = FavoriteCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let userVC = UserViewController()
        
        photosVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        favoriteVC.tabBarItem = UITabBarItem(title: "Favorite", image: UIImage(systemName: "heart"), tag: 2)
        userVC.tabBarItem = UITabBarItem(title: "User", image: UIImage(systemName: "person"), tag: 3)
        viewControllers = [photosVC, favoriteVC, userVC]
    }
    
    private func setupNavigationBar() {
        title = tabBar.selectedItem?.title
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

