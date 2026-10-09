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

/// Small corner version of the known toggle, for overlaying on a flashcard without
/// covering it. Shows just a seal icon; once marked it expands to a "Known" capsule.
struct KnownCornerButton: View {
    @Bindable var plant: Plant

    var body: some View {
        Button {
            withAnimation(.snappy) {
                plant.isKnown.toggle()
            }
        } label: {
            HStack(spacing: 4) {
                Image(systemName: plant.isKnown ? "checkmark.seal.fill" : "checkmark.seal")
                    .font(.system(size: 17, weight: .semibold))
                if plant.isKnown {
                    Text("Known")
                        .font(.caption.weight(.bold))
                        .transition(.opacity.combined(with: .scale(scale: 0.8, anchor: .trailing)))
                }
            }
            .foregroundStyle(.white)
            .padding(.horizontal, plant.isKnown ? 10 : 0)
            .frame(minWidth: 36, minHeight: 36)
            .background(
                Capsule().fill(plant.isKnown ? AnyShapeStyle(AppTheme.brandGreen) : AnyShapeStyle(.black.opacity(0.35)))
            )
            .overlay(Capsule().strokeBorder(.white.opacity(0.4), lineWidth: 1))
            .contentShape(Capsule())
            .padding(6)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(plant.isKnown ? "Marked as known" : "I know this one")
        .accessibilityHint(plant.isKnown
                           ? "Puts this plant back into practice"
                           : "Hides this plant from practice")
    }
}
