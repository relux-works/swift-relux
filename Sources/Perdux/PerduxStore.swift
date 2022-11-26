import Foundation
import Logger

extension PerduxState {
    var key: ObjectIdentifier { .init(type(of: self)) }
    static var key: ObjectIdentifier { .init(self) }
}
extension PerduxViewState {
    var key: ObjectIdentifier { .init(type(of: self)) }
    static var key: ObjectIdentifier { .init(self) }
}


public class PerduxStore: ActionDispatcherSubscriber {
    private(set) var states: [ObjectIdentifier: any PerduxState] = [:]
    private(set) var viewStates: [ObjectIdentifier: any PerduxViewState] = [:]

    public init() {
        ActionDispatcher.connect(self)
    }

    public func connectState(state: any PerduxState) {
        states[state.key] = state
    }

    public func connectViewState(state: any PerduxViewState) {
        viewStates[state.key] = state
    }

    func notify(_ action: PerduxAction) async {
        await states
                .concurrentForEach { pair in
                    await pair.value.reduce(with: action)
                }
    }

    public func getState<T: PerduxState>(_ type: T.Type) -> T {
        let state = states[T.key]
        return state as! T
    }

    public func getViewState<T: PerduxViewState>(_ type: T.Type) -> T {
        let state = viewStates[T.key]
        return state as! T
    }

    deinit {
        log("deinit")
    }
}
