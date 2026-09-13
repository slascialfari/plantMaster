import Foundation

enum StringNormalization {
    static func normalize(_ input: String) -> String {
        let folded = input.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
        let allowed = CharacterSet.letters.union(.whitespaces)
        let filtered = folded.unicodeScalars.filter { allowed.contains($0) }
        let cleaned = String(String.UnicodeScalarView(filtered))
        return cleaned
            .components(separatedBy: .whitespaces)
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }

    static func matches(_ input: String, _ target: String) -> Bool {
        normalize(input) == normalize(target)
    }

    /// True when the input matches the whole target, or any one of its comma-separated
    /// alternatives. Dutch names are stored like "veldesdoorn, Spaanse aak", and either
    /// name alone should count as correct.
    static func matchesAny(_ input: String, _ target: String) -> Bool {
        if matches(input, target) { return true }
        return target
            .components(separatedBy: ",")
            .contains { matches(input, $0) }
    }
}
