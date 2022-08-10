//
//  ViewController.swift
//  MyPexels
//
//  Created by Artem Pavlov on 22.05.2022.
//

import UIKit

class SettingsViewController: UIViewController {
    
    //MARK: - Private Properties
    private lazy var clearFavoriteDataButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 15
        button.setTitle("Clear Favorite Photos", for: .normal)
        button.backgroundColor = .systemOrange.withAlphaComponent(0.7)
        button.setTitleColor(UIColor.systemGray6, for: .normal)
        button.setTitleColor(UIColor.systemGray, for: .highlighted)
        button.addTarget(self, action: #selector(clearFavoriteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var logOutButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 15
        button.setTitle("Log Out", for: .normal)
        button.backgroundColor = .systemRed.withAlphaComponent(0.6)
        button.setTitleColor(UIColor.systemGray6, for: .normal)
        button.setTitleColor(UIColor.systemGray, for: .highlighted)
        button.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
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
    
    private lazy var itemsTextLabel: UILabel = {
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
    
    private lazy var itemsVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.spacing = 10.0
        stackView.addArrangedSubview(itemsTextLabel)
        stackView.addArrangedSubview(horizontalPhotoStackView)
        stackView.addArrangedSubview(horizontalFavoriteStackView)
        stackView.addArrangedSubview(clearFavoriteDataButton)
        stackView.addArrangedSubview(logOutButton)
        return stackView
    }()
    
    private lazy var dataVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.spacing = 10.0
        stackView.addArrangedSubview(clearFavoriteDataButton)
        stackView.addArrangedSubview(logOutButton)
        return stackView
    }()
    
