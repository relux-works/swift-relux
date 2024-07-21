import Foundation
import Logger
import SwiftUI



extension ReluxState {
	var key: ObjectIdentifier { .init(type(of: self)) }
	static var key: ObjectIdentifier { .init(self) }
}

extension ReluxViewState {
	var key: ObjectIdentifier { .init(type(of: self)) }
	static var key: ObjectIdentifier { .init(self) }
}

@available(iOS 17.0, *)
extension ReluxViewStateObserving {
	var key: ObjectIdentifier { .init(type(of: self)) }
	static var key: ObjectIdentifier { .init(self) }
}

public protocol ReluxTemporalState: ReluxState, ReluxViewState {}

extension ReluxTemporalState {
	var key: ObjectIdentifier { .init(self) }
}

public protocol ReluxTemporalStateObserving: ReluxState, ReluxViewStateObserving, AnyObject {}

extension ReluxTemporalStateObserving {
	var key: ObjectIdentifier { ObjectIdentifier(self) }
}


struct ReluxTemporalStateRef {
	weak var objectRef: (any ReluxTemporalState)?
}

struct ReluxTemporalStateObservingRef {
	weak var objectRef: (any ReluxTemporalStateObserving)?
}


extension Relux {
	public actor Store: ADSubscriber, Sendable {
		
		internal private(set) var states: [ObjectIdentifier: any ReluxState] = [:]
		internal private(set) var viewStates: [ObjectIdentifier: any ReluxViewState] = [:]
		internal private(set) var viewStatesObservables: [ObjectIdentifier: any ReluxViewStateObserving] = [:]
		internal private(set) var tempStates: [ObjectIdentifier: ReluxTemporalStateRef] = [:]
		internal private(set) var tempStatesObserving: [ObjectIdentifier: ReluxTemporalStateObservingRef] = [:]
		
		public private(set) var router: (any Relux.Navigation.RouterProtocol)?
		
		public init() {
			AD.connect(self)
		}
		
		public func cleanup() async {
			await states
				.concurrentForEach { await $0.value.cleanup() }
		}
		
		public func connectRouter(_ router: any Relux.Navigation.RouterProtocol) {
			self.router = router
		}
		
		public func connectState(state: any ReluxState) async {
			await states[state.key] = state
		}
		
		public func connectViewState(state: any ReluxViewState) {
			viewStates[state.key] = state
		}
		
		public func connectViewStateObservable(state: any ReluxViewStateObserving) {
			viewStatesObservables[state.key] = state
		}
		
		public func connect<TS: ReluxTemporalState>(state: TS) async -> TS {
			tempStates[await state.key] = .init(objectRef: state)
			return state
		}
		
		public func connect<TS: ReluxTemporalStateObserving>(state: TS) async -> TS {
			tempStatesObserving[await state.key] = .init(objectRef: state)
			return state
		}
		
		public func notify(_ action: ReluxAction) async {
			await states
				.concurrentForEach { pair in
					await pair.value.reduce(with: action)
				}
			
			await tempStates
				.concurrentForEach { pair in
					await pair.value.objectRef?.reduce(with: action)
				}
			
			await tempStatesObserving
				.concurrentForEach { pair in
					await pair.value.objectRef?.reduce(with: action)
				}
			
			await router?.reduce(with: action)
		}
		
		public func getState<T: ReluxState>(_ type: T.Type) -> T {
			let state = states[T.key]
			return state as! T
		}
		
		public func getViewState<T: ReluxViewState>(_ type: T.Type) -> T {
			let state = viewStates[T.key]
			return state as! T
		}
		
		public func getViewState<T: ReluxViewStateObserving>(_ type: T.Type) -> T {
			let state = viewStatesObservables[T.key]
			return state as! T
		}
	}
}
