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
            await NavigationAction.setRootPage(new: .app).perform()
        case false:
            await NavigationAction.setRootPage(new: .onboarding).perform()
        }
    }
}