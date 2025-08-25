import SwiftUI

struct FactOfTheDayCard: View {
    var body: some View {
        NavigationLink {
            FactDetailView(
                imageName: "FactCard",
                title: "Факт дня – Операции во время эпохи Возрождения",
                subtitle: "Врачи эпохи Возрождения начали делать пластические операции"
            )
        } label: {
            HStack(alignment: .top, spacing: 12) {
                Image("FactCard")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 64, height: 85)
                    .clipShape(RoundedRectangle(cornerRadius: 9))
                    .overlay(RoundedRectangle(cornerRadius: 9).stroke(Color.primaryRed, lineWidth: 6))
                    .overlay(RoundedRectangle(cornerRadius: 9).stroke(Color("whiteAsset"), lineWidth: 2))

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
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 16)
            .background(
                ZStack {
                    Color.cardGray
                    Image("Curve")
                        .offset(x: 90, y: 10)
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        FactOfTheDayCard()
            .padding(.top, 24)
    }
}

import SwiftUI

struct FactDetailView: View {
    let imageName: String
    let title: String
    let subtitle: String
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            LinearGradient(
                colors: [.clear, .black.opacity(0.65)],
                startPoint: .center,
                endPoint: .bottom
            )
            .blur(radius: 6)
            .ignoresSafeArea()
        }
        .navigationTitle("Факт дня")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Image(systemName: "bell.fill")
                    .foregroundStyle(.white)
            }
        }
        .safeAreaInset(edge: .bottom) {
            VStack(alignment: .leading, spacing: 12) {
                Text(title)
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)

                Text(subtitle)
                    .foregroundStyle(.white.opacity(0.9))
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)

                Button {
                    dismiss()
                } label: {
                    Text("Буду знать")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .foregroundStyle(Color.primaryRed)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.top, 8)
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 60)
            .background(
                LinearGradient(
                    colors: [.black.opacity(0.25), .black.opacity(0.6)],
                    startPoint: .top, endPoint: .bottom
                )
                .blur(radius: 6)
                .ignoresSafeArea(edges: .bottom)
            )
        }
    }
}

#Preview {
    NavigationStack {
        FactDetailView(
            imageName: "FactCard",
            title: "Врачи эпохи Возрождения начали делать пластические операции",
            subtitle: "Первые реконструктивные методики появились в Европе в XV–XVI веках."
        )
    }
}
