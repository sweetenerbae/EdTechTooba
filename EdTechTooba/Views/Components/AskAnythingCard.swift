import SwiftUI

struct AskSection: View {
    @Binding var questionText: String
    var onTypeTap: () -> Void = {}
    var onSearchTap: () -> Void = {}
    @State private var openChat = false

    @State private var cardHeight: CGFloat = 50

    var body: some View {
        VStack(spacing: 0) {
            Divider()

            ZStack(alignment: .top) {
                Group {
                    if #available(iOS 17.0, *) {
                        UnevenRoundedRectangle(
                            cornerRadii: .init(
                                topLeading: 0,
                                bottomLeading: 32,
                                bottomTrailing: 32,
                                topTrailing: 0                            )
                        )
                        .fill(Color.cardGray)
                    } else {
                        BottomOnlyRounded(radius: 32)
                            .fill(Color.cardGray)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: max(cardHeight + 150, 16))                .ignoresSafeArea(edges: .horizontal)

                AskAnythingCard(
                    questionText: $questionText,
                    onTypeTap: onTypeTap,
                    onSearchTap: { openChat = true }
                )
                .padding(.horizontal, 16)
                .background(
                    GeometryReader { proxy in
                        Color.clear
                            .preference(key: AskCardHeightKey.self, value: proxy.size.height)
                    }
                )
            }
            NavigationLink("", isActive: $openChat) {
                ChatView()
            }
            .hidden()
        }
        .onPreferenceChange(AskCardHeightKey.self) { cardHeight = $0 }
    }
}

// PreferenceKey для измерения высоты
private struct AskCardHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) { value = nextValue() }
}

// Shape для iOS < 17: скругление ТОЛЬКО снизу
struct BottomOnlyRounded: Shape {
    var radius: CGFloat = 32
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let r = min(radius, rect.width/2, rect.height/2)

        p.move(to: CGPoint(x: rect.minX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - r))
        p.addArc(center: CGPoint(x: rect.maxX - r, y: rect.maxY - r),
                 radius: r, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)
        p.addLine(to: CGPoint(x: rect.minX + r, y: rect.maxY))
        p.addArc(center: CGPoint(x: rect.minX + r, y: rect.maxY - r),
                 radius: r, startAngle: .degrees(90), endAngle: .degrees(180), clockwise: false)
        p.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        return p
    }
}

struct AskAnythingCard: View {
    @Binding var questionText: String
    var onTypeTap: () -> Void = {}
    var onSearchTap: () -> Void = {}

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            TextField("Спросите что‑нибудь", text: $questionText, axis: .vertical)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.secondary)
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack {
                Button(action: onTypeTap) {
                    Label("Материал", systemImage: "book.closed")
                        .font(.system(size: 16, weight: .semibold))
                        .labelStyle(.titleAndIcon)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Capsule().fill(Color.cardGray))
                        .foregroundStyle(Color.labelBlack)
                }

                Spacer()

                Button(action: onSearchTap) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Color("whiteAsset"))
                        .frame(width: 36, height: 36)
                        .background(Circle().fill(Color.labelBlack))
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color("whiteAsset"))
        )
        .padding(.top, 12)
    }
}

#Preview {
    VStack(spacing: 0) {
        // имитация SearchRow
        HStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.cardGray)
                .frame(height: 44)
                .overlay(Text("SearchRow").foregroundStyle(.secondary))
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)

        AskSection(questionText: .constant(""))
        Spacer()
    }
    .background(Color.white)
}
