import Combine

actor NavigationState: PerduxState {
    @Published var rootPage: RootPage = .splash
    @Published var appPage: AppPage = .stocksChart
    @Published var modalSheet: ModalPage? = nil
    @Published var modalCover: ModalPage? = nil
    @Published var alert: AlertType? = nil

    func reduce(with action: PerduxAction) async {
        switch action as? NavigationAction {
        case let .some(action): await reduce(with: action)
        case .none: break
        }
    }

    func cleanup() async {

    }
}