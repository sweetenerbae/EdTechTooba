//
//  UsersViewModel.swift
//  EdTechTooba
//
//  Created by Diana Kuchaeva on 24.08.25.
//

import Foundation
import CoreData
import FirebaseFirestore

class UsersViewModel: NSObject, ObservableObject {
    @Published var users: [User] = []   // CoreData entity (NSManagedObject)
    @Published var isLoading = false
    
    private let fetchedResultsController: NSFetchedResultsController<User>
    private let context: NSManagedObjectContext
    
    override init() {
        self.context = CoreDataManager.shared.viewContext
        
        // Настройка NSFetchedResultsController
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "lastName", ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        super.init()
        
        fetchedResultsController.delegate = self
        fetchUsers()
    }
    
    func fetchUsers() {
        isLoading = true
        do {
            try fetchedResultsController.performFetch()
            users = fetchedResultsController.fetchedObjects ?? []
        } catch {
            print("Failed to fetch users: \(error)")
        }
        isLoading = false
    }
    
    func fetchUsersByRole(_ role: UserRole) {
        context.perform {
            let request: NSFetchRequest<User> = User.fetchRequest()
            request.predicate = NSPredicate(format: "role == %@", role.rawValue)
            request.sortDescriptors = [NSSortDescriptor(key: "lastName", ascending: true)]
            
            do {
                let fetched = try self.context.fetch(request)
                DispatchQueue.main.async {
                    self.users = fetched
                }
            } catch {
                print("Failed to fetch users by role: \(error)")
            }
        }
    }
    
    // MARK: - Firebase Operations
    func addUserToFirebase(_ userData: [String: Any]) {
        let db = Firestore.firestore()
        db.collection("users").addDocument(data: userData) { error in
            if let error = error {
                print("Error adding user to Firebase: \(error)")
            }
        }
    }
    
    func updateUserInFirebase(userId: String, data: [String: Any]) {
        let db = Firestore.firestore()
        db.collection("users").document(userId).updateData(data) { error in
            if let error = error {
                print("Error updating user in Firebase: \(error)")
            }
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension UsersViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.users = controller.fetchedObjects as? [User] ?? []
    }
}
