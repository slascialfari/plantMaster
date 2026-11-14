import SwiftUI

/// Leaf outlines used as answer illustrations in the identification key. Each leaf points
/// up, with its stalk at the bottom, drawn in a unit square scaled to the available rect.
enum LeafKind: CaseIterable {
    case linear
    case lanceolate
    case oval
    case heart
    case diamond
    case palmLobed
    case pinnLobed
}

struct LeafSilhouette: Shape {
    let kind: LeafKind

    func path(in rect: CGRect) -> Path {
        let p = Mapper(rect: rect)
        var path = Path()

        switch kind {
        case .linear:
            path.move(to: p(0.50, 0.02))
            path.addQuadCurve(to: p(0.50, 0.98), control: p(0.64, 0.50))
            path.addQuadCurve(to: p(0.50, 0.02), control: p(0.36, 0.50))

        case .lanceolate:
            path.move(to: p(0.50, 0.03))
            path.addCurve(to: p(0.50, 0.84), control1: p(0.60, 0.22), control2: p(0.74, 0.70))
            path.addCurve(to: p(0.50, 0.03), control1: p(0.26, 0.70), control2: p(0.40, 0.22))

        case .oval:
            path.move(to: p(0.50, 0.05))
            path.addCurve(to: p(0.50, 0.84), control1: p(0.86, 0.14), control2: p(0.86, 0.78))
            path.addCurve(to: p(0.50, 0.05), control1: p(0.14, 0.78), control2: p(0.14, 0.14))

        case .heart:
            path.move(to: p(0.50, 0.06))
            path.addCurve(to: p(0.93, 0.56), control1: p(0.60, 0.22), control2: p(0.95, 0.32))
            path.addCurve(to: p(0.50, 0.72), control1: p(0.91, 0.86), control2: p(0.58, 0.92))
            path.addCurve(to: p(0.07, 0.56), control1: p(0.42, 0.92), control2: p(0.09, 0.86))
            path.addCurve(to: p(0.50, 0.06), control1: p(0.05, 0.32), control2: p(0.40, 0.22))

        case .diamond:
            // Birch-like: long pointed tip, widest low down, short straight-ish base.
            path.move(to: p(0.50, 0.04))
            path.addQuadCurve(to: p(0.86, 0.58), control: p(0.62, 0.36))
            path.addQuadCurve(to: p(0.50, 0.82), control: p(0.74, 0.72))
            path.addQuadCurve(to: p(0.14, 0.58), control: p(0.26, 0.72))
            path.addQuadCurve(to: p(0.50, 0.04), control: p(0.38, 0.36))

        case .palmLobed:
            // Five pointed lobes radiating from the stalk, like a maple.
            let centre = (x: 0.50, y: 0.64)
            func polar(_ degrees: Double, _ radius: Double) -> CGPoint {
                let a = degrees * .pi / 180
                return p(centre.x + radius * sin(a), centre.y - radius * cos(a))
            }
            // Each lobe is a broad wedge: shoulder, pointed tip, shoulder; sinuses between.
            let lobes: [(angle: Double, radius: Double)] = [
                (-122, 0.36), (-62, 0.50), (0, 0.60), (62, 0.50), (122, 0.36),
            ]
            let sinuses: [(angle: Double, radius: Double)] = [
                (-92, 0.20), (-31, 0.27), (31, 0.27), (92, 0.20),
            ]
            path.move(to: p(0.50, 0.74))
            for (i, lobe) in lobes.enumerated() {
                path.addLine(to: polar(lobe.angle - 15, lobe.radius * 0.72))
                path.addLine(to: polar(lobe.angle, lobe.radius))
                path.addLine(to: polar(lobe.angle + 15, lobe.radius * 0.72))
                if i < sinuses.count {
                    path.addQuadCurve(
                        to: polar(lobes[i + 1].angle - 15, lobes[i + 1].radius * 0.72),
                        control: polar(sinuses[i].angle, sinuses[i].radius)
                    )
                }
            }
            path.closeSubpath()

        case .pinnLobed:
            // Rounded lobes along both sides, like an oak.
            let samples = 80
            func halfWidth(_ t: Double) -> Double {
                let envelope = 0.34 * pow(sin(.pi * min(max(t, 0), 1)), 0.7)
                let lobes = 0.55 + 0.45 * abs(sin(3.5 * .pi * t))
                return envelope * lobes
            }
            let top = 0.05, bottom = 0.84
            path.move(to: p(0.50, top))
            for i in 0...samples {
                let t = Double(i) / Double(samples)
                path.addLine(to: p(0.50 + halfWidth(t), top + (bottom - top) * t))
            }
            for i in stride(from: samples, through: 0, by: -1) {
                let t = Double(i) / Double(samples)
                path.addLine(to: p(0.50 - halfWidth(t), top + (bottom - top) * t))
            }
            path.closeSubpath()
        }
        return path
    }
}

/// Maps unit-square coordinates into a rect, keeping the drawing square and centred.
private struct Mapper {
    let origin: CGPoint
    let side: CGFloat

    init(rect: CGRect) {
        side = min(rect.width, rect.height)
        origin = CGPoint(x: rect.midX - side / 2, y: rect.midY - side / 2)
    }

    func callAsFunction(_ x: Double, _ y: Double) -> CGPoint {
        CGPoint(x: origin.x + side * x, y: origin.y + side * y)
    }
}

/// A filled leaf with its midrib and stalk.
struct LeafIllustration: View {
    let kind: LeafKind
    var color: Color = AppTheme.brandGreen

    /// Where the blade meets the stalk, in unit coordinates.
    private var baseY: Double {
        switch kind {
        case .heart: return 0.72
        case .palmLobed: return 0.74
        default: return 0.82
        }
    }

    var body: some View {
        GeometryReader { geo in
            let side = min(geo.size.width, geo.size.height)
            let p = Mapper(rect: CGRect(origin: .zero, size: geo.size))
            ZStack {
                LeafSilhouette(kind: kind)
                    .fill(color)

                if kind != .linear {
                    // Midrib.
                    Path { path in
                        path.move(to: p(0.50, 0.12))
                        path.addLine(to: p(0.50, baseY - 0.02))
                    }
                    .stroke(.white.opacity(0.55), style: StrokeStyle(lineWidth: max(1, side * 0.025), lineCap: .round))

                    // Stalk, starting just inside the blade so it always joins it.
                    Path { path in
                        path.move(to: p(0.50, baseY - 0.03))
                        path.addLine(to: p(0.50, 0.99))
                    }
                    .stroke(color, style: StrokeStyle(lineWidth: max(1.2, side * 0.04), lineCap: .round))
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .accessibilityHidden(true)
    }
}

#Preview {
    HStack {
        ForEach(LeafKind.allCases, id: \.self) { kind in
            LeafIllustration(kind: kind).frame(width: 48, height: 48)
        }
    }
    .padding()
}
