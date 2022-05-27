//
//  TabBarViewController.swift
//  MyPexels
//
//  Created by Artem Pavlov on 22.05.2022.
//

import UIKit

class TabBarStartViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
        
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        navigationItem.title = item.title
    }
    
    private func setupTabBar() {
        let photosVC = PhotoCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let favouriteVC = FavouriteCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let userVC = UserViewController()
        
        photosVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        favouriteVC.tabBarItem = UITabBarItem(title: "Favourite", image: UIImage(systemName: "heart"), tag: 2)
        userVC.tabBarItem = UITabBarItem(title: "User", image: UIImage(systemName: "person"), tag: 3)
        viewControllers = [photosVC, favouriteVC, userVC]
    }
    
    private func setupNavigationBar() {
        title = tabBar.selectedItem?.title
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

