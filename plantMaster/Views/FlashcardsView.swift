import SwiftUI
import UIKit

/// A swipeable deck of flip cards. Each card starts as a photo; tapping reveals the Dutch
/// name, tapping again reveals the Latin name.
struct FlashcardsView: View {
    let plants: [Plant]

    @State private var currentIndex = 0

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("\(min(currentIndex + 1, plants.count)) of \(plants.count)")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
                Spacer()
                Text("Swipe for the next plant")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal)
            .padding(.top, 4)

            TabView(selection: $currentIndex) {
                ForEach(Array(plants.enumerated()), id: \.element.persistentModelID) { index, plant in
                    FlashcardView(plant: plant)
                        .padding(.horizontal)
                        .padding(.bottom, 24)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.default, value: currentIndex)

            ProgressView(value: plants.isEmpty ? 0 : Double(currentIndex + 1), total: Double(max(plants.count, 1)))
                .padding(.horizontal)
                .padding(.bottom, 12)
        }
    }
}

private struct FlashcardView: View {
    let plant: Plant

    private enum Reveal: Int {
        case photo
        case dutch
        case latin

        var next: Reveal {
            Reveal(rawValue: rawValue + 1) ?? .photo
        }
    }

    @State private var reveal: Reveal = .photo

    var body: some View {
        Button {
            withAnimation(.spring(duration: 0.3)) {
                reveal = reveal.next
            }
        } label: {
            VStack(spacing: 0) {
                photo
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: .infinity)
                    .clipped()

                VStack(spacing: 8) {
                    if reveal.rawValue >= Reveal.dutch.rawValue {
                        Text(plant.dutchName)
                            .font(.title2.weight(.semibold))
                            .multilineTextAlignment(.center)
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }
                    if reveal.rawValue >= Reveal.latin.rawValue {
                        Text(plant.latinName)
                            .font(.title3)
                            .italic()
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }

                    Text(hint)
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                        .padding(.top, reveal == .photo ? 0 : 4)
                }
                .frame(maxWidth: .infinity)
                .frame(minHeight: 120)
                .padding()
                .background(Color(.secondarySystemBackground))
            }
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color.gray.opacity(0.25))
            )
            .shadow(color: .black.opacity(0.08), radius: 10, y: 4)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private var hint: String {
        switch reveal {
        case .photo: return "Tap to reveal the Dutch name"
        case .dutch: return "Tap to reveal the Latin name"
        case .latin: return "Tap to hide the names"
        }
    }

    @ViewBuilder
    private var photo: some View {
        if let first = plant.sortedPhotos.first,
           let image = PhotoStore.display(filename: first.filename) {
            Color.clear
                .overlay(
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                )
        } else {
            ZStack {
                Color.gray.opacity(0.1)
                Image(systemName: "leaf.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    FlashcardsView(plants: [
        Plant(index: 1, latinName: "Acer campestre", dutchName: "veldesdoorn, Spaanse aak"),
        Plant(index: 2, latinName: "Acer platanoides", dutchName: "Noorse esdoorn"),
    ])
}
