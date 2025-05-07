import Foundation

extension Relux {
    @MainActor
    public final class Store: Sendable {
        internal private(set) var businessStates: [TypeKeyable.Key: any Relux.BusinessState] = [:]
        internal private(set) var tempStates: [TypeKeyable.Key: StateRef] = [:]

        public private(set) var uiStates: [TypeKeyable.Key: any Relux.UIState] = [:]

        public init() {
        }
    }
}

// actions propagation
extension Relux.Store {
    internal func notify(_ action: Relux.Action) async {
        async let notifyBusiness: () = businessStates
            .concurrentForEach { pair in
                await pair.value.reduce(with: action)
            }

        async let notifyTemporals: () = tempStates
            .concurrentForEach { pair in
                await pair.value.objectRef?.reduce(with: action)
            }

        _ = await (notifyBusiness, notifyTemporals)
    }
}

extension Relux.Store: Relux.Subscriber {
    internal func perform(_ action: Relux.Action) async -> Relux.ActionResult {
        await self.notify(action)
        return .success
    }
}

// getters
extension Relux.Store {
    @MainActor
    public func getState<T: Relux.BusinessState>(_ type: T.Type) -> T {
        let state = businessStates[T.key]
        return state as! T
    }

    @MainActor
    public func getState<T: Relux.UIState>(_ type: T.Type) -> T {
        let state = uiStates[T.key]
        return state as! T
    }

    @MainActor
    public func getState<T: Relux.HybridState>(_ type: T.Type) -> T {
        let state = businessStates[T.key]
        return state as! T
    }
}

// connectors
extension Relux.Store {
    public func connect(state: some Relux.AnyState) {
        var typeDefined = false
        if let state = state as? Relux.BusinessState {
            connect(state: state)
            typeDefined = true
        }
        if let state = state as? Relux.UIState {
            connect(state: state)
            typeDefined = true
        }

        guard typeDefined else {
            fatalError("unsupported state type: \(type(of: state))")
        }
    }

    public func connectTemporally<TS: Relux.HybridState>(state: TS) -> TS {
        tempStates[state.key] = .init(objectRef: state)
        return state
    }

    internal func connect(state: some Relux.BusinessState) {
        guard businessStates[state.key].isNil else {
            fatalError("failed to add state, already exists: \(state)")
        }
        businessStates[state.key] = state
    }

    internal func connect(state: some Relux.UIState) {
        guard uiStates[state.key].isNil else {
            fatalError("failed to add state, already exists: \(state)")
        }
        uiStates[state.key] = state
    }
}

// disconnect state
extension Relux.Store {
    public func disconnect(state: some Relux.AnyState) async {
        guard
            let businessState = state as? Relux.BusinessState,
            let state = businessStates[businessState.key]
        else { return }

        await state.cleanup()
        businessStates.removeValue(forKey: state.key)
    }
}

// cleanup
extension Relux.Store {
    public func cleanup(
        exclusions: [Relux.BusinessState.Type] = []
    ) async {
        let excludedKeys = exclusions
            .map { $0.key }
            .asSet

        await businessStates
            .concurrentForEach {
                guard excludedKeys.contains($0.key).not else { return }
                await $0.value.cleanup()
            }
    }
}
