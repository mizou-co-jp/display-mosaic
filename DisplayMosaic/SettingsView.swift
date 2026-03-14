import SwiftUI
import ServiceManagement

struct SettingsView: View {
    @ObservedObject private var settings = MosaicSettings.shared
    @State private var isActive = MosaicOverlayManager.shared.isActive
    @State private var launchAtLogin = SMAppService.mainApp.status == .enabled

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // ヘッダー
            HStack {
                Image(systemName: "eye.slash.fill")
                    .font(.title2)
                    .foregroundColor(.accentColor)
                Text("Display Mosaic")
                    .font(.headline)
                Spacer()
            }

            Divider()

            // モザイク種類
            VStack(alignment: .leading, spacing: 6) {
                Text("モザイクの種類")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Picker("", selection: $settings.mosaicType) {
                    ForEach(MosaicType.allCases) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(.segmented)
                .labelsHidden()
            }

            // 強度スライダー
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("強度")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(Int(settings.strength))")
                        .font(.subheadline)
                        .monospacedDigit()
                        .foregroundColor(.secondary)
                }
                HStack {
                    Text("弱")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Slider(value: $settings.strength, in: 1...100, step: 1)
                    Text("強")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Divider()

            // 有効化ボタン
            Button(action: toggleMosaic) {
                HStack {
                    Spacer()
                    Image(systemName: isActive ? "eye.fill" : "eye.slash.fill")
                    Text(isActive ? "モザイクを解除" : "モザイクを有効にする")
                        .fontWeight(.medium)
                    Spacer()
                }
                .padding(.vertical, 6)
            }
            .buttonStyle(.borderedProminent)
            .tint(isActive ? .red : .accentColor)

            if isActive {
                HStack {
                    Spacer()
                    Text("Escキーで解除できます")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                }
            }

            Divider()

            // ログイン時に起動
            Toggle("ログイン時に自動起動", isOn: $launchAtLogin)
                .font(.subheadline)
                .onChange(of: launchAtLogin) { newValue in
                    do {
                        if newValue {
                            try SMAppService.mainApp.register()
                        } else {
                            try SMAppService.mainApp.unregister()
                        }
                    } catch {
                        launchAtLogin = SMAppService.mainApp.status == .enabled
                    }
                }

            // 終了ボタン
            HStack {
                Spacer()
                Button("終了") {
                    NSApplication.shared.terminate(nil)
                }
                .buttonStyle(.plain)
                .foregroundColor(.secondary)
                .font(.caption)
            }
        }
        .padding(16)
        .frame(width: 280)
        .onReceive(NotificationCenter.default.publisher(for: .mosaicStateDidChange)) { notification in
            if let active = notification.userInfo?["isActive"] as? Bool {
                isActive = active
            }
        }
    }

    private func toggleMosaic() {
        if isActive {
            MosaicOverlayManager.shared.deactivate()
        } else {
            NSApp.windows.forEach { window in
                if let popover = window as? NSPanel {
                    popover.orderOut(nil)
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                MosaicOverlayManager.shared.activate()
            }
        }
    }
}
