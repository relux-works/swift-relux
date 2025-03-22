import Foundation

extension Relux {
    @globalActor
    public actor Store: Relux.Subscriber, Sendable {
        static public var shared: Store { Store() }

        @MainActor
        public private(set) var states: [TypeKeyable.Key: any Relux.State] = [:]

        @MainActor
        internal private(set) var tempStates: [TypeKeyable.Key: StateRef] = [:]

        public init() {
            Relux.Dispatcher.subscribe(self)
        }

        public func cleanup() async {
            await states
                .concurrentForEach { await $0.value.cleanup() }
        }

        @MainActor
        public func connectState(state: some Relux.State) {
            guard states[state.key].isNil else {
                fatalError("failed to add state, already exists: \(state)")
            }
            states[state.key] = state
        }

        @MainActor
        public func connectState(tempState: some Relux.State) -> some Relux.State {
            tempStates[tempState.key] = .init(objectRef: tempState)
            return tempState
        }

        @MainActor
        public func disconnectState(state: some Relux.State) {
            states.removeValue(forKey: state.key)
        }

        public func notify(_ action: Relux.Action) async {
            await states
                .concurrentForEach { pair in
                    await pair.value.reduce(with: action)
                }

            await tempStates
                .concurrentForEach { pair in
                    await pair.value.objectRef?.reduce(with: action)
                }
        }

        @MainActor
        public func getState<T: Relux.State>(_ type: T.Type) -> T {
            let state = states[T.key]
            return state as! T
        }
    }
}
