import Foundation
import Observation
import SwiftData

@Observable
final class PracticeSession {
    private(set) var questions: [PracticeQuestion] = []
    private(set) var currentIndex = 0
    private(set) var score = 0
    private(set) var missed: [Plant] = []

    var selectedChoice: Plant?
    var typedAnswer: String = ""
    var hasAnswered = false
    var lastAnswerWasCorrect = false

    static let questionCount = 12
    static let minimumActivatedPlants = 4

    var currentQuestion: PracticeQuestion? {
        questions.indices.contains(currentIndex) ? questions[currentIndex] : nil
    }

    var isFinished: Bool {
        !questions.isEmpty && currentIndex >= questions.count
    }

    var progress: Double {
        guard !questions.isEmpty else { return 0 }
        return Double(currentIndex) / Double(questions.count)
    }

    func start(with activatedPlants: [Plant]) {
        questions = Self.buildQuestions(from: activatedPlants)
        currentIndex = 0
        score = 0
        missed = []
        selectedChoice = nil
        typedAnswer = ""
        hasAnswered = false
    }

    func submitChoice(_ plant: Plant) {
        guard let question = currentQuestion, !hasAnswered else { return }
        selectedChoice = plant
        lastAnswerWasCorrect = plant.persistentModelID == question.target.persistentModelID
        recordAnswer(correct: lastAnswerWasCorrect, target: question.target)
    }

    func submitTypedAnswer() {
        guard let question = currentQuestion, !hasAnswered else { return }
        lastAnswerWasCorrect = StringNormalization.matches(typedAnswer, question.target.latinName)
        recordAnswer(correct: lastAnswerWasCorrect, target: question.target)
    }

    private func recordAnswer(correct: Bool, target: Plant) {
        hasAnswered = true
        if correct {
            score += 1
        } else {
            missed.append(target)
        }
    }

    func advance() {
        currentIndex += 1
        selectedChoice = nil
        typedAnswer = ""
        hasAnswered = false
    }

    private static func buildQuestions(from activatedPlants: [Plant]) -> [PracticeQuestion] {
        guard activatedPlants.count >= minimumActivatedPlants else { return [] }

        var questions: [PracticeQuestion] = []
        var previousPlantID: PersistentIdentifier?

        for _ in 0..<questionCount {
            var candidates = activatedPlants
            if let previousPlantID, activatedPlants.count > 1 {
                candidates = activatedPlants.filter { $0.persistentModelID != previousPlantID }
            }
            guard let target = candidates.randomElement() else { break }
            previousPlantID = target.persistentModelID

            let kind = PracticeExerciseKind.allCases.randomElement()!
            let choices: [Plant]
            if kind.isMultipleChoice {
                choices = buildChoices(target: target, pool: activatedPlants)
            } else {
                choices = []
            }

            questions.append(PracticeQuestion(kind: kind, target: target, choices: choices))
        }

        return questions
    }

    private static func buildChoices(target: Plant, pool: [Plant]) -> [Plant] {
        let others = pool.filter { $0.persistentModelID != target.persistentModelID }
        let sameCategory = others.filter { $0.category?.persistentModelID == target.category?.persistentModelID }

        var distractors = Array(sameCategory.shuffled().prefix(3))
        if distractors.count < 3 {
            let remaining = others.filter { plant in
                !distractors.contains { $0.persistentModelID == plant.persistentModelID }
            }
            distractors.append(contentsOf: remaining.shuffled().prefix(3 - distractors.count))
        }

        var choices = distractors + [target]
        choices.shuffle()
        return choices
    }
}
