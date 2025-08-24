//
//  Absence.swift
//  EdTechTooba
//
//  Created by Diana Kuchaeva on 24.08.25.
//

import Foundation

struct SubjectAbsence: Identifiable {
    let id = UUID()
    let emoji: String        // иконка / эмоджи
    let title: String        // название предмета
    let totalMissed: Int     // количество пропущенных уроков
    let periods: [AbsencePeriod]
}

/// Отчёт по конкретному аттестационному периоду
struct AbsencePeriod: Identifiable {
    let id = UUID()
    let range: String        // "25 сентября – 25 декабря"
    let periodName: String   // "Аттестационный период 1"
    let score: Double        // средняя оценка
    let missedMarks: [Bool]  // true = присутствие, false = пропуск
}
