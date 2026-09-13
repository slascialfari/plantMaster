import Foundation

/// The two exercises offered on the Practice tab.
enum PracticeMode: CaseIterable, Identifiable {
    /// Every activated plant once, in random order. Shows the first photo and the Dutch
    /// name; the user types the Latin name.
    case dutchToLatin
    /// Ten random activated plants. Shows all photos; the user types both names.
    case exam

    var id: Self { self }

    var title: String {
        switch self {
        case .dutchToLatin: return "Dutch → Latin"
        case .exam: return "Exam simulation"
        }
    }

    var subtitle: String {
        switch self {
        case .dutchToLatin: return "All active plants. See the photo and Dutch name, type the Latin name."
        case .exam: return "\(PracticeSession.examQuestionCount) random plants. See the photos, type both the Dutch and Latin name."
        }
    }

    var systemImage: String {
        switch self {
        case .dutchToLatin: return "translate"
        case .exam: return "graduationcap"
        }
    }

    var asksDutchName: Bool {
        self == .exam
    }

    var showsDutchName: Bool {
        self == .dutchToLatin
    }
}

struct PracticeQuestion: Identifiable {
    let id = UUID()
    let mode: PracticeMode
    let target: Plant
}

/// A question the user got (partly) wrong, kept for the results screen.
struct PracticeMiss: Identifiable {
    let id = UUID()
    let plant: Plant
    let latinCorrect: Bool
    let dutchCorrect: Bool
    let typedLatin: String
    let typedDutch: String
}
