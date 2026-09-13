import Foundation
import SwiftData

@Model
final class Category {
    var name: String
    var colorHex: String
    var sortOrder: Int

    @Relationship(deleteRule: .nullify, inverse: \Plant.category)
    var plants: [Plant] = []

    init(name: String, colorHex: String, sortOrder: Int) {
        self.name = name
        self.colorHex = colorHex
        self.sortOrder = sortOrder
    }
}
