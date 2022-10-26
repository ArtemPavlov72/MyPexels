//
//  UserSettingsManager.swift
//  MyPexels
//
//  Created by Artem Pavlov on 14.08.2022.
//

import Foundation

class UserSettingManager {
    
    static let shared = UserSettingManager()
    
    private let defaults = UserDefaults.standard
    private let key = "user"
    private let userNotRegistered = User(
        name: "",
        isRegistered: false,
        pexelsImageCountPerRow: 2,
        favoriteImageCountPerRow: 2
    )
    
    private init() {}
    //сделать юзера опциональным
    private func fetchData() -> User {
        guard let data = defaults.data(forKey: key) else { return userNotRegistered  }
        guard let user = try? JSONDecoder().decode(User.self, from: data) else { return userNotRegistered }
        return user
    }
    
    func isRegistered() -> Bool {
        let user = fetchData()
        return user.isRegistered
    }
    
    func save(user: User) {
        guard let data = try? JSONEncoder().encode(user) else { return }
        defaults.set(data, forKey: key)
    }
    
    func changeCountOfPhotosPerRowFor(photoCollectionView: Bool, to count: Int) {
        var user = fetchData()
        if photoCollectionView {
            user.pexelsImageCountPerRow = count
        } else {
            user.favoriteImageCountPerRow = count
        }
        save(user: user)
    }
    
    func getCountOfPhotosPerRowFor(photoCollectionView: Bool) -> Int {
        let user = fetchData()
        return photoCollectionView
        ? user.pexelsImageCountPerRow
        : user.favoriteImageCountPerRow
    }
    
    func deleteUserData() {
        defaults.removeObject(forKey: key)
    }
}


