//
//  HomeworkTask.swift
//  EdTechTooba
//
//  Created by Diana Kuchaeva on 25.08.25.
//

import Foundation

struct HomeworkTask: Identifiable {
    let id = UUID()
    let subject: String            // «Физика»
    let coverImageName: String?    // имя ассета (например, "PhysicsCover")
    let ribbonText: String         // «Оценка 5 за расписанное решение»
    let title: String              // «Кинематика»
    let body: String               // длинный текст задачи
    let solvedCount: Int           // 12
    let solvedTotal: Int           // 16
    let correctCount: Int          // 10
    let correctTotal: Int          // 12
}
