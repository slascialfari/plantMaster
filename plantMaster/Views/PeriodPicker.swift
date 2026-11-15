import SwiftUI

/// A row of chips for choosing which period's plants to show: one per period, then All.
/// The choice is stored app-wide, so the List and Practice tabs always show the same period.
/// Scrolls sideways once there are more periods than fit on screen.
struct PeriodPicker: View {
    @AppStorage(PeriodSelection.storageKey) private var selectionRaw = PeriodSelection.defaultRawValue

    private var selection: PeriodSelection {
        PeriodSelection(rawValue: selectionRaw)
    }

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(PeriodSelection.choices, id: \.self) { choice in
                        chip(choice)
                            .id(choice)
                    }
                }
                .padding(.horizontal)
            }
            .onAppear {
                proxy.scrollTo(selection, anchor: .center)
            }
        }
    }

    private func chip(_ choice: PeriodSelection) -> some View {
        let isSelected = choice == selection
        return Button {
            withAnimation(.snappy) { selectionRaw = choice.rawValue }
        } label: {
            Text(choice.label)
                .font(.subheadline.weight(.semibold))
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .foregroundStyle(isSelected ? .white : AppTheme.brandGreen)
                .background(
                    Capsule().fill(isSelected ? AppTheme.brandGreen : AppTheme.brandGreen.opacity(0.12))
                )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(accessibilityLabel(for: choice))
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    private func accessibilityLabel(for choice: PeriodSelection) -> String {
        switch choice {
        case .period(let period): return period.title
        case .all: return "All periods"
        }
    }
}

/// Section header for a plant list: the category name, with the period's title above it
/// in an All periods list.
struct PlantSectionHeader: View {
    let section: PlantSection

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if section.showsPeriod, let period = section.period {
                Text(period.title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .textCase(nil)
            }
            if let category = section.category {
                Text(category.name.uppercased())
                    .foregroundStyle(Color(hex: category.colorHex))
            }
        }
    }
}

#Preview {
    PeriodPicker()
}
