import Foundation

/// A block of the course with its own plant list, such as Year 1 · Trimester 2. Each plant
/// belongs to exactly one period; a species studied in two periods is two separate plants,
/// so photos and the Known mark of, say, a summer oak and a winter oak stay apart.
struct StudyPeriod: Identifiable, Hashable {
    /// Stored on `Plant.periodID`. Never change an existing id: saved plants refer to it.
    let id: String
    let year: Int
    let trimester: Int

    var shortLabel: String { "Y\(year)·T\(trimester)" }
    var title: String { "Year \(year) · Trimester \(trimester)" }

    static let y1t1 = StudyPeriod(id: "y1t1", year: 1, trimester: 1)
    static let y1t2 = StudyPeriod(id: "y1t2", year: 1, trimester: 2)

    /// Every period in course order. Add new periods at the end.
    static let all: [StudyPeriod] = [y1t1, y1t2]

    /// The period the app opens on until the student picks another one.
    static let current: StudyPeriod = y1t2

    static func with(id: String) -> StudyPeriod? {
        all.first { $0.id == id }
    }

    /// Position in `all`, for sorting plants by period.
    var order: Int {
        Self.all.firstIndex(of: self) ?? Int.max
    }
}

/// What the period chips at the top of List and Practice select: one period, or every plant
/// from every period (for studying towards an exam that covers everything).
enum PeriodSelection: Hashable {
    case period(StudyPeriod)
    case all

    /// The value kept in `@AppStorage`, shared by the List and Practice tabs.
    static let storageKey = "selectedPeriod"
    static let allRawValue = "all"
    static let defaultRawValue = StudyPeriod.current.id

    init(rawValue: String) {
        if rawValue == Self.allRawValue {
            self = .all
        } else {
            self = .period(StudyPeriod.with(id: rawValue) ?? .current)
        }
    }

    var rawValue: String {
        switch self {
        case .period(let period): return period.id
        case .all: return Self.allRawValue
        }
    }

    var label: String {
        switch self {
        case .period(let period): return period.shortLabel
        case .all: return "All periods"
        }
    }

    func includes(_ plant: Plant) -> Bool {
        switch self {
        case .period(let period): return plant.periodID == period.id
        case .all: return true
        }
    }

    static var choices: [PeriodSelection] {
        StudyPeriod.all.map { .period($0) } + [.all]
    }
}
