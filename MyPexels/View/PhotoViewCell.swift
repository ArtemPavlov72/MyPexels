//
//  PhotoViewCell.swift
//  MyPexels
//
//  Created by Artem Pavlov on 26.05.2022.
//

import UIKit

class PhotoViewCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.backgroundColor = .green
        image.layer.cornerRadius = 8
        return image
    } ()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupItem()
    }
    
    func configureCell(with photo: Photo) {
        DispatchQueue.global().async {
            guard let imageData = ImageManager.shared.fetchImage(from: photo.src?.medium ?? "") else { return }
            
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: imageData)
            }
        }
    }
    
    private func setupItem() {
        addSubview(imageView)
        imageView.constraintsFill(to: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIView {
    func constraintsFill(to view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}
