import SwiftUI
import SwiftData

struct PlantListView: View {
    @Query(sort: \Plant.index) private var plants: [Plant]

    @AppStorage(PeriodSelection.storageKey) private var periodRaw = PeriodSelection.defaultRawValue
    @State private var searchText = ""
    @FocusState private var isSearchFocused: Bool

    private var period: PeriodSelection {
        PeriodSelection(rawValue: periodRaw)
    }

    /// The selected period's plants, before search.
    private var periodPlants: [Plant] {
        plants.filter { period.includes($0) }
    }

    /// Plants whose Latin or Dutch name has a word starting with the search text, or whose list
    /// number matches. "cer" finds "Cercis" but not "Acer". Case, accents, quotes and the
    /// hybrid sign are ignored, so "magnolia x" finds "Magnolia × soulangeana".
    private var filteredPlants: [Plant] {
        let query = StringNormalization.normalize(searchText)
        guard !query.isEmpty else {
            let trimmed = searchText.trimmingCharacters(in: .whitespaces)
            if let number = Int(trimmed) {
                return periodPlants.filter { $0.index == number }
            }
            return periodPlants
        }
        return periodPlants.filter { plant in
            Self.hasWord(startingWith: query, in: plant.latinName)
                || Self.hasWord(startingWith: query, in: plant.dutchName)
        }
    }

    private static func hasWord(startingWith query: String, in name: String) -> Bool {
        let normalized = StringNormalization.normalize(name)
        return normalized.hasPrefix(query) || normalized.contains(" " + query)
    }

    private var sections: [PlantSection] {
        PlantSections.make(from: filteredPlants, labelPeriods: period == .all)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                AppHeaderBar(title: "My Plants")

                PeriodPicker()
                    .padding(.bottom, 10)

                searchField
                    .padding(.horizontal)
                    .padding(.bottom, 8)

                List {
                    ForEach(sections) { section in
                        Section {
                            ForEach(section.plants) { plant in
                                NavigationLink {
                                    PlantDetailView(plant: plant)
                                } label: {
                                    PlantRow(plant: plant)
                                }
                            }
                        } header: {
                            PlantSectionHeader(section: section)
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
