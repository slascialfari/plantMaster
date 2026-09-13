import SwiftUI
import SwiftData

struct PlantListView: View {
    @Query(sort: \Plant.index) private var plants: [Plant]

    private var groupedByCategory: [(category: Category?, plants: [Plant])] {
        let groups = Dictionary(grouping: plants) { $0.category }
        return groups
            .sorted { lhs, rhs in
                (lhs.key?.sortOrder ?? Int.max) < (rhs.key?.sortOrder ?? Int.max)
            }
            .map { (category: $0.key, plants: $0.value.sorted { $0.index < $1.index }) }
    }

    var body: some View {
        NavigationStack {
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
            .navigationTitle("Planten Lijst")
        }
    }
}

#Preview {
    PlantListView()
        .modelContainer(PreviewData.container)
}
