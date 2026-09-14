import SwiftUI

struct RootTabView: View {
    private enum Tab {
        case list
        case map
        case practice
    }

    @State private var selectedTab: Tab = .list
    @State private var keyboard = KeyboardObserver()
    @State private var footerHeight: CGFloat = 0

    var body: some View {
        GeometryReader { geo in
            // The footer stays put and is covered by the keyboard, like a native tab bar.
            // Only the content shrinks, by however much the keyboard reaches above the footer.
            let keyboardOverlap = max(0, keyboard.height - footerHeight - geo.safeAreaInsets.bottom)

            VStack(spacing: 0) {
                ZStack {
                    PlantListView()
                        .opacity(selectedTab == .list ? 1 : 0)
                        .allowsHitTesting(selectedTab == .list)

                    MapExploreView()
                        .opacity(selectedTab == .map ? 1 : 0)
                        .allowsHitTesting(selectedTab == .map)

                    PracticeView()
                        .opacity(selectedTab == .practice ? 1 : 0)
                        .allowsHitTesting(selectedTab == .practice)
                }
                .padding(.bottom, keyboardOverlap)

                footerBar
                    .onGeometryChange(for: CGFloat.self) { proxy in
                        proxy.size.height
                    } action: { newHeight in
                        footerHeight = newHeight
                    }
            }
        }
        .ignoresSafeArea(.keyboard)
        .task { MapImageLoader.shared.loadIfNeeded() }
    }

    private var footerBar: some View {
        HStack(spacing: 0) {
            tabButton(.list, icon: "list.bullet", label: "List")
            tabButton(.map, icon: "map", label: "Map")
            tabButton(.practice, icon: "brain.head.profile", label: "Practice")
        }
        .padding(.top, 10)
        .padding(.bottom, 8)
        .background(AppTheme.brandGreen.ignoresSafeArea(edges: .bottom))
    }

    private func tabButton(_ tab: Tab, icon: String, label: String) -> some View {
        Button {
            selectedTab = tab
        } label: {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                Text(label)
                    .font(.caption.weight(.semibold))
            }
            .frame(maxWidth: .infinity)
            .foregroundStyle(selectedTab == tab ? .white : .white.opacity(0.65))
        }
    }
}

#Preview {
    RootTabView()
        .modelContainer(PreviewData.container)
}
