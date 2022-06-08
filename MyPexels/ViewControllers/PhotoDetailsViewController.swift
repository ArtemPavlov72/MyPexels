//
//  PhotoDetailsViewController.swift
//  MyPexels
//
//  Created by admin  on 07.06.2022.
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
    
    //MARK: - Public Properties
    var photo: Photo?
    
    //MARK: - Life Cycles Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        DispatchQueue.global().async {
            guard let imageData = ImageManager.shared.fetchImage(from: self.photo?.src?.large ?? "") else { return }
            
            DispatchQueue.main.async {
                self.pexelsImage.image = UIImage(data: imageData)
            }
        }
        view.addSubview(pexelsImage)
        setupConstraints()
    }
    
    //MARK: - Private Methods
    private func setupConstraints() {
        pexelsImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pexelsImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            pexelsImage.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
}
