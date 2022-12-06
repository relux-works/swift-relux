import SwiftUI

struct ContentContainer: View {
    private let appStore: PerduxStore
    @ObservedObject private var navState: NavigationViewState

    init(appStore: PerduxStore) {
        self.appStore = appStore
        self.navState = appStore.getViewState(NavigationViewState.self)
    }

    var body: some View {
        content
                .sheet(item: $navState.modalSheet, content: modalPage)
                .fullScreenCover(item: $navState.modalCover, content: modalPage)
                .alert(item: $navState.alert, content: alert)
    }

    @ViewBuilder
    private var content: some View {
        switch navState.rootPage {
        case .splash: splash
        case .onboarding: onboarding
        case .app: app
        }
    }

    private var splash: some View {
        SplashContainer()
                .environmentObject(appStore.getViewState(SettingsViewState.self))
    }

    private var onboarding: some View {
        OnboardingContainer()
                .environmentObject(appStore.getViewState(SettingsViewState.self))
    }

    private var app: some View {
        AppMainContainer()
                .environmentObject(appStore.getViewState(NavigationViewState.self))
                .environmentObject(appStore.getViewState(SettingsViewState.self))
    }
}

// modal pages
extension ContentContainer {
    @ViewBuilder
    private func modalPage(_ type: ModalPage) -> some View {
        Group {
            switch type {
            case .sampleSheet: sampleSheet
            }
        }
            .tint(Color.green)
            .alert(item: $navState.alert, content: alert)
    }

    private var sampleSheet: some View {
        Text("Sample sheet")
    }
}


// alerts
extension ContentContainer {
    func alert(_ type: AlertType) -> Alert {
        switch type {
        }
    }
}
