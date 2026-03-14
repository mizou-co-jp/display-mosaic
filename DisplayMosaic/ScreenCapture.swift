import AppKit
import CoreImage
import CoreImage.CIFilterBuiltins

struct ScreenCapture {

    /// 指定されたスクリーンをキャプチャし、モザイク処理した NSImage を返す
    static func captureAndApplyMosaic(
        screen: NSScreen,
        type: MosaicType,
        strength: Double
    ) -> NSImage? {
        let displayID = screen.displayID
        guard let cgImage = CGDisplayCreateImage(displayID) else { return nil }

        let ciImage = CIImage(cgImage: cgImage)
        let context = CIContext()

        guard let filtered = applyFilter(to: ciImage, type: type, strength: strength),
              let cgOutput = context.createCGImage(filtered, from: filtered.extent)
        else { return nil }

        let size = NSSize(width: cgImage.width, height: cgImage.height)
        return NSImage(cgImage: cgOutput, size: size)
    }

    private static func applyFilter(
        to image: CIImage,
        type: MosaicType,
        strength: Double
    ) -> CIImage? {
        // strength: 1〜100 を各フィルタの適切な範囲にマッピング
        switch type {
        case .pixellate:
            let scale = mapStrength(strength, min: 2, max: 80)
            let filter = CIFilter.pixellate()
            filter.inputImage = image
            filter.scale = Float(scale)
            filter.center = CGPoint(x: image.extent.midX, y: image.extent.midY)
            return filter.outputImage

        case .gaussianBlur:
            let radius = mapStrength(strength, min: 2, max: 100)
            let filter = CIFilter.gaussianBlur()
            filter.inputImage = image
            filter.radius = Float(radius)
            return filter.outputImage?.cropped(to: image.extent)

        case .crystallize:
            let radius = mapStrength(strength, min: 2, max: 80)
            let filter = CIFilter.crystallize()
            filter.inputImage = image
            filter.radius = Float(radius)
            filter.center = CGPoint(x: image.extent.midX, y: image.extent.midY)
            return filter.outputImage
        }
    }

    private static func mapStrength(_ value: Double, min: Double, max: Double) -> Double {
        return min + (max - min) * (value / 100.0)
    }
}

extension NSScreen {
    var displayID: CGDirectDisplayID {
        let key = NSDeviceDescriptionKey(rawValue: "NSScreenNumber")
        return deviceDescription[key] as? CGDirectDisplayID ?? CGMainDisplayID()
    }
}
