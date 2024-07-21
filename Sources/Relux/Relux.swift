
public actor Relux {
	public let appStore: Store
	public let rootSaga: RootSaga
	
	public init(
		appStore: Store = .init(),
		rootSaga: RootSaga = .init()
	) {
		self.appStore = appStore
		self.rootSaga = rootSaga
	}
	
	@discardableResult
	public func register(_ module: Module) async -> Relux {
		await module.states
			.asyncForEach { await appStore.connectState(state: $0) }
		await module.viewStates
			.asyncForEach { await appStore.connectViewState(state: $0) }
		await module.viewStatesObservables
			.asyncForEach { await appStore.connectViewStateObservable(state: $0) }
		await module.sagas
			.asyncForEach { await rootSaga.add(saga: $0) }
		
		return self
	}
	
	public func register(_ modules: [Module]) async -> Relux {
		for module in modules {
			await register(module)
		}
		return self
	}
}

public extension Relux {

	protocol Module: Sendable {
		var states: [ReluxState] { get }
		var viewStates: [any ReluxViewState] { get }
		var viewStatesObservables: [any ReluxViewStateObserving] { get }
		var sagas: [ReluxSaga] { get }
	}
}


extension Relux {
	@resultBuilder
	public struct ModulesBuilder {
		public static func buildBlock() -> [any Module] { [] }
		
		public static func buildBlock(_ modules: any Module...) -> [any Module] {
			modules
		}
	}
}
