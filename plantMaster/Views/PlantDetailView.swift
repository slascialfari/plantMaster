import SwiftUI
import SwiftData
import UIKit

struct PlantDetailView: View {
    @Bindable var plant: Plant
    @Environment(\.modelContext) private var modelContext

    @State private var isEditing = false
    @State private var isShowingMap = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                photoSection

                VStack(alignment: .leading, spacing: 4) {
                    Text("\(plant.index). \(plant.latinName)")
                        .font(.title2.weight(.semibold))
                        .italic()
                    Text(plant.dutchName)
                        .font(.title3)
                        .foregroundStyle(.secondary)
                    if let category = plant.category {
                        Text(category.name)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Color(hex: category.colorHex))
                    }
                }
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Notes")
                        .font(.headline)
                    if isEditing {
                        PlantNotesEditor(plant: plant)
                    } else if plant.notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        Text("No notes yet. Tap Edit to add some.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    } else {
                        Text(plant.notes)
                            .font(.body)
                            .textSelection(.enabled)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(.horizontal)

                mapSection
                    .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .fullScreenCover(isPresented: $isShowingMap) {
            PlantMapSheet(plant: plant, isEditing: isEditing)
        }
        .navigationTitle("Plant Detail")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(isEditing ? "Done" : "Edit") {
                    isEditing.toggle()
                }
            }
        }
    }

    private var pinMarkers: [MapPinMarker] {
        let color = plant.category.map { Color(hex: $0.colorHex) } ?? AppTheme.brandGreen
        return plant.sortedPins.map { pin in
            MapPinMarker(id: pin.persistentModelID, x: pin.x, y: pin.y, label: "\(plant.index)", color: color)
        }
    }

    private var mapSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Map")
                    .font(.headline)
                Spacer()
                Text(plant.pins.count == 1 ? "1 pin" : "\(plant.pins.count) pins")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Button {
                isShowingMap = true
            } label: {
                MapCanvasView(markers: pinMarkers, isInteractive: false)
                    .frame(height: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3))
                    )
                    .overlay(alignment: .bottomTrailing) {
                        Image(systemName: isEditing ? "mappin.and.ellipse" : "arrow.up.left.and.arrow.down.right")
                            .font(.caption.weight(.semibold))
                            .padding(8)
                            .background(.regularMaterial, in: Circle())
                            .padding(8)
                    }
            }
            .buttonStyle(.plain)

            if isEditing {
                Button {
                    isShowingMap = true
                } label: {
                    Label("Edit pins on map", systemImage: "mappin.and.ellipse")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .tint(AppTheme.brandGreen)
            } else if plant.pins.isEmpty {
                Text("No pins yet. Tap Edit to place this plant on the map.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    @ViewBuilder
    private var photoSection: some View {
        let photos = plant.sortedPhotos

        VStack(spacing: 8) {
            if photos.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "leaf")
                        .font(.system(size: 48))
                        .foregroundStyle(.secondary)
                    Text("Add a photo to activate this plant")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    AddPhotoMenu { image in
                        addPhoto(image)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 220)
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
            } else {
                TabView {
                    ForEach(photos) { photo in
                        if let image = PhotoStore.display(filename: photo.filename) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .tag(photo.id)
                        }
                    }
                }
                .tabViewStyle(.page)
                .frame(height: 260)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)

                if isEditing {
                    photoThumbnailStrip(photos: photos)
                }
            }
        }
    }

    private func photoThumbnailStrip(photos: [PlantPhoto]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Drag to reorder, swipe to delete")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.horizontal)

            List {
                ForEach(photos) { photo in
                    HStack(spacing: 12) {
                        if let image = PhotoStore.thumbnail(filename: photo.filename) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 48, height: 48)
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                        Text("Photo \(photo.sortOrder + 1)")
                        Spacer()
                    }
                }
                .onDelete { offsets in
                    for index in offsets {
                        deletePhoto(photos[index])
                    }
                }
                .onMove { source, destination in
                    reorderPhotos(photos, from: source, to: destination)
                }
            }
            .listStyle(.plain)
            .frame(height: CGFloat(photos.count) * 60 + 16)
            .environment(\.editMode, .constant(.active))

            AddPhotoMenu { image in
                addPhoto(image)
            }
            .padding(.horizontal)
        }
    }

    private func addPhoto(_ image: UIImage) {
        guard let filename = PhotoStore.save(image) else { return }
        let nextOrder = (plant.photos.map(\.sortOrder).max() ?? -1) + 1
        let photo = PlantPhoto(filename: filename, sortOrder: nextOrder)
        modelContext.insert(photo)
        plant.photos.append(photo)
        try? modelContext.save()
    }

    private func deletePhoto(_ photo: PlantPhoto) {
        PhotoStore.delete(filename: photo.filename)
        plant.photos.removeAll { $0.id == photo.id }
        modelContext.delete(photo)
        try? modelContext.save()
    }

    private func reorderPhotos(_ photos: [PlantPhoto], from source: IndexSet, to destination: Int) {
        var ordered = photos
        ordered.move(fromOffsets: source, toOffset: destination)
        for (index, photo) in ordered.enumerated() {
            photo.sortOrder = index
        }
        try? modelContext.save()
    }
}

#Preview {
    NavigationStack {
        PlantDetailView(plant: Plant(index: 1, latinName: "Acer campestre", dutchName: "veldesdoorn, Spaanse aak"))
    }
    .modelContainer(PreviewData.container)
}
