import Foundation
import SwiftData

@Model
final class Plant {
    var index: Int
    var latinName: String
    var dutchName: String
    var notes: String
    var category: Category?

    @Relationship(deleteRule: .cascade)
    var photos: [PlantPhoto] = []

    var isActivated: Bool {
        !photos.isEmpty
    }

    var sortedPhotos: [PlantPhoto] {
        photos.sorted { $0.sortOrder < $1.sortOrder }
    }

    init(index: Int, latinName: String, dutchName: String, notes: String = "", category: Category? = nil) {
        self.index = index
        self.latinName = latinName
        self.dutchName = dutchName
        self.notes = notes
        self.category = category
    }
}
