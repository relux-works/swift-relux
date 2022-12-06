import Foundation

protocol ISettingsSaga: PerduxSaga {
}

class SettingsSaga: ISettingsSaga {
    private let settingsSvc: ISettingsService

    init(
            settingsSvc: ISettingsService
    ) {
        self.settingsSvc = settingsSvc
    }

    func apply(_ effect: PerduxEffect) async {
        switch effect as? SettingsSideEffect {
        case .obtainSettings: await obtainSettings()
        case let .upsertSettings(newSettings): await upsertSettings(new: newSettings)
        case .none: break
        }
    }

    private func obtainSettings() async {
        let res = settingsSvc.getSettings()
        switch settingsSvc.getSettings() {
        case let .success(settings):
            await SettingsAction.obtainSettingsSuccess(settings: settings).perform()
        case let .failure(err):
            await SettingsAction.obtainSettingsFail.perform()
        }
    }

    private func upsertSettings(new settings: Settings) async {
        switch settingsSvc.upsertSettings(new: settings) {
        case .success:
            await SettingsAction.upsertSettingsSuccess(newSettings: settings)
        case let .failure(err):
            log(err)
            await SettingsAction.upsertSettingsFail
        }
    }
}