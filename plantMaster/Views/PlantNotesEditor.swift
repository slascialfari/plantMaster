import SwiftUI
import SwiftData

/// Edits a plant's notes in a local draft and writes to the model only after the user
/// pauses typing or the editor goes away. Keeps every keystroke from triggering a
/// SwiftData save and a re-render of the whole detail screen.
struct PlantNotesEditor: View {
    @Bindable var plant: Plant
    @Environment(\.modelContext) private var modelContext

    @State private var draft: String = ""
    @State private var pendingSave: Task<Void, Never>?

    var body: some View {
        TextEditor(text: $draft)
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .lineSpacing(3)
            .frame(minHeight: 120)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.3))
            )
            .onAppear {
                draft = plant.notes
            }
            .onChange(of: draft) { _, _ in
                scheduleSave()
            }
            .onDisappear {
                pendingSave?.cancel()
                commit()
            }
    }

    private func scheduleSave() {
        pendingSave?.cancel()
        pendingSave = Task {
            try? await Task.sleep(for: .milliseconds(800))
            guard !Task.isCancelled else { return }
            commit()
        }
    }

    private func commit() {
        guard plant.notes != draft else { return }
        plant.notes = draft
        try? modelContext.save()
    }
}
