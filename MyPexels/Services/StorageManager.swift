//
//  StorageManager.swift
//  MyPexels
//
//  Created by Artem Pavlov on 21.06.2022.
//

import CoreData

class StorageManager {
    static let shared = StorageManager()
    
    // MARK: - Core Data stack
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Pexels")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private let viewContext: NSManagedObjectContext
    
    init() {
        viewContext = persistentContainer.viewContext
    }
    
    func fetchFavoritePhotos(completion: (Result<[PexelsPhoto], Error>) -> Void) {
        let fetchRequest = PexelsPhoto.fetchRequest()
        do {
            let photos = try viewContext.fetch(fetchRequest)
            completion(.success(photos))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func deleteFavoritePhotos() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = PexelsPhoto.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try viewContext.execute(deleteRequest)
        } catch let error {
            print(error)
        }
    }
    
    //MARK: - Private Methods of Photos
    func savePhoto(pexelsPhoto: Photo?) {
        let photo = PexelsPhoto(context: viewContext)
        photo.id = Int64(pexelsPhoto?.id ?? 0)
        photo.photographer = pexelsPhoto?.photographer
        photo.descriptionOfPhoto = pexelsPhoto?.alt
        photo.smallSizeOfPhoto = pexelsPhoto?.src?.small
        photo.mediumSizeOfPhoto = pexelsPhoto?.src?.medium
        photo.largeSizeOfPhoto = pexelsPhoto?.src?.large
        photo.originalSizeOfPhoto = pexelsPhoto?.src?.original
        photo.pexelsUrl = pexelsPhoto?.url
        photo.width = Int64(pexelsPhoto?.width ?? 0)
        photo.height = Int64(pexelsPhoto?.height ?? 0)
        saveContext()
    }
        
    func deletePhoto(photo: PexelsPhoto) {
        viewContext.delete(photo)
        saveContext()
    }
    
    func deletePhoto2(photo: Photo?) {
        var favoritePhotos: [PexelsPhoto] = []
        fetchFavoritePhotos { result in
            switch result {
            case .success(let photos):
                favoritePhotos = photos
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        guard let pexelsPhotoId = photo?.id else { return }
        for favorPhoto in favoritePhotos {
            if pexelsPhotoId == Int(favorPhoto.id) {
                deletePhoto(photo: favorPhoto)
            }
        }
    }
    
    // MARK: - Core Data Saving support
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
