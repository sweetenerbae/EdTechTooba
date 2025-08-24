//
//  FactOfTheDay.swift
//  EdTechTooba
//
//  Created by Diana Kuchaeva on 24.08.25.
//
//import SwiftUI
//
//struct FactOfDayCard: View {
//    var body: some View {
//        HStack(spacing: 12) {
//            RoundedRectangle(cornerRadius: 12)
//                .fill(.ultraThinMaterial)
//                .frame(width: 56, height: 56)
//                .overlay(
//                    Image(systemName: "photo")
//                        .font(.title3)
//                        .foregroundStyle(.secondary)
//                )
//
//            VStack(alignment: .leading, spacing: 2) {
//                HStack(spacing: 6) {
//                    Image(systemName: "lightbulb.fill").foregroundStyle(Color.redAsset)
//                    Text("Факт дня").font(.subheadline.bold())
//                    Spacer()
//                }
//                Text("Пётр I никогда не ел шоколад")
//                    .font(.subheadline)
//                    .foregroundStyle(.secondary)
//            }
//        }
//        .padding(14)
//        .background(
//            ZStack {
//                Color.cardGray
//                Image("Curve")
//                    .offset(x: 90, y: 10)
//            }
//        )
//        .clipShape(RoundedRectangle(cornerRadius: 16))
//    }
//}
//
//#Preview {
//    FactOfDayCard()
//}
//import SwiftUI
//
//struct FactOfTheDayCard: View {
//    var body: some View {
//        HStack(alignment: .top, spacing: 16) {
//            Image("FactCard")
//                .resizable()
//                .scaledToFill()
//                .frame(width: 64, height: 85)
//                .clipShape(RoundedRectangle(cornerRadius: 9))
//                .overlay(
//                    RoundedRectangle(cornerRadius: 9)
//                        .stroke(Color.primaryRed, lineWidth: 6)
//                )
//                .overlay(
//                    RoundedRectangle(cornerRadius: 9)
//                        .stroke(Color("whiteAsset"), lineWidth: 2)
//                )
//
//            VStack(alignment: .leading, spacing: 5) {
//                Image(systemName: "lightbulb.fill")
//                    .foregroundColor(.primaryRed)
//                    .font(.system(size: 20))
//
//                VStack(alignment: .leading, spacing: 4) {
//                    Text("Факт дня")
//                        .font(.system(size: 14, weight: .semibold))
//                    Text("Пётр I никогда не ел шоколад")
//                        .font(.system(size: 12))
//                        .fixedSize(horizontal: false, vertical: true)
//                }
//            }
//        }
//        .padding(14)
//        .frame(maxWidth: .infinity)
//        .background(
//              ZStack {
//                  Color.cardGray
//                  Image("Curve")
//                      .offset(x: 90, y: 10)
//              }
//          )
//          .clipShape(RoundedRectangle(cornerRadius: 16))
//          .cornerRadius(16)
//        .padding(.horizontal, 20)
//    }
//}
//
//#Preview {
//    FactOfTheDayCard()
//}
import SwiftUI

struct FactOfTheDayCard: View {
    var body: some View {
        HStack(alignment: .top, spacing: 12) {        // расстояние между картинкой и текстовым блоком = 12
            Image("FactCard")
                .resizable()
                .scaledToFill()
                .frame(width: 64, height: 85)
                .clipShape(RoundedRectangle(cornerRadius: 9))
                .overlay(
                    RoundedRectangle(cornerRadius: 9)
                        .stroke(Color.primaryRed, lineWidth: 6)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 9)
                        .stroke(Color("whiteAsset"), lineWidth: 2)
                )

            VStack(alignment: .leading, spacing: 5) {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.primaryRed)
                    .font(.system(size: 20))

                VStack(alignment: .leading, spacing: 4) {
                    Text("Факт дня")
                        .font(.system(size: 14, weight: .semibold))
                    Text("Пётр I никогда не ел шоколад")
                        .font(.system(size: 12))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading) // растягиваем блок факта
        }
        .padding(.vertical, 20)
        .padding(.leading, 16)   // отступ слева у картинки
        .padding(.trailing, 16)  // отступ справа у блока факта
        .cornerRadius(16)
        .padding(.horizontal, 20)
        .background(
              ZStack {
                  Color.cardGray
                  Image("Curve")
                      .offset(x: 90, y: 10)
              }
          )
          .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    FactOfTheDayCard()
}
