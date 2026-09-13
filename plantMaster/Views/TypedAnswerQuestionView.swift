import SwiftUI
import UIKit

struct TypedAnswerQuestionView: View {
    let question: PracticeQuestion
    let session: PracticeSession

    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(spacing: 24) {
            prompt

            TextField("Type the latin name", text: Binding(
                get: { session.typedAnswer },
                set: { session.typedAnswer = $0 }
            ))
            .textFieldStyle(.roundedBorder)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .disabled(session.hasAnswered)
            .focused($isFocused)
            .onSubmit {
                if !session.hasAnswered {
                    session.submitTypedAnswer()
                }
            }

            if session.hasAnswered {
                VStack(spacing: 4) {
                    Text(session.lastAnswerWasCorrect ? "Correct!" : "Not quite")
                        .font(.headline)
                        .foregroundStyle(session.lastAnswerWasCorrect ? .green : .red)
                    if !session.lastAnswerWasCorrect {
                        Text(question.target.latinName)
                            .italic()
                            .foregroundStyle(.secondary)
                    }
                }
            } else {
                Button("Check") {
                    session.submitTypedAnswer()
                }
                .buttonStyle(.borderedProminent)
                .disabled(session.typedAnswer.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
        .padding()
        .onAppear { isFocused = true }
    }

    @ViewBuilder
    private var prompt: some View {
        switch question.kind {
        case .photoToLatinTyped:
            Group {
                if let photo = question.target.sortedPhotos.first,
                   let image = PhotoStore.load(filename: photo.filename) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                } else {
                    Image(systemName: "leaf.fill")
                        .resizable()
                        .scaledToFit()
                        .padding(40)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(height: 220)
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .background(Color.gray.opacity(0.1))
        case .dutchToLatinTyped:
            Text(question.target.dutchName)
                .font(.title.weight(.semibold))
                .multilineTextAlignment(.center)
        default:
            EmptyView()
        }
    }
}
