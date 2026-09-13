import Foundation
import SwiftData

/// A location on the garden map where a plant grows.
/// `x` and `y` are normalized (0...1) relative to the map image's width and height,
/// so pins stay valid regardless of how the map is scaled on screen.
@Model
final class PlantPin {
    var x: Double
    var y: Double
    var createdAt: Date
    var plant: Plant?

    init(x: Double, y: Double, plant: Plant? = nil) {
        self.x = x
        self.y = y
        self.createdAt = .now
        self.plant = plant
    }
}
