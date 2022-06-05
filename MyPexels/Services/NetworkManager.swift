//
//  NetworkManager.swift
//  MyPexels
//
//  Created by Artem Pavlov on 28.05.2022.
// "https://api.pexels.com/v1/curated?per_page=20&page=1"

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func fetchData(from url: String, withNumberOfPhotosOnPage: Int, numberOfPage: Int, completion: @escaping(Result<Pexels, NetworkError>) -> Void) {
        guard let url = URL(string: "\(url)?per_page=\(withNumberOfPhotosOnPage)&page=\(numberOfPage)") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue(ApiKey.pexelsKey.rawValue, forHTTPHeaderField: ApiKey.keyForHeader.rawValue)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let pexelsData = try JSONDecoder().decode(Pexels.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(pexelsData))
                }
            } catch {
                completion(.failure(.decodingError))
            }
        } .resume()
    }
}

class ImageManager {
    static let shared = ImageManager()
    private init() {}
    
    func fetchImage(from url: String) -> Data? {
        guard let imageUrl = URL(string: url) else { return nil }
        return try? Data(contentsOf: imageUrl)
    }
}
