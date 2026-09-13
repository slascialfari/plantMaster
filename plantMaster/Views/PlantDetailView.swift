import SwiftUI
import SwiftData
import UIKit

struct PlantDetailView: View {
    @Bindable var plant: Plant
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Category.sortOrder) private var categories: [Category]

    @State private var isEditing = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                photoSection

                if isEditing {
                    VStack(alignment: .leading, spacing: 8) {
                        TextField("Latin name", text: $plant.latinName)
                            .font(.title3.weight(.semibold))
                            .textFieldStyle(.roundedBorder)
                        TextField("Dutch name", text: $plant.dutchName)
                            .textFieldStyle(.roundedBorder)
                        categoryPicker
                    }
                    .padding(.horizontal)
                } else {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(plant.index). \(plant.latinName)")
                            .font(.title2.weight(.semibold))
                            .italic()
                        Text(plant.dutchName)
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Notes")
                        .font(.headline)
                    TextEditor(text: $plant.notes)
                        .frame(minHeight: 120)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3))
                        )
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
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
                        if let image = PhotoStore.load(filename: photo.filename) {
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
                        if let image = PhotoStore.load(filename: photo.filename) {
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

    private var categoryPicker: some View {
        Picker("Category", selection: Binding(
            get: { plant.category },
            set: { plant.category = $0 }
        )) {
            Text("None").tag(Category?.none)
            ForEach(categories) { category in
                Text(category.name).tag(Category?.some(category))
            }
        }
        .pickerStyle(.menu)
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
