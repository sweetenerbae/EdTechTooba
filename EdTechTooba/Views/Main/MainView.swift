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

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Поиск + закладки
                    SearchRow(searchText: $searchText)

                    // «Спросите что-нибудь»
                    AskAnythingCard(questionText: $questionText)

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
//            .navigationTitle("Дневник")
        }
    }
}

// MARK: - Title

private struct TitleHero: View {
    var body: some View {
        HStack {
            Text("Перемен")
                .foregroundStyle(Color.redAsset)
                .font(.system(size: 28, weight: .heavy))
            + Text(" требуют\nнаши сердца")
                .font(.system(size: 28, weight: .heavy))
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

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Сегодня 3 урока")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                Image(systemName: "photo.on.rectangle")
                    .foregroundStyle(.secondary)
            }

            // дни недели
            HStack(spacing: 8) {
                ForEach(0..<7, id: \.self) { i in
                    let idx = i + 1
                    Text(week[i])
                        .font(.subheadline.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(idx == selectedWeekday ? Color.redAsset.opacity(0.12) : Color.ui.surface)
                        .foregroundStyle(idx == selectedWeekday ? Color.redAsset : .primary)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(idx == selectedWeekday ? Color.redAsset.opacity(0.35) : Color.ui.stroke)
                        )
                        .onTapGesture { selectedWeekday = idx }
                }
            }

            // числа
            HStack(spacing: 8) {
                ForEach([11,12,13,14,15,16,17], id: \.self) { day in
                    Text("\(day)")
                        .font(.subheadline.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(day == selectedDay ? Color.redAsset : Color("whiteAsset"))
                        .foregroundStyle(day == selectedDay ? .white : .primary)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(day == selectedDay ? Color.redAsset : Color.ui.stroke)
                        )
                        .onTapGesture { selectedDay = day }
                }
            }

            Button(action: onScheduleTap) {
                HStack {
                    Text("Посмотреть расписание")
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

            Button(action: onAddNoteTap) {
                Label("Добавить запись", systemImage: "pencil")
                    .font(.subheadline.weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color("whiteAsset"))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.ui.stroke))
            }
        }
        .padding(14)
        .background(Color("whiteAsset"))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Materials carousel

private struct MaterialsCarousel: View {
    struct Item: Identifiable { let id = UUID(); let title: String; let topics: Int; let image: String }
    private let items: [Item] = [
        .init(title: "История", topics: 36, image: "books.vertical"),
        .init(title: "Математика+", topics: 20, image: "function"),
        .init(title: "Русский язык", topics: 52, image: "character.book.closed")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Учебные материалы").font(.title3.bold())
                    Text("База знаний по учебным предметам")
                        .foregroundStyle(.secondary)
                        .font(.footnote)
                }
                Spacer()
                Image(systemName: "books.vertical")
                    .font(.title2)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(items) { item in
                        VStack(alignment: .leading, spacing: 8) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.ui.surface)
                                .frame(height: 110)
                                .overlay(Image(systemName: item.image).font(.largeTitle).foregroundStyle(.secondary))

                            Text(item.title).font(.subheadline.bold())
                            Text("\(item.topics) тем").font(.caption).foregroundStyle(.secondary)
                        }
                        .padding(12)
                        .frame(width: 160)
                        .background(Color("whiteAsset"))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }
            }
        }
    }
}

// MARK: - Homework

private struct HomeworkCard: View {
    var onAllTap: () -> Void
    var body: some View {
        SectionCard(
            title: "Домашняя работа",
            subtitle: "4 домашних задания на неделю",
            trailingIcon: "house"
        ) {
            VStack(spacing: 0) {
                HomeworkRow(icon: "tablecells", title: "3 упражнения")
                Divider().padding(.leading, 44)
                HomeworkRow(icon: "book.closed", title: "Литература — 1 задание")
                Divider().padding(.leading, 44)
                HomeworkRow(icon: "globe.europe.africa.fill", title: "География — 6 упражнений")
            }
        } footer: {
            Button(action: onAllTap) {
                HStack {
                    Text("Посмотреть все задания")
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
        }
    }
}

private struct HomeworkRow: View {
    let icon: String
    let title: String
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .frame(width: 24, height: 24)
                .foregroundStyle(.pink)
            Text(title)
            Spacer()
        }
        .padding(12)
        .background(Color("whiteAsset"))
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
            trailingIcon: "trophy"
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
                .padding(.vertical, 12)
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
            subtitle: "ИИ распознает текст с фотки и переведёт их в элeк‑вый формат",
            trailingIcon: "laptopcomputer"
        ) {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.ui.surface)
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
                .padding(.vertical, 12)
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
                    Text(title).font(.title3.bold())
                    if let subtitle {
                        Text(subtitle).font(.footnote).foregroundStyle(.secondary)
                    }
                }
                Spacer()
                if let trailingIcon {
                    Image(systemName: trailingIcon).font(.title2)
                }
            }

            content

            footer
        }
        .padding(14)
        .background(Color("whiteAsset"))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.ui.stroke))
    }
}

// MARK: - Theme

private extension Color {
    struct ui {
        static let accent = Color(red: 0.95, green: 0.22, blue: 0.30) // красная кнопка/акценты
        static let bg = Color(red: 0.97, green: 0.97, blue: 0.97)     // фон страницы
        static let surface = Color(red: 0.96, green: 0.96, blue: 0.98)
        static let stroke = Color.black.opacity(0.08)
        static let pillBG = Color.black.opacity(0.06)
    }
}

// MARK: - Preview

#Preview {
    MainView()
}
