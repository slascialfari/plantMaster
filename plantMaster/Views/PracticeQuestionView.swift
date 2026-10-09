import SwiftUI
import SwiftData
import UIKit

/// One practice question: the plant's photo(s), an optional Dutch name prompt, and one or
/// two typed answer fields depending on the exercise mode.
struct PracticeQuestionView: View {
    let question: PracticeQuestion
    let session: PracticeSession

    private enum Field: Hashable {
        case dutch
        case latin
    }

    @FocusState private var focusedField: Field?
    /// Photo currently showing in the question's pager, also opened in the full-screen viewer.
    @State private var selectedPhotoID: PersistentIdentifier?
    @State private var isShowingViewer = false
    /// Field that had focus before opening the viewer, restored when it closes.
    @State private var focusBeforeViewer: Field?

    var body: some View {
        VStack(spacing: 20) {
            if question.isRetry {
                Label("You missed this one earlier. Try again.", systemImage: "arrow.counterclockwise")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.orange)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            photos

            if question.mode.showsDutchName {
                Text(question.target.dutchName)
                    .font(.title.weight(.semibold))
                    .multilineTextAlignment(.center)
            }

            VStack(spacing: 12) {
                if question.mode.asksDutchName {
                    answerField(
                        placeholder: "Type the Dutch name",
                        text: Binding(get: { session.typedDutch }, set: { session.typedDutch = $0 }),
                        field: .dutch,
                        isCorrect: session.dutchCorrect,
                        correctAnswer: question.target.dutchName
                    )
                    .submitLabel(.next)
                    .onSubmit { focusedField = .latin }
                }

                answerField(
                    placeholder: "Type the Latin name",
                    text: Binding(get: { session.typedLatin }, set: { session.typedLatin = $0 }),
                    field: .latin,
                    isCorrect: session.latinCorrect,
                    correctAnswer: question.target.latinName
                )
                .submitLabel(.done)
                .onSubmit {
                    if session.canSubmit && !session.hasAnswered {
                        session.submit()
                    }
                }
            }

            if session.hasAnswered {
                Text(session.lastAnswerWasCorrect ? "Correct!" : "Not quite")
                    .font(.headline)
                    .foregroundStyle(session.lastAnswerWasCorrect ? .green : .red)

                KnownToggleButton(plant: question.target)
            } else {
                Button("Check") {
                    session.submit()
                }
                .buttonStyle(.borderedProminent)
                .disabled(!session.canSubmit)
            }
        }
        .padding()
        .onAppear {
            focusedField = question.mode.asksDutchName ? .dutch : .latin
            PhotoRotation.markShown(question.photo)
        }
        .onChange(of: question.id) { _, _ in
            focusedField = question.mode.asksDutchName ? .dutch : .latin
            PhotoRotation.markShown(question.photo)
            selectedPhotoID = question.photo?.persistentModelID
        }
        .onAppear {
            selectedPhotoID = question.photo?.persistentModelID
        }
        .fullScreenCover(isPresented: $isShowingViewer, onDismiss: {
            focusedField = focusBeforeViewer
        }) {
            PhotoViewer(photos: photosToShow, selection: $selectedPhotoID)
        }
    }

    // MARK: - Photos

    /// The rotated photo alone, or for the exam all photos in the question's shuffled order.
    private var photosToShow: [PlantPhoto] {
        guard let lead = question.photo else { return [] }
        guard question.mode == .exam else { return [lead] }
        return question.examPhotos
    }

    @ViewBuilder
    private var photos: some View {
        let shown = photosToShow

        Group {
            if shown.isEmpty {
                Image(systemName: "leaf.fill")
                    .resizable()
                    .scaledToFit()
                    .padding(40)
                    .foregroundStyle(.secondary)
            } else if shown.count == 1, let image = PhotoStore.display(filename: shown[0].filename) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .pinchToZoom()
            } else {
                TabView(selection: $selectedPhotoID) {
                    ForEach(shown) { photo in
                        if let image = PhotoStore.display(filename: photo.filename) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .pinchToZoom()
                                .tag(Optional(photo.persistentModelID))
                        }
                    }
                }
                .tabViewStyle(.page)
            }
        }
        .frame(height: 260)
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .contentShape(RoundedRectangle(cornerRadius: 12))
        .onTapGesture {
            openViewer()
        }
        .overlay(alignment: .bottomTrailing) {
            if !shown.isEmpty {
                Button {
                    openViewer()
                } label: {
                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 34, height: 34)
                        .background(.black.opacity(0.4), in: Circle())
                }
                .padding(10)
                .accessibilityLabel("Expand photo")
            }
        }
    }

    private func openViewer() {
        guard !photosToShow.isEmpty else { return }
        if selectedPhotoID == nil {
            selectedPhotoID = photosToShow.first?.persistentModelID
        }
        focusBeforeViewer = focusedField
        focusedField = nil
        isShowingViewer = true
    }

    // MARK: - Fields

    private func answerField(
        placeholder: String,
        text: Binding<String>,
        field: Field,
        isCorrect: Bool,
        correctAnswer: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 8) {
                TextField(placeholder, text: text)
                    .textFieldStyle(.roundedBorder)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .disabled(session.hasAnswered)
                    .focused($focusedField, equals: field)

                if session.hasAnswered {
                    Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .font(.title3)
                        .foregroundStyle(isCorrect ? .green : .red)
                }
            }

            if session.hasAnswered && !isCorrect {
                Text(correctAnswer)
                    .font(.subheadline)
                    .italic()
                    .foregroundStyle(.secondary)
                    .padding(.leading, 4)
            }
        }
    }
}
