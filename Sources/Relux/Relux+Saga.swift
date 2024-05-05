import Foundation

public protocol ReluxSaga {
    func apply(_ effect: ReluxEffect) async
}

extension Relux {
    public class RootSaga: ADSubscriber {
        private var sagas: [ReluxSaga] = []

        public init() {
            Relux.AD.connect(self)
        }

        public func add(saga: ReluxSaga) {
            sagas.append(saga)
        }

        public func notify(_ action: ReluxAction) async {
            guard let effect = action as? ReluxEffect else {
                return
            }

            await sagas
                .concurrentForEach { await $0.apply(effect) }
        }
    }
}
