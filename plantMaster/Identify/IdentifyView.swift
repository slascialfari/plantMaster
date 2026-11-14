import SwiftUI
import SwiftData
import UIKit

/// The Identify tab: an identification key over every course plant. Answer what you can
/// see, in any order; the matching plants narrow down after each answer.
struct IdentifyView: View {
    @Query(sort: \Plant.index) private var plants: [Plant]

    @State private var answers: [KeyTrait: String] = [:]
    /// Order the answers were given, for the answer list and Undo.
    @State private var answerOrder: [KeyTrait] = []
    @State private var skipped: Set<KeyTrait> = []
    /// Every answer or skip in order, so Back can undo the most recent step.
    @State private var history: [Step] = []

    private enum Step: Equatable {
        case answered(KeyTrait)
        case skipped(KeyTrait)
    }
    /// A question the user chose from "Other questions", shown instead of the suggestion.
    @State private var chosenTrait: KeyTrait?
    @State private var isShowingMatches = false

    // MARK: - Key state

    private var keyPlants: [KeyPlant] {
        plants.map { KeyPlant(index: $0.index, categoryName: $0.category?.name) }
    }

    private var candidates: [KeyPlant] {
        PlantKey.candidates(keyPlants, answers: answers)
    }

    private var matchingPlants: [Plant] {
        let indices = Set(candidates.map(\.index))
        return plants.filter { indices.contains($0.index) }
    }

    private var currentTrait: KeyTrait? {
        if let chosenTrait, answers[chosenTrait] == nil { return chosenTrait }
        return PlantKey.suggestedTrait(
            among: candidates,
            excluding: Set(answers.keys).union(skipped)
        )
    }

    /// Unanswered questions that could still narrow things down, other than the current one.
    private var otherTraits: [KeyTrait] {
        KeyTrait.allCases.filter { trait in
            trait != currentTrait
                && answers[trait] == nil
                && PlantKey.isInformative(trait, among: candidates)
        }
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                AppHeaderBar(
                    title: "Identify",
                    backTitle: "Back",
                    onBack: history.isEmpty ? nil : { goBack() }
                )

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        matchesCard

                        if let currentTrait, matchingPlants.count > 1 {
                            QuestionCard(
                                trait: currentTrait,
                                counts: PlantKey.counts(for: currentTrait, among: candidates),
                                onAnswer: { answer(currentTrait, $0) },
                                onSkip: { skip(currentTrait) }
                            )
                            .id(currentTrait)
                            .transition(.asymmetric(
                                insertion: .move(edge: .trailing).combined(with: .opacity),
                                removal: .opacity
                            ))
                        } else if matchingPlants.count > 1 {
                            Text("No more questions can tell these plants apart. Compare the matches above.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }

                        if !answerOrder.isEmpty {
                            answersSection
                        }

                        if !otherTraits.isEmpty && matchingPlants.count > 1 {
                            otherQuestionsSection
                        }

                        Label("Demo: the plant features are draft data and may contain mistakes.",
                              systemImage: "info.circle")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding(.top, 4)
                    }
                    .padding()
                    .animation(.snappy, value: answers)
                    .animation(.snappy, value: skipped)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .sheet(isPresented: $isShowingMatches) {
                MatchListView(plants: matchingPlants)
            }
        }
    }

    // MARK: - Matches

    @ViewBuilder
    private var matchesCard: some View {
        let matches = matchingPlants

        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                Text(matchesTitle(matches.count))
                    .font(.headline)
                Spacer()
                if matches.count > 1 {
                    Button("See all") { isShowingMatches = true }
                        .font(.subheadline.weight(.semibold))
                        .tint(AppTheme.brandGreen)
                }
            }

