//
//  ContentView.swift
//  EdTechTooba
//
//  Created by Diana Kuchaeva on 24.08.25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var usersVM = UsersViewModel()
    private let syncService = FirebaseSyncService()
    
    var body: some View {
        TabView {
            MainView()
                .tabItem { Label("Дневник", systemImage: "book.closed") }
            
            Text("Учёба")
                .tabItem { Label("Учёба", systemImage: "graduationcap") }
            
            ProfileView(usersVM: usersVM)
                .tabItem { Label("Профиль", systemImage: "person.crop.circle") }
        }
        .onAppear {
            // слушаем фаерстор и вливаем в CoreData
            syncService.syncUsers()
        }
    }
}
