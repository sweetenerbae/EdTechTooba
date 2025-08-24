//
//  GradesViewModel.swift
//  EdTechTooba
//
//  Created by Diana Kuchaeva on 24.08.25.
//
import SwiftUI

struct SubjectGrade: Identifiable, Hashable {
    let id = UUID()
    let emoji: String
    let title: String
    let subtitle: String
    let average: Double
}

final class GradesViewModel: ObservableObject {
    enum Tab: String, CaseIterable {
        case grades = "Оценки"
        case skips  = "Пропуски"
    }

    @Published var selectedTab: Tab = .grades
    @Published var searchText: String = ""
    @Published var items: [SubjectGrade] = []

    init() {
        loadMock() // пока мок потом загрузкa из бэка
    }

    func loadMock() {
        items = [
            .init(emoji: "🪆", title: "Литература",    subtitle: "Среднегодовая оценка", average: 4.4),
            .init(emoji: "🇷🇺", title: "Русский язык", subtitle: "Среднегодовая оценка", average: 5.0),
            .init(emoji: "🧮", title: "Математика",    subtitle: "Среднегодовая оценка", average: 4.8),
            .init(emoji: "⚽️", title: "Физкультура",  subtitle: "Среднегодовая оценка", average: 4.1),
            .init(emoji: "🧓", title: "История",       subtitle: "Среднегодовая оценка", average: 4.2),
            .init(emoji: "🌍", title: "География",     subtitle: "Среднегодовая оценка", average: 4.7)
        ]
    }

    var filteredItems: [SubjectGrade] {
        let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else { return items }
        return items.filter { $0.title.localizedCaseInsensitiveContains(q) }
    }
}

final class AbsencesViewModel: ObservableObject {
    @Published var items: [SubjectAbsence] = []

    init() {
        loadMock()
    }

    func loadMock() {
        items = [
            SubjectAbsence(
                emoji: "🪆",
                title: "Литература",
                totalMissed: 3,
                periods: [
                    AbsencePeriod(
                        range: "25 сентября – 25 декабря",
                        periodName: "Аттестационный период 1",
                        score: 4.4,
                        missedMarks: [false,false,true,true,true,false,true,true,false] // пример
                    )
                ]
            ),
            SubjectAbsence(emoji: "🇷🇺", title: "Русский язык", totalMissed: 1, periods: []),
            SubjectAbsence(emoji: "🧮", title: "Математика", totalMissed: 0, periods: []),
            SubjectAbsence(emoji: "⚽️", title: "Физкультура", totalMissed: 0, periods: []),
            SubjectAbsence(emoji: "🧓", title: "История", totalMissed: 0, periods: [])
        ]
    }
}
