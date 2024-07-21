import Foundation
import SwiftUI
import Combine

extension Relux {
    public enum Navigation {}
}

extension Relux.Navigation {
    public protocol PathComponent: Hashable {}
}

extension Relux.Navigation {
    public protocol RouterProtocol: ReluxState, ReluxViewState {
        associatedtype Page: PathComponent
    }
}
