import SwiftUI

struct AppHeaderBar: View {
    let title: String

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Rectangle()
                .fill(AppTheme.brandGreen)
                .frame(height: 6)

            Text(title)
                .font(.largeTitle.bold())
                .padding(.horizontal)
                .padding(.top, 16)
                .padding(.bottom, 12)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color(.systemBackground))
    }
}

#Preview {
    AppHeaderBar(title: "Planten Lijst")
}
