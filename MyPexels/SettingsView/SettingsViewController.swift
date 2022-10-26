//
//  ViewController.swift
//  MyPexels
//
//  Created by Artem Pavlov on 22.05.2022.
//

import UIKit
import SnapKit

class SettingsViewController: UIViewController {
    
    var viewModel: SettingViewModelProtocol!
    
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
        button.setTitle(" \(viewModel.numberOfPhotoItems) ", for: .normal)
        button.backgroundColor = .systemGray2
        button.setTitleColor(UIColor.systemGray6, for: .normal)
        button.setTitleColor(UIColor.systemGray, for: .highlighted)
        button.addTarget(self, action: #selector(changeItemsOnPhotoVCTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var changeNumberOfItemsOnFVCButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 15
        button.setTitle(" \(viewModel.numberOfFavoriteItems) ", for: .normal)
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
        
    //MARK: - Life Cycles Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        viewModelUpdate()
        setupSubViews(itemsVStackView, dataVStackView)
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.topItem?.searchController = nil
    }
    
    //MARK: - Private Methods
    private func viewModelUpdate() {
        viewModel.viewModelDidChange = { [weak self] viewModel in
            self?.changeNumberOfItemsOnPVCButton.setTitle(" \(viewModel.numberOfPhotoItems) ", for: .normal)
            self?.changeNumberOfItemsOnFVCButton.setTitle(" \(viewModel.numberOfFavoriteItems) ", for: .normal)
        }
    }
    
    private func setupSubViews(_ subViews: UIView...) {
        subViews.forEach { subview in
            view.addSubview(subview)
        }
    }
    
    @objc private func clearFavoriteButtonTapped() {
        showAlert(with: "All favorite photos will be deleted.", and: "Do you want to continue?") {
            self.viewModel.clearButtonTapped()
        }
    }
    
    @objc private func logoutButtonTapped() {
        showAlert(with: "All saved data will be deleted.", and: "Do you want to continue?") {
            self.viewModel.logoutButtonTapped()
        }
    }
    
    @objc private func changeItemsOnPhotoVCTapped() {
        viewModel.changeNumberOfPhotoItemsTapped()
    }
    
    @objc private func changeItemsOnFavoriteVCTapped() {
        viewModel.changeNumberOfFavoriteItemsTapped()
    }
    
    //MARK: - Setup Constraints
    private func setupConstraints() {
        itemsVStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.right.left.equalToSuperview().inset(16)
        }
        
        dataVStackView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(35)
            make.right.left.equalToSuperview().inset(16)
        }
        
        changeNumberOfItemsOnPVCButton.snp.makeConstraints { make in
            make.width.equalTo(60)
        }
        
        changeNumberOfItemsOnFVCButton.snp.makeConstraints { make in
            make.width.equalTo(60)
        }
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
