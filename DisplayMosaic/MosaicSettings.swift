import Foundation
import Combine

enum MosaicType: String, CaseIterable, Identifiable {
    case pixellate
    case gaussianBlur
    case crystallize

    var id: String { rawValue }

    var localizedName: String {
        switch self {
        case .pixellate: return NSLocalizedString("pixellate", comment: "")
        case .gaussianBlur: return NSLocalizedString("blur", comment: "")
        case .crystallize: return NSLocalizedString("crystallize", comment: "")
        }
    }
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
        // rawValueが変更されたので旧値からのマイグレーション
        let savedType = UserDefaults.standard.string(forKey: "mosaicType") ?? ""
        switch savedType {
        case "ピクセレート": self.mosaicType = .pixellate
        case "ぼかし": self.mosaicType = .gaussianBlur
        case "クリスタライズ": self.mosaicType = .crystallize
        default: self.mosaicType = MosaicType(rawValue: savedType) ?? .pixellate
        }
        let savedStrength = UserDefaults.standard.double(forKey: "mosaicStrength")
        self.strength = savedStrength > 0 ? savedStrength : 30
        let savedMinutes = UserDefaults.standard.object(forKey: "autoMosaicMinutes") != nil
            ? UserDefaults.standard.double(forKey: "autoMosaicMinutes") : 0
        self.autoMosaicMinutes = savedMinutes
        self.autoMosaicEnabled = savedMinutes > 0
    }
}
