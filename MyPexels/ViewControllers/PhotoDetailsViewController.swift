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
    private var photoId: Int?
    
    //MARK: - Public Properties
    var photo: Photo?
    var favouritePhoto: PexelsPhoto?
    var favouritePhotos: [PexelsPhoto] = []
    
    //MARK: - Life Cycles Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.largeTitleDisplayMode = .never
        setupPhotoInfo()
        setupNavigationBar()
        setupSubViews(pexelsImage, photogtapherNameLabel, descriptionLabel)
        setupConstraints()
    }
    
    //MARK: - Private Methods
    private func setupPhotoInfo() {
        if favouritePhoto != nil {
            getDetailsWith(
                photoUrl: favouritePhoto?.largeSizeOfPhoto ?? "",
                photographerName: favouritePhoto?.photographer ?? "",
                descriptionOfPhoto: favouritePhoto?.descriptionOfPhoto ?? ""
            )
            photoId = Int(favouritePhoto?.id ?? 0)
            liked = true
        } else {
            getDetailsWith(
                photoUrl: photo?.src?.large ?? "",
                photographerName: photo?.photographer ?? "",
                descriptionOfPhoto: photo?.alt ?? ""
            )
            isLiked()
        }
    }
    
    private func getDetailsWith(photoUrl: String, photographerName: String, descriptionOfPhoto: String) {
        loadImage(from: photoUrl)
        photogtapherNameLabel.text = photographerName.capitalized
        descriptionLabel.text = descriptionOfPhoto.capitalized
    }
    
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
    
    private func isLiked() {
        loadFavouritePhotos()
        guard let pexelsPhotoId = photo?.id else { return }
        for favorPhoto in favouritePhotos {
            if pexelsPhotoId == Int(favorPhoto.id) {
                favouritePhoto = favorPhoto
                liked = true
            }
        }
    }
    
    private func loadFavouritePhotos() {
        StorageManager.shared.fetchFavouritePhotos { result in
            switch result {
            case .success(let photos):
                self.favouritePhotos = photos
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem (
            image: UIImage(systemName: "heart"), style: .plain,
            target: self,
            action: #selector(addToFavourite)
        )
    }
    
    @objc private func addToFavourite() {
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart")
        if liked {
            StorageManager.shared.deletePhoto(photo: favouritePhoto ?? PexelsPhoto())
            liked = false
        } else {
            if photo == nil {
                NetworkManager.shared.fetchData(from: Link.getPexelsPhotoById.rawValue, usingId: photoId ?? 0) { result in
                    switch result {
                    case .success(let photo):
                        //self.photo = photo
                        StorageManager.shared.savePhoto(pexelsPhoto: photo)
                        self.liked = true
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            } else {
            StorageManager.shared.savePhoto(pexelsPhoto: photo)
                loadFavouritePhotos()
                isLiked()
            liked = true
        }
        }
    }
    
    private func setupSubViews(_ subViews: UIView...) {
        subViews.forEach { subview in
            view.addSubview(subview)
        }
    }
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        if (gesture.view as? UIImageView) != nil {
            let photoVC = PhotoViewController()
            if favouritePhoto != nil {
                photoVC.photo = favouritePhoto?.originalSizeOfPhoto
            } else {
                photoVC.photo = photo?.src?.original
            }
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


