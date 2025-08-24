//
//  MainView.swift
//  EdTechTooba
//
//  Created by Diana Kuchaeva on 23.08.25.
//
import SwiftUI

// MARK: - MainView

struct MainView: View {
    @State private var searchText = ""
    @State private var questionText = ""
    @State private var selectedWeekday: Int = Calendar.current.component(.weekday, from: .now)
    @State private var selectedDay: Int = Calendar.current.component(.day, from: .now)
    @State private var showGrades = false
    @State private var wd = 4  // текущий день недели
    @State private var d  = 14 // выбранное число
    var onScheduleTap: () -> Void
    var onAddNoteTap: () -> Void
    

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Поиск + закладки
                    SearchRow(searchText: $searchText)

                    // «Спросите что-нибудь»
                    AskSection(questionText: $questionText)

                    // Заголовок
                    TitleHero()

                    // Факт дня
                    FactOfTheDayCard()

                    // Календарь занятий
                    LessonsCalendarCard(
                        selectedWeekday: $wd,
                        selectedDay: $d,
                        onScheduleTap: { /* открыть расписание */ },
                        onAddNoteTap: { /* показать добавление записи */ }
                    )
                    .padding(.horizontal, 16)

                    // Учебные материалы (горизонтальная карусель)
                    MaterialsCarousel()

                    // Домашняя работа
                    HomeworkCard(onAllTap: {})

                    // Оценки
                    GradesCard(onAllTap: {showGrades = true})

                    // Цифровизация лекций
                    OCRCard(onCapture: {})
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 24)
                .navigationDestination(isPresented: $showGrades) {
                         GradesView()
                     }
            }
            .background(Color("whiteAsset").ignoresSafeArea())
            .navigationTitle("Дневник")
            .hideKeyboardOnTap()
        }
    }
}

// MARK: - Title

private struct TitleHero: View {
    var body: some View {
        HStack {
            Text("Перемен")
                .foregroundStyle(Color.redAsset)
                .font(.system(size: 32, weight: .heavy))
            + Text(" требуют\nнаши сердца")
                .font(.system(size: 32, weight: .heavy))
            Spacer()
        }
    }
}


// MARK: - Пример использования под «Календарь занятий»
private struct LessonsCalendarCard: View {
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
                        .onTapGesture { selectedDay = d
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
            .font(.headline.weight(.semibold))
            .foregroundStyle(isSelected ? Color.redAsset : .secondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(isSelected ? Color("whiteAsset") : Color.cardGray)
            .clipShape(RoundedRectangle(cornerRadius: corner, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: corner, style: .continuous)
                    .stroke(isSelected ? Color.redAsset : .clear, lineWidth: 2)
            )
    }
}


private struct WeekdayCell: View {
    let title: String
    let isSelected: Bool

