import Foundation

/// Observable traits of one course plant, keyed by its list number.
///
/// DRAFT DATA: labelled from general botanical references, not yet checked against the
/// course material. A field with several values means the plant can show any of them
/// (variable, or differs between leaves). `climbing` is empty for plants that don't climb.
/// Growth form is not stored here; it comes from the plant's category.
struct PlantTraitRecord {
    let index: Int
    let foliage: [String]
    let arrangement: [String]
    let leafType: [String]
    let shape: [String]
    let margin: [String]
    let colour: [String]
    let thorns: Bool
    let flowers: [String]
    var climbing: [String] = []
}

enum PlantTraitData {
    static let records: [Int: PlantTraitRecord] = Dictionary(
        uniqueKeysWithValues: all.map { ($0.index, $0) }
    )

    /// Growth form per course category name.
    static let growthFormByCategory: [String: String] = [
        "Bomen": "tree",
        "Heesters": "shrub",
        "Klimplanten": "climber",
        "Vaste planten": "perennial",
        "Grassen": "grass",
    ]

    private static func r(
        _ index: Int,
        _ foliage: [String], _ arrangement: [String], _ leafType: [String],
        _ shape: [String], _ margin: [String], _ colour: [String],
        thorns: Bool = false, flowers: [String], climbing: [String] = []
    ) -> PlantTraitRecord {
        PlantTraitRecord(
            index: index, foliage: foliage, arrangement: arrangement, leafType: leafType,
            shape: shape, margin: margin, colour: colour, thorns: thorns,
            flowers: flowers, climbing: climbing
        )
    }

    // Shorthands keep the table readable.
    private static let dec = ["deciduous"], ever = ["evergreen"], back = ["diesBack"]
    private static let alt = ["alternate"], opp = ["opposite"], bas = ["basal"]
    private static let simple = ["simple"], pinnate = ["pinnate"], palmate = ["palmate"]
    private static let smooth = ["entire"], toothed = ["toothed"]
    private static let green = ["green"]

