//
//  User+CoreDataProperties.swift
//  EdTechTooba
//
//  Created by Diana Kuchaeva on 24.08.25.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "UserEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var email: String?
    @NSManaged public var userName: String?
    @NSManaged public var birthDate: Date?
    @NSManaged public var role: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var profilePageURL: String?
    @NSManaged public var firebaseId: String?

}

extension User : Identifiable {

}
