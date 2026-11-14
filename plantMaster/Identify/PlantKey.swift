import Foundation

/// A plant as seen by the identification key: its list number and the values it has for
/// each trait. A trait missing from `values` is unknown and never rules the plant out,
/// except `climbingMethod`, which only climbers have.
struct KeyPlant: Equatable {
    let index: Int
    let values: [KeyTrait: Set<String>]

    /// Builds the key entry for a course plant from its category and the trait table.
    init(index: Int, categoryName: String?) {
        self.index = index
        var values: [KeyTrait: Set<String>] = [:]
        if let categoryName, let form = PlantTraitData.growthFormByCategory[categoryName] {
            values[.growthForm] = [form]
        }
        if let record = PlantTraitData.records[index] {
            values[.foliage] = Set(record.foliage)
            values[.leafArrangement] = Set(record.arrangement)
            values[.leafType] = Set(record.leafType)
            values[.leafShape] = Set(record.shape)
            values[.leafMargin] = Set(record.margin)
            values[.leafColour] = Set(record.colour)
            values[.thorns] = [record.thorns ? "yes" : "no"]
            values[.flowerColour] = Set(record.flowers)
            values[.climbingMethod] = Set(record.climbing)
        }
        self.values = values
    }

    init(index: Int, values: [KeyTrait: Set<String>]) {
        self.index = index
        self.values = values
    }

    /// Whether this plant is consistent with answering `option` for `trait`.
    func matches(_ trait: KeyTrait, _ option: String) -> Bool {
        guard let known = values[trait] else { return true }
        // An empty set means the trait doesn't apply (a non-climber has no climbing method).
        return known.contains(option)
    }
}

/// The multi-access identification key: answer any traits in any order, and the plants
/// that fit every answer remain.
enum PlantKey {
    static func candidates(_ plants: [KeyPlant], answers: [KeyTrait: String]) -> [KeyPlant] {
        plants.filter { plant in
            answers.allSatisfy { trait, option in plant.matches(trait, option) }
        }
    }

    /// How many of `candidates` would remain for each option of `trait`.
    static func counts(for trait: KeyTrait, among candidates: [KeyPlant]) -> [String: Int] {
        var result: [String: Int] = [:]
        for option in trait.options {
            result[option.id] = candidates.filter { $0.matches(trait, option.id) }.count
        }
        return result
    }

    /// Whether the question makes sense for every remaining plant. Climbing method is only
    /// asked once all remaining plants are climbers.
    static func isApplicable(_ trait: KeyTrait, among candidates: [KeyPlant]) -> Bool {
        candidates.allSatisfy { plant in
            guard let known = plant.values[trait] else { return true }
            return !known.isEmpty
        }
    }

    /// Whether answering `trait` could narrow `candidates` down at all.
    static func isInformative(_ trait: KeyTrait, among candidates: [KeyPlant]) -> Bool {
        guard isApplicable(trait, among: candidates) else { return false }
        let counts = counts(for: trait, among: candidates).values
        return counts.contains { $0 > 0 && $0 < candidates.count }
    }

    /// The unanswered trait expected to leave the fewest plants, so each question removes as
    /// many candidates as possible. Traits in `excluded` (answered or skipped) are ignored.
    static func suggestedTrait(among candidates: [KeyPlant], excluding excluded: Set<KeyTrait>) -> KeyTrait? {
        guard candidates.count > 1 else { return nil }

        var best: (trait: KeyTrait, score: Double)?
        for trait in KeyTrait.allCases where !excluded.contains(trait) {
            guard isInformative(trait, among: candidates) else { continue }
            let counts = counts(for: trait, among: candidates).values.filter { $0 > 0 }
            let total = Double(counts.reduce(0, +))
            // Expected number of plants left, if the answer is picked in proportion to how
            // many plants show it. Lower is better.
            let expected = counts.reduce(0.0) { $0 + Double($1 * $1) } / total
            if best == nil || expected < best!.score {
                best = (trait, expected)
            }
        }
        return best?.trait
    }
}
