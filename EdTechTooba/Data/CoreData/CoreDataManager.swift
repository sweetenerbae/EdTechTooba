//
//  CoreDataManager.swift
//  EdTechTooba
//
//  Created by Diana Kuchaeva on 24.08.25.
//

import CoreData
import FirebaseFirestore

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "EdTechToobaModel")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func saveContext() {
        let context = viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Core Data save error: \(error)")
            }
        }
    }
}
