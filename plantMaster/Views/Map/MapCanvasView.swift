import SwiftUI
import SwiftData

/// A marker to draw on the map. Coordinates are normalized (0...1) in map space.
struct MapPinMarker: Identifiable, Equatable {
    let id: PersistentIdentifier
    let x: Double
    let y: Double
    let label: String
    let color: Color
}

/// Displays the garden map with pins on top. Supports pinch-to-zoom, panning and
/// double-tap to zoom. Tapping the map reports the normalized map coordinate that
/// was hit; tapping a marker reports the marker.
struct MapCanvasView: View {
    var markers: [MapPinMarker]
    var selectedMarkerIDs: Set<PersistentIdentifier> = []
    var isInteractive: Bool = true
    var onTapMap: ((CGPoint) -> Void)? = nil
    var onTapMarker: ((MapPinMarker) -> Void)? = nil

    private let minScale: CGFloat = 1
    private let maxScale: CGFloat = 8

    /// Scale committed to the layout. The map is laid out at this size so the vector
    /// asset re-renders crisply once a gesture ends.
    @State private var committedScale: CGFloat = 1
    /// Extra scale applied as a transform while a pinch is in progress.
    @State private var liveFactor: CGFloat = 1
    @State private var offset: CGSize = .zero

    @State private var pinchStart: (scale: CGFloat, offset: CGSize)? = nil
    @State private var dragStartOffset: CGSize? = nil

    private var totalScale: CGFloat { committedScale * liveFactor }

    var body: some View {
        GeometryReader { geo in
            let container = geo.size
            let fitted = MapAsset.fittedSize(in: container)
            let laidOut = CGSize(width: fitted.width * committedScale, height: fitted.height * committedScale)

            ZStack {
                Color.white

                content(laidOut: laidOut)
                    .frame(width: laidOut.width, height: laidOut.height)
                    .scaleEffect(liveFactor)
                    .offset(offset)
            }
            .frame(width: container.width, height: container.height)
            .contentShape(Rectangle())
            .clipped()
            .allowsHitTesting(isInteractive)
            .onTapGesture(count: 2) { location in
                guard isInteractive else { return }
                handleDoubleTap(at: location, container: container, fitted: fitted)
            }
            .onTapGesture(count: 1) { location in
                guard isInteractive, let onTapMap else { return }
                if let normalized = normalizedPoint(for: location, container: container, fitted: fitted) {
                    onTapMap(normalized)
                }
            }
            .gesture(isInteractive ? magnifyGesture(container: container, fitted: fitted) : nil)
            .simultaneousGesture(isInteractive ? dragGesture(container: container, fitted: fitted) : nil)
            .onChange(of: container) { _, newValue in
                let newFitted = MapAsset.fittedSize(in: newValue)
                offset = clampedOffset(offset, scale: totalScale, container: newValue, fitted: newFitted)
            }
        }
    }

    // MARK: - Content

    private func content(laidOut: CGSize) -> some View {
        ZStack {
            if MapAsset.isAvailable {
                Image(MapAsset.imageName)
                    .resizable()
                    .interpolation(.high)
            } else {
                missingMapPlaceholder
            }

            ForEach(markers) { marker in
                markerView(marker)
                    .scaleEffect(1 / liveFactor)
                    .position(x: marker.x * laidOut.width, y: marker.y * laidOut.height)
            }
        }
    }

