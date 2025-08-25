//
//  LessonsCalendarCard.swift
//  EdTechTooba
//
//  Created by Diana Kuchaeva on 25.08.25.
//
import SwiftUI

struct LessonsCalendarCard: View {
    @Binding var selectedWeekday: Int
    @Binding var selectedDay: Int
    
    var onScheduleTap: () -> Void
    var onAddNoteTap: () -> Void

    private let week = ["Пн","Вт","Ср","Чт","Пт","Сб","Вс"]
    private let days = [11,12,13,14,15,16,17]
    private let dayToWeekday: [Int:Int] = [11:1, 12:2, 13:3, 14:4, 15:5, 16:6, 17:7]

    var body: some View {
        SectionCard(
            title: "Календарь занятий",
            subtitle: "Через 2 дня выходной день",
            trailingIcon: "🗓"
        ) {
            VStack(spacing: 12) {
                // Срок/статус
                Text("Сегодня 3 урока")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(Color.redAsset)

                // ДНИ НЕДЕЛИ
                HStack(spacing: 12) {
                    ForEach(0..<week.count, id: \.self) { i in
                        let idx = i + 1
                        pill(
                            title: week[i],
                            isSelected: idx == selectedWeekday
                        )
                        .onTapGesture {
                            selectedWeekday = idx
                            if let d = days.first(where: { dayToWeekday[$0] == idx }) {
                                selectedDay = d
                            }
                        }
                    }
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
                .background(RoundedRectangle(cornerRadius: 18).fill(Color.cardGray))

                // ЧИСЛА
                HStack(spacing: 12) {
                    ForEach(days, id: \.self) { d in
                        pill(
                            title: String(d),
                            isSelected: d == selectedDay
                        )
                        .onTapGesture {
                            selectedDay = d
                            if let wd = dayToWeekday[d] {
                                selectedWeekday = wd
                            }
                        }
                    }
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
                .background(RoundedRectangle(cornerRadius: 18).fill(Color.cardGray))

                // КРАСНАЯ кнопка
                Button(action: onScheduleTap) {
                    HStack {
                        Text("Посмотреть расписание")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color("whiteAsset"))
                    .padding(.horizontal, 16)
                    .frame(height: 56)
                    .background(Color.redAsset)
                    .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                }

                // БЕЛАЯ кнопка
                Button(action: onAddNoteTap) {
                    HStack(spacing: 10) {
                        Image(systemName: "pencil")
                            .foregroundStyle(.secondary)
                        Text("Добавить запись")
                            .foregroundStyle(Color.labelBlack)
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 56)
                    .background(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .fill(Color("whiteAsset"))
                    )
                }
            }
        } footer: {
            EmptyView()
        }
    }

    // MARK: - Пилюля дня/числа
    @ViewBuilder
    private func pill(title: String, isSelected: Bool) -> some View {
        let corner: CGFloat = 14
        Text(title)
            .font(.system(size: 15, weight: .semibold))
            .foregroundStyle(isSelected ? Color("whiteAsset") : Color.labelBlack)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: corner, style: .continuous)
                    .fill(isSelected ? Color.redAsset : Color.cardGray)
            )
    }
}

private struct SectionCard<Content: View, Footer: View>: View {
    let title: String
    let subtitle: String?
    let trailingIcon: String?
    @ViewBuilder let content: Content
    @ViewBuilder let footer: Footer

    init(
        title: String,
        subtitle: String? = nil,
        trailingIcon: String? = nil,
        @ViewBuilder content: () -> Content,
        @ViewBuilder footer: () -> Footer
    ) {
        self.title = title
        self.subtitle = subtitle
        self.trailingIcon = trailingIcon
        self.content = content()
        self.footer = footer()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 20, weight: .bold))
                    if let subtitle {
                        Text(subtitle)
                            .font(.system(size: 16, weight: .regular))
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer()
                if let trailingIcon {
                    Text(trailingIcon)
                        .font(.system(size: 44, weight: .bold))
                }
            }

            content
            footer
        }
        .padding(14)
        .background(Color.cardGray)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

//  инициализатор без footer
extension SectionCard where Footer == EmptyView {
    init(
        title: String,
        subtitle: String? = nil,
        trailingIcon: String? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.init(title: title, subtitle: subtitle, trailingIcon: trailingIcon, content: content) {
            EmptyView()
        }
    }
}

