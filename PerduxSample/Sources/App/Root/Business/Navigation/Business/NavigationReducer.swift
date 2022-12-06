import Foundation

extension NavigationState {
    func reduce(with action: NavigationAction) async {
        switch action {
        case let .setRootPage(new):
            self.rootPage = new
        case let .setAppPage(new):
            self.appPage = new
        case let .setModalScreenCover(new):
            self.modalCover = new
        case let .setModalSheet(new):
            self.modalSheet = new
        case let .setAlert(new):
            self.alert = new
        }
    }
}