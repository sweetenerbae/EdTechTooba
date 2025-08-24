//
//  SearchRow.swift
//  EdTechTooba
//
//  Created by Diana Kuchaeva on 24.08.25.
//

import SwiftUI

struct SearchRow: View {
    @Binding var searchText: String
    var body: some View {
        HStack(spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                TextField("Поиск", text: $searchText)
                    .foregroundStyle(Color.backgroundGray)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 12)
            .background(Color.cardGray)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(RoundedRectangle(cornerRadius: 8))

            Button {
                // bookmarks / избранное
            } label: {
                Image(systemName: "bookmark")
                    .frame(width: 44, height: 44)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(RoundedRectangle(cornerRadius: 14))
            }
        }
    }
}
