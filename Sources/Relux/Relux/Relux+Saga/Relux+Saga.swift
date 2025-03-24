public extension Relux {
    protocol Saga: Actor, TypeKeyable {
        func apply(_ effect: any Relux.Effect) async
    }
}

public extension Relux {
    @MainActor
    final class RootSaga: Subscriber {
        private var sagas: [TypeKeyable.Key: any Relux.Saga] = [:]

        public init() {
            Relux.Dispatcher.subscribe(self)
        }

        public func connectSaga(saga: any Relux.Saga) {
            guard sagas[saga.key].isNil else {
                fatalError("failed to add saga, already exists: \(saga)")
            }
            sagas[saga.key] = saga
        }

        public func disconnect(saga: any Relux.Saga) {
            sagas.removeValue(forKey: saga.key)
        }

        internal func notify(_ action: any Relux.Action) async {
            guard let effect = action as? Relux.Effect else {
                return
            }

            await sagas
                .concurrentForEach { await $0.value.apply(effect) }
        }
    }
}
