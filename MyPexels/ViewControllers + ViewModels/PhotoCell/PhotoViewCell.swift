//
//  PhotoViewCell.swift
//  MyPexels
//
//  Created by Artem Pavlov on 26.05.2022.
//

import UIKit

class PhotoViewCell: UICollectionViewCell {
    
    //MARK: - Public Properties
    let imageView: PexelsImageView = {
        let image = PexelsImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 25
        return image
    }()
    
    var viewModel: PhotoViewCellViewModelProtocol! {
        didSet {
            guard let imageUrl = viewModel.pexelPhotoURL else { return }
            imageView.fetchImage(from: imageUrl)
        }
    }
    
    //MARK: - Cell Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupItem()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    //MARK: - Private Methods
    private func setupItem() {
        addSubview(imageView)
        imageView.constraintsFill(to: self)
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
