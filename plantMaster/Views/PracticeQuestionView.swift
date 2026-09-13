import SwiftUI
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

    var body: some View {
        VStack(spacing: 20) {
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
        }
        .onChange(of: question.id) { _, _ in
            focusedField = question.mode.asksDutchName ? .dutch : .latin
        }
    }

    // MARK: - Photos

    @ViewBuilder
    private var photos: some View {
        let plantPhotos = question.target.sortedPhotos
        let shown = question.mode == .exam ? plantPhotos : Array(plantPhotos.prefix(1))

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
            } else {
                TabView {
                    ForEach(shown) { photo in
                        if let image = PhotoStore.display(filename: photo.filename) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .tag(photo.id)
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
