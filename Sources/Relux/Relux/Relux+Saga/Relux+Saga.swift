public extension Relux {
	protocol Saga: Actor {
		func apply(_ effect: any Relux.Effect) async
	}
}

public extension Relux {
	 actor RootSaga: Subscriber {
		@MainActor private var sagas: [any Relux.Saga] = []

        public init() {
			Relux.Dispatcher.subscribe(self)
        }

		@MainActor
		public func connectSaga(saga: any Relux.Saga) {
            sagas.append(saga)
        }

        public func notify(_ action: any Relux.Action) async {
			guard let effect = action as? Relux.Effect else {
                return
            }

            await sagas
                .concurrentForEach { await $0.apply(effect) }
        }
    }
}
