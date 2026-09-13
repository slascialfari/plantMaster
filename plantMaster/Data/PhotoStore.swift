import Foundation
import ImageIO
import UIKit

enum PhotoStore {
    /// Longest edge, in pixels, that a photo is stored at. Camera photos are far larger
    /// than anything the app displays, so they are downscaled once on save.
    static let storedMaxPixel: CGFloat = 2048

    /// Longest edge for list and strip thumbnails (points × 3 for Retina).
    static let thumbnailMaxPixel: CGFloat = 200

    /// Longest edge for the large photo shown in the detail pager and practice questions.
    static let displayMaxPixel: CGFloat = 1600

    private static let cache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.totalCostLimit = 120 * 1024 * 1024
        return cache
    }()

    private static var directory: URL = {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let dir = documents.appendingPathComponent("PlantPhotos", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir
    }()

    // MARK: - Saving

    static func save(_ image: UIImage) -> String? {
        let stored = downscaled(image, maxPixel: storedMaxPixel)
        guard let data = stored.jpegData(compressionQuality: 0.85) else { return nil }
        let filename = "\(UUID().uuidString).jpg"
        let url = directory.appendingPathComponent(filename)
        do {
            try data.write(to: url)
            return filename
        } catch {
            return nil
        }
    }

    private static func downscaled(_ image: UIImage, maxPixel: CGFloat) -> UIImage {
        let pixelSize = CGSize(width: image.size.width * image.scale, height: image.size.height * image.scale)
        let longest = max(pixelSize.width, pixelSize.height)
        guard longest > maxPixel else { return image }

        let factor = maxPixel / longest
        let target = CGSize(width: floor(pixelSize.width * factor), height: floor(pixelSize.height * factor))
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        format.opaque = true
        return UIGraphicsImageRenderer(size: target, format: format).image { _ in
            image.draw(in: CGRect(origin: .zero, size: target))
        }
    }

    // MARK: - Loading

    /// Small image for rows and thumbnail strips.
    static func thumbnail(filename: String) -> UIImage? {
        image(filename: filename, maxPixel: thumbnailMaxPixel)
    }

    /// Large image for the detail pager and practice prompts.
    static func display(filename: String) -> UIImage? {
        image(filename: filename, maxPixel: displayMaxPixel)
    }

    /// Loads a photo downsampled to `maxPixel` on its longest edge, decoding only as many
    /// pixels as needed. Results are cached in memory so repeated renders are free.
    static func image(filename: String, maxPixel: CGFloat) -> UIImage? {
        let key = "\(filename)#\(Int(maxPixel))" as NSString
        if let cached = cache.object(forKey: key) {
            return cached
        }

        let url = directory.appendingPathComponent(filename)
        guard let source = CGImageSourceCreateWithURL(url as CFURL, nil) else { return nil }
        let options: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceThumbnailMaxPixelSize: maxPixel,
        ]
        guard let cgImage = CGImageSourceCreateThumbnailAtIndex(source, 0, options as CFDictionary) else { return nil }

        let image = UIImage(cgImage: cgImage)
        cache.setObject(image, forKey: key, cost: cgImage.bytesPerRow * cgImage.height)
        return image
    }

    // MARK: - Deleting

    static func delete(filename: String) {
        let url = directory.appendingPathComponent(filename)
        try? FileManager.default.removeItem(at: url)
        for maxPixel in [thumbnailMaxPixel, displayMaxPixel] {
            cache.removeObject(forKey: "\(filename)#\(Int(maxPixel))" as NSString)
        }
    }
}
