//
//  AskAnythingCard.swift
//  EdTechTooba
//
//  Created by Diana Kuchaeva on 24.08.25.
//

import SwiftUI

struct AskAnythingCard: View {
    @Binding var questionText: String
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Спросите что-нибудь")
                    .foregroundStyle(.secondary)
                Spacer()
                Button {
                } label: {
                    Label("Материал", systemImage: "doc.text")
                        .labelStyle(.titleAndIcon)
                        .font(.footnote.weight(.semibold))
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .background(Color.backgroundGray)
                        .clipShape(Capsule())
                }
            }

            HStack(spacing: 8) {
                TextField("", text: $questionText, prompt: Text("Спросите что-нибудь"))
                    .textInputAutocapitalization(.sentences)
                Button {
                } label: {
                    Image(systemName: "magnifyingglass")
                        .font(.headline)
                        .frame(width: 44, height: 44)
                        .background(Color.labelBlack)
                        .foregroundStyle(Color("whiteAsset"))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
        .padding(16)
        .background(Color("whiteAsset"))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
