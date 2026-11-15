import Testing
import SwiftData
@testable import plantMaster

@MainActor
struct StudyPeriodTests {
    private func makeContainer() throws -> ModelContainer {
        let schema = Schema([Category.self, Plant.self, PlantPhoto.self, PlantPin.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        return try ModelContainer(for: schema, configurations: [config])
    }

    @Test func freshStoreGetsEveryPeriodsList() throws {
        let container = try makeContainer() // must outlive the context
        let context = container.mainContext
        PlantSeedData.seedIfNeeded(context: context)

        let plants = try context.fetch(FetchDescriptor<Plant>())
        #expect(plants.filter { $0.periodID == StudyPeriod.y1t1.id }.count == 87)
        #expect(plants.filter { $0.periodID == StudyPeriod.y1t2.id }.count == 61)
    }

    /// A device that only has Trimester 1 keeps its plants and marks, and gains Trimester 2
    /// as separate plants, even for species that are on both lists.
    @Test func existingStoreGainsNewPeriodWithoutTouchingOldPlants() throws {
        let container = try makeContainer() // must outlive the context
        let context = container.mainContext
        let bomen = Category(name: "Bomen", colorHex: "#2E7D5B", sortOrder: 0)
        context.insert(bomen)
        let oak = Plant(index: 28, latinName: "Quercus robur", dutchName: "zomereik", notes: "lobed leaves", category: bomen)
        oak.isKnown = true
        context.insert(oak)
        try context.save()

        PlantSeedData.seedIfNeeded(context: context)
        PlantSeedData.seedIfNeeded(context: context) // a second launch adds nothing more

        let oaks = try context.fetch(FetchDescriptor<Plant>()).filter { $0.latinName == "Quercus robur" }
        #expect(oaks.count == 2)

        let summerOak = try #require(oaks.first { $0.periodID == StudyPeriod.y1t1.id })
        #expect(summerOak === oak)
        #expect(summerOak.isKnown)
        #expect(summerOak.notes == "lobed leaves")

        let winterOak = try #require(oaks.first { $0.periodID == StudyPeriod.y1t2.id })
        #expect(winterOak.index == 34)
        #expect(!winterOak.isKnown)
        #expect(winterOak.category?.name == "Winterkenmerken")

        let total = try context.fetch(FetchDescriptor<Plant>()).count
        #expect(total == 87 + 61)
    }

    /// Names corrected in the seed list are corrected on devices that saved the old spelling.
    @Test func correctedNamesAreAppliedToSavedPlants() throws {
        let container = try makeContainer() // must outlive the context
        let context = container.mainContext
        let grass = Plant(index: 87, latinName: "Pennisetum alopecuroides 'Hameln'", dutchName: "lampenpoetsersgras")
        let juniper = Plant(index: 8, periodID: StudyPeriod.y1t2.id, latinName: "Juniperus communis (cv)", dutchName: "jeneverbes")
        context.insert(grass)
        context.insert(juniper)
        try context.save()

        PlantSeedData.seedIfNeeded(context: context)

        #expect(grass.dutchName == "lampepoetsersgras")
        #expect(juniper.latinName == "Juniperus communis")
    }

    @Test func selectionFiltersByPeriod() {
        let summer = Plant(index: 1, periodID: StudyPeriod.y1t1.id, latinName: "Acer campestre", dutchName: "veldesdoorn")
        let winter = Plant(index: 21, periodID: StudyPeriod.y1t2.id, latinName: "Acer campestre", dutchName: "veldesdoorn")

        #expect(PeriodSelection.period(.y1t1).includes(summer))
        #expect(!PeriodSelection.period(.y1t1).includes(winter))
        #expect(PeriodSelection.all.includes(summer) && PeriodSelection.all.includes(winter))

        #expect(PeriodSelection(rawValue: "all") == .all)
        #expect(PeriodSelection(rawValue: "y1t1") == .period(.y1t1))
        #expect(PeriodSelection(rawValue: "unknown") == .period(.current))
    }

    @Test func sectionsGroupByPeriodThenCategory() {
        let winterCategory = Category(name: "Winterkenmerken", colorHex: "#000000", sortOrder: 6)
        let summerCategory = Category(name: "Bomen", colorHex: "#000000", sortOrder: 0)
        let plants = [
            Plant(index: 21, periodID: StudyPeriod.y1t2.id, latinName: "Acer campestre", dutchName: "a", category: winterCategory),
            Plant(index: 2, periodID: StudyPeriod.y1t1.id, latinName: "Acer platanoides", dutchName: "b", category: summerCategory),
            Plant(index: 1, periodID: StudyPeriod.y1t1.id, latinName: "Acer campestre", dutchName: "c", category: summerCategory),
        ]

        let sections = PlantSections.make(from: plants, labelPeriods: true)
        #expect(sections.map(\.period) == [.y1t1, .y1t2])
        let allStartPeriods = sections.allSatisfy { $0.showsPeriod }
        #expect(allStartPeriods)
        #expect(sections[0].plants.map(\.index) == [1, 2])
    }

    @Test func plantWithoutDutchNameIsOnlyAskedLatin() {
        let session = PracticeSession()
        session.start(mode: .exam, with: [
            Plant(index: 11, periodID: StudyPeriod.y1t2.id, latinName: "Microbiota decussata", dutchName: ""),
        ])
        #expect(session.currentQuestion?.asksDutchName == false)

        session.typedLatin = "Microbiota decussata"
        #expect(session.canSubmit)
        session.submit()
        #expect(session.lastAnswerWasCorrect)
    }
}
