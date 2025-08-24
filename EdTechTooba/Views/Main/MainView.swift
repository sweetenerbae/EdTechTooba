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
                    FactOfDayCard()

                    // Календарь занятий
                    LessonsCalendarCard(
                        selectedWeekday: $selectedWeekday,
                        selectedDay: $selectedDay,
                        onScheduleTap: {},
                        onAddNoteTap: {}
                    )

                    // Учебные материалы (горизонтальная карусель)
                    MaterialsCarousel()

                    // Домашняя работа
                    HomeworkCard(onAllTap: {})

                    // Оценки
                    GradesCard(onAllTap: {})

                    // Цифровизация лекций
                    OCRCard(onCapture: {})
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 24)
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


// MARK: - Lessons calendar
private struct LessonsCalendarCard: View {
    @Binding var selectedWeekday: Int
    @Binding var selectedDay: Int
    var onScheduleTap: () -> Void
    var onAddNoteTap: () -> Void

    private let week = ["Пн","Вт","Ср","Чт","Пт","Сб","Вс"]
    private let days = [11,12,13,14,15,16,17]

    var body: some View {
        VStack(spacing: 12) {
            header

            // Дни недели
            HStack(spacing: 8) {
                ForEach(0..<week.count, id: \.self) { i in
                    let idx = i + 1
                    WeekdayCell(
                        title: week[i],
                        isSelected: idx == selectedWeekday
                    )
                    .onTapGesture { selectedWeekday = idx }
                }
            }

            // Числа
            HStack(spacing: 8) {
                ForEach(days, id: \.self) { day in
                    DayCell(
                        day: day,
                        isSelected: day == selectedDay
                    )
                    .onTapGesture { selectedDay = day }
                }
            }

            primaryButton(
                title: "Посмотреть расписание",
                action: onScheduleTap
            )

            secondaryButton(
                title: "Добавить запись",
                systemImage: "pencil",
                action: onAddNoteTap
            )
        }
        .padding(14)
        .background(Color("whiteAsset"))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Subviews

    private var header: some View {
        HStack {
            Text("Сегодня 3 урока")
                .font(.caption)
                .foregroundStyle(.redAsset)
            Spacer()
            Image(systemName: "photo.on.rectangle")
                .foregroundStyle(.secondary)
        }
    }

    private func primaryButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Text(title)
                Spacer()
                Image(systemName: "chevron.right")
            }
            .font(.subheadline.weight(.semibold))
            .padding(.vertical, 14)
            .padding(.horizontal, 14)
            .foregroundStyle(Color("whiteAsset"))
            .background(Color.redAsset)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    private func secondaryButton(title: String, systemImage: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
                .font(.subheadline.weight(.semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .foregroundStyle(Color.labelBlack)
                .background(Color("whiteAsset"))
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

// MARK: - Cells

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
        .init(title: "История",      topics: 36, image: "books.vertical"),
        .init(title: "Математика+",  topics: 20, image: "function"),
        .init(title: "Русский язык", topics: 52, image: "character.book.closed")
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
                                .fill(Color.cardGray)
                                .frame(height: 110)
                                .overlay(
                                    Image(systemName: item.image)
                                        .font(.largeTitle)
                                        .foregroundStyle(.secondary)
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
                        .background(Color.white)
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
            NavigationLink {
                GradesView()
            } label: {
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
                .fill(Color.cardGray)
                .frame(height: 140)
                .overlay(
                    VStack(spacing: 8) {
                        Image(systemName: "camera.fill").font(.title)
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

// MARK: - SectionCard (универсальная «коробка»)

private struct SectionCard<Content: View, Footer: View>: View {
    let title: String
    let subtitle: String?
    let trailingIcon: String?
    @ViewBuilder let content: Content
    @ViewBuilder let footer: Footer

    init(title: String,
         subtitle: String? = nil,
         trailingIcon: String? = nil,
         @ViewBuilder content: () -> Content,
         @ViewBuilder footer: () -> Footer) {
        self.title = title
        self.subtitle = subtitle
        self.trailingIcon = trailingIcon
        self.content = content()
        self.footer = footer()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 20, weight: .bold))

                    if let subtitle {
                        Text(subtitle)
                            .font(.system(size: 16, weight: .regular))
                    }
                }
                Spacer()
                if let trailingIcon {
                    Text(trailingIcon).font(.system(size: 51, weight: .bold))
                }
            }

            content

            footer
        }
        .padding(14)
        .background(Color.cardGray)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    MainView()
}