    var body: some View {
        let bg = isSelected ? Color.redAsset.opacity(0.12) : Color.ui.surface
        let fg: Color = isSelected ? .redAsset : .primary

        Text(title)
            .font(.subheadline.weight(.semibold))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(bg)
            .foregroundStyle(fg)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

private struct DayCell: View {
    let day: Int
    let isSelected: Bool

    var body: some View {
        let bg = isSelected ? Color.redAsset : Color("whiteAsset")
        let fg: Color = isSelected ? .white : .primary

        Text("\(day)")
            .font(.subheadline.weight(.semibold))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(bg)
            .foregroundStyle(fg)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

// MARK: - Helpers

private extension Color {
    struct ui {
        static let surface = Color(red: 0.96, green: 0.96, blue: 0.98)
        static let stroke = Color.black.opacity(0.08)
    }
}
// MARK: - Materials carousel

private struct MaterialsCarousel: View {
    struct Item: Identifiable {
        let id = UUID()
        let title: String
        let topics: Int
        let image: String
    }

    private let items: [Item] = [
        .init(title: "История",      topics: 36, image: "History"),
        .init(title: "Математика+",  topics: 20, image: "Math"),
        .init(title: "Русский язык", topics: 52, image: "Russian")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Учебные материалы")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.primary)

                    Text("База знаний по учебным предметам")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text("📚")
                    .font(.system(size: 44, weight: .bold))
                    .padding(.leading, 8)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(items) { item in
                        VStack(alignment: .leading, spacing: 8) {
                            RoundedRectangle(cornerRadius: 12)
                                .frame(height: 110)
                                .overlay(
                                    Image(item.image)
                                        .resizable()
                                        .scaledToFit()
                                )

                            Text(item.title)
                                .font(.subheadline.bold())
                                .foregroundStyle(.primary)

                            Text("\(item.topics) тем")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(12)
                        .frame(width: 160)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                }
                .padding(.trailing, 4)
            }
        }
        .padding(14)
        .background(Color.cardGray)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}


// MARK: - Homework

private struct HomeworkCard: View {
    var onAllTap: () -> Void
    var body: some View {
        SectionCard(
            title: "Домашняя работа",
            subtitle: "4 домашних задания на неделю",
            trailingIcon: "🏠"
        ) {
            VStack(spacing: 0) {
                HomeworkRow(text: "🧮", title: "3 упражнения")
                Divider()
                HomeworkRow(text: "🪆", title: "Литература — 1 задание")
                Divider()
                HomeworkRow(text: "🌎 ", title: "География — 6 упражнений")
            }
        } footer: {
            Button(action: onAllTap) {
                HStack {
                    Text("Посмотреть все задания")
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .font(.subheadline.weight(.semibold))
                .padding(.vertical, 16)
                .padding(.horizontal, 14)
                .foregroundStyle(Color("whiteAsset"))
                .background(Color.redAsset)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }
}

private struct HomeworkRow: View {
    let text: String
    let title: String
    var body: some View {
        HStack(spacing: 12) {
            Text(text)
                .frame(width: 20, height: 20)
            Text(title)
            Spacer()
        }
        .padding(12)
        .background(Color.cardGray)
    }
}

// MARK: - Grades

private struct GradesCard: View {
    var onAllTap: () -> Void
    struct Grade: Identifiable { let id = UUID(); let name: String; let value: String }
    private let grades = [
        Grade(name: "Русский язык", value: "4.3"),
        Grade(name: "Математика", value: "5.0"),
        Grade(name: "География", value: "3.6")
    ]
    var body: some View {
        SectionCard(
            title: "Оценки",
            subtitle: "Средние результаты за предметы",
            trailingIcon: "🏆"
        ) {
            VStack(spacing: 0) {
                ForEach(grades) { g in
                    HStack {
                        Text(g.name)
                        Spacer()
                        Text(g.value).bold()
                            .foregroundStyle(Color.redAsset)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 12)

                    if g.id != grades.last?.id {
                        Divider().padding(.leading, 0)
                    }
                }
            }
        } footer: {
            Button(action: onAllTap) {
                HStack {
                    Text("Посмотреть все оценки")
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .font(.subheadline.weight(.semibold))
                .padding(.vertical, 16)
                .padding(.horizontal, 14)
                .foregroundStyle(Color("whiteAsset"))
                .background(Color.redAsset)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)
        }
    }
}

// MARK: - OCR

private struct OCRCard: View {
    var onCapture: () -> Void
    var body: some View {
        SectionCard(
            title: "Цифровизация лекций",
            subtitle: "ИИ распознает текст с фотки и переведёт их в элeк-ый формат",
            trailingIcon: "💻"
        ) {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color("whiteAsset"))
                .frame(height: 140)
                .overlay(
                    VStack(spacing: 8) {
                        Image(systemName: "camera.fill").font(.title).foregroundStyle(Color.labelBlack)
                        Text("Добавьте фото").font(.footnote).foregroundStyle(.secondary)
                    }
                )
        } footer: {
            Button(action: onCapture) {
                HStack {
                    Text("Сфотографировать")
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .font(.subheadline.weight(.semibold))
                .padding(.vertical, 16)
                .padding(.horizontal, 14)
                .foregroundStyle(Color("whiteAsset"))
                .background(Color.redAsset)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }
}

// MARK: - Универсальная серая карточка
private struct SectionCard<Content: View, Footer: View>: View {
    let title: String
    let subtitle: String?
    let trailingIcon: String?
    let content: () -> Content
    let footer: () -> Footer

    init(
        title: String,
        subtitle: String? = nil,
        trailingIcon: String? = nil,
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder footer: @escaping () -> Footer
    ) {
        self.title = title
        self.subtitle = subtitle
        self.trailingIcon = trailingIcon
        self.content = content
        self.footer = footer
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 20, weight: .bold))
                    if let subtitle {
                        Text(subtitle)
                            .font(.system(size: 16))
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer()
                if let trailingIcon {
                    Text(trailingIcon)
                        .font(.system(size: 48, weight: .bold))
                }
            }

            content()

            footer()
        }
        .padding(16)
        .background(Color.cardGray)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}


