//
//  FirebaseSyncService.swift
//  EdTechTooba
//
//  Created by Diana Kuchaeva on 24.08.25.
//

import FirebaseFirestore
import CoreData

class FirebaseSyncService {
    private let db = Firestore.firestore()
    private let context = CoreDataManager.shared.viewContext
        
    func syncUsers() {
        db.collection("users").addSnapshotListener { [weak self] snapshot, error in
            guard let documents = snapshot?.documents else {
                print("No users found")
                return
            }
            
            self?.processUsers(documents)
        }
    }
    
    private func processUsers(_ documents: [QueryDocumentSnapshot]) {
        context.perform { [weak self] in
            guard let self = self else { return }
            
            for document in documents {
                let data = document.data()
                let firebaseId = document.documentID
                
                let user: User
                if let existingUser = self.fetchUser(by: firebaseId) {
                    user = existingUser
                } else {
                    user = User(context: self.context)
                    user.firebaseId = firebaseId
                }
                
                self.updateUser(user, with: data)
            }
            
            do {
                try self.context.save()
            } catch {
                print("Failed to save users: \(error)")
            }
        }
    }
    
    private func fetchUser(by firebaseId: String) -> User? {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "firebaseId == %@", firebaseId)
        request.fetchLimit = 1
        
        do {
            return try context.fetch(request).first
        } catch {
            print("Fetch user error: \(error)")
            return nil
        }
    }
    private func updateUser(_ user: User, with data: [String: Any]) {
        user.id = data["id"] as? Int64 ?? 0
        user.email = data["email"] as? String
        user.phoneNumber = data["phoneNumber"] as? String
        user.firstName = data["firstName"] as? String
        user.lastName = data["lastName"] as? String
        user.userName = data["userName"] as? String
        user.role = data["role"] as? String ?? "student"
        user.profilePageURL = data["profilePageURL"] as? String
        
        if let birthDateTimestamp = data["birthDate"] as? Timestamp {
            user.birthDate = birthDateTimestamp.dateValue()
        }
        if let createdAtTimestamp = data["createdAt"] as? Timestamp {
            user.createdAt = createdAtTimestamp.dateValue()
        }
    }
    
    // в будущем доделатб методы для других сущностей
}
