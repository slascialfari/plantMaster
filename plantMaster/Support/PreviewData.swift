import Foundation
import SwiftData

@MainActor
enum PreviewData {
    static let container: ModelContainer = {
        let schema = Schema([Category.self, Plant.self, PlantPhoto.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: schema, configurations: [config])
        PlantSeedData.seedIfNeeded(context: container.mainContext)
        return container
    }()
}
