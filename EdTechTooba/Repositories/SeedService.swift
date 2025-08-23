//
//  SeedService.swift
//  EdTechTooba
//
//  Created by Diana Kuchaeva on 23.08.25.
//
import Foundation
import CoreData

final class SeedService {
    private let container: NSPersistentContainer
    private let api = UserAPI.shared
    private let defaultsKey = "isSeeded"

    init(container: NSPersistentContainer) {
        self.container = container
    }
}
