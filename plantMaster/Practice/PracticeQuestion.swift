import Foundation

enum PracticeExerciseKind: CaseIterable {
    case photoToLatinChoice
    case dutchToLatinChoice
    case latinToPhotoChoice
    case dutchToLatinTyped
    case photoToLatinTyped

    var isMultipleChoice: Bool {
        switch self {
        case .photoToLatinChoice, .dutchToLatinChoice, .latinToPhotoChoice:
            return true
        case .dutchToLatinTyped, .photoToLatinTyped:
            return false
        }
    }

    var isPhotoBased: Bool {
        switch self {
        case .photoToLatinChoice, .latinToPhotoChoice, .photoToLatinTyped:
            return true
        case .dutchToLatinChoice, .dutchToLatinTyped:
            return false
        }
    }
}

struct PracticeQuestion: Identifiable {
    let id = UUID()
    let kind: PracticeExerciseKind
    let target: Plant
    /// For multiple-choice questions: the shuffled options (includes the correct target).
    let choices: [Plant]
}
