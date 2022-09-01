//
//  PexelsImageView.swift
//  MyPexels
//
//  Created by Artem PAvlov on 10.06.2022.
//

import SDWebImage

class PexelsImageView: UIImageView {
        
    //MARK: - Public Methods
    func fetchImage(from url: String, completion: @escaping(()->Void)) {
        guard let url = URL(string: url) else { return }
        sd_imageIndicator = SDWebImageActivityIndicator.gray
        sd_setImage(with: url) { _, _, _, _ in
            completion()
        }
    }
}
