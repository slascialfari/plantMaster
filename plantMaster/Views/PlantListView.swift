import SwiftUI
import SwiftData

struct PlantListView: View {
    @Query(sort: \Plant.index) private var plants: [Plant]

    @State private var searchText = ""
    @FocusState private var isSearchFocused: Bool

    /// Plants whose Latin or Dutch name has a word starting with the search text, or whose list
    /// number matches. "cer" finds "Cercis" but not "Acer". Case, accents, quotes and the
    /// hybrid sign are ignored, so "magnolia x" finds "Magnolia × soulangeana".
    private var filteredPlants: [Plant] {
        let query = StringNormalization.normalize(searchText)
        guard !query.isEmpty else {
            let trimmed = searchText.trimmingCharacters(in: .whitespaces)
            if let number = Int(trimmed) {
                return plants.filter { $0.index == number }
            }
            return plants
        }
        return plants.filter { plant in
            Self.hasWord(startingWith: query, in: plant.latinName)
                || Self.hasWord(startingWith: query, in: plant.dutchName)
        }
    }

    private static func hasWord(startingWith query: String, in name: String) -> Bool {
        let normalized = StringNormalization.normalize(name)
        return normalized.hasPrefix(query) || normalized.contains(" " + query)
    }

    private var groupedByCategory: [(category: Category?, plants: [Plant])] {
        let groups = Dictionary(grouping: filteredPlants) { $0.category }
        return groups
            .sorted { lhs, rhs in
                (lhs.key?.sortOrder ?? Int.max) < (rhs.key?.sortOrder ?? Int.max)
            }
            .map { (category: $0.key, plants: $0.value.sorted { $0.index < $1.index }) }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                AppHeaderBar(title: "My Plants")

                searchField
                    .padding(.horizontal)
                    .padding(.bottom, 8)

                List {
                    ForEach(groupedByCategory, id: \.category?.persistentModelID) { group in
                        Section {
                            ForEach(group.plants) { plant in
                                NavigationLink {
                                    PlantDetailView(plant: plant)
                                } label: {
                                    PlantRow(plant: plant)
                                }
                            }
                        } header: {
                            if let category = group.category {
                                Text(category.name.uppercased())
                                    .foregroundStyle(Color(hex: category.colorHex))
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .scrollDismissesKeyboard(.immediately)
                .overlay {
                    if filteredPlants.isEmpty && !searchText.isEmpty {
                        ContentUnavailableView.search(text: searchText)
                    }
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    private var searchField: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)

            TextField("Search Latin or Dutch name", text: $searchText)
                .focused($isSearchFocused)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .submitLabel(.search)

            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .accessibilityLabel("Clear search")
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    PlantListView()
        .modelContainer(PreviewData.container)
}
