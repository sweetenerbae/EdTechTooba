//
//  ProfileView.swift
//  EdTechTooba
//
//  Created by Diana Kuchaeva on 23.08.25.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var usersVM: UsersViewModel
    @AppStorage("currentFirebaseId") private var currentFirebaseId: String?

    // текущий пользователь: сперва по firebaseId, иначе — первый
    private var currentUser: User? {
        if let id = currentFirebaseId {
            return usersVM.users.first(where: { $0.firebaseId == id })
        }
        return usersVM.users.first
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color("whiteAsset").ignoresSafeArea() 

                if let user = currentUser {
                    ProfileLoggedInView(
                        user: user,
                        onSignOut: { currentFirebaseId = nil }
                    )
                } else {
                    ProfileLoggedOutView(onSignIn: demoSignIn)
                }
            }
            .navigationTitle("Профиль")
        }
    }

    // Заглушка: «войти» — привязать первого пользователя к AppStorage
    private func demoSignIn() {
        if let first = usersVM.users.first, let fid = first.firebaseId {
            currentFirebaseId = fid
        } else {
            // мок если база пуста
            let context = CoreDataManager.shared.viewContext
            let demo = User(context: context)
            demo.firstName = "Тест"
            demo.lastName  = "Юзер"
            demo.userName  = "student_demo"
            demo.role      = "student"
            demo.firebaseId = "demo123"
            try? context.save()
            usersVM.fetchUsers()
            currentFirebaseId = "demo123"
        }
    }
}

// MARK: - Logged OUT

private struct ProfileLoggedOutView: View {
    let onSignIn: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Войдите в профиль")
                        .font(.title).bold()
                    Text("Чтобы обращаться в поддержку и иметь доступ ко всем функциям приложения")
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(20)
                .background(Color.cardGray) // карточка серая
                .clipShape(RoundedRectangle(cornerRadius: 16))

                Button(action: onSignIn) {
                    Text("Войти")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.primaryRed)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal, 4)

                SettingsSection()
                SupportSection()
            }
            .padding(16)
        }
    }
}

// MARK: - Logged IN

private struct ProfileLoggedInView: View {
    let user: User
    let onSignOut: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ProfileCard(user: user, onMore: {}, onSignOut: onSignOut)
                QuickStatsGrid()
                SettingsSection()
                SupportSection()
            }
            .padding(16)
        }
    }
}

// MARK: - Profile Card

private struct ProfileCard: View {
    let user: User
    let onMore: () -> Void
    let onSignOut: () -> Void

    var fullName: String {
        [user.lastName, user.firstName].compactMap { $0 }.joined(separator: " ")
    }

    var subtitle: String {
        if let role = user.role {
            return role.capitalized + (user.userName.map { " • \($0)" } ?? "")
        }
        return user.userName ?? "Студент"
    }

