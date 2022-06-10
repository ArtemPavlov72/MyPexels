//
//  PhotoDetailsViewController.swift
//  MyPexels
//
//  Created by Artem Pavlov on 07.06.2022.
//

import UIKit

class PhotoDetailsViewController: UIViewController {
    
    //MARK: - Private Properties
    private lazy var pexelsImage: UIImageView = {
        let photo = UIImageView()
        photo.layer.cornerRadius = 3
        photo.contentMode = .scaleAspectFit
        photo.layer.cornerRadius = 15
        photo.layer.masksToBounds = true
        return photo
    }()
    
    private lazy var imageWidthConstraint = pexelsImage.widthAnchor.constraint(equalToConstant: 0)
    private lazy var imageHeightConstraint = pexelsImage.heightAnchor.constraint(equalToConstant: 0)
    
    private var activityIndicator: UIActivityIndicatorView?
    
    //MARK: - Public Properties
    var photo: Photo?
    
    //MARK: - Life Cycles Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        loadImage(from: photo?.src?.large ?? "")
        view.addSubview(pexelsImage)
        setupConstraints()
    }
    
    //MARK: - Private Methods
    private func loadImage(from url: String) {
        activityIndicator = showSpinner(in: view)
        
        DispatchQueue.global().async {
            guard let imageData = ImageManager.shared.fetchImage(from: url) else { return }
            
            DispatchQueue.main.async {
                self.pexelsImage.image = UIImage(data: imageData)
                self.updateImageViewConstraint()
                self.activityIndicator?.stopAnimating()
            }
        }
    }
    
    private func setupConstraints() {
        pexelsImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pexelsImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pexelsImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageWidthConstraint,
            imageHeightConstraint
        ])
    }
    
    private func updateImageViewConstraint(_ size: CGSize? = nil) {
        guard let image = pexelsImage.image else {
            imageHeightConstraint.constant = 0
            imageWidthConstraint.constant = 0
            return
        }
        
        let size = size ?? view.bounds.size
        let maxSize = CGSize(width: size.width - 32, height: size.height - 150)
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


