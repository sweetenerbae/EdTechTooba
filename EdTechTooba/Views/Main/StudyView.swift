//
//  StudyView.swift
//  EdTechTooba
//
//  Created by Diana Kuchaeva on 24.08.25.
//

import SwiftUI

struct StudyView: View {
    @StateObject var vm = StudyViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Поиск
                SearchRow(searchText: $vm.searchText)

                Divider().padding(.top, 4)

                // Рекомендации
                SectionCardGray(
                    title: "Рекомендации",
                    subtitle: "Рекомендуем подготовиться к контрольной работе пройдя тест",
                    trailingEmoji: "💡"
                ) {
                    // две карточки в ряд
                    HStack(spacing: 12) {
                        ForEach(vm.recs.prefix(2)) { r in
                            RecommendationTile(rec: r)
                        }
                    }

                    ExpandRow(
                        title: "Ещё \(vm.hiddenRecsCount) предметов",
                        subtitle: "Рекомендации по остальным предметам",
                        isExpanded: $vm.recsExpanded
                    )
                }

                // Подготовка к ЕГЭ
                SectionCardGray(
                    title: "Подготовка к ЕГЭ",
                    subtitle: "Школы подготовки к ЕГЭ по литературе",
                    trailingEmoji: "📚"
                ) {
                    HStack(spacing: 12) {
                        ForEach(vm.partners) { p in
                            PartnerTile(partner: p)
                        }
                    }
                }

                // Подкасты
                SectionCardGray(
                    title: "Подкасты",
                    subtitle: "Красивый голос и полезная информация",
                    trailingEmoji: "🎙"
                ) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(vm.podcasts) { p in
                                PodcastTile(podcast: p)
                            }
                        }
                        .padding(.horizontal, 2)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .background(Color("whiteAsset").ignoresSafeArea())
        .navigationTitle("Учёба")
    }
}

// MARK: - Reusable pieces

private struct SectionCardGray<Content: View>: View {
    let title: String
    let subtitle: String?
    let trailingEmoji: String?
    @ViewBuilder var content: Content

    init(title: String, subtitle: String? = nil, trailingEmoji: String? = nil, @ViewBuilder content: () -> Content) {
        self.title = title
        self.subtitle = subtitle
        self.trailingEmoji = trailingEmoji
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title).font(.system(size: 24, weight: .heavy))
                    if let subtitle {
                        Text(subtitle).foregroundStyle(.secondary)
                    }
                }
                Spacer()
                if let trailingEmoji { Text(trailingEmoji).font(.system(size: 40)) }
            }
            content
        }
        .padding(16)
        .background(Color.cardGray)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

private struct RecommendationTile: View {
    let rec: StudyViewModel.Recommendation
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Text(rec.emoji).font(.title3)
                Text(rec.title).font(.headline).lineLimit(1)
                Spacer()
            }
            Text(rec.subtitle).foregroundStyle(.secondary)
        }
        .padding(14)
        .frame(maxWidth: .infinity)
        .background(Color("whiteAsset"))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

private struct ExpandRow: View {
    let title: String
    let subtitle: String
    @Binding var isExpanded: Bool
    var body: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) { isExpanded.toggle() }
        } label: {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title).font(.headline)
                    Text(subtitle).foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
            .padding(14)
            .background(Color("whiteAsset"))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }
}

private struct PartnerTile: View {
    let partner: StudyViewModel.Partner
    var body: some View {
        VStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("whiteAsset"))
                .frame(height: 120)
                .overlay(
                    Group {
                        if UIImage(named: partner.logo) != nil {
                            Image(partner.logo).resizable().scaledToFit().padding(16)
                        } else {
                            Text(partner.title.prefix(2)).font(.title).bold()
                        }
                    }
                )
            Text(partner.title).font(.headline)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct PodcastTile: View {
    let podcast: StudyViewModel.Podcast
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("whiteAsset"))
                .frame(width: 200, height: 120)
                .overlay(
                    Group {
                        if UIImage(named: podcast.cover) != nil {
                            Image(podcast.cover).resizable().scaledToFill().clipShape(RoundedRectangle(cornerRadius: 16))
                        } else {
                            Rectangle().fill(Color.cardGray)
                        }
                    }
                )
            Text(podcast.title).font(.headline).lineLimit(2)
        }
        .frame(width: 200, alignment: .leading)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack { StudyView() }
}
