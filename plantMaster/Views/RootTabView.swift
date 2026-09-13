import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            PlantListView()
                .tabItem {
                    Label("List", systemImage: "list.bullet")
                }

            PracticeView()
                .tabItem {
                    Label("Practice", systemImage: "gamecontroller")
                }
        }
    }
}

#Preview {
    RootTabView()
        .modelContainer(PreviewData.container)
}
