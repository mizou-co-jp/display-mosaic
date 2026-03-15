import SwiftUI
import ServiceManagement

struct SettingsView: View {
    @ObservedObject private var settings = MosaicSettings.shared
    @State private var isActive = MosaicOverlayManager.shared.isActive
    @State private var launchAtLogin = SMAppService.mainApp.status == .enabled

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Display Mosaic")
                    .font(.headline)
                Spacer()
            }

            Divider()

            // モザイク種類
            VStack(alignment: .leading, spacing: 6) {
                Text("mosaic_type")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Picker("", selection: $settings.mosaicType) {
                    ForEach(MosaicType.allCases) { type in
                        Text(type.localizedName).tag(type)
                    }
                }
                .pickerStyle(.segmented)
                .labelsHidden()
            }

            // 強度スライダー
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("strength")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(Int(settings.strength))")
                        .font(.subheadline)
                        .monospacedDigit()
                        .foregroundColor(.secondary)
                }
                HStack {
                    Text("weak")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Slider(value: $settings.strength, in: 1...100, step: 1)
                    Text("strong")
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
                    Text(isActive ? "disable_mosaic" : "enable_mosaic")
                        .fontWeight(.medium)
                    Spacer()
                }
                .padding(.vertical, 6)
            }
            .buttonStyle(.borderedProminent)
            .tint(isActive ? .red : .accentColor)

            HStack {
                Spacer()
                Text("press_esc_to_dismiss")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
            }

            Divider()

            // 自動モザイク
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("auto_mosaic")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(autoMosaicLabel)
                        .font(.subheadline)
                        .monospacedDigit()
                        .foregroundColor(.secondary)
                }
                HStack {
                    Text("off")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Slider(value: $settings.autoMosaicMinutes, in: 0...30, step: 1)
                        .onChange(of: settings.autoMosaicMinutes) { newValue in
                            settings.autoMosaicEnabled = newValue > 0
                        }
                    Text(String(format: NSLocalizedString("minutes_format", comment: ""), 30))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                if settings.autoMosaicEnabled {
                    Text(String(format: NSLocalizedString("auto_mosaic_description", comment: ""), Int(settings.autoMosaicMinutes)))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Divider()

            // ログイン時に起動
            Toggle(LocalizedStringKey("launch_at_login"), isOn: $launchAtLogin)
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

            HStack {
                Spacer()
                Button("quit") {
                    NSApplication.shared.terminate(nil)
                }
                .buttonStyle(.plain)
                .foregroundColor(.secondary)
                .font(.caption)
            }
        }
        .padding(16)
        .frame(width: 280)
        .fixedSize(horizontal: false, vertical: true)
        .onReceive(MosaicOverlayManager.shared.$isActive) { active in
            isActive = active
        }
    }

    private var autoMosaicLabel: String {
        if settings.autoMosaicMinutes == 0 {
            return NSLocalizedString("off", comment: "")
        }
        return String(format: NSLocalizedString("minutes_format", comment: ""), Int(settings.autoMosaicMinutes))
    }

    private func toggleMosaic() {
        if isActive {
            MosaicOverlayManager.shared.deactivate()
        } else {
            MosaicOverlayManager.shared.activate()
        }
    }
}
