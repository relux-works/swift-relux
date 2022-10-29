import Foundation

public protocol PerduxSaga {
    func apply(_ effect: PerduxEffect) async
}

public class PerduxRootSaga: ActionDispatcherSubscriber {
    private var sagas: [PerduxSaga] = []

    public init() {
        ActionDispatcher.connect(self)
    }

    public func add(saga: PerduxSaga) {
        sagas.append(saga)
    }

    public func notify(_ action: PerduxAction) async {
        guard let effect = action as? PerduxEffect else {
            return
        }

        await sagas
                .concurrentForEach { await $0.apply(effect) }
    }
}