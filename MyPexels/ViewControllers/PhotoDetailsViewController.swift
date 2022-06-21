//
//  PhotoDetailsViewController.swift
//  MyPexels
//
//  Created by Artem Pavlov on 07.06.2022.
//

import UIKit
import CoreData

class PhotoDetailsViewController: UIViewController {
    
    //MARK: - Private Properties
    private lazy var pexelsImage: UIImageView = {
        let photo = UIImageView()
        photo.layer.cornerRadius = 15
        photo.contentMode = .scaleAspectFill
        photo.layer.masksToBounds = true
        
        let action = UITapGestureRecognizer(target: self, action: #selector(imageTapped(gesture:)))
        photo.addGestureRecognizer(action)
        photo.isUserInteractionEnabled = true
        
        return photo
    }()
    
    private lazy var photogtapherNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private var activityIndicator: UIActivityIndicatorView?
    private var liked = false
    
    //MARK: - Public Properties
    var photo: Photo?
    
    //MARK: - Life Cycles Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.largeTitleDisplayMode = .never
        getInfo()
        setupNavigationBar()
        setupSubViews(pexelsImage, photogtapherNameLabel, descriptionLabel)
        setupConstraints()
    }
    
    //MARK: - Private Methods
    private func loadImage(from url: String) {
        activityIndicator = showSpinner(in: view)
        
        DispatchQueue.global().async {
            guard let imageData = ImageManager.shared.fetchImage(from: url) else { return }
            
            DispatchQueue.main.async {
                self.pexelsImage.image = UIImage(data: imageData)
                self.activityIndicator?.stopAnimating()
            }
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem (
            image: UIImage(systemName: setButtonImage()), style: .plain,
            target: self,
            action: #selector(addToFavourite)
        )
    }
    
    @objc private func addToFavourite() {
        liked.toggle()
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: setButtonImage())
        StorageManager.shared.savePhoto(pexelsPhoto: photo!)
    }
    
    private func setButtonImage() -> String {
        var image = ""
        if liked {
            image = "heart.fill"
        } else {
            image = "heart"
        }
        return image
    }

    private func getInfo() {
        loadImage(from: photo?.src?.large ?? "")
        photogtapherNameLabel.text = photo?.photographer?.capitalized
        descriptionLabel.text = photo?.alt?.capitalized
    }
    
    private func setupSubViews(_ subViews: UIView...) {
        subViews.forEach { subview in
            view.addSubview(subview)
        }
    }
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        if (gesture.view as? UIImageView) != nil {
            let photoVC = PhotoViewController()
            photoVC.photo = photo
            show(photoVC, sender: nil)
        }
    }
    
    //MARK: - Setup Constraints
    private func setupConstraints() {
        let offsetLineView = view.bounds.height * 0.7
        
        pexelsImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pexelsImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            pexelsImage.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: offsetLineView),
            pexelsImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            pexelsImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        photogtapherNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photogtapherNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: offsetLineView + 10),
            photogtapherNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            photogtapherNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: photogtapherNameLabel.bottomAnchor, constant: 2),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}


