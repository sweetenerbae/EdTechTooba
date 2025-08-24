//
//  StudyViewModel.swift
//  EdTechTooba
//
//  Created by Diana Kuchaeva on 24.08.25.
//
import SwiftUI

final class StudyViewModel: ObservableObject {
    struct Recommendation: Identifiable { let id = UUID(); let title: String; let subtitle: String; let emoji: String }
    struct Partner: Identifiable { let id = UUID(); let title: String; let logo: String }
    struct Podcast: Identifiable { let id = UUID(); let title: String; let cover: String }

    @Published var searchText: String = ""

    @Published var recs: [Recommendation] = [
        .init(title: "Тест по формам речи",   subtitle: "Тест (10 мин)", emoji: "🥷"),
        .init(title: "Тест по Дубровскому",   subtitle: "Тест (10 мин)", emoji: "🥷")
    ]
    @Published var hiddenRecsCount: Int = 5
    @Published var recsExpanded = false

    @Published var partners: [Partner] = [
        .init(title: "ЕгЭЛенд",  logo: "EgeLand"),   // добавь ассеты логотипов (или замени на системные)
        .init(title: "Соточка",  logo: "Sotochka"),
        .init(title: "ПрофиРу",  logo: "ProfiRu")
    ]

    @Published var podcasts: [Podcast] = [
        .init(title: "Поп‑литература",             cover: "pod1"),
        .init(title: "История литературы за…",     cover: "pod2"),
        .init(title: "Божественная комедия",       cover: "pod3")
    ]
}
