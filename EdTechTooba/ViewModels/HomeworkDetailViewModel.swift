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

// MARK: - Detail View

struct HomeworkDetailView: View {
    @StateObject var vm: HomeworkDetailViewModel

    init(task: HomeworkTask) {
        _vm = StateObject(wrappedValue: HomeworkDetailViewModel(task: task))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // Cover
                Group {
                    if let name = vm.task.coverImageName, UIImage(named: name) != nil {
                        Image(name)
                            .resizable()
                            .scaledToFill()
                    } else {
                        // заглушка, если ассета нет
                        ZStack {
                            RoundedRectangle(cornerRadius: 24).fill(Color.cardGray)
                            Image(systemName: "atom")
                                .font(.system(size: 80, weight: .regular))
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .frame(height: 230)
                .clipShape(RoundedRectangle(cornerRadius: 24))

                // Card with text
                VStack(alignment: .leading, spacing: 12) {
                    Text(vm.task.ribbonText)
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(Color.redAsset)

                    Text(vm.task.title)
                        .font(.system(size: 28, weight: .heavy))

                    Text(vm.task.body)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(16)
                .background(Color.cardGray)
                .clipShape(RoundedRectangle(cornerRadius: 16))

                // Stats (две плитки)
                HStack(spacing: 16) {
                    StatTile(
                        headline: "\(vm.task.solvedCount) из \(vm.task.solvedTotal)",
                        caption: "Уже решили",
                        systemIcon: "checkmark.seal"
                    )
                    StatTile(
                        headline: "\(vm.task.correctCount) из \(vm.task.correctTotal)",
                        caption: "Решили верно",
                        systemIcon: "checkmark.circle.fill",
                        accent: .green
                    )
                }

                // Attach result
                Button(action: vm.attachResult) {
                    Text("Прикрепить результат")
                        .font(.system(size: 17, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .foregroundStyle(Color("whiteAsset"))
                        .background(Color.redAsset)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                }
                .padding(.top, 4)
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 24)
        }
        .navigationTitle(vm.task.subject)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Image(systemName: "bell.fill").foregroundStyle(.secondary)
            }
        }
        .background(Color("whiteAsset").ignoresSafeArea())
    }
}

// MARK: - Subviews

private struct StatTile: View {
    let headline: String
    let caption: String
    let systemIcon: String
    var accent: Color = .secondary

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(headline)
                    .font(.system(size: 24, weight: .heavy))
                Text(caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: systemIcon)
                .font(.title2)
                .foregroundStyle(accent)
                .frame(width: 36, height: 36)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("whiteAsset"))
                )
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(Color.cardGray)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    NavigationStack {
        HomeworkDetailView(task:
            HomeworkTask(
                subject: "Физика",
                coverImageName: "Kinematic",
                ribbonText: "Оценка 5 за расписанное решение",
                title: "Кинематика",
                body: """
Четыре одинаковых кирпича массой 3 кг каждый сложены в стопку (см. рис.). На сколько увеличится сила N, действующая со стороны горизонтальной опоры на 1-й кирпич, если сверху положить еще один такой же кирпич? Ответ выразите в ньютонах.
""",
                solvedCount: 12, solvedTotal: 16,
                correctCount: 10, correctTotal: 12
            )
        )
    }
}
