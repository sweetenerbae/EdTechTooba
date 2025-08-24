//
//  User.swift
//  EdTechTooba
//
//  Created by Diana Kuchaeva on 24.08.25.
//
import Foundation

enum UserRole: String, Codable {
    case student
    case teacher
    case admin
}

struct UserEntity: Identifiable, Codable {
    let id: Int64
    let email: String
    let phoneNumber: String?
    let firstName: String
    let lastName: String
    let birthDate: Date
    let role: UserRole
    let userName: String
    var profileImageURL: String?
    let createdAt: Date
    let firebaseId: String?
}
