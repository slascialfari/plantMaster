import SwiftUI
import SwiftData

/// The Map tab: every pin from every plant on one zoomable map.
struct MapExploreView: View {
    @Query(sort: \Plant.index) private var plants: [Plant]

    @State private var selectedPlant: Plant?
    @State private var plantToOpen: Plant?

    private var pinnedPlants: [Plant] {
        plants.filter { !$0.pins.isEmpty }
    }

    private var markers: [MapPinMarker] {
        pinnedPlants.flatMap { plant in
            let color = plant.category.map { Color(hex: $0.colorHex) } ?? AppTheme.brandGreen
            return plant.sortedPins.map { pin in
                MapPinMarker(id: pin.persistentModelID, x: pin.x, y: pin.y, label: "\(plant.index)", color: color)
            }
        }
    }

    private var plantByMarkerID: [PersistentIdentifier: Plant] {
        var lookup: [PersistentIdentifier: Plant] = [:]
        for plant in pinnedPlants {
            for pin in plant.pins {
                lookup[pin.persistentModelID] = plant
            }
        }
        return lookup
    }

    private var selectedMarkerIDs: Set<PersistentIdentifier> {
        guard let selectedPlant else { return [] }
        return Set(selectedPlant.pins.map(\.persistentModelID))
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                AppHeaderBar(title: "Map")

                ZStack(alignment: .bottom) {
                    MapCanvasView(
                        markers: markers,
                        selectedMarkerIDs: selectedMarkerIDs,
                        onTapMap: { _ in
                            withAnimation { selectedPlant = nil }
                        },
                        onTapMarker: { marker in
                            withAnimation { selectedPlant = plantByMarkerID[marker.id] }
                        }
                    )

                    if markers.isEmpty {
                        emptyState
                    }

                    if let selectedPlant {
                        selectedCard(for: selectedPlant)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(item: $plantToOpen) { plant in
                PlantDetailView(plant: plant)
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 8) {
            Image(systemName: "mappin.slash")
                .font(.system(size: 32))
            Text("No pins yet")
                .font(.headline)
            Text("Open a plant, tap Edit, and add pins to the map.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
        }
        .foregroundStyle(.secondary)
        .padding(20)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 14))
        .padding()
        .frame(maxHeight: .infinity, alignment: .center)
        .allowsHitTesting(false)
    }

    private func selectedCard(for plant: Plant) -> some View {
        HStack(spacing: 12) {
            PlantRow(plant: plant)
                .saturation(1)
                .opacity(1)

            Button {
                plantToOpen = plant
            } label: {
                Image(systemName: "chevron.right.circle.fill")
                    .font(.title2)
                    .foregroundStyle(AppTheme.brandGreen)
            }
            .accessibilityLabel("Open plant")
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 14))
        .overlay(alignment: .topTrailing) {
            Button {
                withAnimation { selectedPlant = nil }
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.body)
                    .foregroundStyle(.secondary)
            }
            .padding(6)
            .accessibilityLabel("Dismiss")
        }
        .padding(.horizontal)
        .padding(.bottom, 12)
    }
}

#Preview {
    MapExploreView()
        .modelContainer(PreviewData.container)
}
