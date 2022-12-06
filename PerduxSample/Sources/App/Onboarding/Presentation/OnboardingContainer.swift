import SwiftUI

struct OnboardingContainer: View {
    @EnvironmentObject private var settingsState: SettingsViewState

    var body: some View {
        content
    }

    private var content: some View {
        OnboardingView(
                props: .init(),
                actions: .init(
                        completeOnboarding: completeOnboarding
                )
        )
    }

    private func completeOnboarding() async {
		await actions(.concurrently) {
			NavigationAction.setRootPage(new: .app)
			SettingsSideEffect.upsertSettings(
				newSettings: settingsState.settings.apply(onboarded: true)
			)
		}
    }
}
