//
//  FavoriteManager.swift
//  TongueLaw
//
//  Created by 김수경 on 10/8/24.
//

import CoreData

struct FavoriteManager {
    
    private let coreDataManager = CoreDataManager.shared
    
    func createFavoriteObject(_ content: FavoriteContent) -> Bool {
        let entity = FavoriteEntity.entity()
        let context = coreDataManager.context
        if let _ = fetchFavoriteObject(withId: content.id) {
            return true
        }
        
        let favoriteCoreData = FavoriteEntity(entity: entity, insertInto: context)
        
        favoriteCoreData.setValue(content.id, forKey: "id")
        favoriteCoreData.setValue(content.title, forKey: "title")
        favoriteCoreData.setValue(content.image, forKey: "image")
        
        return coreDataManager.saveContext()
    }
    
    func fetchAllFavoriteObject() -> [FavoriteContent]? {
        let request = FavoriteEntity.fetchRequest()
        
        do {
            let favorites = try coreDataManager.context.fetch(request)
            var contents = [FavoriteContent]()
            
            for favorite in favorites {
                contents.append(FavoriteContent(entity: favorite))
            }
            
            return contents
        } catch {
            print(error)
            
            return nil
        }
    }
    
    func fetchFavoriteObject(withId id: String) -> FavoriteContent? {
        let request = FavoriteEntity.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", id)
        
        request.predicate = predicate
        
        do {
            let result = try coreDataManager.context.fetch(request)
            if result.isEmpty {
                return nil
            }
            
            return FavoriteContent(entity: result[0])
        } catch {
            print(error)
            return nil
        }
    }
    
    func deleteFavoriteObject(withId id: String) -> Bool {
        let context = coreDataManager.context
        let request = FavoriteEntity.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", id)
        
        request.predicate = predicate
        
        do {
            let fetchedObject = try coreDataManager.context.fetch(request)
            
            if let objectToDelete = fetchedObject.first {
                context.delete(objectToDelete)
            } else {
                print("no object found with id \(id)")
            
                return false
            }
            
            return coreDataManager.saveContext()
        } catch {
            print("failed to delete object: \(error.localizedDescription)")
            
            return false
        }
    }
    
}
