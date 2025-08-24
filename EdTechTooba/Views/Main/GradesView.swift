import SwiftUI

// GradesView.swift

struct GradesView: View {
    @StateObject var vm = GradesViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {

                    // Search + bell
                    HeaderSearch(searchText: $vm.searchText)

                    // Заголовок
                    if vm.selectedTab == .grades {
                        HeaderTitle(
                            title: "Оценки",
                            subtitle: "Средние результаты за предметы",
                            emoji: "🏆"
                        )
                        GradesListView(items: vm.filteredItems)
                    } else {
                        HeaderTitle(
                            title: "Пропуски",
                            subtitle: "Информация по пропущенным урокам",
                            emoji: "🫠"
                        )
                        AbsencesView()
                    }


                    // Segmented
                    Picker("", selection: $vm.selectedTab) {
                        Text("Оценки").tag(GradesViewModel.Tab.grades)
                        Text("Пропуски").tag(GradesViewModel.Tab.skips)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, 16)

                    // ✅ без рекурсии:
                    if vm.selectedTab == .grades {
                        GradesListView(items: vm.filteredItems)
                    } else {
                        AbsencesView()
                    }
                }
                .padding(.vertical, 12)
            }
            .background(Color("whiteAsset").ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .hideKeyboardOnTap()
        }
    }
}

private struct GradesListView: View {
    let items: [SubjectGrade]
    var body: some View {
        VStack(spacing: 12) {
            ForEach(items) { item in
                GradeRow(item: item)
            }
        }
        .padding(.horizontal, 16)
    }
}

// Вспомогательные заголовки вынеси для читабельности
private struct HeaderSearch: View {
    @Binding var searchText: String
    var body: some View {
        HStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
                TextField("Поиск", text: $searchText)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 12)
            .background(Color.cardGray)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            Button { } label: {
                Image(systemName: "bell.fill")
                    .frame(width: 44, height: 44)
                    .foregroundStyle(Color.labelBlack)
                    .background(Color.cardGray)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(.horizontal, 16)
    }
}

struct HeaderTitle: View {
    let title: String
    let subtitle: String
    let emoji: String

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 28, weight: .heavy))
                Text(subtitle)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text(emoji)
                .font(.system(size: 44))
        }
        .padding(.horizontal, 16)
    }
}



private struct GradeRow: View {
    let item: SubjectGrade
    @State private var isExpanded = false

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Text(item.emoji).font(.system(size: 26))

                VStack(alignment: .leading, spacing: 2) {
                    Text(item.title).font(.headline)
                    Text(item.subtitle).font(.footnote).foregroundStyle(.secondary)
                }

                Spacer()

                Text(String(format: "%.1f", item.average))
                    .font(.headline).bold()
                    .foregroundStyle(.green)

                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 14)

            if isExpanded {
                // Контент раскрытия — здесь можно показать оценки по четвертям/семестрам и т.п.
                VStack(alignment: .leading, spacing: 8) {
                    Divider()
                    Text("1 четверть: 4.5")
                    Text("2 четверть: 4.3")
                    Text("3 четверть: 4.7")
                    Text("4 четверть: 4.4")
                }
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(14)
            }
        }
        .background(Color.cardGray)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .onTapGesture { withAnimation(.easeInOut) { isExpanded.toggle() } }
    }
}
