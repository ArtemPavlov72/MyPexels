//
//  User.swift
//  MyPexels
//
//  Created by Artem Pavlov on 13.08.2022.
//

import Foundation

struct User: Codable {
    let name: String
    let isRegistered: Bool
    var pexelsImageCountPerRow: Int
    var favoriteImageCountPerRow: Int
}
