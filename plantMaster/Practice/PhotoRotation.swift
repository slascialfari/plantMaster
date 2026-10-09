import Foundation

/// Chooses which of a plant's photos to show in practice and flashcards.
///
/// Picks at random among the photos shown the fewest times, so every photo gets its turn
/// before any repeats: two photos alternate, three are all shown before the first comes
/// back, and a newly added photo is shown next. The photo shown most recently is never
/// picked again straight away when there is any other choice.
enum PhotoRotation {
    static func pick(from photos: [PlantPhoto]) -> PlantPhoto? {
        guard let fewest = photos.map(\.timesShown).min() else { return nil }
        var candidates = photos.filter { $0.timesShown == fewest }

        let mostRecent = photos
            .filter { $0.lastShownAt != nil }
            .max { $0.lastShownAt! < $1.lastShownAt! }
        if candidates.count > 1, let mostRecent {
            candidates.removeAll { $0 === mostRecent }
        }
        return candidates.randomElement()
    }

    /// Records that `photo` was actually put on screen.
    static func markShown(_ photo: PlantPhoto?) {
        guard let photo else { return }
        photo.timesShown += 1
        photo.lastShownAt = .now
    }
}
