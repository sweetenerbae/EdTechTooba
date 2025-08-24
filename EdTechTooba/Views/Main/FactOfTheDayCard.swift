//
//  FactOfTheDay.swift
//  EdTechTooba
//
//  Created by Diana Kuchaeva on 24.08.25.
//
import SwiftUI

struct FactOfDayCard: View {
    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .frame(width: 56, height: 56)
                .overlay(
                    Image(systemName: "photo")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                )

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Image(systemName: "lightbulb.fill").foregroundStyle(Color.redAsset)
                    Text("Факт дня").font(.subheadline.bold())
                    Spacer()
                }
                Text("Пётр I никогда не ел шоколад")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(14)
        .background(
            ZStack {
                Color("whiteAsset")
                Image(systemName: "scribble.variable")
                    .font(.system(size: 120))
                    .foregroundStyle(Color.black.opacity(0.03))
                    .offset(x: 90, y: 10)
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    FactOfDayCard()
}
