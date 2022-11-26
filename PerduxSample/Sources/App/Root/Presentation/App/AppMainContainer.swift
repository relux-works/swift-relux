import SwiftUI

struct AppMainContainer: View {
    @EnvironmentObject private var navState: NavigationViewState

    var body: some View {
        content
    }

    private var content: some View {
        TabView(selection: $navState.appPage) {
            StocksChartContainer()
                    .tag(AppPage.stocksChart)
                    .tabItem {
                        Label("Stocks", systemImage: "list.dash")
                    }
            SettingsContainer()
                    .tag(AppPage.settings)
                    .tabItem {
                        Label("Settings", systemImage: "list.dash")
                    }
        }
    }
}

