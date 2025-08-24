import SwiftUI

struct GradesView: View {
    @StateObject var vm = GradesViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {

                    // Поиск + колокольчик (как на скрине)
                    HStack(spacing: 12) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(.secondary)
                            TextField("Поиск", text: $vm.searchText)
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 12)
                        .background(Color.cardGray)
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                        Button {
                            // уведомления
                        } label: {
                            Image(systemName: "bell.fill")
                                .frame(width: 44, height: 44)
                                .background(Color.cardGray)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                    .padding(.horizontal, 16)

                    // Заголовок + кубок
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Оценки").font(.system(size: 28, weight: .heavy))
                            Text("Средние результаты за предметы")
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text("🏆").font(.system(size: 44))
                    }
                    .padding(.horizontal, 16)

                    // Сегменты
                    Picker("", selection: $vm.selectedTab) {
                        Text("Оценки").tag(GradesViewModel.Tab.grades)
                        Text("Пропуски").tag(GradesViewModel.Tab.skips)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16).fill(Color.clear)
                    )

                    // Список предметов
                    VStack(spacing: 12) {
                        ForEach(vm.filteredItems) { item in
                            GradeRow(item: item)
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.vertical, 12)
            }
            .background(Color("whiteAsset").ignoresSafeArea())
            .navigationTitle("") // заголовок внутри
            .navigationBarTitleDisplayMode(.inline)
        }
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
