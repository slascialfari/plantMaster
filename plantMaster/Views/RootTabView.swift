import SwiftUI

struct RootTabView: View {
    private enum Tab {
        case list
        case practice
    }

    @State private var selectedTab: Tab = .list

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                PlantListView()
                    .opacity(selectedTab == .list ? 1 : 0)
                    .allowsHitTesting(selectedTab == .list)

                PracticeView()
                    .opacity(selectedTab == .practice ? 1 : 0)
                    .allowsHitTesting(selectedTab == .practice)
            }

            footerBar
        }
    }

    private var footerBar: some View {
        HStack(spacing: 0) {
            tabButton(.list, icon: "list.bullet", label: "List")
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
