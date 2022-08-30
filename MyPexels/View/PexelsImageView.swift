//
//  PexelsImageView.swift
//  MyPexels
//
//  Created by Artem PAvlov on 10.06.2022.
//

import UIKit

class PexelsImageView: UIImageView {
    
    //MARK: - Private Properties
    private var spinnerView: UIActivityIndicatorView?
        
    //MARK: - Public Methods
    func fetchImage(from url: String) {
        guard let url = URL(string: url) else { return }
        
        if let catchedImage = getCatchedImage(from: url) {
            image = catchedImage
            return
        }
        
        spinnerView = showSpinner(in: self)
        
        ImageManager.shared.fetchImageWithCatch(from: url) { [weak self] data, response in
            guard let self = self else {return}
            self.image = UIImage(data: data)
            self.spinnerView?.stopAnimating()
            self.saveDataToCatch(with: data, and: response)
        }
    }
    
    //MARK: - Private Methods
    private func saveDataToCatch(with data: Data, and response: URLResponse) {
        guard let url = response.url else { return }
        let request = URLRequest(url: url)
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: request)
    }
    
    private func getCatchedImage(from url: URL) -> UIImage? {
        let request = URLRequest(url: url)
        
        if let cachedResponse = URLCache.shared.cachedResponse(for: request) {
            return UIImage(data: cachedResponse.data)
        }
        return nil
    }
}
