import SwiftUI
import Combine
import UIKit

/// Tracks how far the software keyboard overlaps the bottom of the screen.
/// Used by the root layout to keep the footer fixed while insetting only the content.
@Observable
final class KeyboardObserver {
    /// Height of the keyboard overlapping the screen, measured from the screen's bottom edge.
    private(set) var height: CGFloat = 0

    @ObservationIgnored
    private var cancellables = Set<AnyCancellable>()

    init() {
        let center = NotificationCenter.default
        center.publisher(for: UIResponder.keyboardWillChangeFrameNotification)
            .merge(with: center.publisher(for: UIResponder.keyboardWillHideNotification))
            .sink { [weak self] notification in
                self?.handle(notification)
            }
            .store(in: &cancellables)
    }

    private func handle(_ notification: Notification) {
        let userInfo = notification.userInfo
        let duration = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.25

        let newHeight: CGFloat
        if notification.name == UIResponder.keyboardWillHideNotification {
            newHeight = 0
        } else if let frame = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let screenBottom = UIScreen.main.bounds.maxY
            newHeight = max(0, screenBottom - frame.minY)
        } else {
            return
        }

        withAnimation(.easeOut(duration: duration)) {
            height = newHeight
        }
    }
}
