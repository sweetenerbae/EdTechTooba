//
//  HomeworkDetailViewModel.swift
//  EdTechTooba
//
//  Created by Diana Kuchaeva on 25.08.25.
//

import SwiftUI

final class HomeworkDetailViewModel: ObservableObject {
    @Published var task: HomeworkTask

    init(task: HomeworkTask) {
        self.task = task
    }

    // заглушка загрузки/отправки результата
    func attachResult() {
        // TODO: upload to backend / Firebase Storage
        print("Attach result tapped")
    }
}
