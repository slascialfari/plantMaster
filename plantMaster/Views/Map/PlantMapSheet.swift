import SwiftUI
import SwiftData

/// Full-screen map for a single plant. In edit mode, tapping the map adds a pin
/// and tapping an existing pin offers to remove it.
struct PlantMapSheet: View {
    @Bindable var plant: Plant
    let isEditing: Bool

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var pinToRemove: PlantPin?

    private var markers: [MapPinMarker] {
        let color = plant.category.map { Color(hex: $0.colorHex) } ?? AppTheme.brandGreen
        return plant.sortedPins.map { pin in
            MapPinMarker(id: pin.persistentModelID, x: pin.x, y: pin.y, label: "\(plant.index)", color: color)
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if isEditing {
                    HStack(spacing: 8) {
                        Image(systemName: "hand.tap")
                        Text("Tap the map to add a pin. Tap a pin to remove it.")
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.secondarySystemBackground))
                }

                MapCanvasView(
                    markers: markers,
                    onTapMap: isEditing ? { point in addPin(at: point) } : nil,
                    onTapMarker: isEditing ? { marker in
                        pinToRemove = plant.pins.first { $0.persistentModelID == marker.id }
                    } : nil
                )
                .ignoresSafeArea(edges: .bottom)
            }
            .navigationTitle(plant.latinName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text(pinCountLabel)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .fontWeight(.semibold)
                }
            }
            .confirmationDialog("Remove this pin?", isPresented: Binding(
                get: { pinToRemove != nil },
                set: { if !$0 { pinToRemove = nil } }
            ), titleVisibility: .visible) {
                Button("Remove pin", role: .destructive) {
                    if let pin = pinToRemove { removePin(pin) }
                    pinToRemove = nil
                }
                Button("Cancel", role: .cancel) { pinToRemove = nil }
            }
        }
    }

    private var pinCountLabel: String {
        let count = plant.pins.count
        return count == 1 ? "1 pin" : "\(count) pins"
    }

    private func addPin(at point: CGPoint) {
        let pin = PlantPin(x: point.x, y: point.y, plant: plant)
        modelContext.insert(pin)
        plant.pins.append(pin)
        try? modelContext.save()
    }

    private func removePin(_ pin: PlantPin) {
        plant.pins.removeAll { $0.persistentModelID == pin.persistentModelID }
        modelContext.delete(pin)
        try? modelContext.save()
    }
}

#Preview {
    PlantMapSheet(plant: Plant(index: 1, latinName: "Acer campestre", dutchName: "veldesdoorn, Spaanse aak"), isEditing: true)
        .modelContainer(PreviewData.container)
}
