import SwiftUI
import UIKit

/// Central access to the garden map image stored in the asset catalog
/// (Assets.xcassets/Map.imageset/map.svg).
enum MapAsset {
    static let imageName = "Map"

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
}
