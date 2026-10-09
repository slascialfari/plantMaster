import SwiftUI

/// "I know this one" button used in the exercises. Marking a plant as known hides it from
/// practice (unless the Practice filter is set to All). Tapping again undoes it.
struct KnownToggleButton: View {
    @Bindable var plant: Plant

    var body: some View {
        Button {
            withAnimation(.snappy) {
                plant.isKnown.toggle()
            }
        } label: {
            Label(
                plant.isKnown ? "Marked as known · Undo" : "I know this one",
                systemImage: plant.isKnown ? "checkmark.seal.fill" : "checkmark.seal"
            )
            .font(.subheadline.weight(.semibold))
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
        .tint(plant.isKnown ? .secondary : AppTheme.brandGreen)
        .accessibilityHint(plant.isKnown
                           ? "Puts this plant back into practice"
                           : "Hides this plant from practice")
    }
}
