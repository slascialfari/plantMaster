import SwiftUI
import SwiftData

struct PracticeView: View {
    @Query private var allPlants: [Plant]
    @State private var session = PracticeSession()
    @State private var hasStarted = false

    private var activatedPlants: [Plant] {
        allPlants.filter { $0.isActivated }
    }

    private var canPractice: Bool {
        activatedPlants.count >= PracticeSession.minimumActivatedPlants
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
            VStack(spacing: 0) {
                AppHeaderBar(title: title)

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
                .scrollDismissesKeyboard(.interactively)
                .safeAreaInset(edge: .bottom) {
                    footer
                }
            }
            .toolbar(.hidden, for: .navigationBar)
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

    // MARK: - Landing

    private var landing: some View {
        VStack(spacing: 16) {
            Text(canPractice
                 ? "\(activatedPlants.count) plants activated"
                 : "Add a photo to at least one plant before you can practice.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 8)

            ForEach(PracticeMode.allCases) { mode in
                modeButton(mode)
            }
        }
        .padding()
    }

    private func modeButton(_ mode: PracticeMode) -> some View {
        Button {
            guard canPractice else { return }
            startSession(mode: mode)
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: mode.systemImage)
                        .font(.system(size: 30, weight: .semibold))
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.headline)
                        .opacity(0.7)
                }
                Spacer(minLength: 0)
                Text(mode.title)
                    .font(.title2.weight(.bold))
                Text(mode.subtitle)
                    .font(.subheadline)
                    .opacity(0.9)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .foregroundStyle(.white)
            .padding(20)
            .frame(maxWidth: .infinity, minHeight: 170, alignment: .leading)
            .background(canPractice ? AppTheme.brandGreen : Color(.systemGray3), in: RoundedRectangle(cornerRadius: 18))
        }
        .buttonStyle(.plain)
        .accessibilityHint(canPractice ? "" : "Add a photo to a plant first")
    }

    // MARK: - Session

    @ViewBuilder
    private func sessionContent(question: PracticeQuestion) -> some View {
        VStack(spacing: 16) {
            ProgressView(value: session.progress)
                .padding(.horizontal)

            PracticeQuestionView(question: question, session: session)
        }
        .padding(.top)
    }

    @ViewBuilder
    private var footer: some View {
        switch stage {
        case .landing:
            EmptyView()
        case .question:
            if session.hasAnswered {
                footerBar {
                    Button(session.isLastQuestion ? "Finish" : "Next") {
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
                        startSession(mode: session.mode)
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
        VStack(spacing: 0) {
            Divider()
            content()
                .padding()
        }
        .background(Color(.systemBackground))
    }

    private func startSession(mode: PracticeMode) {
        session.start(mode: mode, with: activatedPlants)
        hasStarted = true
    }
}

#Preview {
    PracticeView()
        .modelContainer(PreviewData.container)
}
