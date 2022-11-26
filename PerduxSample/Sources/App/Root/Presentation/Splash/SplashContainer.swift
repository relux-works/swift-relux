import SwiftUI

struct SplashContainer: View {

    var body: some View {
        content
    }

    private var content: some View {
        Splash(
            props: .init(),
            actions: .init(
                next: navigateToApp
            )
        )
    }

    private func navigateToApp() async {
        await NavigationAction.setRootPage(new: .app).perform()
    }
}