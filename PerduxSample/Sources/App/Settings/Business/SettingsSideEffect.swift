import Foundation

enum SettingsSideEffect: PerduxEffect {
    case obtainSettings
    case upsertSettings(newSettings: Settings)
}