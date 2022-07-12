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
        return photo
    }()
    
    private lazy var originSizeButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 15
        button.setTitle("Original size", for: .normal)
        button.backgroundColor = .systemGray2
        button.setTitleColor(UIColor.systemGray6, for: .normal)
        button.setTitleColor(UIColor.systemGray, for: .highlighted)
        button.addTarget(self, action: #selector(originSizeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 15
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.tintColor = .systemGray6
        button.backgroundColor = .systemGray2
        button.addTarget(self, action: #selector(shareData), for: .touchUpInside)
        return button
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 15
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .systemGray6
        button.backgroundColor = .systemGray2
        button.addTarget(self, action: #selector(addToFavorite), for: .touchUpInside)
        return button
    }()
    
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        stackView.spacing = 10.0
        stackView.addArrangedSubview(originSizeButton)
        stackView.addArrangedSubview(sendButton)
        stackView.addArrangedSubview(likeButton)
        return stackView
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
    var favoritePhoto: PexelsPhoto?
    var favoritePhotos: [PexelsPhoto] = []
    var delegateTabBarVC: TabBarStartViewControllerDelegate?
    var delegateFavoriteVC: FavoriteCollectionViewControllerDelegate?
    
    //MARK: - Life Cycles Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupPhotoInfo()
        setupSubViews(pexelsImage, horizontalStackView, photogtapherNameLabel, descriptionLabel)
        setupConstraints()
    }
    
    //MARK: - Private Methods
    private func setupPhotoInfo() {
        if favoritePhoto != nil {
            getDetailsWith(
                photoUrl: favoritePhoto?.largeSizeOfPhoto ?? "",
                photographerName: favoritePhoto?.photographer ?? "",
                descriptionOfPhoto: favoritePhoto?.descriptionOfPhoto ?? ""
            )
            loadPexelsDataFromFavourite()
            setLike()
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
    
    private func loadPexelsDataFromFavourite() {
        let id = Int(favoritePhoto?.id ?? 0)
        NetworkManager.shared.fetchData(from: Link.getPexelsPhotoById.rawValue, usingId: id) { result in
            switch result {
            case .success(let fetchedPhoto):
                self.photo = fetchedPhoto
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func isLiked() {
        loadFavouritePhotos()
        guard let pexelsPhotoId = photo?.id else { return }
        for favorPhoto in favoritePhotos {
            if pexelsPhotoId == Int(favorPhoto.id) {
                favoritePhoto = favorPhoto
                setLike()
            }
        }
    }
    
    private func setLike() {
        liked = true
        likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        likeButton.tintColor = .systemYellow
    }
    
    private func removeLike() {
        liked = false
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.tintColor = .systemGray6
    }
    
    private func loadFavouritePhotos() {
        StorageManager.shared.fetchFavoritePhotos { result in
            switch result {
            case .success(let photos):
                self.favoritePhotos = photos
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @objc private func addToFavorite() {
        if liked {
            removeLike()
            StorageManager.shared.deletePhoto(photo: favoritePhoto ?? PexelsPhoto())
            delegateTabBarVC?.reloadFavoriteData() //переместить в setLike
        } else {
            StorageManager.shared.savePhoto(pexelsPhoto: photo)
            delegateTabBarVC?.reloadFavoriteData() //переместить в setLike
            setLike()
            isLiked()
        }
        delegateFavoriteVC?.reloadData()
    }
    
    @objc private func shareData() {
        guard let link = photo?.url else { return }
        guard let photoLink = NSURL(string: link) else { return }
        let activityViewController: UIActivityViewController = UIActivityViewController(
            activityItems: [photoLink],
            applicationActivities: nil
        )
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    private func setupSubViews(_ subViews: UIView...) {
        subViews.forEach { subview in
            view.addSubview(subview)
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
    }
    
    @objc func originSizeButtonTapped() {
        let photoVC = PhotoViewController()
        photoVC.photo = photo?.src?.original
        show(photoVC, sender: nil)
    }
    
    //MARK: - Setup Constraints
    private func setupConstraints() {
        let offsetLineView = view.bounds.height * 0.65
        
        pexelsImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pexelsImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            pexelsImage.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: offsetLineView),
            pexelsImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            pexelsImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: offsetLineView + 10),
            horizontalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            horizontalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            sendButton.widthAnchor.constraint(equalToConstant: 35),
            likeButton.widthAnchor.constraint(equalToConstant: 35)
        ])
        
        photogtapherNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photogtapherNameLabel.topAnchor.constraint(equalTo: originSizeButton.bottomAnchor, constant: 5),
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



