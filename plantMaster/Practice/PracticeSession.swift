import Foundation
import Observation
import SwiftData

@Observable
final class PracticeSession {
    static let examQuestionCount = 10
    static let minimumActivatedPlants = 1

    private(set) var mode: PracticeMode = .dutchToLatin
    private(set) var questions: [PracticeQuestion] = []
    private(set) var currentIndex = 0
    private(set) var score = 0
    private(set) var missed: [PracticeMiss] = []

    var typedLatin: String = ""
    var typedDutch: String = ""
    private(set) var hasAnswered = false
    private(set) var latinCorrect = false
    private(set) var dutchCorrect = false

    var currentQuestion: PracticeQuestion? {
        questions.indices.contains(currentIndex) ? questions[currentIndex] : nil
    }

    var isFinished: Bool {
        !questions.isEmpty && currentIndex >= questions.count
    }

    var isLastQuestion: Bool {
        currentIndex + 1 == questions.count
    }

    var progress: Double {
        guard !questions.isEmpty else { return 0 }
        return Double(currentIndex) / Double(questions.count)
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

        if lastAnswerWasCorrect {
            score += 1
        } else {
            missed.append(PracticeMiss(
                plant: target,
                latinCorrect: latinCorrect,
                dutchCorrect: dutchCorrect,
                typedLatin: typedLatin,
                typedDutch: typedDutch
            ))
        }
    }

    func advance() {
        currentIndex += 1
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
        }

        return selected.map { PracticeQuestion(mode: mode, target: $0) }
    }
}
