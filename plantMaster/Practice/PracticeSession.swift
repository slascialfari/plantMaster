import Foundation
import Observation
import SwiftData

@Observable
final class PracticeSession {
    static let examQuestionCount = 10
    static let minimumActivatedPlants = 1

    private(set) var mode: PracticeMode = .dutchToLatin
    /// The main round: every selected plant once.
    private(set) var questions: [PracticeQuestion] = []
    private(set) var currentIndex = 0
    /// Plants answered wrongly, asked again after the main round until they are right.
    private(set) var retryQueue: [PracticeQuestion] = []
    /// Number of retry questions answered so far, right or wrong.
    private(set) var retriesTaken = 0
    private(set) var score = 0
    private(set) var missed: [PracticeMiss] = []

    var typedLatin: String = ""
    var typedDutch: String = ""
    private(set) var hasAnswered = false
    private(set) var latinCorrect = false
    private(set) var dutchCorrect = false

    var isInRetryPhase: Bool {
        currentIndex >= questions.count
    }

    var currentQuestion: PracticeQuestion? {
        if questions.indices.contains(currentIndex) {
            return questions[currentIndex]
        }
        return retryQueue.first
    }

    var isFinished: Bool {
        !questions.isEmpty && isInRetryPhase && retryQueue.isEmpty
    }

    /// True when advancing past the current question ends the session. During the main
    /// round that also requires nothing to be waiting in the retry queue.
    var isLastQuestion: Bool {
        if isInRetryPhase {
            return retryQueue.count == 1
        }
        return currentIndex + 1 == questions.count && retryQueue.isEmpty
    }

    var progress: Double {
        let total = questions.count + retriesTaken + retryQueue.count
        guard total > 0 else { return 0 }
        let answered = min(currentIndex, questions.count) + retriesTaken
        return Double(answered) / Double(total)
    }

    var lastAnswerWasCorrect: Bool {
        latinCorrect && (!mode.asksDutchName || dutchCorrect)
    }

    /// Whether the current answer can be submitted: every asked field has something in it.
    var canSubmit: Bool {
        let latinFilled = !typedLatin.trimmingCharacters(in: .whitespaces).isEmpty
        let dutchFilled = !typedDutch.trimmingCharacters(in: .whitespaces).isEmpty
        return latinFilled && (!mode.asksDutchName || dutchFilled)
    }

    func start(mode: PracticeMode, with activatedPlants: [Plant]) {
        self.mode = mode
        questions = Self.buildQuestions(mode: mode, from: activatedPlants)
        currentIndex = 0
        retryQueue = []
        retriesTaken = 0
        score = 0
        missed = []
        resetAnswerState()
    }

    func submit() {
        guard let question = currentQuestion, !hasAnswered else { return }
        let target = question.target

        latinCorrect = StringNormalization.matchesAny(typedLatin, target.latinName)
        dutchCorrect = mode.asksDutchName ? StringNormalization.matchesAny(typedDutch, target.dutchName) : true
        hasAnswered = true

        if question.isRetry {
            // Retries never change the score; a wrong retry simply comes back once more.
            if !lastAnswerWasCorrect {
                retryQueue.append(PracticeQuestion(mode: mode, target: target, isRetry: true))
            }
        } else if lastAnswerWasCorrect {
            score += 1
        } else {
            missed.append(PracticeMiss(
                plant: target,
                latinCorrect: latinCorrect,
                dutchCorrect: dutchCorrect,
                typedLatin: typedLatin,
                typedDutch: typedDutch
            ))
            retryQueue.append(PracticeQuestion(mode: mode, target: target, isRetry: true))
        }
    }

    func advance() {
        if isInRetryPhase {
            if !retryQueue.isEmpty {
                retryQueue.removeFirst()
                retriesTaken += 1
            }
        } else {
            currentIndex += 1
            if isInRetryPhase {
                retryQueue.shuffle()
            }
        }
        resetAnswerState()
    }

    private func resetAnswerState() {
        typedLatin = ""
        typedDutch = ""
        hasAnswered = false
        latinCorrect = false
        dutchCorrect = false
    }

    private static func buildQuestions(mode: PracticeMode, from activatedPlants: [Plant]) -> [PracticeQuestion] {
        guard activatedPlants.count >= minimumActivatedPlants else { return [] }

        let shuffled = activatedPlants.shuffled()
        let selected: [Plant]
        switch mode {
        case .dutchToLatin:
            selected = shuffled
        case .exam:
            selected = Array(shuffled.prefix(examQuestionCount))
        case .flashcards:
            // Flashcards are browsed in FlashcardsView, never as a scored session.
            return []
        }

        return selected.map { PracticeQuestion(mode: mode, target: $0) }
    }
}
