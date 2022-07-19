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
        button.backgroundColor = .systemRed.withAlphaComponent(0.6)
        button.setTitleColor(UIColor.systemGray6, for: .normal)
        button.setTitleColor(UIColor.systemGray, for: .highlighted)
        button.addTarget(self, action: #selector(clearFavoriteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var changeNumberOfItemsOnPVCButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 15
        button.setTitle(" \(numberOfItemsOnPhotoVC) ", for: .normal)
        button.backgroundColor = .systemGray2
        button.setTitleColor(UIColor.systemGray6, for: .normal)
        button.setTitleColor(UIColor.systemGray, for: .highlighted)
        button.addTarget(self, action: #selector(changeItemsOnPhotoVCTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var changeNumberOfItemsOnFVCButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 15
        button.setTitle(" \(numberOfItemsOnFavoriteVC) ", for: .normal)
        button.backgroundColor = .systemGray2
        button.setTitleColor(UIColor.systemGray6, for: .normal)
        button.setTitleColor(UIColor.systemGray, for: .highlighted)
        button.addTarget(self, action: #selector(changeItemsOnFavoriteVCTapped), for: .touchUpInside)
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
    
    private lazy var favoriteLabel: UILabel = {
        let label = UILabel()
        label.text = "Favorite collection:"
        return label
    }()
    
    private lazy var horizontalPhotoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        stackView.spacing = 10.0
        stackView.addArrangedSubview(pexelsLabel)
        stackView.addArrangedSubview(changeNumberOfItemsOnPVCButton)
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var horizontalFavoriteStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        stackView.spacing = 10.0
        stackView.addArrangedSubview(favoriteLabel)
        stackView.addArrangedSubview(changeNumberOfItemsOnFVCButton)
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private var numberOfItemsOnPhotoVC = ItemsOfRow.two
    private var numberOfItemsOnFavoriteVC = ItemsOfRow.two
    
    //MARK: - Public Properties
    var delegateTabBarVC: TabBarStartViewControllerDelegate?
    var delegateFavoriteVC: FavoriteCollectionViewControllerDelegate?
    var delegatePhotoCollectionVC: PhotoCollectionViewControllerDelegate?
    
    //MARK: - Life Cycles Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupSubViews(clearFavoriteDataButton, itemsText, horizontalPhotoStackView, horizontalFavoriteStackView)
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
    
    @objc private func changeItemsOnPhotoVCTapped() {
        switch numberOfItemsOnPhotoVC {
        case .one:
            numberOfItemsOnPhotoVC = ItemsOfRow.two
            delegatePhotoCollectionVC?.changeNumberOfItemsPerRow(2, size: .medium)
            changeNumberOfItemsOnPVCButton.setTitle(" \(numberOfItemsOnPhotoVC) ", for: .normal)
        case .two:
            numberOfItemsOnPhotoVC = ItemsOfRow.three
            delegatePhotoCollectionVC?.changeNumberOfItemsPerRow(3, size: .small)
            changeNumberOfItemsOnPVCButton.setTitle(" \(numberOfItemsOnPhotoVC) ", for: .normal)
        case .three:
            numberOfItemsOnPhotoVC = ItemsOfRow.one
            delegatePhotoCollectionVC?.changeNumberOfItemsPerRow(1, size: .large)
            changeNumberOfItemsOnPVCButton.setTitle(" \(numberOfItemsOnPhotoVC) ", for: .normal)
        }
    }
    
    @objc private func changeItemsOnFavoriteVCTapped() {
        switch numberOfItemsOnFavoriteVC {
        case .one:
            numberOfItemsOnFavoriteVC = ItemsOfRow.two
            delegateFavoriteVC?.changeNumberOfItemsPerRow(2, size: .medium)
            changeNumberOfItemsOnFVCButton.setTitle(" \(numberOfItemsOnFavoriteVC) ", for: .normal)
        case .two:
            numberOfItemsOnFavoriteVC = ItemsOfRow.three
            delegateFavoriteVC?.changeNumberOfItemsPerRow(3, size: .small)
            changeNumberOfItemsOnFVCButton.setTitle(" \(numberOfItemsOnFavoriteVC) ", for: .normal)
        case .three:
            numberOfItemsOnFavoriteVC = ItemsOfRow.one
            delegateFavoriteVC?.changeNumberOfItemsPerRow(1, size: .large)
            changeNumberOfItemsOnFVCButton.setTitle(" \(numberOfItemsOnFavoriteVC) ", for: .normal)
        }
    }
    
    //MARK: - Setup Constraints
    private func setupConstraints() {

        itemsText.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            itemsText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            itemsText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            itemsText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        horizontalPhotoStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            horizontalPhotoStackView.topAnchor.constraint(equalTo: itemsText.bottomAnchor, constant: 10),
            horizontalPhotoStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            horizontalPhotoStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        horizontalFavoriteStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            horizontalFavoriteStackView.topAnchor.constraint(equalTo: horizontalPhotoStackView.bottomAnchor, constant: 10),
            horizontalFavoriteStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            horizontalFavoriteStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        clearFavoriteDataButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            clearFavoriteDataButton.topAnchor.constraint(equalTo: horizontalFavoriteStackView.bottomAnchor, constant: 50),
            clearFavoriteDataButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            clearFavoriteDataButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
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
    enum ItemsOfRow {
        case one, two, three
    }
}
