import SwiftUI

struct PracticeSummaryView: View {
    let session: PracticeSession

    var body: some View {
        VStack(spacing: 24) {
            Text(session.mode.title)
                .font(.headline)
                .foregroundStyle(.secondary)

            Text("\(session.score) / \(session.questions.count)")
                .font(.system(size: 48, weight: .bold))
                .foregroundStyle(.green)

            if session.missed.isEmpty {
                Text("Everything correct first time. Well done!")
                    .font(.headline)
            } else {
                Text(session.retriesTaken == 1
                     ? "You got the missed one right on the retry."
                     : "All missed plants answered correctly after \(session.retriesTaken) retries.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Missed on the first try:")
                        .font(.headline)
                    ForEach(session.missed) { miss in
                        VStack(alignment: .leading, spacing: 2) {
                            answerLine(correct: miss.latinCorrect, answer: miss.plant.latinName, typed: miss.typedLatin)
                                .italic()
                            if session.mode.asksDutchName {
                                answerLine(correct: miss.dutchCorrect, answer: miss.plant.dutchName, typed: miss.typedDutch)
                                    .font(.subheadline)
                            } else {
                                Text(miss.plant.dutchName)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding()
    }

    private func answerLine(correct: Bool, answer: String, typed: String) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 6) {
            Image(systemName: correct ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundStyle(correct ? .green : .red)
                .font(.caption)
            Text(answer)
            if !correct, !typed.trimmingCharacters(in: .whitespaces).isEmpty {
                Text("(you typed: \(typed))")
                    .foregroundStyle(.secondary)
                    .font(.caption)
            }
        }
    }
}
