import Foundation
import SwiftData

@Model
final class PlantPhoto {
    var filename: String
    var sortOrder: Int

    init(filename: String, sortOrder: Int) {
        self.filename = filename
        self.sortOrder = sortOrder
    }
}
