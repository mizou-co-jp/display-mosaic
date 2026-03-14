import AppKit
import CoreGraphics

enum ScreenRecordingPermission {

    static func requestIfNeeded() {
        guard !hasPermission() else { return }

        let alert = NSAlert()
        alert.messageText = NSLocalizedString("screen_recording_required", comment: "")
        alert.informativeText = NSLocalizedString("screen_recording_description", comment: "")
        alert.alertStyle = .warning
        alert.addButton(withTitle: NSLocalizedString("open_system_settings", comment: ""))
        alert.addButton(withTitle: NSLocalizedString("later", comment: ""))

        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            openScreenRecordingSettings()
        }
    }

    static func hasPermission() -> Bool {
        let testImage = CGDisplayCreateImage(CGMainDisplayID())
        return testImage != nil
    }

    private static func openScreenRecordingSettings() {
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture") {
            NSWorkspace.shared.open(url)
        }
    }
}
