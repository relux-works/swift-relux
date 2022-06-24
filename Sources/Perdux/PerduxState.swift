import Combine
import Foundation
import Logger


/*
 * ReduxState purpose is storing data in memory and notifying about it's change
 * Derived from ReduxStore classes contain their own fields with initial states
 * Fields initialised with NIL before they would be updated.
 * It means that their state is not determined yet
 * and on UI we show progress or nothing as initial UI state.
 */
open class PerduxState: ObservableObject {
    public let objectDidChange = ObservableObjectPublisher()
    private var observers: Set<AnyCancellable> = []

    public init() {}

    open func reduce(with action: PerduxAction) async {
    }

    open func reduce(with action: PerduxAction) {
    }

    open func cleanup() throws {
        fatalError("\(#function) NOT IMPLEMENTED")
    }

    public func handleWillChange(sender: Any, name: String, oldValue: Any?, newValue: Any?) {
        log("")
    }

    public func handleDidChange(sender: Any, name: String, oldValue: Any?, newValue: Any?) {
        DispatchQueue.main.async {
            self.objectDidChange.send()
        }
    }
}
