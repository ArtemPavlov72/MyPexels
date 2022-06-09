//
//  PhotoViewCell.swift
//  MyPexels
//
//  Created by Artem Pavlov on 26.05.2022.
//

import UIKit

class PhotoViewCell: UICollectionViewCell {
    
    //MARK: - Private Properties
    private var spinnerView: UIActivityIndicatorView?
    
    //MARK: - Public Properties
    let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 8
        return image
    }()
    
    //MARK: - Cell Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupItem()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public Methods
    func configureCell(with photo: Photo) {
        spinnerView = showSpinner(in: imageView)

        DispatchQueue.global().async {
            guard let imageData = ImageManager.shared.fetchImage(from: photo.src?.medium ?? "") else { return }
            
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: imageData)
                self.spinnerView?.stopAnimating()
            }
        }
    }
    
    //MARK: - Private Methods
    private func setupItem() {
        addSubview(imageView)
        imageView.constraintsFill(to: self)
    }
    
    private func showSpinner(in view: UIView) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(frame: view.bounds)
        activityIndicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        return activityIndicator
    }
}

//MARK: - Setup Constraints
extension UIView {
    func constraintsFill(to view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}
