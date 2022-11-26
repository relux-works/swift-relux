import Foundation

enum NavigationAction: PerduxAction {
    case setRootPage(new: RootPage)
    case setAppPage(new: AppPage)
    case setModalSheet(new: ModalPage?)
    case setModalScreenCover(new: ModalPage?)
    case setAlert(new: AlertType?)
}