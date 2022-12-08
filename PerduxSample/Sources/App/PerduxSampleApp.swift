@_exported import Perdux
@_exported import Logger
@_exported import SwiftPlus
@_exported import FoundationPlus
import SwiftUI

@main @MainActor
struct PerduxSampleApp: App {
    private let appStore: PerduxStore = .init()
    private let rootSaga: PerduxRootSaga = .init()

    init() {
        let time = measure {
            modules()
            configureIoC()
            configureAppStore()
            configureRootSaga()
            setupAppContext()
            configureAppearance()
        }
        log("app initialization took: \(time)", category: .performance)
    }

    var body: some Scene {
        WindowGroup {
            ContentContainer(
                    appStore: appStore
            )
            .accentColor(Color.green)
        }
    }

    private func modules() {
    }

    private func configureIoC() {
        ObjectFactory.initialize(with: DIContainer.build())
    }

    private func configureAppStore() {

        //business states
        appStore.connectState(state: NavigationState())
        appStore.connectState(state: SettingsState())

        //view states
        appStore.connectViewState(state: NavigationViewState(navState: appStore.getState(NavigationState.self)))
        appStore.connectViewState(state: SettingsViewState(settingsState: appStore.getState(SettingsState.self)))
    }

    private func configureRootSaga() {
        rootSaga.add(saga: F.get(type: ISettingsSaga.self)!)
    }

    private func setupAppContext() {
        Task {
            let setupContextTime = await measure {
				await actions(.concurrently) {
					SettingsSideEffect.obtainSettings
				}
            }

            log("App setup context took \(setupContextTime)", category: .performance)
        }

    }

    private func configureAppearance() {
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(Color.green)
    }
}


