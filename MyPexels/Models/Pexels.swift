//
//  Pexels.swift
//  MyPexels
//
//  Created by Artem Pavlov on 25.05.2022.
//

enum Link: String {
case pexels = "https://api.pexels.com/v1/"
}

struct Pexels: Decodable {
    let page: Int
    let prevPage: String
    let nextPage: String
    let photos: [Photo]
    
    enum CodingKeys: String, CodingKey {
        case page
        case prevPage = "prev_page"
        case nextPage = "next_page"
        case photos
    }
}

struct Photo: Decodable {
    let id: Int
    let url: String
    let photographer: String
    let photographerUrl: String
    let photographerId: String
    let liked: Bool
    let alt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case url
        case photographer
        case photographerUrl = "photographer_url"
        case photographerId = "photographer_id"
        case liked
        case alt
    }
}
