//
//  RoleCard.swift
//  EdTechTooba
//
//  Created by Diana Kuchaeva on 23.08.25.
//

import SwiftUI

struct RoleCard: View {
    let emoji: String
    let title: String
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Text(emoji)
                .font(.system(size: 59))
                .frame(width: 59, height: 71)
            Text(title)
                .font(.headline)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(hex: "#FAFAFA"))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isSelected ? Color.red : Color(hex: "#F5F5F5"), lineWidth: 2)
                .animation(.easeInOut, value: isSelected)
            
        )
    }
}