    var body: some View {
        HStack(spacing: 12) {
            Avatar(urlString: user.profilePageURL)
            VStack(alignment: .leading, spacing: 4) {
                Text(fullName.isEmpty ? (user.userName ?? "Пользователь") : fullName)
                    .font(.headline).bold()
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Menu {
                Button("Выйти", role: .destructive, action: onSignOut)
                Button("Подробнее...", action: onMore)
            } label: {
                Image(systemName: "chevron.forward")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(16)
        .background(Color.cardGray) // карточка серая
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

private struct Avatar: View {
    let urlString: String?
    var body: some View {
        Group {
            if let urlString, let url = URL(string: urlString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let img): img.resizable().scaledToFill()
                    default:
                        Image(systemName: "person.crop.circle.fill")
                            .resizable().scaledToFit()
                            .padding(8)
                    }
                }
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable().scaledToFit()
                    .padding(8)
            }
        }
        .frame(width: 56, height: 56)
        .background(Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Quick Stats

private struct QuickStatsGrid: View {
    struct Tile {
        let icon: String
        let title: String
        let subtitle: String
    }

    private let t1 = Tile(icon: "building.columns", title: "Мой класс", subtitle: "21 ученик")
    private let t2 = Tile(icon: "bell.fill",        title: "Расписание", subtitle: "До следующего урока 12 минут")
    private let t3 = Tile(icon: "hand.thumbsup.fill", title: "Программа", subtitle: "12 предметов")
    private let t4 = Tile(icon: "star.fill",        title: "4.8", subtitle: "Средняя оценка")
    private let t5 = Tile(icon: "graduationcap.fill", title: "Курсы", subtitle: "4 добавлено")

    private let spacing: CGFloat = 12

    var body: some View {
        GeometryReader { geo in
            let W = geo.size.width

            // --- Ряд 1: 93 и 238 по высоте 93 ---
            // пропорциональные ширины, чтобы соблюсти соотношение 93:238
            let row1Total: CGFloat = 93 + 190
            let r1Left  = (W - spacing) * (93 / row1Total)
            let r1Right = (W - spacing) - r1Left

            // --- Ряд 2: три по 106 по высоте 93 ---
            let r2Item  = (W - spacing*2) / 3

            VStack(spacing: spacing) {
                // РЯД 1
                HStack(spacing: spacing) {
                    QuickTile(tile: t1)
                        .frame(width: r1Left, height: 93)
                    QuickTile(tile: t2)
                        .frame(width: r1Right, height: 93)
                }

                // РЯД 2
                HStack(spacing: spacing) {
                    QuickTile(tile: t3)
                        .frame(width: r2Item, height: 93)
                    QuickTile(tile: t4)
                        .frame(width: r2Item, height: 93)
                    QuickTile(tile: t5)
                        .frame(width: r2Item, height: 93)
                }
            }
        }
        .frame(height: 93*2 + spacing) // общая высота гриды
    }
}

private struct QuickTile: View {
    let tile: QuickStatsGrid.Tile

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(systemName: tile.icon)
                .font(.title2)
                .foregroundStyle(Color.redAsset)

            Text(tile.title)
                .font(.system(size: 14, weight: .semibold))
                .lineLimit(1)

            Text(tile.subtitle)
                .font(.system(size: 12, weight: .regular))
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
        .padding(14)
        .background(Color.cardGray) // серый фон карточки
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}



// MARK: - Sections (Настройки / Поддержка)

private struct SettingsSection: View {
    var body: some View {
        SectionCard(title: "Настройки", rows: [
            .init(title: "Уведомления", icon: "bell"),
            .init(title: "Конфиденциальность", icon: "lock.shield")
        ])
    }
}

private struct SupportSection: View {
    var body: some View {
        SectionCard(title: "Поддержка", rows: [
            .init(title: "Не могу войти", icon: "person.fill.questionmark"),
            .init(title: "Неверно занятия", icon: "exclamationmark.bubble"),
            .init(title: "Про ограничения по времени", icon: "clock.arrow.circlepath")
        ])
    }
}

private struct SectionCard: View {
    struct Row: Identifiable { let id = UUID(); let title: String; let icon: String }
    let title: String
    let rows: [Row]

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(title).font(.title3).bold()
                Spacer()
            }
            .padding(.horizontal, 8)

            VStack(spacing: 0) {
                ForEach(rows.indices, id: \.self) { idx in
                    let row = rows[idx]
                    HStack(spacing: 12) {
                        Image(systemName: row.icon)
                            .frame(width: 24, height: 24)
                            .foregroundStyle(.pink)
                        Text(row.title)
                            .foregroundStyle(.primary)
                        Spacer()
                        Image(systemName: "chevron.right").foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 14)
                    .padding(.horizontal, 12)

                    if idx < rows.count - 1 {
                        Divider().padding(.horizontal, 12)
                    }
                }
            }
            .background(Color.cardGray)                 
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .padding(.top, 4)
    }
}

// MARK: - Preview

#Preview("Залогинен") {
    let vm = UsersViewModel()
    let context = CoreDataManager.shared.viewContext
    let user = User(context: context)
    user.firstName = "Иван"
    user.lastName  = "Иванов"
    user.userName  = "ivan_student"
    user.role      = "student"
    user.profilePageURL = nil
    user.firebaseId = "demo123"
    vm.users = [user]
    return ProfileView(usersVM: vm)
}
