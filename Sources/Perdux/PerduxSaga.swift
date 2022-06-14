import Foundation

public protocol PerduxSaga {
    func apply(_ effect: PerduxEffect)
}

public class PerduxRootSaga: ActionDispatcherSubscriber {
    private var sagas: [PerduxSaga] = []

    public init() {
        ActionDispatcher.subscribe(self)
    }

    public func add(saga: PerduxSaga) {
        sagas.append(saga)
    }

    public func notify(_ action: PerduxAction) {
        guard let effect = action as? PerduxEffect else {
            return
        }

        sagas
                .forEach { $0.apply(effect) }
    }
}