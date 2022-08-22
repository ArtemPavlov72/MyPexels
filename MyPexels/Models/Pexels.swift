//
//  Pexels.swift
//  MyPexels
//
//  Created by Artem Pavlov on 25.05.2022.
//
import Foundation

struct Pexels: Codable {
    let page: Int?
    let perPage: Int?
    let totalResults: Int?
    let prevPage: String?
    let nextPage: String?
    let photos: [Photo]?
    
    enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case totalResults = "total_results"
        case prevPage = "prev_page"
        case nextPage = "next_page"
        case photos
    }
}

struct Photo: Codable {
    let id: Int?
    let url: String?
    let photographer: String?
    let src: Src?
    let alt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case url
        case photographer
        case src
        case alt
    }
}

struct Src: Codable {
    let original: String?
    let large: String?
    let medium: String?
    let small: String?
    
    enum CodingKeys: String, CodingKey {
        case original
        case large
        case medium
        case small
    }
}

enum SizeOfPhoto {
    case small, medium, large
}

enum Link: String {
    case pexelsBaseURL = "https://api.pexels.com/v1"
    case pexelsCuratedPhotos = "https://api.pexels.com/v1/curated"
    case pexelsPhotoById = "https://api.pexels.com/v1/photos/"
    case pexelsSearchingPhotos = "https://api.pexels.com/v1/search"
}

enum ApiKey: String {
    case pexelsKey = "563492ad6f91700001000001253d7c5e346445889db51ee382e45bd2"
    case keyForHeader = "Authorization"
}
