@MainActor
public final class Relux: Sendable {
	@MainActor public let store: Store
	@MainActor public let rootSaga: RootSaga
	
	
	public init(
		logger: (any Relux.Logger),
		appStore: Store = .init(),
		rootSaga: RootSaga = .init()
	) {
		self.store = appStore
		self.rootSaga = rootSaga
		Relux.Dispatcher.setup(logger: logger)
	}
	
	
	@MainActor
	@discardableResult
	public func register(_ module: Module) -> Relux {
		module
			.states
			.forEach {
				store.connectState(state: $0)
			}
		
		module
			.uistates
			.forEach {
				store.connectState(uistate: $0)
			}
		
		module
			.routers
			.forEach {
				store.connectRouter(router: $0)
			}
		
		module
			.sagas
			.forEach {
				rootSaga.connectSaga(saga: $0)
			}
		
		return self
	}

    @MainActor
    @discardableResult
    public func unregister(_ module: Module) -> Relux {
        module
            .states
            .forEach {
                store.disconnectState(state: $0)
            }

        module
            .uistates
            .forEach {
                store.disconnectState(uistate: $0)
            }

        module
            .routers
            .forEach {
                store.disconnectRouter(router: $0)
            }

        module
            .sagas
            .forEach {
                rootSaga.disconnectSaga(saga: $0)
            }

        return self
    }

	@MainActor
	public func register(_ modules: [Module]) -> Relux {
		modules
			.forEach {
				register($0)
			}
		
		return self
	}
}
