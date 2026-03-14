import AppKit
import CoreGraphics

enum ScreenRecordingPermission {

    /// 画面収録の権限がなければシステム設定を開くよう促す
    static func requestIfNeeded() {
        guard !hasPermission() else { return }

        let alert = NSAlert()
        alert.messageText = "画面収録の許可が必要です"
        alert.informativeText = "DisplayMosaic は画面にモザイクをかけるために画面収録の許可が必要です。\n\n「システム設定 → プライバシーとセキュリティ → 画面収録」から DisplayMosaic を許可してください。"
        alert.alertStyle = .warning
        alert.addButton(withTitle: "システム設定を開く")
        alert.addButton(withTitle: "後で")

        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            openScreenRecordingSettings()
        }
    }

    /// 画面収録の権限があるかチェック
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