            if matches.count == 1, let plant = matches.first {
                resultRow(plant)
            } else if matches.isEmpty {
                Text("No plant fits all your answers. Remove an answer below to go back.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 10) {
                        ForEach(matches) { plant in
                            NavigationLink {
                                PlantDetailView(plant: plant)
                            } label: {
                                MatchThumbnail(plant: plant)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .frame(height: 118)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 16))
    }

    private func matchesTitle(_ count: Int) -> String {
        switch count {
        case 0: return "No matches"
        case 1: return "It's probably this one"
        default: return "\(count) of \(plants.count) plants match"
        }
    }

    private func resultRow(_ plant: Plant) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            NavigationLink {
                PlantDetailView(plant: plant)
            } label: {
                HStack(spacing: 14) {
                    PlantThumbnailImage(plant: plant, size: 72)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(plant.latinName)
                            .font(.title3.weight(.semibold))
                            .italic()
                        Text(plant.dutchName)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.tertiary)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            Button {
                startOver()
            } label: {
                Label("Identify another plant", systemImage: "arrow.counterclockwise")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(AppTheme.brandGreen)
        }
    }

    // MARK: - Answers

    private var answersSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Your observations")
                    .font(.headline)
                Spacer()
                Button("Start over") { startOver() }
                    .font(.subheadline)
                    .tint(AppTheme.brandGreen)
            }

            ForEach(answerOrder) { trait in
                if let id = answers[trait], let option = trait.option(id) {
                    HStack(spacing: 10) {
                        OptionIcon(option: option)
                            .frame(width: 28, height: 28)
                        VStack(alignment: .leading, spacing: 1) {
                            Text(trait.title)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(option.label)
                                .font(.subheadline.weight(.semibold))
                        }
                        Spacer()
                        Button {
                            removeAnswer(trait)
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title3)
                                .foregroundStyle(.secondary)
                        }
                        .accessibilityLabel("Remove \(trait.title)")
                    }
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12))
                }
            }
        }
    }

    private var otherQuestionsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Answer something else")
                .font(.headline)
            Text("Pick any feature you can see.")
                .font(.caption)
                .foregroundStyle(.secondary)

            FlowRow(spacing: 8) {
                ForEach(otherTraits) { trait in
                    Button {
                        withAnimation(.snappy) {
                            skipped.remove(trait)
                            chosenTrait = trait
                        }
                    } label: {
                        Text(trait.title)
                            .font(.subheadline.weight(.medium))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 7)
                            .background(Capsule().strokeBorder(AppTheme.brandGreen.opacity(0.6)))
                            .foregroundStyle(AppTheme.brandGreen)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: - Actions

    private func answer(_ trait: KeyTrait, _ option: String) {
        withAnimation(.snappy) {
            answers[trait] = option
            answerOrder.removeAll { $0 == trait }
            answerOrder.append(trait)
            history.append(.answered(trait))
            chosenTrait = nil
        }
    }

    private func skip(_ trait: KeyTrait) {
        withAnimation(.snappy) {
            skipped.insert(trait)
            history.append(.skipped(trait))
            chosenTrait = nil
        }
    }

    private func removeAnswer(_ trait: KeyTrait) {
        withAnimation(.snappy) {
            answers[trait] = nil
            answerOrder.removeAll { $0 == trait }
            history.removeAll { $0 == .answered(trait) }
        }
    }

    /// Undoes the most recent answer or skip and shows that question again.
    private func goBack() {
        guard let last = history.popLast() else { return }
        withAnimation(.snappy) {
            switch last {
            case .answered(let trait):
                answers[trait] = nil
                answerOrder.removeAll { $0 == trait }
                chosenTrait = trait
            case .skipped(let trait):
                skipped.remove(trait)
                chosenTrait = trait
            }
        }
    }

    private func startOver() {
        withAnimation(.snappy) {
            answers = [:]
            answerOrder = []
            skipped = []
            history = []
            chosenTrait = nil
        }
    }
}

// MARK: - Question card

private struct QuestionCard: View {
    let trait: KeyTrait
    let counts: [String: Int]
    let onAnswer: (String) -> Void
    let onSkip: () -> Void

    private let columns = [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)]

    private func isLeaf(_ option: KeyOption) -> Bool {
        if case .leaf = option.icon { return true }
        return false
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                Text(trait.title.uppercased())
                    .font(.caption.weight(.bold))
                    .tracking(1.2)
                    .foregroundStyle(AppTheme.brandGreen)
                Text(trait.question)
                    .font(.title3.weight(.semibold))
                if let help = trait.help {
                    Text(help)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }

            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(trait.options) { option in
                    let count = counts[option.id] ?? 0
                    Button {
                        onAnswer(option.id)
                    } label: {
                        VStack(spacing: 8) {
                            OptionIcon(option: option)
                                .frame(width: isLeaf(option) ? 56 : 34, height: isLeaf(option) ? 56 : 34)
                            Text(option.label)
                                .font(.subheadline.weight(.semibold))
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                            Text(count == 1 ? "1 plant" : "\(count) plants")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, minHeight: 104)
                        .padding(8)
                        .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 14))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .strokeBorder(AppTheme.brandGreen.opacity(count > 0 ? 0.45 : 0.12))
                        )
                    }
                    .buttonStyle(.plain)
                    .disabled(count == 0)
                    .opacity(count == 0 ? 0.4 : 1)
                    .accessibilityLabel("\(option.label), \(count) plants")
                }
            }

            Button {
                onSkip()
            } label: {
                Label("Not sure, skip this question", systemImage: "questionmark.circle")
                    .font(.subheadline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .tint(.secondary)
        }
        .padding()
        .background(AppTheme.brandGreen.opacity(0.08), in: RoundedRectangle(cornerRadius: 18))
    }
}

