import SwiftUI
import SwiftData

@main
struct plantMasterApp: App {
    let modelContainer: ModelContainer = {
        let schema = Schema([Category.self, Plant.self, PlantPhoto.self])
        let config = ModelConfiguration(schema: schema)
        let container = try! ModelContainer(for: schema, configurations: [config])
        PlantSeedData.seedIfNeeded(context: container.mainContext)
        return container
    }()

    var body: some Scene {
        WindowGroup {
            RootTabView()
        }
        .modelContainer(modelContainer)
    }
}
