//
//  CoreDataManager.swift
//  TongueLaw
//
//  Created by 김수경 on 10/9/24.
//

import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FavoriteDataModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unresolved error \(error.localizedDescription)")
            }
        }
        return container
    }()
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private init() {}
    
    func saveContext(backgroundContext: NSManagedObjectContext? = nil) -> Bool {
        let context = backgroundContext ?? context
        
        if context.hasChanges == false { return true }
        
        do {
            try context.save()
            
            return true
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
            
            return false
        }
    }

}
