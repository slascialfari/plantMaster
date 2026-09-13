import SwiftUI
import UIKit

/// Central access to the garden map image stored in the asset catalog
/// (Assets.xcassets/Map.imageset/map.svg).
///
/// The SVG is a very heavy vector (hundreds of thousands of path segments), so drawing it
/// directly makes Core Graphics re-rasterise it every time its size changes. Instead it is
/// rendered once, in the background, into a bitmap that the views can scale cheaply.
enum MapAsset {
    static let imageName = "Map"

    /// Longest edge of the pre-rendered bitmap, in pixels. Large enough to stay sharp at
    /// the canvas's maximum zoom on a phone, small enough to fit comfortably in memory.
    static let renderedMaxPixel: CGFloat = 3072

    /// Width divided by height of the map image. Falls back to 16:10 if the asset is missing.
    static let aspectRatio: CGFloat = {
        guard let size = UIImage(named: imageName)?.size, size.height > 0 else { return 1.6 }
        return size.width / size.height
    }()

    static var isAvailable: Bool {
        UIImage(named: imageName) != nil
    }

    /// Largest size with the map's aspect ratio that fits inside `container`.
    static func fittedSize(in container: CGSize) -> CGSize {
        guard container.width > 0, container.height > 0 else { return .zero }
        if container.width / container.height > aspectRatio {
            return CGSize(width: container.height * aspectRatio, height: container.height)
        } else {
            return CGSize(width: container.width, height: container.width / aspectRatio)
        }
    }

    /// Rasterises the vector asset once at `renderedMaxPixel`. Safe to call off the main thread.
    static func renderBitmap() -> UIImage? {
        guard let vector = UIImage(named: imageName), vector.size.width > 0, vector.size.height > 0 else {
            return nil
        }
        let longest = max(vector.size.width, vector.size.height)
        let factor = renderedMaxPixel / longest
        let target = CGSize(width: floor(vector.size.width * factor), height: floor(vector.size.height * factor))

        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        format.opaque = true
        return UIGraphicsImageRenderer(size: target, format: format).image { context in
            UIColor.white.setFill()
            context.fill(CGRect(origin: .zero, size: target))
            vector.draw(in: CGRect(origin: .zero, size: target))
        }
    }
}

/// Holds the rendered map bitmap for the lifetime of the app and renders it on first request.
@Observable
final class MapImageLoader {
    static let shared = MapImageLoader()

    private(set) var image: UIImage?
    private(set) var isLoading = false

    private init() {}

    func loadIfNeeded() {
        guard image == nil, !isLoading else { return }
        isLoading = true
        Task.detached(priority: .userInitiated) {
            let rendered = MapAsset.renderBitmap()
            await MainActor.run {
                self.image = rendered
                self.isLoading = false
            }
        }
    }
}
