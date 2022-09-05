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
    
    private lazy var imageWidthConstraint = pexelsPhoto.widthAnchor.constraint(equalToConstant: 0)
    private lazy var imageHeightConstraint = pexelsPhoto.heightAnchor.constraint(equalToConstant: 0)
    
    private var imageIsLoaded = false
    
    //MARK: - Public Properties
    var photo: Photo?
    
    //MARK: - Life Cycles Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar(imageIsLoaded)
        updateImageViewConstraint(size: photo?.width, x: photo?.height)
        loadImage(from: photo?.src?.original ?? "")
        setupSubViews(pexelsPhoto)
        setupConstraints()
    }
    
    //MARK: - Private Methods
    private func loadImage(from url: String) {
        pexelsPhoto.fetchImage(from: url) {
            self.imageIsLoaded.toggle()
            self.navigationItem.rightBarButtonItem?.isEnabled = self.imageIsLoaded
        }
    }
    
    private func setupSubViews(_ subViews: UIView...) {
        subViews.forEach { subview in
            view.addSubview(subview)
        }
    }
    
    private func setupNavigationBar(_ imageIsLoaded: Bool) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(saveAction)
        )
        navigationItem.rightBarButtonItem?.isEnabled = imageIsLoaded
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
        pexelsPhoto.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pexelsPhoto.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pexelsPhoto.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageWidthConstraint,
            imageHeightConstraint
        ])
    }
    
    private func updateImageViewConstraint(size width: Int?,x height: Int?) {
        let width = CGFloat(width ?? 0)
        let height = CGFloat(height ?? 0)
        
        let size = view.bounds.size
        let offsetForPhotoHeight = view.bounds.height * 0.25
        let maxSize = CGSize(width: size.width - 32, height: size.height - offsetForPhotoHeight)
        let imageSize = findBestImageSize(width: width, height: height, maxSize: maxSize)
        
        imageHeightConstraint.constant = imageSize.height
        imageWidthConstraint.constant = imageSize.width
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
