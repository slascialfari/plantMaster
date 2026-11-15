import Foundation
import SwiftData

/// One list section: the plants of one category within one period, in list-number order.
struct PlantSection: Identifiable {
    let period: StudyPeriod?
    let category: Category?
    let plants: [Plant]
    /// True when several periods are shown, so every header names its period and you can
    /// tell where you are while scrolling.
    let showsPeriod: Bool

    var id: String {
        "\(period?.id ?? "none")-\(category?.name ?? "none")"
    }
}

enum PlantSections {
    /// Groups plants by period (in course order), then by category, then sorts by number.
    /// Pass `labelPeriods` when more than one period can appear, as with All periods.
    static func make(from plants: [Plant], labelPeriods: Bool) -> [PlantSection] {
        let byPeriod = Dictionary(grouping: plants) { $0.period }
            .sorted { ($0.key?.order ?? Int.max) < ($1.key?.order ?? Int.max) }

        return byPeriod.flatMap { period, periodPlants in
            let byCategory = Dictionary(grouping: periodPlants) { $0.category }
                .sorted { ($0.key?.sortOrder ?? Int.max) < ($1.key?.sortOrder ?? Int.max) }

            return byCategory.map { group in
                PlantSection(
                    period: period,
                    category: group.key,
                    plants: group.value.sorted { $0.index < $1.index },
                    showsPeriod: labelPeriods
                )
            }
        }
    }
}
