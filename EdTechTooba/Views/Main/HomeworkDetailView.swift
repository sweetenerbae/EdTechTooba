//
//  HomeworkDetailView.swift
//  EdTechTooba
//
//  Created by Diana Kuchaeva on 25.08.25.
//

import SwiftUI

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
                        Icon: "☑️"
                    )
                    StatTile(
                        headline: "\(vm.task.correctCount) из \(vm.task.correctTotal)",
                        caption: "Решили верно",
                        Icon: "✅",
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