    private static let all: [PlantTraitRecord] = [
        // MARK: Bomen
        r(1, dec, opp, simple, ["palmLobed"], smooth, green, flowers: ["green"]),
        r(2, dec, opp, simple, ["palmLobed"], toothed, green, flowers: ["yellow", "green"]),
        r(3, dec, opp, simple, ["palmLobed"], toothed, green, flowers: ["green"]),
        r(4, dec, opp, palmate, ["oval"], toothed, green, flowers: ["white"]),
        r(5, dec, alt, simple, ["roundHeart"], toothed, green, flowers: ["green"]),
        r(6, dec, alt, simple, ["oval"], toothed, green, flowers: ["green"]),
        r(7, dec, alt, simple, ["triangular"], toothed, green, flowers: ["green"]),
        r(8, dec, alt, simple, ["oval", "triangular"], toothed, green, flowers: ["green"]),
        r(9, dec, alt, simple, ["oval"], toothed, green, flowers: ["green"]),
        r(10, dec, alt, simple, ["narrow"], toothed, green, flowers: ["white"]),
        r(11, dec, opp, simple, ["roundHeart"], toothed, green, flowers: ["green"]),
        r(12, dec, alt, simple, ["oval"], smooth, green, flowers: ["green"]),
        r(13, dec, alt, simple, ["oval"], smooth, ["purple"], flowers: ["green"]),
        r(14, dec, opp, pinnate, ["narrow"], toothed, green, flowers: ["green"]),
        r(15, dec, alt, pinnate, ["oval"], smooth, green, thorns: true, flowers: ["green"]),
        r(16, dec, alt, simple, ["palmLobed"], toothed, green, flowers: ["green"]),
        r(17, dec, alt, simple, ["palmLobed"], smooth, green, flowers: ["yellow", "green"]),
        r(18, dec, alt, simple, ["oval"], smooth, green, flowers: ["pink", "white"]),
        r(19, dec, alt, simple, ["palmLobed"], toothed, green, flowers: ["green"]),
        r(20, dec, alt, simple, ["palmLobed", "oval"], toothed, ["silver"], flowers: ["green"]),
        r(21, dec, alt, simple, ["triangular"], toothed, green, flowers: ["green"]),
        r(22, dec, alt, simple, ["oval"], toothed, green, flowers: ["white"]),
        r(23, dec, alt, simple, ["oval"], toothed, ["purple"], flowers: ["pink", "white"]),
        r(24, dec, alt, simple, ["oval"], toothed, green, flowers: ["white"]),
        r(25, dec, alt, simple, ["oval"], toothed, green, flowers: ["pink", "white"]),
        r(26, dec, alt, simple, ["pinnLobed"], smooth, green, flowers: ["green"]),
        r(27, dec, alt, simple, ["pinnLobed"], smooth, green, flowers: ["green"]),
        r(28, dec, alt, simple, ["pinnLobed"], smooth, green, flowers: ["green"]),
        r(29, dec, alt, simple, ["pinnLobed"], smooth, green, flowers: ["green"]),
        r(30, dec, alt, pinnate, ["oval"], smooth, green, thorns: true, flowers: ["white"]),
        r(31, dec, alt, simple, ["narrow"], toothed, ["silver"], flowers: ["green", "yellow"]),
        r(32, dec, alt, pinnate, ["narrow"], toothed, green, flowers: ["white"]),
        r(33, dec, alt, simple, ["roundHeart"], toothed, green, flowers: ["yellow"]),
        r(34, dec, alt, simple, ["oval"], toothed, green, flowers: ["green"]),

        // MARK: Heesters
        r(35, dec, opp, simple, ["palmLobed"], toothed, ["green", "purple"], flowers: ["green"]),
        r(36, dec, alt, simple, ["oval"], toothed, green, flowers: ["white"]),
        r(37, dec, opp, simple, ["narrow"], toothed, green, flowers: ["purple", "pink", "white"]),
        r(38, dec, opp, simple, ["oval"], smooth, green, flowers: ["white"]),
        r(39, dec, alt, simple, ["roundHeart"], toothed, green, flowers: ["yellow"]),
        r(40, dec, alt, simple, ["pinnLobed"], toothed, green, thorns: true, flowers: ["white"]),
        r(41, dec, opp, simple, ["oval", "narrow"], toothed, green, flowers: ["green"]),
        r(42, dec, alt, simple, ["oval"], smooth, green, flowers: ["green"]),
        r(43, dec, opp, simple, ["oval"], toothed, green, flowers: ["white"]),
        r(44, ["deciduous", "evergreen"], opp, simple, ["oval"], smooth, green, flowers: ["yellow"]),
        r(45, ever, alt, simple, ["oval"], toothed, green, flowers: ["white"]),
        r(46, ["evergreen", "deciduous"], opp, simple, ["oval"], smooth, green, flowers: ["white"]),
        r(47, ["deciduous", "evergreen"], opp, simple, ["narrow"], smooth, green, flowers: ["white"]),
        r(48, dec, alt, simple, ["narrow"], toothed, green, flowers: ["green"]),
        r(49, dec, alt, pinnate, ["narrow"], smooth, green, flowers: ["yellow", "white"]),
        r(50, dec, alt, simple, ["oval", "narrow"], toothed, green, flowers: ["white"]),
        r(51, dec, alt, simple, ["oval"], toothed, green, thorns: true, flowers: ["white"]),
        r(52, dec, alt, simple, ["palmLobed"], toothed, green, flowers: ["pink"]),
        r(53, dec, alt, pinnate, ["oval"], toothed, green, thorns: true, flowers: ["pink", "white"]),
        r(54, dec, alt, pinnate, ["oval"], toothed, green, thorns: true, flowers: ["pink"]),
        r(55, dec, alt, pinnate, ["oval"], toothed, green, thorns: true, flowers: ["pink", "white"]),
        r(56, ["deciduous", "evergreen"], alt, palmate, ["oval"], toothed, green, thorns: true, flowers: ["white", "pink"]),
        r(57, dec, alt, simple, ["oval"], toothed, green, flowers: ["yellow", "green"]),
        r(58, dec, alt, simple, ["oval"], ["entire", "toothed"], green, flowers: ["yellow"]),
        r(59, dec, alt, simple, ["oval"], ["entire", "toothed"], green, flowers: ["yellow", "green"]),
        r(60, dec, opp, pinnate, ["oval"], toothed, green, flowers: ["white"]),
        r(61, dec, alt, simple, ["oval", "narrow"], toothed, green, flowers: ["pink"]),
        r(62, dec, opp, simple, ["oval"], smooth, green, flowers: ["pink"]),
        r(63, dec, opp, simple, ["oval"], smooth, green, flowers: ["pink"]),
        r(64, dec, opp, simple, ["roundHeart"], smooth, green, flowers: ["purple", "white"]),
        r(65, dec, opp, simple, ["palmLobed"], toothed, green, flowers: ["white"]),

        // MARK: Klimplanten
        r(66, dec, opp, pinnate, ["oval"], smooth, green, flowers: ["purple", "white", "pink"], climbing: ["leafStalks"]),
        r(67, ever, alt, simple, ["palmLobed"], smooth, green, flowers: ["green"], climbing: ["clinging"]),
        r(68, dec, opp, simple, ["roundHeart"], toothed, green, flowers: ["white"], climbing: ["clinging"]),
        r(69, dec, opp, simple, ["oval"], smooth, green, flowers: ["yellow", "white"], climbing: ["twining"]),
        r(70, dec, alt, palmate, ["oval"], toothed, green, flowers: ["green"], climbing: ["tendrils", "clinging"]),
        r(71, dec, alt, simple, ["palmLobed", "roundHeart"], toothed, green, flowers: ["green"], climbing: ["tendrils"]),
        r(72, dec, alt, pinnate, ["oval"], smooth, green, flowers: ["purple"], climbing: ["twining"]),

        // MARK: Vaste planten
        r(73, back, alt, simple, ["palmLobed"], toothed, green, flowers: ["purple"]),
        r(74, back, bas, palmate, ["oval"], toothed, green, flowers: ["pink"]),
        r(75, back, bas, palmate, ["oval"], toothed, green, flowers: ["white"]),
        r(76, back, alt, simple, ["narrow"], toothed, green, flowers: ["white", "purple"]),
        r(77, back, alt, simple, ["roundHeart"], toothed, green, flowers: ["white"]),
        r(78, back, alt, simple, ["narrow"], ["entire", "toothed"], green, flowers: ["purple"]),
        r(79, back, ["basal", "opposite"], simple, ["palmLobed"], toothed, green, flowers: ["purple"]),
        r(80, ever, bas, simple, ["linear"], smooth, green, flowers: ["purple"]),
        r(81, back, opp, simple, ["oval", "roundHeart"], toothed, ["green", "silver"], flowers: ["purple"]),
        r(82, back, alt, simple, ["roundHeart"], smooth, green, flowers: ["pink"]),
        r(83, back, alt, simple, ["narrow"], ["entire", "toothed"], green, flowers: ["yellow"]),
        r(84, back, ["opposite", "alternate"], simple, ["oval"], ["entire", "toothed"], ["green", "silver"], flowers: ["pink"]),

        // MARK: Grassen
        r(85, back, bas, simple, ["linear"], smooth, green, flowers: ["green"]),
        r(86, back, bas, simple, ["linear"], smooth, ["silver"], flowers: ["green"]),
        r(87, back, bas, simple, ["linear"], smooth, green, flowers: ["green"]),
    ]
}
