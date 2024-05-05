import Foundation
import Logger
import SwiftUI

extension ReluxState {
    var key: ObjectIdentifier { .init(type(of: self)) }
    static var key: ObjectIdentifier { .init(self) }
}
extension ReluxViewState {
    var key: ObjectIdentifier { .init(type(of: self)) }
    static var key: ObjectIdentifier { .init(self) }
}
extension ReluxTemporalState {
    var key: ObjectIdentifier { .init(self) }
}

public protocol ReluxTemporalState: ReluxState, ReluxViewState {}

struct ReluxTemporalStateRef {
    weak var objectRef: (any ReluxTemporalState)?
}


extension Relux {
    open class Store: ADSubscriber {
        private(set) var states: [ObjectIdentifier: any ReluxState] = [:]
        private(set) var viewStates: [ObjectIdentifier: any ReluxViewState] = [:]
        private(set) var tempStates: [ObjectIdentifier: ReluxTemporalStateRef] = [:]

        public init() {
            AD.connect(self)
        }

        public func cleanup() async {
            await states
                .concurrentForEach { await $0.value.cleanup() }
        }

        public func connectState(state: any ReluxState) {
            states[state.key] = state
        }

        public func connectViewState(state: any ReluxViewState) {
            viewStates[state.key] = state
        }

        public func connect<TS: ReluxTemporalState>(state: TS) -> TS {
            tempStates[state.key] = .init(objectRef: state)
            return state
        }

        public func notify(_ action: ReluxAction) async {
            await states
                .concurrentForEach { pair in
                    await pair.value.reduce(with: action)
                }

            await tempStates
                .concurrentForEach { pair in
                    await pair.value.objectRef?.reduce(with: action)
                }
        }

        public func getState<T: ReluxState>(_ type: T.Type) -> T {
            let state = states[T.key]
            return state as! T
        }

        public func getViewState<T: ReluxViewState>(_ type: T.Type) -> T {
            let state = viewStates[T.key]
            return state as! T
        }

        deinit {
            log("deinit")
        }
    }

}