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
            HStack {
                Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
                TextField("Поиск", text: $searchText)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 12)
            .background(Color.cardGray)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            Button { } label: {
                Image(systemName: "bell.fill")
                    .frame(width: 44, height: 44)
                    .foregroundStyle(Color.labelBlack)
                    .background(Color.cardGray)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(.horizontal, 16)
    }
}
