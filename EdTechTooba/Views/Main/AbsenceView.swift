//
//  Absence.swift
//  EdTechTooba
//
//  Created by Diana Kuchaeva on 24.08.25.
//

import SwiftUI

struct AbsencesView: View {
    @StateObject var vm = AbsencesViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(vm.items) { subject in
                    AbsenceRow(item: subject)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(Color("whiteAsset"))
    }
}

private struct AbsenceRow: View {
    let item: SubjectAbsence
    @State private var isExpanded = false

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Text(item.emoji).font(.system(size: 24))

                VStack(alignment: .leading, spacing: 2) {
                    Text(item.title).font(.headline)
                    Text("Количество пропущенных уроков")
                        .font(.footnote).foregroundStyle(.secondary)
                }
                Spacer()
                if item.totalMissed > 0 {
                    Text("\(item.totalMissed)")
                        .font(.headline.bold())
                        .foregroundStyle(.red)
                }
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 14)
            .onTapGesture { withAnimation { isExpanded.toggle() } }

            if isExpanded {
                ForEach(item.periods) { p in
                    Divider()
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(p.range).font(.subheadline)
                                Text(p.periodName).font(.footnote).foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text(String(format: "%.1f", p.score))
                                .font(.headline)
                                .foregroundStyle(.green)
                        }

                        ProgressView(value: Double(item.totalMissed), total: 5)
                            .tint(.green)

                        Text("Ещё два пропуска до неудовлетворительной оценки")
                            .font(.footnote)
                            .foregroundStyle(.secondary)

                        // таблица галочек/крестиков
                        LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 6), spacing: 8) {
                            ForEach(p.missedMarks, id: \.self) { present in
                                Image(systemName: present ? "checkmark.square.fill" : "xmark.square.fill")
                                    .foregroundStyle(present ? .green : .red)
                                    .font(.title3)
                            }
                        }
                    }
                    .padding(14)
                }
            }
        }
        .background(Color.cardGray)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}
