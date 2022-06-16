//
//  PhotoViewController.swift
//  MyPexels
//
//  Created by Artem Pavlov on 14.06.2022.
//

import UIKit

class PhotoViewController: UIViewController {
    
    //MARK: - Private Properties
    private lazy var pexelsPhoto: UIImageView = {
        let photo = UIImageView()
        photo.layer.cornerRadius = 15
        photo.contentMode = .scaleAspectFit
        photo.layer.masksToBounds = true
        return photo
    }()
    
    private lazy var imageWidthConstraint = pexelsPhoto.widthAnchor.constraint(equalToConstant: 0)
    private lazy var imageHeightConstraint = pexelsPhoto.heightAnchor.constraint(equalToConstant: 0)
    
    private var activityIndicator: UIActivityIndicatorView?
    
    //MARK: - Public Properties
    var photo: Photo?
    
    //MARK: - Life Cycles Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        getInfo()
        setupSubViews(pexelsPhoto)
        setupConstraints()
        setupNavigationBar()
    }
    
    //MARK: - Private Methods
    private func loadImage(from url: String) {
        activityIndicator = showSpinner(in: view)
        
        DispatchQueue.global().async {
            guard let imageData = ImageManager.shared.fetchImage(from: url) else { return }
            
            DispatchQueue.main.async {
                self.pexelsPhoto.image = UIImage(data: imageData)
                self.updateImageViewConstraint()
                self.activityIndicator?.stopAnimating()
            }
        }
    }
    
    private func getInfo() {
        loadImage(from: photo?.src?.original ?? "")
    }
    
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
    
    private func updateImageViewConstraint(_ size: CGSize? = nil) {
        guard let image = pexelsPhoto.image else {
            imageHeightConstraint.constant = 0
            imageWidthConstraint.constant = 0
            return
        }
        
        let size = view.bounds.size
        let offsetForPhotoHeight = view.bounds.height * 0.25
        let maxSize = CGSize(width: size.width - 32, height: size.height - offsetForPhotoHeight)
        let imageSize = findBestImageSize(img: image, maxSize: maxSize)
        
        imageHeightConstraint.constant = imageSize.height
        imageWidthConstraint.constant = imageSize.width
    }
    
    private func findBestImageSize(img: UIImage, maxSize: CGSize) -> CGSize {
        let width = img.width(height: maxSize.height)
        let checkedWidth = min(width, maxSize.width)
        let height = img.height(width: checkedWidth)
        return CGSize(width: checkedWidth, height: height)
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

