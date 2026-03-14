import AppKit
import CoreGraphics
import Combine

/// システムのアイドル時間を監視し、指定時間経過後にモザイクを自動適用する
final class IdleMonitor {

    static let shared = IdleMonitor()

    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()

    private init() {
        let settings = MosaicSettings.shared

        // 設定変更を監視して自動的にタイマーを再構成
        settings.$autoMosaicEnabled
            .combineLatest(settings.$autoMosaicMinutes)
            .sink { [weak self] enabled, _ in
                if enabled {
                    self?.startMonitoring()
                } else {
                    self?.stopMonitoring()
                }
            }
            .store(in: &cancellables)
    }

    /// アイドル監視を開始
    func startMonitoring() {
        stopMonitoring()

        // 10秒ごとにアイドル時間をチェック
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { [weak self] _ in
            self?.checkIdleTime()
        }
    }

    /// アイドル監視を停止
    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
    }

    private func checkIdleTime() {
        let settings = MosaicSettings.shared
        guard settings.autoMosaicEnabled else { return }
        guard !MosaicOverlayManager.shared.isActive else { return }

        let idleSeconds = CGEventSource.secondsSinceLastEventType(
            .combinedSessionState,
            eventType: CGEventType(rawValue: ~0)!
        )

        let thresholdSeconds = settings.autoMosaicMinutes * 60

        if idleSeconds >= thresholdSeconds {
            DispatchQueue.main.async {
                MosaicOverlayManager.shared.activate()
            }
        }
    }
}
