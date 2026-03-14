import AppKit
import Combine

/// 全画面モザイクオーバーレイの表示・非表示を管理する
final class MosaicOverlayManager {

    static let shared = MosaicOverlayManager()

    @Published private(set) var isActive = false

    private var overlayWindows: [MosaicOverlayWindow] = []
    private var localKeyMonitor: Any?

    private static let escapeKeyCode: UInt16 = 53

    private init() {}

    func activate() {
        guard !isActive else { return }

        let settings = MosaicSettings.shared

        for screen in NSScreen.screens {
            guard let mosaicImage = ScreenCapture.captureAndApplyMosaic(
                screen: screen,
                type: settings.mosaicType,
                strength: settings.strength
            ) else { continue }

            let window = MosaicOverlayWindow(screen: screen, image: mosaicImage)
            window.makeKeyAndOrderFront(nil)
            overlayWindows.append(window)
        }

        startKeyMonitoring()
        isActive = true
    }

    func deactivate() {
        stopKeyMonitoring()

        for window in overlayWindows {
            window.orderOut(nil)
        }
        overlayWindows.removeAll()

        isActive = false
    }

    private func startKeyMonitoring() {
        localKeyMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            if event.keyCode == Self.escapeKeyCode {
                self?.deactivate()
                return nil
            }
            return event
        }
    }

    private func stopKeyMonitoring() {
        if let monitor = localKeyMonitor {
            NSEvent.removeMonitor(monitor)
            localKeyMonitor = nil
        }
    }
}
