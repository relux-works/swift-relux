import SwiftUI

struct SettingsContainer: View {
    @EnvironmentObject private var settingsState: SettingsViewState

    var body: some View {
        content
    }

    private var content: some View {
        NavigationView {
            SettingsView(
                    props: .init(),
                    actions: .init(
                            setNotOnboarded: setNotOnboarded,
                            openSampleSheet: openSampleSheet
                    )
            )
        }
    }

    private func setNotOnboarded() async {
		await actions {
			SettingsSideEffect.upsertSettings(
				newSettings: settingsState.settings.apply(onboarded: false)
			)
			NavigationAction.setRootPage(new: .onboarding)
			NavigationAction.setAppPage(new: .stocksChart)
		}
    }

    private func openSampleSheet() async {
		await action {
			NavigationAction.setModalSheet(new: .sampleSheet)
		}
    }
}
