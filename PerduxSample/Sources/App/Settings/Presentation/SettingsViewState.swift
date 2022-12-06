import Foundation

@MainActor
class SettingsViewState: PerduxViewState {
    @Published var settings: Settings = .defaultValue

    init(settingsState: SettingsState) {
        Task {
            await initPipelines(settingsState: settingsState)
        }
    }

    private func initPipelines(settingsState: SettingsState) async {
        await settingsState.$settings
                .map { $0 ?? .defaultValue }
                .receive(on: DispatchQueue.main)
                .assign(to: &$settings)
    }
}