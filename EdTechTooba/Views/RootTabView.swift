//
//  RootTabView.swift
//  EdTechTooba
//
//  Created by Diana Kuchaeva on 23.08.25.
//
import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            MainView()
                .tabItem {
                    Label("Главная", systemImage: "house")
                }
            
            LessonsView()
                .tabItem {
                    Label("Занятия", systemImage: "calendar")
                }
            
            ProfileView()
                .tabItem {
                    Label("Профиль", systemImage: "person.circle")
                }
        }
    }
}
