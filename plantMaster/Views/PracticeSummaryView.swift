import SwiftUI

struct PracticeSummaryView: View {
    let session: PracticeSession
    let onPracticeAgain: () -> Void
    let onDone: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Text("Session Complete")
                .font(.title.weight(.bold))

            Text("\(session.score) / \(session.questions.count)")
                .font(.system(size: 48, weight: .bold))
                .foregroundStyle(.green)

            if !session.missed.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Review these:")
                        .font(.headline)
                    ForEach(session.missed) { plant in
                        VStack(alignment: .leading) {
                            Text(plant.latinName).italic()
                            Text(plant.dutchName)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            Spacer()

            Button("Practice Again") {
                onPracticeAgain()
            }
            .buttonStyle(.borderedProminent)

            Button("Done") {
                onDone()
            }
        }
        .padding()
    }
}
