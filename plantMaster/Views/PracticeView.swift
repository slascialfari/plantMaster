import SwiftUI
import SwiftData

struct PracticeView: View {
    @Query private var allPlants: [Plant]
    @State private var session = PracticeSession()
    @State private var hasStarted = false
    @State private var flashcardPlants: [Plant]? = nil
    @AppStorage("practiceFilter") private var filter: PracticeFilter = .learning
    @State private var isChoosingHandpicked = false

    /// Which plants the exercises draw from.
    enum PracticeFilter: String, CaseIterable, Identifiable {
        /// Photographed plants not marked as known.
        case learning
        /// Every photographed plant.
        case all
        /// Photographed plants chosen in the Handpicked sheet, known or not.
        case handpicked

        var id: Self { self }

        var label: String {
            switch self {
            case .learning: return "Still learning"
            case .all: return "All"
            case .handpicked: return "Handpicked"
            }
        }
    }

    private var activatedPlants: [Plant] {
        allPlants.filter { $0.isActivated }
    }

    private var knownCount: Int {
        activatedPlants.filter(\.isKnown).count
    }

    /// The plants every exercise draws from, according to the filter.
    private var practicePlants: [Plant] {
        switch filter {
        case .learning: return activatedPlants.filter { !$0.isKnown }
        case .all: return activatedPlants
        case .handpicked: return activatedPlants.filter(\.isHandpicked)
        }
    }

    private var canPractice: Bool {
        practicePlants.count >= PracticeSession.minimumActivatedPlants
    }

    private enum Stage {
        case landing
        case question(PracticeQuestion)
        case summary
        case flashcards([Plant])
    }

    private var stage: Stage {
        if let flashcardPlants {
            return .flashcards(flashcardPlants)
        } else if hasStarted, let question = session.currentQuestion {
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
                AppHeaderBar(
                    title: title,
                    backTitle: "Practice",
                    onBack: showsBackButton ? { returnToLanding() } : nil
                )

                if case .flashcards(let plants) = stage {
                    FlashcardsView(plants: plants)
                } else {
                    ScrollView {
                        switch stage {
                        case .landing:
                            landing
                        case .question(let question):
                            sessionContent(question: question)
                        case .summary:
                            PracticeSummaryView(session: session)
                        case .flashcards:
                            EmptyView()
                        }
                    }
                    .scrollDismissesKeyboard(.interactively)
                    .safeAreaInset(edge: .bottom) {
                        footer
                    }
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .sheet(isPresented: $isChoosingHandpicked) {
                HandpickedSelectionView()
            }
        }
    }

    private var title: String {
        switch stage {
        case .landing:
            return "Practice"
        case .question:
            if session.isInRetryPhase {
                return session.retryQueue.count == 1 ? "Retry · last one" : "Retry · \(session.retryQueue.count) left"
            }
            return "Question \(session.currentIndex + 1) of \(session.questions.count)"
        case .summary:
            return "Results"
        case .flashcards:
            return "Flashcards"
        }
    }

    private var showsBackButton: Bool {
        if case .landing = stage { return false }
        return true
    }

    private func returnToLanding() {
        hasStarted = false
        flashcardPlants = nil
    }

    // MARK: - Landing

    private var landing: some View {
        VStack(spacing: 16) {
            if !activatedPlants.isEmpty {
                Picker("Plants to practise", selection: $filter) {
                    ForEach(PracticeFilter.allCases) { option in
                        Text(option.label).tag(option)
                    }
                }
                .pickerStyle(.segmented)

                if filter == .handpicked {
                    Button {
                        isChoosingHandpicked = true
                    } label: {
                        Label(practicePlants.isEmpty ? "Choose plants" : "Change selection",
                              systemImage: "checklist")
                            .font(.subheadline.weight(.semibold))
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(AppTheme.brandGreen)
                }
            }

            Text(landingMessage)
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

    private var landingMessage: String {
        if activatedPlants.isEmpty {
            return "Add a photo to at least one plant before you can practice."
        }
        if practicePlants.isEmpty {
            switch filter {
            case .handpicked:
                return "No plants picked yet. Choose the categories or plants you want to practise."
            case .learning:
                return "All your plants are marked as known. Switch to All to practise them."
            case .all:
                return ""
            }
        }
        let plantsText = practicePlants.count == 1 ? "1 plant" : "\(practicePlants.count) plants"
        if filter == .learning && knownCount > 0 {
            let knownText = knownCount == 1 ? "1 known plant" : "\(knownCount) known plants"
            return "\(plantsText) to practise. \(knownText) hidden."
        }
        return "\(plantsText) to practise."
    }

    private func modeButton(_ mode: PracticeMode) -> some View {
        Button {
            guard canPractice else { return }
            startSession(mode: mode)
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: mode.systemImage)
                        .font(.system(size: 26, weight: .semibold))
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
            .frame(maxWidth: .infinity, minHeight: 140, alignment: .leading)
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
        case .landing, .flashcards:
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
        guard mode.isQuiz else {
            flashcardPlants = practicePlants.shuffled()
            return
        }
        session.start(mode: mode, with: practicePlants)
        hasStarted = true
    }
}

#Preview {
    PracticeView()
        .modelContainer(PreviewData.container)
}
