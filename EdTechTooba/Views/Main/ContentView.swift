//
//  ContentView.swift
//  EdTechTooba
//
//  Created by Diana Kuchaeva on 24.08.25.
//
import SwiftUI

struct ContentView: View {
    @StateObject private var usersVM = UsersViewModel()
    @StateObject private var vm = StudyViewModel()

    private let syncService = FirebaseSyncService()
    
    var body: some View {
        TabView {
            MainView(
                onScheduleTap: {},
                onAddNoteTap: {}
            )
            .tabItem { Label("Дневник", systemImage: "book.closed") }
            
            StudyView(vm: vm)
                .tabItem { Label("Учёба", systemImage: "graduationcap") }
            
            ProfileView(usersVM: usersVM)
                .tabItem { Label("Профиль", systemImage: "person.crop.circle") }
        }
        .onAppear {
            syncService.syncUsers()
        }
    }
}
