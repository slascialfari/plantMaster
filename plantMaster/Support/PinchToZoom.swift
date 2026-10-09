import SwiftUI

/// Two-finger pinch to zoom into a photo around the point being pinched. The photo springs
/// back when the fingers lift, so one-finger swipes (photo pagers, flashcard deck) keep
/// working normally.
private struct PinchToZoom: ViewModifier {
    var maxScale: CGFloat = 4

    @State private var scale: CGFloat = 1
    @State private var anchor: UnitPoint = .center

    func body(content: Content) -> some View {
        content
            .scaleEffect(scale, anchor: anchor)
            .zIndex(scale > 1 ? 1 : 0)
            .simultaneousGesture(
                MagnifyGesture()
                    .onChanged { value in
                        if scale == 1 {
                            anchor = value.startAnchor
                        }
                        scale = min(max(value.magnification, 1), maxScale)
                    }
                    .onEnded { _ in
                        withAnimation(.spring(duration: 0.35, bounce: 0.2)) {
                            scale = 1
                        }
                    }
            )
    }
}

extension View {
    func pinchToZoom(maxScale: CGFloat = 4) -> some View {
        modifier(PinchToZoom(maxScale: maxScale))
    }
}
