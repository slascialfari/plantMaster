import Foundation
import SwiftData

@Model
final class Plant {
    var index: Int
    var latinName: String
    var dutchName: String
    var notes: String
    var category: Category?
    /// Marked by the student as already learned. Known plants are left out of practice
    /// unless the Practice filter is set to All.
    var isKnown: Bool = false

    @Relationship(deleteRule: .cascade)
    var photos: [PlantPhoto] = []

    @Relationship(deleteRule: .cascade, inverse: \PlantPin.plant)
    var pins: [PlantPin] = []

    var isActivated: Bool {
        !photos.isEmpty
    }

    var sortedPhotos: [PlantPhoto] {
        photos.sorted { $0.sortOrder < $1.sortOrder }
    }

    var sortedPins: [PlantPin] {
        pins.sorted { $0.createdAt < $1.createdAt }
    }

    init(index: Int, latinName: String, dutchName: String, notes: String = "", category: Category? = nil) {
        self.index = index
        self.latinName = latinName
        self.dutchName = dutchName
        self.notes = notes
        self.category = category
    }
}
