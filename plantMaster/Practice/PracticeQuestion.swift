import Foundation

/// The two exercises offered on the Practice tab.
enum PracticeMode: CaseIterable, Identifiable {
    /// Every activated plant once, in random order. Shows the first photo and the Dutch
    /// name; the user types the Latin name.
    case dutchToLatin
    /// Ten random activated plants. Shows all photos; the user types both names.
    case exam
    /// Every activated plant once, in random order, as flip cards: photo, then the Dutch
    /// name, then the Latin name. Not scored.
    case flashcards

    var id: Self { self }

    /// Quiz modes run through `PracticeSession`; flashcards are a free browse.
    var isQuiz: Bool {
        self != .flashcards
    }

    var title: String {
        switch self {
        case .dutchToLatin: return "Dutch → Latin"
        case .exam: return "Exam simulation"
        case .flashcards: return "Flashcards"
        }
    }

    var subtitle: String {
        switch self {
        case .dutchToLatin: return "All active plants. See the photo and Dutch name, type the Latin name."
        case .exam: return "\(PracticeSession.examQuestionCount) random plants. See the photos, type both the Dutch and Latin name."
        case .flashcards: return "All active plants in random order. Tap the card to reveal the names, swipe for the next plant."
        }
    }

    var systemImage: String {
        switch self {
        case .dutchToLatin: return "translate"
        case .exam: return "graduationcap"
        case .flashcards: return "rectangle.on.rectangle.angled"
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
    /// True when this plant was answered wrongly earlier in the session and is being asked again.
    var isRetry: Bool = false
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