    private func markerView(_ marker: MapPinMarker) -> some View {
        let isSelected = selectedMarkerIDs.contains(marker.id)
        let size: CGFloat = isSelected ? 34 : 28

        return Button {
            onTapMarker?(marker)
        } label: {
            ZStack {
                Circle()
                    .fill(marker.color)
                    .shadow(color: .black.opacity(0.35), radius: 3, y: 2)
                Circle()
                    .strokeBorder(.white, lineWidth: isSelected ? 3 : 2)
                Text(marker.label)
                    .font(.system(size: isSelected ? 13 : 11, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                    .padding(.horizontal, 4)
            }
            .frame(width: size, height: size)
            .contentShape(Circle())
            .frame(width: 44, height: 44)
        }
        .buttonStyle(.plain)
        .disabled(onTapMarker == nil)
        .animation(.spring(duration: 0.25), value: isSelected)
    }

    private var missingMapPlaceholder: some View {
        ZStack {
            Color(.systemGray5)
            VStack(spacing: 8) {
                Image(systemName: "map")
                    .font(.system(size: 40))
                Text("Map image not found")
                    .font(.headline)
                Text("Add map.svg to Assets.xcassets/Map.imageset")
                    .font(.caption)
                    .multilineTextAlignment(.center)
            }
            .foregroundStyle(.secondary)
            .padding()
        }
    }

    // MARK: - Gestures

    private func magnifyGesture(container: CGSize, fitted: CGSize) -> some Gesture {
        MagnifyGesture()
            .onChanged { value in
                if pinchStart == nil {
                    pinchStart = (committedScale, offset)
                }
                guard let start = pinchStart else { return }

                let target = clamp(start.scale * value.magnification, min: minScale, max: maxScale)
                let anchor = CGPoint(
                    x: value.startLocation.x - container.width / 2,
                    y: value.startLocation.y - container.height / 2
                )
                let ratio = target / start.scale
                let proposed = CGSize(
                    width: anchor.x - (anchor.x - start.offset.width) * ratio,
                    height: anchor.y - (anchor.y - start.offset.height) * ratio
                )

                liveFactor = target / committedScale
                offset = clampedOffset(proposed, scale: target, container: container, fitted: fitted)
            }
            .onEnded { _ in
                commitScale(container: container, fitted: fitted)
                pinchStart = nil
            }
    }

    private func dragGesture(container: CGSize, fitted: CGSize) -> some Gesture {
        DragGesture(minimumDistance: 8)
            .onChanged { value in
                if dragStartOffset == nil {
                    dragStartOffset = offset
                }
                guard let start = dragStartOffset else { return }
                let proposed = CGSize(
                    width: start.width + value.translation.width,
                    height: start.height + value.translation.height
                )
                offset = clampedOffset(proposed, scale: totalScale, container: container, fitted: fitted)
            }
            .onEnded { _ in
                dragStartOffset = nil
            }
    }

    private func handleDoubleTap(at location: CGPoint, container: CGSize, fitted: CGSize) {
        withAnimation(.easeInOut(duration: 0.25)) {
            if totalScale > minScale + 0.01 {
                committedScale = minScale
                liveFactor = 1
                offset = .zero
            } else {
                let target: CGFloat = 2.5
                let anchor = CGPoint(x: location.x - container.width / 2, y: location.y - container.height / 2)
                let ratio = target / totalScale
                let proposed = CGSize(
                    width: anchor.x - (anchor.x - offset.width) * ratio,
                    height: anchor.y - (anchor.y - offset.height) * ratio
                )
                committedScale = target
                liveFactor = 1
                offset = clampedOffset(proposed, scale: target, container: container, fitted: fitted)
            }
        }
    }

    private func commitScale(container: CGSize, fitted: CGSize) {
        let total = totalScale
        committedScale = total
        liveFactor = 1
        offset = clampedOffset(offset, scale: total, container: container, fitted: fitted)
    }

    // MARK: - Geometry

    /// Converts a point in the container's coordinate space to a normalized map coordinate.
    /// Returns nil when the point falls outside the map image.
    private func normalizedPoint(for location: CGPoint, container: CGSize, fitted: CGSize) -> CGPoint? {
        guard fitted.width > 0, fitted.height > 0 else { return nil }
        let scale = totalScale
        let relative = CGPoint(
            x: location.x - container.width / 2 - offset.width,
            y: location.y - container.height / 2 - offset.height
        )
        let mapPoint = CGPoint(
            x: relative.x / scale + fitted.width / 2,
            y: relative.y / scale + fitted.height / 2
        )
        let normalized = CGPoint(x: mapPoint.x / fitted.width, y: mapPoint.y / fitted.height)
        guard (0...1).contains(normalized.x), (0...1).contains(normalized.y) else { return nil }
        return normalized
    }

    /// Keeps the map covering the container when zoomed in, and centered when it fits.
    private func clampedOffset(_ proposed: CGSize, scale: CGFloat, container: CGSize, fitted: CGSize) -> CGSize {
        let scaled = CGSize(width: fitted.width * scale, height: fitted.height * scale)
        let maxX = max(0, (scaled.width - container.width) / 2)
        let maxY = max(0, (scaled.height - container.height) / 2)
        return CGSize(
            width: clamp(proposed.width, min: -maxX, max: maxX),
            height: clamp(proposed.height, min: -maxY, max: maxY)
        )
    }

    private func clamp(_ value: CGFloat, min lower: CGFloat, max upper: CGFloat) -> CGFloat {
        Swift.min(Swift.max(value, lower), upper)
    }
}

#Preview {
    MapCanvasView(markers: [])
}
