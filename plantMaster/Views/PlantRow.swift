import SwiftUI
import UIKit

struct PlantRow: View {
    let plant: Plant

    private var thumbnail: UIImage? {
        guard let first = plant.sortedPhotos.first else { return nil }
        return PhotoStore.thumbnail(filename: first.filename)
    }

    var body: some View {
        HStack(spacing: 12) {
            if let category = plant.category {
                Rectangle()
                    .fill(Color(hex: category.colorHex))
                    .frame(width: 3)
            }

            Text("\(plant.index)")
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(width: 24, alignment: .leading)

            Group {
                if let thumbnail {
                    Image(uiImage: thumbnail)
                        .resizable()
                        .scaledToFill()
                } else {
                    Image(systemName: "leaf.fill")
                        .resizable()
                        .scaledToFit()
                        .padding(8)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: 44, height: 44)
            .background(Color.gray.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 2) {
                Text(plant.latinName)
                    .font(.body.weight(.semibold))
                    .italic()
                Text(plant.dutchName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(.vertical, 4)
        .opacity(plant.isActivated ? 1.0 : 0.4)
        .saturation(plant.isActivated ? 1.0 : 0.0)
    }
}

#Preview {
    List {
        PlantRow(plant: Plant(index: 1, latinName: "Acer campestre", dutchName: "veldesdoorn, Spaanse aak"))
    }
}
