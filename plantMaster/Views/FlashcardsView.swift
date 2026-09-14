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

    private enum Face: Int, CaseIterable {
        case photo
        case dutch
        case latin
    }

    /// Number of taps so far. Each tap turns the card half a rotation; the face shown is
    /// `tapCount % 3`, alternating between the physical front and back of the card.
    @State private var tapCount = 0

    private var angle: Double { Double(tapCount) * 180 }

    private var currentFace: Face { Face(rawValue: tapCount % 3)! }

    /// The face that is turning away during the current flip stays on the hidden side so
    /// the user never sees content change mid-turn.
    private var previousFace: Face { Face(rawValue: ((tapCount - 1) % 3 + 3) % 3)! }

    private var frontFace: Face { tapCount.isMultiple(of: 2) ? currentFace : previousFace }
    private var backFace: Face { tapCount.isMultiple(of: 2) ? previousFace : currentFace }

    var body: some View {
        Button {
            withAnimation(.spring(duration: 0.55, bounce: 0.15)) {
                tapCount += 1
            }
        } label: {
            FlipCard(angle: angle) {
                face(frontFace)
            } back: {
                face(backFace)
            }
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color.gray.opacity(0.25))
            )
            .shadow(color: .black.opacity(0.12), radius: 12, y: 6)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(accessibilityText)
        .accessibilityHint("Tap to turn the card")
    }

    private var accessibilityText: String {
        switch currentFace {
        case .photo: return "Photo of a plant"
        case .dutch: return "Dutch name: \(plant.dutchName)"
        case .latin: return "Latin name: \(plant.latinName)"
        }
    }

    // MARK: - Faces

    @ViewBuilder
    private func face(_ face: Face) -> some View {
        switch face {
        case .photo:
            photoFace
        case .dutch:
            nameFace(
                caption: "Dutch name",
                name: plant.dutchName,
                background: AppTheme.brandGreen,
                hint: "Tap for the Latin name"
            )
        case .latin:
            nameFace(
                caption: "Latin name",
                name: plant.latinName,
                background: Color(hex: "#1F5E3D"),
                hint: "Tap to go back to the photo",
                italic: true
            )
        }
    }

    private var photoFace: some View {
        ZStack(alignment: .bottom) {
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

            Text("Tap to reveal the Dutch name")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(.black.opacity(0.45), in: Capsule())
                .padding(.bottom, 14)
        }
        .clipped()
    }

    private func nameFace(caption: String, name: String, background: Color, hint: String, italic: Bool = false) -> some View {
        ZStack {
            background
            VStack(spacing: 14) {
                Text(caption.uppercased())
                    .font(.caption.weight(.bold))
                    .tracking(1.5)
                    .foregroundStyle(.white.opacity(0.7))
                Text(name)
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .italic(italic)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.6)
                    .padding(.horizontal, 24)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            VStack {
                Spacer()
                Text(hint)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.85))
                    .padding(.bottom, 14)
            }
        }
    }
}

/// Rotates between a front and a back view around the vertical axis. Conforms to
/// `Animatable` so the visible side switches exactly at the 90° mark during the animation.
private struct FlipCard<Front: View, Back: View>: View, Animatable {
    var angle: Double
    let front: Front
    let back: Back

    init(angle: Double, @ViewBuilder front: () -> Front, @ViewBuilder back: () -> Back) {
        self.angle = angle
        self.front = front()
        self.back = back()
    }

    var animatableData: Double {
        get { angle }
        set { angle = newValue }
    }

    private var showsBack: Bool {
        let normalized = ((angle.truncatingRemainder(dividingBy: 360)) + 360).truncatingRemainder(dividingBy: 360)
        return normalized > 90 && normalized < 270
    }

    var body: some View {
        ZStack {
            front
                .opacity(showsBack ? 0 : 1)
            back
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                .opacity(showsBack ? 1 : 0)
        }
        .rotation3DEffect(.degrees(angle), axis: (x: 0, y: 1, z: 0), perspective: 0.45)
    }
}

#Preview {
    FlashcardsView(plants: [
        Plant(index: 1, latinName: "Acer campestre", dutchName: "veldesdoorn, Spaanse aak"),
        Plant(index: 2, latinName: "Acer platanoides", dutchName: "Noorse esdoorn"),
    ])
}
