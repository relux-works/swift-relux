import SwiftUI

struct SettingsContainer: View {
    @EnvironmentObject private var settingsState: SettingsViewState

    var body: some View {
        content
    }

    private var content: some View {
        SettingsView(
                props: .init(),
                actions: .init(
                        setNotOnboarded: setNotOnboarded,
                        openSampleSheet: openSampleSheet
                )
        )
    }

    private func setNotOnboarded() async {
        await [
            SettingsSideEffect.upsertSettings(
                    newSettings: settingsState.settings.apply(onboarded: false)
            ),
            NavigationAction.setRootPage(new: .onboarding),
            NavigationAction.setAppPage(new: .stocksChart),
        ].sequentialPerform()
    }

    private func openSampleSheet() async {
        await NavigationAction.setModalSheet(new: .sampleSheet).perform()
    }
}