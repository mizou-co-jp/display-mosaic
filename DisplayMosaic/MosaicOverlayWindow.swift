import AppKit

/// 画面全体を覆うモザイクオーバーレイウィンドウ
final class MosaicOverlayWindow: NSWindow {

    init(screen: NSScreen, image: NSImage) {
        super.init(
            contentRect: screen.frame,
            styleMask: .borderless,
            backing: .buffered,
            defer: false
        )

        self.level = .statusBar + 1
        self.isOpaque = true
        self.hasShadow = false
        self.ignoresMouseEvents = false
        self.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        self.backgroundColor = .black

        let imageView = NSImageView(frame: screen.frame)
        imageView.image = image
        imageView.imageScaling = .scaleAxesIndependently
        imageView.autoresizingMask = [.width, .height]
        self.contentView = imageView
    }
}
