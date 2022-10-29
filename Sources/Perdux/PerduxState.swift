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


public protocol PerduxState {
   // public let objectDidChange = ObservableObjectPublisher()

    func reduce(with action: PerduxAction) async

    func cleanup()

//    func handleDidChange(sender: Any, name: String, oldValue: Any?, newValue: Any?) {
//        DispatchQueue.main.async {
//            self.objectDidChange.send()
//        }
//    }
}
