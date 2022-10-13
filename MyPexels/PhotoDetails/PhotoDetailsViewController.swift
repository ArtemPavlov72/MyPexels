//
//  PhotoDetailsViewController.swift
//  MyPexels
//
//  Created by Artem Pavlov on 07.06.2022.
//

import UIKit

class PhotoDetailsViewController: UIViewController {
    
    //MARK: - Public Properties
    var viewModel: PhotoDetailsViewModelProtocol! {
        didSet {
            viewModel.viewModelDidChange = { [weak self] viewModel in
                self?.delegateTabBarVC?.reloadFavoriteData()
                self?.delegateFavoriteVC?.reloadData()
                self?.installLike()
            }
            photogtapherNameLabel.text = viewModel.photogtapherNameLabel?.capitalized
            descriptionLabel.text = viewModel.descriptionLabel?.capitalized
            guard let imageUrl = viewModel.pexelsImageURL else { return }
            pexelsImage.fetchImage(from: imageUrl)
            // по загрузке картинки
            // в моделе убегающее замыкание, и когда она будет загружаться, то выдает дату дату
            // а перед этим активити индикатор крутит
        }
    }
    
    var photo: Photo? //delete
    var favoritePhoto: PexelsPhoto? //delete
    var favoritePhotos: [PexelsPhoto] = [] //delete
    var delegateTabBarVC: TabBarStartViewControllerDelegate? //delete
    var delegateFavoriteVC: FavoriteCollectionViewControllerDelegate? //delete
    
    //MARK: - Private Properties
    private lazy var pexelsImage: PexelsImageView = {
        let photo = PexelsImageView()
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
        
    //MARK: - Life Cycles Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        viewModel = PhotoDetailsViewModel( // delete
            photo: photo,
            favoritePhoto: favoritePhoto,
            favoritePhotos: favoritePhotos
        )
        setupNavigationBar()
        installLike()
        setupSubViews(
            pexelsImage,
            horizontalStackView,
            photogtapherNameLabel,
            descriptionLabel
        )
        setupConstraints()
    }
    
    //MARK: - Private Methods
    private func installLike() {
        viewModel.isFavorte ? addLike() : removeLike()
    }
    
    private func addLike() {
        likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        likeButton.tintColor = .systemYellow
    }
    
    private func removeLike() {
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.tintColor = .systemGray6
    }
    
    @objc private func addToFavorite() {
        viewModel.favoriteButtonPressed()
    }
    
    @objc private func shareData() {
        let activityViewController = UIActivityViewController(
            activityItems: [viewModel.photoLink],
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
    
    @objc private func originSizeButtonTapped() {
        let photoVC = PhotoViewController() // убрать
        photoVC.photo = photo
        show(photoVC, sender: nil)
    }
    
    //MARK: - Setup Constraints
    private func setupConstraints() {
        pexelsImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view).multipliedBy(0.65)
            make.left.right.equalToSuperview().inset(16)
        }
        
        horizontalStackView.snp.makeConstraints { make in
            make.top.equalTo(pexelsImage.snp.bottom).inset(-10)
            make.left.right.equalToSuperview().inset(16)
        }
        
        sendButton.snp.makeConstraints { make in
            make.width.equalTo(35)
        }
        
        likeButton.snp.makeConstraints { make in
            make.width.equalTo(35)
        }
        
        photogtapherNameLabel.snp.makeConstraints { make in
            make.top.equalTo(horizontalStackView.snp.bottom).inset(-10)
            make.left.right.equalToSuperview().inset(16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(photogtapherNameLabel.snp.bottom).inset(-2)
            make.left.right.equalToSuperview().inset(16)
        }
    }
}
