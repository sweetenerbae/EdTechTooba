//
//  HomeworkView.swift
//  EdTechTooba
//
//  Created by Diana Kuchaeva on 24.08.25.
//

import SwiftUI

struct HomeworkView: View {
    @State private var selectedTab = 0
    @State private var searchText = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            SearchRow(searchText: $searchText)
            
            Divider()
            
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Домашняя работа")
                        .font(.system(size: 20, weight: .bold))
                    Text("4 домашних задания на неделю")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text("🏠").font(.system(size: 51))
            }
            .padding(.top, )
            .padding(.horizontal, 16)

            Picker("", selection: $selectedTab) {
                Text("Нужно сделать").tag(0)
                Text("Сделано").tag(1)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 16)

            ScrollView {
                VStack(spacing: 16) {
                    HomeworkSubjectCard(
                        subject: "Физика",
                        subtitle: "1 практическое задание",
                        topic: "Кинематика",
                        detail: "2 закон Ньютона",
                        description: "Четыре одинаковых кирпича массой 3 кг каждый сложены в стопку (см. рис.). На сколько увеличится сила N, действующая со стороны горизонтальной опоры на 1-⁠й кирпич, если сверху положить еще один такой же кирпич? Ответ выразите в ньютонах."
                    )

                    HomeworkSubjectCard(
                        subject: "Литература",
                        subtitle: "2 задания"
                    )
                }
                .padding(.horizontal, 16)
            }
        }
        .background(Color("whiteAsset"))
        .navigationTitle("Домашка")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Карточка задания

struct HomeworkSubjectCard: View {
    let subject: String
    let subtitle: String
    var topic: String? = nil
    var detail: String? = nil
    var description: String? = nil

    @State private var expanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(subject).font(.system(size: 14, weight: .medium))
                Spacer()
                Text(subtitle).font(.system(size: 12, weight: .regular))
            Button {
                    withAnimation { expanded.toggle() }
                } label: {
                    Image(systemName: expanded ? "chevron.up" : "chevron.down")
                        .foregroundStyle(.secondary)
                }
            }

            if expanded {
                if let topic { Text(topic).font(.system(size: 14, weight: .medium)) }
                if let detail { Text(detail).font(.system(size: 12, weight: .regular))
                    .foregroundStyle(.secondary) }
                if let description {
                    Text(description)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                NavigationLink {
                    HomeworkDetailView(task:
                        HomeworkTask(
                            subject: "Физика",
                            coverImageName: "Kinematic",
                            ribbonText: "Оценка 5 за расписанное решение",
                            title: "Кинематика",
                            body: "Четыре одинаковых кирпича массой 3 кг каждый сложены в стопку (см. рис.). На сколько увеличится сила N, действующая со стороны горизонтальной опоры на 1-⁠й кирпич, если сверху положить еще один такой же кирпич? Ответ выразите в ньютонах.",
                            solvedCount: 12, solvedTotal: 16,
                            correctCount: 10, correctTotal: 12
                        )
                    )
                } label: {
                    HStack {
                        Text("Подробнее")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .font(.subheadline.weight(.semibold))
                    .padding(.vertical, 12)
                    .padding(.horizontal, 14)
                    .foregroundStyle(Color("whiteAsset"))
                    .background(Color.redAsset)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
                .padding(.top, 8)
            }
        }
        .padding(16)
        .background(Color.cardGray)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Subviews

struct StatTile: View {
    let headline: String
    let caption: String
    let Icon: String
    var accent: Color = .secondary

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(headline)
                    .font(.system(size: 20, weight: .bold))
                Text(caption)
                    .font(.system(size: 14, weight: .regular))
            }
            Spacer()
            Text(Icon)
                .font(.title2)
                .frame(width: 33, height: 33)
                .background(
                    RoundedRectangle(cornerRadius: 12)
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
        HomeworkView()
    }
}
