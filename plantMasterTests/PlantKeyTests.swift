import Testing
@testable import plantMaster

struct PlantKeyTests {
    private let categories: [Int: String] = {
        var map: [Int: String] = [:]
        for i in 1...34 { map[i] = "Bomen" }
        for i in 35...65 { map[i] = "Heesters" }
        for i in 66...72 { map[i] = "Klimplanten" }
        for i in 73...84 { map[i] = "Vaste planten" }
        for i in 85...87 { map[i] = "Grassen" }
        return map
    }()

    private var allPlants: [KeyPlant] {
        (1...87).map { KeyPlant(index: $0, categoryName: categories[$0]) }
    }

    // MARK: Data

    @Test func everyCoursePlantHasTraits() {
        let missing = (1...87).filter { PlantTraitData.records[$0] == nil }
        #expect(missing.isEmpty, "No traits for plants \(missing)")
    }

    @Test func everyTraitValueIsAValidOption() {
        for plant in allPlants {
            for (trait, values) in plant.values {
                let valid = Set(trait.options.map(\.id))
                let invalid = values.subtracting(valid)
                #expect(invalid.isEmpty, "Plant \(plant.index) has invalid \(trait.rawValue): \(invalid)")
            }
        }
    }

    @Test func onlyClimbersHaveAClimbingMethod() {
        for plant in allPlants {
            let isClimber = plant.values[.growthForm] == ["climber"]
            let climbing = plant.values[.climbingMethod] ?? []
            #expect(isClimber == !climbing.isEmpty, "Plant \(plant.index)")
        }
    }

    // MARK: Engine

    @Test func answeringNarrowsTheCandidates() {
        let climbers = PlantKey.candidates(allPlants, answers: [.growthForm: "climber"])
        #expect(climbers.map(\.index) == Array(66...72))

        let twining = PlantKey.candidates(allPlants, answers: [.growthForm: "climber", .climbingMethod: "twining"])
        #expect(Set(twining.map(\.index)) == [69, 72])
    }

    @Test func climbingMethodIsOnlyAskedOnceAllCandidatesClimb() {
        #expect(!PlantKey.isApplicable(.climbingMethod, among: allPlants))
        let climbers = PlantKey.candidates(allPlants, answers: [.growthForm: "climber"])
        #expect(PlantKey.isApplicable(.climbingMethod, among: climbers))
    }

    @Test func suggestionSkipsAnsweredAndUselessQuestions() {
        let first = PlantKey.suggestedTrait(among: allPlants, excluding: [])
        #expect(first != nil)
        #expect(first != .climbingMethod)

        let grasses = PlantKey.candidates(allPlants, answers: [.growthForm: "grass"])
        let next = PlantKey.suggestedTrait(among: grasses, excluding: [.growthForm])
        // Only leaf colour separates the three grasses.
        #expect(next == .leafColour)
    }

    @Test func multiValuedPlantsMatchEitherAnswer() {
        let plant = KeyPlant(index: 81, categoryName: "Vaste planten")
        #expect(plant.matches(.leafColour, "green"))
        #expect(plant.matches(.leafColour, "silver"))
        #expect(!plant.matches(.leafColour, "purple"))
    }

    @Test func unknownTraitsNeverRuleAPlantOut() {
        let plant = KeyPlant(index: 999, categoryName: nil)
        #expect(plant.matches(.leafShape, "oval"))
        #expect(plant.matches(.growthForm, "tree"))
    }
}
