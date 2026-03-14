import Foundation
import Combine

enum MosaicType: String, CaseIterable, Identifiable {
    case pixellate = "ピクセレート"
    case gaussianBlur = "ぼかし"
    case crystallize = "クリスタライズ"

    var id: String { rawValue }
}

final class MosaicSettings: ObservableObject {
    static let shared = MosaicSettings()

    @Published var mosaicType: MosaicType {
        didSet { UserDefaults.standard.set(mosaicType.rawValue, forKey: "mosaicType") }
    }

    /// 1〜100 の強度値
    @Published var strength: Double {
        didSet { UserDefaults.standard.set(strength, forKey: "mosaicStrength") }
    }

    /// 自動モザイクが有効かどうか
    @Published var autoMosaicEnabled: Bool {
        didSet { UserDefaults.standard.set(autoMosaicEnabled, forKey: "autoMosaicEnabled") }
    }

    /// 自動モザイクまでのアイドル時間（分）
    @Published var autoMosaicMinutes: Double {
        didSet { UserDefaults.standard.set(autoMosaicMinutes, forKey: "autoMosaicMinutes") }
    }

    private init() {
        let savedType = UserDefaults.standard.string(forKey: "mosaicType") ?? MosaicType.pixellate.rawValue
        self.mosaicType = MosaicType(rawValue: savedType) ?? .pixellate
        let savedStrength = UserDefaults.standard.double(forKey: "mosaicStrength")
        self.strength = savedStrength > 0 ? savedStrength : 30
        self.autoMosaicEnabled = UserDefaults.standard.bool(forKey: "autoMosaicEnabled")
        let savedMinutes = UserDefaults.standard.double(forKey: "autoMosaicMinutes")
        self.autoMosaicMinutes = savedMinutes > 0 ? savedMinutes : 5
    }
}
