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
        photo.backgroundColor = .black
        return photo
    }()
    
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
        activityIndicator = showSpinner(in: pexelsImage)
        
        DispatchQueue.global().async {
            guard let imageData = ImageManager.shared.fetchImage(from: url) else { return }
            
            DispatchQueue.main.async {
                self.pexelsImage.image = UIImage(data: imageData)
                self.activityIndicator?.stopAnimating()
            }
        }
    }
    
    private func showSpinner(in view: UIView) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(frame: view.bounds)
        activityIndicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        return activityIndicator
    }
    
    private func setupConstraints() {
        pexelsImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pexelsImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            pexelsImage.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
        ])
    }
}
