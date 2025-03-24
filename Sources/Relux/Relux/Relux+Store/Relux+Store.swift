import Foundation

extension Relux {
    @MainActor
    public final class Store: Sendable {
        internal private(set) var businessStates: [TypeKeyable.Key: any Relux.BusinessState] = [:]
        internal private(set) var tempStates: [TypeKeyable.Key: StateRef] = [:]

        public private(set) var uiStates: [TypeKeyable.Key: any Relux.UIState] = [:]

        public init() {
            Relux.Dispatcher.subscribe(self)
        }
    }
}

// actions propagation
extension Relux.Store: Relux.Subscriber {
    internal func notify(_ action: Relux.Action) async {
        async let notifyBusiness = businessStates
            .concurrentForEach { pair in
                await pair.value.reduce(with: action)
            }

        async let notifyTemporals = await tempStates
            .concurrentForEach { pair in
                await pair.value.objectRef?.reduce(with: action)
            }

        _ = await (notifyBusiness, notifyTemporals)
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

    public func connectTemporally(state: some Relux.HybridState) -> some Relux.HybridState {
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
            let state = await businessStates[businessState.key]
        else { return }

        await state.cleanup()
        businessStates.removeValue(forKey: state.key)
    }
}

// cleanup
extension Relux.Store {
    public func cleanup() async {
        await businessStates
            .concurrentForEach { await $0.value.cleanup() }
    }
}