/// The SF Symbol or colour swatch representing an answer.
private struct OptionIcon: View {
    let option: KeyOption

    var body: some View {
        switch option.icon {
        case .swatch(let swatch):
            Circle()
                .fill(swatch)
                .overlay(Circle().strokeBorder(Color.primary.opacity(0.2)))
                .padding(3)
        case .symbol(let symbol):
            Image(systemName: symbol)
                .resizable()
                .scaledToFit()
                .foregroundStyle(AppTheme.brandGreen)
                .padding(3)
        case .leaf(let kind):
            LeafIllustration(kind: kind)
        }
    }
}

// MARK: - Matching plants

private struct PlantThumbnailImage: View {
    let plant: Plant
    let size: CGFloat

    var body: some View {
        Group {
            if let first = plant.sortedPhotos.first,
               let image = PhotoStore.thumbnail(filename: first.filename) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                Image(systemName: "leaf.fill")
                    .font(.system(size: size * 0.35))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.gray.opacity(0.15))
            }
        }
        .frame(width: size, height: size)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

private struct MatchThumbnail: View {
    let plant: Plant

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            PlantThumbnailImage(plant: plant, size: 76)
            Text(plant.latinName)
                .font(.caption2.weight(.semibold))
                .italic()
                .lineLimit(2)
                .frame(width: 76, alignment: .leading)
        }
    }
}

private struct MatchListView: View {
    let plants: [Plant]
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List(plants) { plant in
                NavigationLink {
                    PlantDetailView(plant: plant)
                } label: {
                    HStack(spacing: 12) {
                        PlantThumbnailImage(plant: plant, size: 44)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(plant.latinName).italic().font(.body.weight(.semibold))
                            Text(plant.dutchName).font(.subheadline).foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle(plants.count == 1 ? "1 match" : "\(plants.count) matches")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

// MARK: - Layout helper

/// Lays children out left to right, wrapping onto new lines as needed.
private struct FlowRow: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        var x: CGFloat = 0, y: CGFloat = 0, rowHeight: CGFloat = 0, widest: CGFloat = 0
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x > 0 && x + size.width > maxWidth {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
            widest = max(widest, x - spacing)
        }
        return CGSize(width: proposal.width ?? widest, height: y + rowHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX, y = bounds.minY, rowHeight: CGFloat = 0
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x > bounds.minX && x + size.width > bounds.maxX {
                x = bounds.minX
                y += rowHeight + spacing
                rowHeight = 0
            }
            subview.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}

#Preview {
    IdentifyView()
        .modelContainer(PreviewData.container)
}
