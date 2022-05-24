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

        let photosVC = PhotoCollectionViewController(collectionViewLayout: UICollectionViewLayout())
        let favouriteVC = FavouriteCollectionViewController(collectionViewLayout: UICollectionViewLayout())
        let userVC = UserViewController()
        
        photosVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        favouriteVC.tabBarItem = UITabBarItem(title: "Favourite", image: UIImage(systemName: "heart"), tag: 2)
        userVC.tabBarItem = UITabBarItem(title: "User", image: UIImage(systemName: "person"), tag: 3)
        viewControllers = [photosVC, favouriteVC, userVC]
    }
}

