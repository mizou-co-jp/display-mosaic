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

    @Published var strength: Double {
        didSet { UserDefaults.standard.set(strength, forKey: "mosaicStrength") }
    }

    @Published var autoMosaicEnabled: Bool {
        didSet { UserDefaults.standard.set(autoMosaicEnabled, forKey: "autoMosaicEnabled") }
    }

    @Published var autoMosaicMinutes: Double {
        didSet { UserDefaults.standard.set(autoMosaicMinutes, forKey: "autoMosaicMinutes") }
    }

    private init() {
        let savedType = UserDefaults.standard.string(forKey: "mosaicType") ?? ""
        self.mosaicType = MosaicType(rawValue: savedType) ?? .pixellate
        let savedStrength = UserDefaults.standard.double(forKey: "mosaicStrength")
        self.strength = savedStrength > 0 ? savedStrength : 30
        let savedMinutes = UserDefaults.standard.object(forKey: "autoMosaicMinutes") != nil
            ? UserDefaults.standard.double(forKey: "autoMosaicMinutes") : 0
        self.autoMosaicMinutes = savedMinutes
        self.autoMosaicEnabled = savedMinutes > 0
    }
}
