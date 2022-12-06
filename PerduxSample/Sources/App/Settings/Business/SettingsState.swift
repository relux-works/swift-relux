import Foundation

actor SettingsState: PerduxState {
    @Published var settings: Settings?

    func reduce(with action: PerduxAction) async {
        switch action as? SettingsAction {
        case let .some(action): await reduce(with: action)
        case .none: break
        }
    }

    func cleanup() async {

    }
}