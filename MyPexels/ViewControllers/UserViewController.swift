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
        button.setTitle(" \(numberOfItemsOnPhotoVC) ", for: .normal)
        button.backgroundColor = .systemGray2
        button.setTitleColor(UIColor.systemGray6, for: .normal)
        button.setTitleColor(UIColor.systemGray, for: .highlighted)
        button.addTarget(self, action: #selector(changeItemsTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var itemsText: UILabel = {
        let label = UILabel()
        label.text = "Set number of items on one row:"
        return label
    }()
    
    private lazy var pexelsLabel: UILabel = {
        let label = UILabel()
        label.text = "Pexels collection:"
        return label
    }()
    
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        stackView.spacing = 10.0
        stackView.addArrangedSubview(pexelsLabel)
        stackView.addArrangedSubview(changeNumberOfItemsButton)
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private var numberOfItemsOnPhotoVC = ItemsOfRow.two
    
    //MARK: - Public Properties
    var delegateTabBarVC: TabBarStartViewControllerDelegate?
    var delegateFavoriteVC: FavoriteCollectionViewControllerDelegate?
    var delegatePhotoCollectionVC: PhotoCollectionViewControllerDelegate?
    
    //MARK: - Life Cycles Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupSubViews(clearFavoriteDataButton, itemsText, horizontalStackView)
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
        showAlert(with: "Complete!", and: "Your favorite photos deleted.")
    }
    
    @objc private func changeItemsTapped() {
        switch numberOfItemsOnPhotoVC {
        case .one:
            numberOfItemsOnPhotoVC = ItemsOfRow.two
            delegatePhotoCollectionVC?.changeNumberOfItemsPerRow(2)
            changeNumberOfItemsButton.setTitle(" \(numberOfItemsOnPhotoVC) ", for: .normal)
        case .two:
            numberOfItemsOnPhotoVC = ItemsOfRow.three
            delegatePhotoCollectionVC?.changeNumberOfItemsPerRow(3)
            changeNumberOfItemsButton.setTitle(" \(numberOfItemsOnPhotoVC) ", for: .normal)
        case .three:
            numberOfItemsOnPhotoVC = ItemsOfRow.one
            delegatePhotoCollectionVC?.changeNumberOfItemsPerRow(1)
            changeNumberOfItemsButton.setTitle(" \(numberOfItemsOnPhotoVC) ", for: .normal)
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
        
        itemsText.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            itemsText.topAnchor.constraint(equalTo: clearFavoriteDataButton.bottomAnchor, constant: 50),
            itemsText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            itemsText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: itemsText.bottomAnchor, constant: 10),
            horizontalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            horizontalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}

//MARK: - Alert Controller
extension UserViewController {
    func showAlert(with title: String, and massage: String) {
        let alert = UIAlertController(title: title, message: massage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

//MARK: - Number Of Photos On Row
extension UserViewController {
    enum ItemsOfRow: String {
        case one = "1",
             two = "2",
             three = "3"
    }
}