    private lazy var horizontalPhotoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        stackView.spacing = 10.0
        stackView.addArrangedSubview(pexelsLabel)
        stackView.addArrangedSubview(changeNumberOfItemsOnPVCButton)
        return stackView
    }()
    
    private lazy var horizontalFavoriteStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        stackView.spacing = 10.0
        stackView.addArrangedSubview(favoriteLabel)
        stackView.addArrangedSubview(changeNumberOfItemsOnFVCButton)
        return stackView
    }()
    
    private var numberOfItemsOnPhotoVC: ItemsOfRow = {
        var items = ItemsOfRow.one
        if UserDefaults.standard.value(forKey: "itemsPhotoVC") as? Int == 1 {
            items = ItemsOfRow.one
        } else if UserDefaults.standard.value(forKey: "itemsPhotoVC") as? Int == 2 {
            items = ItemsOfRow.two
        } else {
            items = ItemsOfRow.three
        }
        return items
    }()
    
    private var numberOfItemsOnFavoriteVC: ItemsOfRow = {
        var items = ItemsOfRow.one
        if UserDefaults.standard.value(forKey: "itemsFavoriteVC") as? Int == 1 {
            items = ItemsOfRow.one
        } else if UserDefaults.standard.value(forKey: "itemsFavoriteVC") as? Int == 2 {
            items = ItemsOfRow.two
        } else {
            items = ItemsOfRow.three
        }
        return items
    }()
    
    //MARK: - Public Properties
    var delegateTabBarVC: TabBarStartViewControllerDelegate?
    var delegateFavoriteVC: FavoriteCollectionViewControllerDelegate?
    var delegatePhotoCollectionVC: PhotoCollectionViewControllerDelegate?
    
    //MARK: - Life Cycles Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupSubViews(itemsVStackView, dataVStackView)
        setupConstraints()
    }
    
    //MARK: - Private Methods
    private func setupSubViews(_ subViews: UIView...) {
        subViews.forEach { subview in
            view.addSubview(subview)
        }
    }
    
    @objc private func clearFavoriteButtonTapped() {
        showAlert(with: "All favorite photos will be deleted.", and: "Do you want to continue?") {
            StorageManager.shared.deleteFavoritePhotos()
            self.delegateTabBarVC?.reloadFavoriteData()
            self.delegateFavoriteVC?.reloadData()
        }
    }
    
    @objc private func logoutButtonTapped() {
        showAlert(with: "All saved data will be deleted.", and: "Do you want to continue?") {
            UserDefaults.standard.set(false, forKey: "done")
            UserDefaults.standard.set(2, forKey: "itemsPhotoVC")
            UserDefaults.standard.set(2, forKey: "itemsFavoriteVC")
            AppDelegate.shared.rootViewController.switchToLogout()
            StorageManager.shared.deleteFavoritePhotos()
        }
    }
    
    @objc private func changeItemsOnPhotoVCTapped() {
        switch numberOfItemsOnPhotoVC {
        case .one:
            numberOfItemsOnPhotoVC = ItemsOfRow.two
            delegatePhotoCollectionVC?.changeNumberOfItemsPerRow(2, size: .medium)
            changeNumberOfItemsOnPVCButton.setTitle(" \(numberOfItemsOnPhotoVC) ", for: .normal)
            UserDefaults.standard.set(2, forKey: "itemsPhotoVC")
        case .two:
            numberOfItemsOnPhotoVC = ItemsOfRow.three
            delegatePhotoCollectionVC?.changeNumberOfItemsPerRow(3, size: .small)
            changeNumberOfItemsOnPVCButton.setTitle(" \(numberOfItemsOnPhotoVC) ", for: .normal)
            UserDefaults.standard.set(3, forKey: "itemsPhotoVC")
        case .three:
            numberOfItemsOnPhotoVC = ItemsOfRow.one
            delegatePhotoCollectionVC?.changeNumberOfItemsPerRow(1, size: .large)
            changeNumberOfItemsOnPVCButton.setTitle(" \(numberOfItemsOnPhotoVC) ", for: .normal)
            UserDefaults.standard.set(1, forKey: "itemsPhotoVC")
        }
    }
    
    @objc private func changeItemsOnFavoriteVCTapped() {
        switch numberOfItemsOnFavoriteVC {
        case .one:
            numberOfItemsOnFavoriteVC = ItemsOfRow.two
            delegateFavoriteVC?.changeNumberOfItemsPerRow(2, size: .medium)
            changeNumberOfItemsOnFVCButton.setTitle(" \(numberOfItemsOnFavoriteVC) ", for: .normal)
            UserDefaults.standard.set(2, forKey: "itemsFavoriteVC")
        case .two:
            numberOfItemsOnFavoriteVC = ItemsOfRow.three
            delegateFavoriteVC?.changeNumberOfItemsPerRow(3, size: .small)
            changeNumberOfItemsOnFVCButton.setTitle(" \(numberOfItemsOnFavoriteVC) ", for: .normal)
            UserDefaults.standard.set(3, forKey: "itemsFavoriteVC")
        case .three:
            numberOfItemsOnFavoriteVC = ItemsOfRow.one
            delegateFavoriteVC?.changeNumberOfItemsPerRow(1, size: .large)
            changeNumberOfItemsOnFVCButton.setTitle(" \(numberOfItemsOnFavoriteVC) ", for: .normal)
            UserDefaults.standard.set(1, forKey: "itemsFavoriteVC")
        }
    }
    
    //MARK: - Setup Constraints
    private func setupConstraints() {
        
        itemsVStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            itemsVStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70),
            itemsVStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            itemsVStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        dataVStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dataVStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -120),
            dataVStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dataVStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        changeNumberOfItemsOnPVCButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            changeNumberOfItemsOnPVCButton.widthAnchor.constraint(equalToConstant: 110),
        ])
        
        changeNumberOfItemsOnFVCButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            changeNumberOfItemsOnFVCButton.widthAnchor.constraint(equalToConstant: 110),
        ])
    }
}

//MARK: - Alert Controller
extension SettingsViewController {
    private func showAlert(with title: String, and massage: String, completion: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: massage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            guard let completion = completion else { return }
            completion()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}

//MARK: - Number Of Photos On Row
extension SettingsViewController {
    enum ItemsOfRow {
        case one, two, three
    }
}
