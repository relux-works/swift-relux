import Combine
import Foundation

@MainActor
class NavigationViewState: PerduxViewState {
    @Published var rootPage: RootPage = .splash
    @Published var appPage: AppPage = .stocksChart
    @Published var modalSheet: ModalPage? = nil
    @Published var modalCover: ModalPage? = nil
    @Published var alert: AlertType? = nil

    init(navState: NavigationState) {
        Task {
            await initPipelines(navState: navState)
        }
    }

    private func initPipelines(navState: NavigationState) async {
        await navState.$rootPage
                .receive(on: DispatchQueue.main)
                .assign(to: &$rootPage)

        await navState.$appPage
                .receive(on: DispatchQueue.main)
                .assign(to: &$appPage)

        await navState.$modalCover
                .receive(on: DispatchQueue.main)
                .assign(to: &$modalCover)

        await navState.$modalSheet
                .receive(on: DispatchQueue.main)
                .assign(to: &$modalSheet)
    }
}