extension Relux {
    @MainActor
    public final class RootSaga {
        private var sagas: [TypeKeyable.Key: any Relux.Saga] = [:]

        public init() {
        }
    }
}

extension Relux.RootSaga: Relux.Subscriber {
    internal func perform(_ action: any Relux.Action) async -> Relux.ActionResult? {
        guard let effect = action as? Relux.Effect else {
            return .none
        }

        return await notifyFlows(with: effect)
    }

    private func notifyFlows(with effect: Relux.Effect) async -> Relux.ActionResult? {
        await sagas
            .concurrentMap {
                switch $0.value {
                    case let flow as Relux.Flow: await flow.apply(effect)
                    default: await $0.value.apply(effect)
                }
            }
            .reducedResult
    }
}

    // sagas management
extension Relux.RootSaga {
    public func connectSaga(saga: any Relux.Saga) {
        guard sagas[saga.key].isNil else {
            fatalError("failed to add saga, already exists: \(saga)")
        }
        sagas[saga.key] = saga
    }

    public func disconnect(saga: any Relux.Saga) {
        sagas.removeValue(forKey: saga.key)
    }
}
