import Foundation
import Logger

public class PerduxStore: ActionDispatcherSubscriber {
    private(set) var states: [PerduxState] = []

    public init() {
        ActionDispatcher.connect(self)
    }

    public func connect(state: PerduxState) {
        states.append(state)
    }

    func notify(_ action: PerduxAction) async {
        await states
                .concurrentForEach { state in
                    await state.reduce(with: action)
                }
    }

    public func getState<T: PerduxState>(_ type: T.Type) -> T {
        let state = states.first { $0 is T }
        return state as! T
    }

    deinit {
        log("deinit")
    }
}
