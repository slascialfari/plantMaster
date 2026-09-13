import SwiftUI

/// The app-wide header: a brand-green bar with the app icon in the centre and an optional
/// back button on the left, followed by the screen's large title.
struct AppHeaderBar: View {
    let title: String
    var backTitle: String? = nil
    var onBack: (() -> Void)? = nil

    private let barHeight: CGFloat = 52

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack {
                Image("HeaderIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .strokeBorder(.white.opacity(0.35), lineWidth: 1)
                    )
                    .accessibilityHidden(true)

                HStack {
                    if let onBack {
                        Button(action: onBack) {
                            HStack(spacing: 4) {
                                Image(systemName: "chevron.left")
                                    .font(.body.weight(.semibold))
                                Text(backTitle ?? "Back")
                                    .font(.body)
                            }
                            .foregroundStyle(.white)
                            .padding(.vertical, 8)
                            .padding(.trailing, 8)
                            .contentShape(Rectangle())
                        }
                        .accessibilityLabel("Back to \(backTitle ?? "previous screen")")
                    }
                    Spacer()
                }
                .padding(.horizontal)
            }
            .frame(height: barHeight)
            .frame(maxWidth: .infinity)
            .background(AppTheme.brandGreen)

            Text(title)
                .font(.largeTitle.bold())
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .padding(.horizontal)
                .padding(.top, 14)
                .padding(.bottom, 12)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color(.systemBackground))
    }
}

#Preview("Plain") {
    VStack(spacing: 24) {
        AppHeaderBar(title: "Planten Lijst")
        AppHeaderBar(title: "Question 3 of 12", backTitle: "Practice") {}
    }
}
