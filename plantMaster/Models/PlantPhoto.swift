import Foundation
import SwiftData

@Model
final class PlantPhoto {
    var filename: String
    var sortOrder: Int
    /// How many times this photo has been the one shown in practice or flashcards.
    /// Used to rotate through a plant's photos evenly. Defaults to 0 for existing photos.
    var timesShown: Int = 0
    /// When this photo was last shown, so the same photo is never shown twice in a row.
    var lastShownAt: Date? = nil

    init(filename: String, sortOrder: Int) {
        self.filename = filename
        self.sortOrder = sortOrder
        self.timesShown = 0
    }
}
