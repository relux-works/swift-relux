
@MainActor
public final class Relux: Sendable {
	@MainActor public let store: Store
	@MainActor public let rootSaga: RootSaga
	
	public init(
		appStore: Store = .init(),
		rootSaga: RootSaga = .init()
	) {
		self.store = appStore
		self.rootSaga = rootSaga
	}
	
	
	@MainActor
	@discardableResult
	public func register(_ module: Module) -> Relux {
		module.states
			.forEach {
				store.connectState(state: $0)
			}
		
		module.uistates
			.forEach {
				store.connectState(uistate: $0)
			}
		
		module.sagas
			.forEach {
				rootSaga.connectSaga(saga: $0)
			}
		
		return self
	}
	
	@MainActor
	public func register(_ modules: [Module]) -> Relux {
		for module in modules {
			register(module)
		}
		return self
	}
}
