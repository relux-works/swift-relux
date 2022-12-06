import Foundation

extension SettingsState {
    func reduce(with action: SettingsAction) async {
        switch action {
        case let .obtainSettingsSuccess(settings):
            self.settings = settings
        case .obtainSettingsFail: 
            break
            
        case let .upsertSettingsSuccess(newSettings):
            self.settings = newSettings
        case .upsertSettingsFail:
            break
        }
    }
}