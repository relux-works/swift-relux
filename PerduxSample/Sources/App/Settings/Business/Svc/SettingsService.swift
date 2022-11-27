import Foundation
import FoundationPlus

protocol ISettingsService {
    func getSettings() -> Result<Settings, SettingsError>
    func upsertSettings(new settings: Settings) -> Result<Void, SettingsError>
}

class SettingsService: ISettingsService {
    private let store: UserDefaults

    init(store: UserDefaults) {
        self.store = store
    }

    func getSettings() -> Result<Settings, SettingsError> {
        let value = store.value(forKey: Key.appSettings.rawValue) as? Data
        let settings = Settings.init(fromJsonData: value) ?? .defaultValue
        return .success(settings)
    }

    func upsertSettings(new settings: Settings) -> Result<Void, SettingsError> {
        store.set(settings.asJsonData, forKey: Key.appSettings.rawValue)
        return .success(())
    }
}