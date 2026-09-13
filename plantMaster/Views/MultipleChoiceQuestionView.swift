import SwiftUI
import UIKit

struct MultipleChoiceQuestionView: View {
    let question: PracticeQuestion
    let session: PracticeSession

    var body: some View {
        VStack(spacing: 24) {
            prompt

            if question.kind == .latinToPhotoChoice {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(question.choices) { plant in
                        photoOption(for: plant)
                    }
                }
            } else {
                VStack(spacing: 12) {
                    ForEach(question.choices) { plant in
                        textOption(for: plant)
                    }
                }
            }
        }
        .padding()
    }

    @ViewBuilder
    private var prompt: some View {
        switch question.kind {
        case .photoToLatinChoice:
            promptPhoto
        case .dutchToLatinChoice:
            Text(question.target.dutchName)
                .font(.title.weight(.semibold))
                .multilineTextAlignment(.center)
        case .latinToPhotoChoice:
            Text(question.target.latinName)
                .font(.title.weight(.semibold))
                .italic()
                .multilineTextAlignment(.center)
        default:
            EmptyView()
        }
    }

    private var promptPhoto: some View {
        Group {
            if let photo = question.target.sortedPhotos.first,
               let image = PhotoStore.display(filename: photo.filename) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                Image(systemName: "leaf.fill")
                    .resizable()
                    .scaledToFit()
                    .padding(40)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(height: 220)
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .background(Color.gray.opacity(0.1))
    }

    private func textOption(for plant: Plant) -> some View {
        Button {
            session.submitChoice(plant)
        } label: {
            Text(plant.latinName)
                .italic()
                .frame(maxWidth: .infinity)
                .padding()
                .background(optionColor(for: plant))
                .foregroundStyle(.primary)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .disabled(session.hasAnswered)
    }

    private func photoOption(for plant: Plant) -> some View {
        Button {
            session.submitChoice(plant)
        } label: {
            Group {
                if let photo = plant.sortedPhotos.first,
                   let image = PhotoStore.display(filename: photo.filename) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                } else {
                    Image(systemName: "leaf.fill")
                        .resizable()
                        .scaledToFit()
                        .padding(24)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(height: 120)
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(borderColor(for: plant), lineWidth: 3)
            )
        }
        .disabled(session.hasAnswered)
    }

    private func optionColor(for plant: Plant) -> Color {
        guard session.hasAnswered else { return Color.gray.opacity(0.15) }
        if plant.persistentModelID == question.target.persistentModelID {
            return .green.opacity(0.3)
        }
        if plant.persistentModelID == session.selectedChoice?.persistentModelID {
            return .red.opacity(0.3)
        }
        return Color.gray.opacity(0.15)
    }

    private func borderColor(for plant: Plant) -> Color {
        guard session.hasAnswered else { return .clear }
        if plant.persistentModelID == question.target.persistentModelID {
            return .green
        }
        if plant.persistentModelID == session.selectedChoice?.persistentModelID {
            return .red
        }
        return .clear
    }
}
