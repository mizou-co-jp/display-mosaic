import AppKit

/// 全画面モザイクオーバーレイの表示・非表示を管理する
final class MosaicOverlayManager {

    static let shared = MosaicOverlayManager()

    private var overlayWindows: [MosaicOverlayWindow] = []
    private var globalKeyMonitor: Any?
    private var localKeyMonitor: Any?

    var isActive: Bool { !overlayWindows.isEmpty }

    private init() {}

    /// モザイクオーバーレイを全スクリーンに表示する
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

        NotificationCenter.default.post(
            name: .mosaicStateDidChange,
            object: nil,
            userInfo: ["isActive": true]
        )
    }

    /// モザイクオーバーレイを解除する
    func deactivate() {
        stopKeyMonitoring()

        for window in overlayWindows {
            window.orderOut(nil)
        }
        overlayWindows.removeAll()

        NotificationCenter.default.post(
            name: .mosaicStateDidChange,
            object: nil,
            userInfo: ["isActive": false]
        )
    }

    private func startKeyMonitoring() {
        localKeyMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            if event.keyCode == 53 { // Escape
                self?.deactivate()
                return nil
            }
            return event
        }

        globalKeyMonitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
            if event.keyCode == 53 {
                self?.deactivate()
            }
        }
    }

    private func stopKeyMonitoring() {
        if let monitor = localKeyMonitor {
            NSEvent.removeMonitor(monitor)
            localKeyMonitor = nil
        }
        if let monitor = globalKeyMonitor {
            NSEvent.removeMonitor(monitor)
            globalKeyMonitor = nil
        }
    }
}

extension Notification.Name {
    static let mosaicStateDidChange = Notification.Name("mosaicStateDidChange")
}
