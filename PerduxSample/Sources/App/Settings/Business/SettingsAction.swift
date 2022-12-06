import Foundation

enum SettingsAction: PerduxAction {
    case obtainSettingsSuccess(settings: Settings)
    case obtainSettingsFail

    case upsertSettingsSuccess(newSettings: Settings)
    case upsertSettingsFail
}