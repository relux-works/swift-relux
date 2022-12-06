import SwiftUI

struct SplashContainer: View {
    @EnvironmentObject private var settingsState: SettingsViewState

    var body: some View {
        content
    }

    private var content: some View {
        Splash(
            props: .init(),
            actions: .init(
                next: next
            )
        )
    }

    private func next() async {
        switch settingsState.settings.isOnboarded {
        case true:
			await action {
				NavigationAction.setRootPage(new: .app)
			}
        case false:
			await action {
				NavigationAction.setRootPage(new: .onboarding)
			}
        }
    }
}
