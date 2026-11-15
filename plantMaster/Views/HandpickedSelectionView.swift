import SwiftUI
import SwiftData

/// Sheet for choosing the Handpicked practice set: whole categories or single plants.
/// Only plants with a photo in the selected period are listed, since only those can be
/// practised there. Picks in other periods are kept but not shown.
struct HandpickedSelectionView: View {
    let period: PeriodSelection

    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Plant.index) private var plants: [Plant]

    private var activated: [Plant] {
        plants.filter { $0.isActivated && period.includes($0) }
    }

    private var sections: [PlantSection] {
        PlantSections.make(from: activated, labelPeriods: period == .all)
    }

    private var selectedCount: Int {
        activated.filter(\.isHandpicked).count
    }

    var body: some View {
        NavigationStack {
            List {
                if activated.isEmpty {
                    Text(period == .all
                         ? "Add a photo to a plant to be able to pick it."
                         : "Add a photo to a plant in \(period.label) to be able to pick it.")
                        .foregroundStyle(.secondary)
                }

                ForEach(sections) { section in
                    Section {
                        ForEach(section.plants) { plant in
                            plantRow(plant)
                        }
                    } header: {
                        VStack(alignment: .leading, spacing: 8) {
                            if section.showsPeriod, let studyPeriod = section.period {
                                Text(studyPeriod.title)
                                    .font(.headline)
                                    .foregroundStyle(.primary)
                                    .textCase(nil)
                            }
                            categoryHeader(section.category, plants: section.plants)
                        }
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
                        Text(subtitle)
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

    private var subtitle: String {
        let count = selectedCount == 1 ? "1 plant selected" : "\(selectedCount) plants selected"
        return period == .all ? count : "\(period.label) · \(count)"
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
                    if plant.hasDutchName {
                        Text(plant.dutchName)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
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
