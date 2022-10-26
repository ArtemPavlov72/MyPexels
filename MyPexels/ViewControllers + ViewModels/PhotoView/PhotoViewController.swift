//
//  PhotoViewController.swift
//  MyPexels
//
//  Created by Artem Pavlov on 14.06.2022.
//

import UIKit

class PhotoViewController: UIViewController {
    
    //MARK: - Private Properties
    private lazy var pexelsPhoto: PexelsImageView = {
        let photo = PexelsImageView()
        photo.layer.cornerRadius = 15
        photo.contentMode = .scaleAspectFit
        photo.layer.masksToBounds = true
        return photo
    }()
    
    private lazy var imageWidthConstraint: CGFloat = 0
    private lazy var imageHeightConstraint: CGFloat = 0
    
    //MARK: - Public Properties    
    var viewModel: PhotoViewModelProtocol! {
        didSet {
            guard let imageUrl = viewModel.pexelsImageURL else { return }
            pexelsPhoto.fetchImage(from: imageUrl) {
                self.viewModel.loadingImage()
                self.navigationItem.rightBarButtonItem?.isEnabled = self.viewModel.imageIsLoaded
            }
        }
    }
    
    //MARK: - Life Cycles Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        updateImageViewConstraint(size: viewModel.photoWidth, x: viewModel.photoHeight)
        setupSubViews(pexelsPhoto)
        setupConstraints()
    }
    
    //MARK: - Private Methods
    private func setupSubViews(_ subViews: UIView...) {
        subViews.forEach { subview in
            view.addSubview(subview)
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(saveAction)
        )
        navigationItem.rightBarButtonItem?.isEnabled = viewModel.imageIsLoaded
    }
    
    @objc private func saveAction() {
        guard let image = pexelsPhoto.image else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageWillSave(_:_:_:)), nil)
    }
    
    @objc func imageWillSave(_ image: UIImage, _ error: Error?, _ contextInfo: UnsafeRawPointer) {
        if let error = error {
            showAlert(with: "Save error", and: error.localizedDescription)
        } else {
            showAlert(with: "Saved!", and: "Image has been saved to your photo library.")
        }
    }
    
    //MARK: - Setup Constraints
    private func setupConstraints() {
        pexelsPhoto.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(imageWidthConstraint)
            make.height.equalTo(imageHeightConstraint)
        }
    }
    
    private func updateImageViewConstraint(size width: Int?,x height: Int?) {
        let width = CGFloat(width ?? 0)
        let height = CGFloat(height ?? 0)
        
        let size = view.bounds.size
        let offsetForPhotoHeight = view.bounds.height * 0.25
        let maxSize = CGSize(width: size.width - 32, height: size.height - offsetForPhotoHeight)
        let imageSize = findBestImageSize(width: width, height: height, maxSize: maxSize)
        
        imageWidthConstraint = imageSize.width
        imageHeightConstraint = imageSize.height
    }
    
    private func findBestImageSize(width: CGFloat, height: CGFloat, maxSize: CGSize) -> CGSize {
        let cropRatio: CGFloat = width / height
        let widthCroped = maxSize.height / cropRatio
        let updatedWidth = min(widthCroped, maxSize.width)
        let updatedCroped = updatedWidth / cropRatio
        return CGSize(width: updatedWidth, height: updatedCroped)
    }
}

//MARK: - Alert Controller
extension PhotoViewController {
    func showAlert(with title: String, and massage: String) {
        let alert = UIAlertController(title: title, message: massage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
