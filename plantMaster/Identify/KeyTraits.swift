import SwiftUI

/// One observable feature used by the identification key, with the answers it allows.
enum KeyTrait: String, CaseIterable, Identifiable {
    case growthForm
    case foliage
    case leafArrangement
    case leafType
    case leafShape
    case leafMargin
    case leafColour
    case thorns
    case flowerColour
    case climbingMethod

    var id: Self { self }

    /// Short name shown in the list of answers.
    var title: String {
        switch self {
        case .growthForm: return "Growth form"
        case .foliage: return "In winter"
        case .leafArrangement: return "Leaf arrangement"
        case .leafType: return "Leaf type"
        case .leafShape: return "Leaf shape"
        case .leafMargin: return "Leaf edge"
        case .leafColour: return "Leaf colour"
        case .thorns: return "Thorns"
        case .flowerColour: return "Flower colour"
        case .climbingMethod: return "Climbing method"
        }
    }

    var question: String {
        switch self {
        case .growthForm: return "What kind of plant is it?"
        case .foliage: return "What happens to the leaves in winter?"
        case .leafArrangement: return "How are the leaves attached to the stem?"
        case .leafType: return "Is each leaf one blade, or made of leaflets?"
        case .leafShape: return "What shape is the leaf, or each leaflet?"
        case .leafMargin: return "What does the leaf edge look like?"
        case .leafColour: return "What colour are the leaves in summer?"
        case .thorns: return "Does the stem have thorns or prickles?"
        case .flowerColour: return "What colour are the flowers?"
        case .climbingMethod: return "How does it hold on while climbing?"
        }
    }

    /// Extra guidance shown under the question.
    var help: String? {
        switch self {
        case .leafArrangement: return "Look where the leaves leave the stem: one per point, two facing each other, or all from the base."
        case .leafType: return "A compound leaf has several leaflets on one stalk, with a bud only at the base of the whole leaf."
        case .leafShape: return "For compound leaves, look at a single leaflet."
        case .leafMargin: return "Ignore the lobes and look at the edge itself."
        case .flowerColour: return "Skip this if the plant isn't flowering."
        default: return nil
        }
    }

    var options: [KeyOption] {
        switch self {
        case .growthForm:
            return [
                KeyOption("tree", "Tree", symbol: "tree.fill"),
                KeyOption("shrub", "Shrub", symbol: "leaf.fill"),
                KeyOption("climber", "Climber", symbol: "point.topleft.down.to.point.bottomright.curvepath"),
                KeyOption("perennial", "Perennial", symbol: "camera.macro"),
                KeyOption("grass", "Grass", symbol: "laurel.leading"),
            ]
        case .foliage:
            return [
                KeyOption("deciduous", "Drops its leaves", symbol: "leaf.arrow.triangle.circlepath"),
                KeyOption("evergreen", "Keeps its leaves", symbol: "snowflake"),
                KeyOption("diesBack", "Dies back to the ground", symbol: "arrow.down.to.line"),
            ]
        case .leafArrangement:
            return [
                KeyOption("alternate", "Alternate", symbol: "arrow.triangle.swap"),
                KeyOption("opposite", "Opposite", symbol: "arrow.left.and.right"),
                KeyOption("basal", "From the base", symbol: "circle.dotted"),
            ]
        case .leafType:
            return [
                KeyOption("simple", "Single blade", symbol: "leaf"),
                KeyOption("pinnate", "Leaflets in a row", symbol: "line.3.horizontal"),
                KeyOption("palmate", "Leaflets like a hand", symbol: "hand.raised.fingers.spread"),
            ]
        case .leafShape:
            return [
                KeyOption("linear", "Long and grass-like", leaf: .linear),
                KeyOption("narrow", "Narrow, pointed", leaf: .lanceolate),
                KeyOption("oval", "Oval", leaf: .oval),
                KeyOption("roundHeart", "Round or heart-shaped", leaf: .heart),
                KeyOption("triangular", "Triangular or diamond", leaf: .diamond),
                KeyOption("palmLobed", "Lobed like a hand", leaf: .palmLobed),
                KeyOption("pinnLobed", "Lobed along the sides", leaf: .pinnLobed),
            ]
        case .leafMargin:
            return [
                KeyOption("entire", "Smooth", symbol: "circle"),
                KeyOption("toothed", "Toothed or serrated", symbol: "waveform.path"),
            ]
        case .leafColour:
            return [
                KeyOption("green", "Green", swatch: Color(hex: "#5E9E52")),
                KeyOption("purple", "Purple or red", swatch: Color(hex: "#6B2D3C")),
                KeyOption("silver", "Silver or blue-grey", swatch: Color(hex: "#A9B8BE")),
            ]
        case .thorns:
            return [
                KeyOption("yes", "Yes", symbol: "exclamationmark.triangle"),
                KeyOption("no", "No", symbol: "checkmark.circle"),
            ]
        case .flowerColour:
            return [
                KeyOption("white", "White or cream", swatch: Color(hex: "#F7F4EC")),
                KeyOption("yellow", "Yellow", swatch: Color(hex: "#E8C33A")),
                KeyOption("pink", "Pink or red", swatch: Color(hex: "#E06C8E")),
                KeyOption("purple", "Purple or blue", swatch: Color(hex: "#7B66C9")),
                KeyOption("green", "Green, catkins or plumes", swatch: Color(hex: "#9DB98A")),
            ]
        case .climbingMethod:
            return [
                KeyOption("twining", "Twining stems", symbol: "arrow.triangle.2.circlepath"),
                KeyOption("tendrils", "Tendrils", symbol: "scribble"),
                KeyOption("leafStalks", "Twisting leaf stalks", symbol: "leaf.arrow.triangle.circlepath"),
                KeyOption("clinging", "Roots or sticky pads", symbol: "hand.raised.fingers.spread"),
            ]
        }
    }

    func option(_ id: String) -> KeyOption? {
        options.first { $0.id == id }
    }
}

/// A possible answer to a trait question.
struct KeyOption: Identifiable, Equatable {
    /// How the answer is illustrated.
    enum Icon: Equatable {
        case symbol(String)
        case swatch(Color)
        case leaf(LeafKind)
    }

    let id: String
    let label: String
    let icon: Icon

    init(_ id: String, _ label: String, symbol: String) {
        self.id = id
        self.label = label
        self.icon = .symbol(symbol)
    }

    init(_ id: String, _ label: String, swatch: Color) {
        self.id = id
        self.label = label
        self.icon = .swatch(swatch)
    }

    init(_ id: String, _ label: String, leaf: LeafKind) {
        self.id = id
        self.label = label
        self.icon = .leaf(leaf)
    }
}
