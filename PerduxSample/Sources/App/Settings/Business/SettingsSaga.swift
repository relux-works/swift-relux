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
				await action {
					SettingsAction.obtainSettingsSuccess(settings: settings)
				}
        case .failure:
				await action {
					SettingsAction.obtainSettingsFail
				}
        }
    }

    private func upsertSettings(new settings: Settings) async {
		switch settingsSvc.upsertSettings(new: settings) {
		case .success:
			await action {
				SettingsAction.upsertSettingsSuccess(newSettings: settings)
			}
		case let .failure(err):
			log(err)
			await action {
				SettingsAction.upsertSettingsFail
			}
		}
    }
}
