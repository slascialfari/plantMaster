import Foundation
import SwiftData

@Model
final class Plant {
    /// Number on the school's list. Unique within a period, not across periods.
    var index: Int
    /// The `StudyPeriod` this plant is studied in. Plants saved before periods existed were
    /// all from Year 1 · Trimester 1, hence the default.
    var periodID: String = "y1t1"
    var latinName: String
    var dutchName: String
    var notes: String
    var category: Category?
    /// Marked by the student as already learned. Known plants are left out of practice
    /// unless the Practice filter is set to All.
    var isKnown: Bool = false
    /// Chosen for the Handpicked practice set. Independent of `isKnown`.
    var isHandpicked: Bool = false

    @Relationship(deleteRule: .cascade)
    var photos: [PlantPhoto] = []

    @Relationship(deleteRule: .cascade, inverse: \PlantPin.plant)
    var pins: [PlantPin] = []

    var period: StudyPeriod? {
        StudyPeriod.with(id: periodID)
    }

    /// False for the few plants whose school list gives no Dutch name ("-"). Those are
    /// stored with an empty Dutch name and never asked for one in practice.
    var hasDutchName: Bool {
        !dutchName.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var isActivated: Bool {
        !photos.isEmpty
    }

    var sortedPhotos: [PlantPhoto] {
        photos.sorted { $0.sortOrder < $1.sortOrder }
    }

    var sortedPins: [PlantPin] {
        pins.sorted { $0.createdAt < $1.createdAt }
    }

    init(
        index: Int,
        periodID: String = StudyPeriod.y1t1.id,
        latinName: String,
        dutchName: String,
        notes: String = "",
        category: Category? = nil
    ) {
        self.index = index
        self.periodID = periodID
        self.latinName = latinName
        self.dutchName = dutchName
        self.notes = notes
        self.category = category
    }
}
