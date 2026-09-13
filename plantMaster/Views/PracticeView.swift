import SwiftUI
import SwiftData

struct PracticeView: View {
    @Query private var allPlants: [Plant]
    @State private var session = PracticeSession()
    @State private var hasStarted = false

    private var activatedPlants: [Plant] {
        allPlants.filter { $0.isActivated }
    }

    var body: some View {
        NavigationStack {
            Group {
                if hasStarted, let question = session.currentQuestion {
                    sessionContent(question: question)
                } else if hasStarted, session.isFinished {
                    PracticeSummaryView(
                        session: session,
                        onPracticeAgain: startSession,
                        onDone: { hasStarted = false }
                    )
                } else {
                    landing
                }
            }
            .navigationTitle("Practice")
        }
    }

    private var landing: some View {
        VStack(spacing: 20) {
            Image(systemName: "gamecontroller.fill")
                .font(.system(size: 48))
                .foregroundStyle(.green)

            Text("\(activatedPlants.count) plants activated")
                .font(.headline)

            if activatedPlants.count < PracticeSession.minimumActivatedPlants {
                Text("Activate at least \(PracticeSession.minimumActivatedPlants) plants (add a photo to each) before you can practice.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            } else {
                Text("A quick \(PracticeSession.questionCount)-question round mixing photos, names, and typing.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Button("Start Practice") {
                    startSession()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
    }

    @ViewBuilder
    private func sessionContent(question: PracticeQuestion) -> some View {
        VStack(spacing: 16) {
            ProgressView(value: session.progress)
                .padding(.horizontal)

            Text("Question \(session.currentIndex + 1) of \(session.questions.count)")
                .font(.caption)
                .foregroundStyle(.secondary)

            if question.kind.isMultipleChoice {
                MultipleChoiceQuestionView(question: question, session: session)
            } else {
                TypedAnswerQuestionView(question: question, session: session)
            }

            if session.hasAnswered {
                Button(session.currentIndex + 1 == session.questions.count ? "Finish" : "Next") {
                    session.advance()
                }
                .buttonStyle(.borderedProminent)
                .padding(.horizontal)
            }

            Spacer()
        }
        .padding(.top)
    }

    private func startSession() {
        session.start(with: activatedPlants)
        hasStarted = true
    }
}

#Preview {
    PracticeView()
        .modelContainer(PreviewData.container)
}
