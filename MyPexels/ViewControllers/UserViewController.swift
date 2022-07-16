//
//  ViewController.swift
//  MyPexels
//
//  Created by Artem Pavlov on 22.05.2022.
//

import UIKit

class UserViewController: UIViewController {
    
    //MARK: - Private Properties
    private lazy var clearFavoriteDataButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 15
        button.setTitle("Clear Favorite Photos", for: .normal)
        button.backgroundColor = .systemGray2
        button.setTitleColor(UIColor.systemGray6, for: .normal)
        button.setTitleColor(UIColor.systemGray, for: .highlighted)
        button.addTarget(self, action: #selector(clearFavoriteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var changeNumberOfItemsButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 15
        button.setTitle("Number of items on Pexels View: \(numberOfItems)", for: .normal)
        button.backgroundColor = .systemGray2
        button.setTitleColor(UIColor.systemGray6, for: .normal)
        button.setTitleColor(UIColor.systemGray, for: .highlighted)
        button.addTarget(self, action: #selector(changeItemsTapped), for: .touchUpInside)
        return button
    }()
    
    private var numberOfItems = 2
    
    //MARK: - Public Properties
    var delegateTabBarVC: TabBarStartViewControllerDelegate?
    var delegateFavoriteVC: FavoriteCollectionViewControllerDelegate?
    var delegatePhotoCollectionVC: PhotoCollectionViewControllerDelegate?
    
    //MARK: - Life Cycles Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubViews(clearFavoriteDataButton, changeNumberOfItemsButton)
        setupConstraints()
    }
    
    //MARK: - Private Methods
    private func setupSubViews(_ subViews: UIView...) {
        subViews.forEach { subview in
            view.addSubview(subview)
        }
    }
    
    @objc private func clearFavoriteButtonTapped() {
        StorageManager.shared.deleteFavoritePhotos()
        delegateTabBarVC?.reloadFavoriteData()
        delegateFavoriteVC?.reloadData()
    }
    
    @objc private func changeItemsTapped() {
        if numberOfItems == 2 {
            delegatePhotoCollectionVC?.changeNumberOfItemsPerRow(CGFloat(numberOfItems + 1))
            numberOfItems += 1
            changeNumberOfItemsButton.setTitle("Number of items on Pexels View: \(numberOfItems)", for: .normal)
        } else {
            delegatePhotoCollectionVC?.changeNumberOfItemsPerRow(CGFloat(numberOfItems - 1))
            numberOfItems -= 1
            changeNumberOfItemsButton.setTitle("Number of items on Pexels View: \(numberOfItems)", for: .normal)
        }
    }
    
    //MARK: - Setup Constraints
    private func setupConstraints() {
        clearFavoriteDataButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            clearFavoriteDataButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            clearFavoriteDataButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            clearFavoriteDataButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        changeNumberOfItemsButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            changeNumberOfItemsButton.topAnchor.constraint(equalTo: clearFavoriteDataButton.bottomAnchor, constant: 50),
            changeNumberOfItemsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            changeNumberOfItemsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}
