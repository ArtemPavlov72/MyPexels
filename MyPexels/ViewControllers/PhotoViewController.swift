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
    private var imageIsLoaded = false
    
    //MARK: - Public Properties
    var photo: String?
    
    //MARK: - Life Cycles Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar(imageIsLoaded)
        getInfo()
        setupSubViews(pexelsPhoto)
        setupConstraints()
    }
    
    //MARK: - Private Methods
    private func loadImage(from url: String) {
        activityIndicator = showSpinner(in: view)
        
        ImageManager.shared.fetchImage(from: url, completion: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let photoData):
                self.pexelsPhoto.image = UIImage(data: photoData)
                self.updateImageViewConstraint()
                self.activityIndicator?.stopAnimating()
                self.imageIsLoaded.toggle()
                self.navigationItem.rightBarButtonItem?.isEnabled = self.imageIsLoaded
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    private func getInfo() {
        loadImage(from: photo ?? "")
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

