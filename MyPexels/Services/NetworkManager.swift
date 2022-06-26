//
//  NetworkManager.swift
//  MyPexels
//
//  Created by Artem Pavlov on 28.05.2022.
// 

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
    
    func fetchData(from url: String, usingId id: Int, completion: @escaping(Result<Photo, NetworkError>) -> Void) {
        guard let url = URL(string: "\(url)\(id)") else {
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
                let photo = try JSONDecoder().decode(Photo.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(photo))
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
    
    func fetchImageWithCatch(from url: URL, completion: @escaping(Data, URLResponse) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let response = response else {
                print(NetworkError.noData)
                return
            }
            guard url == response.url else { return }
            DispatchQueue.main.async {
                completion(data, response)
            }
        } .resume()
    }
}
