//
//  EdTechToobaApp.swift
//  EdTechTooba
//
//  Created by Diana Kuchaeva on 23.08.25.
//

import SwiftUI

@main
struct EdTechToobaApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
