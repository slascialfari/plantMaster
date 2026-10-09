import SwiftUI
import SwiftData

/// Sheet for choosing the Handpicked practice set: whole categories or single plants.
/// Only plants with a photo are listed, since only those can be practised.
struct HandpickedSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Plant.index) private var plants: [Plant]

    private var activated: [Plant] {
        plants.filter(\.isActivated)
    }

    private var groups: [(category: Category?, plants: [Plant])] {
        Dictionary(grouping: activated) { $0.category }
            .sorted { ($0.key?.sortOrder ?? Int.max) < ($1.key?.sortOrder ?? Int.max) }
            .map { (category: $0.key, plants: $0.value.sorted { $0.index < $1.index }) }
    }

    private var selectedCount: Int {
        activated.filter(\.isHandpicked).count
    }

    var body: some View {
        NavigationStack {
            List {
                if activated.isEmpty {
                    Text("Add a photo to a plant to be able to pick it.")
                        .foregroundStyle(.secondary)
                }

                ForEach(groups, id: \.category?.persistentModelID) { group in
                    Section {
                        ForEach(group.plants) { plant in
                            plantRow(plant)
                        }
                    } header: {
                        categoryHeader(group.category, plants: group.plants)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Handpicked")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Clear") {
                        setSelected(activated, to: false)
                    }
                    .disabled(selectedCount == 0)
                }
                ToolbarItem(placement: .principal) {
                    VStack(spacing: 0) {
                        Text("Handpicked").font(.headline)
                        Text(selectedCount == 1 ? "1 plant selected" : "\(selectedCount) plants selected")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .fontWeight(.semibold)
                }
            }
        }
    }

    // MARK: - Rows

    private func plantRow(_ plant: Plant) -> some View {
        Button {
            withAnimation(.snappy) { plant.isHandpicked.toggle() }
        } label: {
            HStack(spacing: 12) {
                selectionIcon(plant.isHandpicked ? .all : .none)
                VStack(alignment: .leading, spacing: 2) {
                    Text(plant.latinName)
                        .italic()
                        .foregroundStyle(.primary)
                    Text(plant.dutchName)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                if plant.isKnown {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundStyle(AppTheme.brandGreen.opacity(0.6))
                        .accessibilityLabel("Known")
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(plant.isHandpicked ? .isSelected : [])
    }

    private func categoryHeader(_ category: Category?, plants: [Plant]) -> some View {
        let picked = plants.filter(\.isHandpicked).count
        let state: SelectionState = picked == 0 ? .none : (picked == plants.count ? .all : .some)

        return Button {
            withAnimation(.snappy) { setSelected(plants, to: state != .all) }
        } label: {
            HStack(spacing: 12) {
                selectionIcon(state)
                Text((category?.name ?? "Other").uppercased())
                    .foregroundStyle(category.map { Color(hex: $0.colorHex) } ?? .secondary)
                Spacer()
                Text("\(picked)/\(plants.count)")
                    .foregroundStyle(.secondary)
            }
            .font(.footnote.weight(.semibold))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(category?.name ?? "Other"), \(picked) of \(plants.count) selected")
        .accessibilityHint(state == .all ? "Deselects the whole category" : "Selects the whole category")
    }

    private enum SelectionState {
        case none, some, all
    }

    private func selectionIcon(_ state: SelectionState) -> some View {
        let name: String
        switch state {
        case .none: name = "circle"
        case .some: name = "minus.circle.fill"
        case .all: name = "checkmark.circle.fill"
        }
        return Image(systemName: name)
            .font(.title3)
            .foregroundStyle(state == .none ? Color.secondary : AppTheme.brandGreen)
    }

    private func setSelected(_ plants: [Plant], to value: Bool) {
        for plant in plants {
            plant.isHandpicked = value
        }
    }
}
