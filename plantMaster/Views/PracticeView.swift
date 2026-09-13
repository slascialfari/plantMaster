import SwiftUI
import SwiftData

struct PracticeView: View {
    @Query private var allPlants: [Plant]
    @State private var session = PracticeSession()
    @State private var hasStarted = false

    private var activatedPlants: [Plant] {
        allPlants.filter { $0.isActivated }
    }

    private enum Stage {
        case landing
        case question(PracticeQuestion)
        case summary
    }

    private var stage: Stage {
        if hasStarted, let question = session.currentQuestion {
            return .question(question)
        } else if hasStarted, session.isFinished {
            return .summary
        } else {
            return .landing
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                switch stage {
                case .landing:
                    landing
                case .question(let question):
                    sessionContent(question: question)
                case .summary:
                    PracticeSummaryView(session: session)
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaInset(edge: .bottom) {
                footer
            }
        }
    }

    private var title: String {
        switch stage {
        case .landing:
            return "Practice"
        case .question:
            return "Question \(session.currentIndex + 1) of \(session.questions.count)"
        case .summary:
            return "Results"
        }
    }

    @ViewBuilder
    private var footer: some View {
        switch stage {
        case .landing:
            if activatedPlants.count >= PracticeSession.minimumActivatedPlants {
                footerBar {
                    Button("Start Practice") {
                        startSession()
                    }
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)
                }
            }
        case .question:
            if session.hasAnswered {
                footerBar {
                    Button(session.currentIndex + 1 == session.questions.count ? "Finish" : "Next") {
                        session.advance()
                    }
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)
                }
            }
        case .summary:
            footerBar {
                VStack(spacing: 12) {
                    Button("Practice Again") {
                        startSession()
                    }
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)

                    Button("Done") {
                        hasStarted = false
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }

    private func footerBar<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .padding()
            .background(.bar)
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
            }
        }
        .padding(.top, 40)
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private func sessionContent(question: PracticeQuestion) -> some View {
        VStack(spacing: 16) {
            ProgressView(value: session.progress)
                .padding(.horizontal)

            if question.kind.isMultipleChoice {
                MultipleChoiceQuestionView(question: question, session: session)
            } else {
                TypedAnswerQuestionView(question: question, session: session)
            }
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
