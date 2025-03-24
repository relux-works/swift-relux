extension Relux {
    public protocol AnyState: AnyObject, TypeKeyable, Sendable {}

    public protocol BusinessState: AnyState {
        func reduce(with action: any Relux.Action) async
        func cleanup() async
    }

    public protocol UIState: AnyState {}

    public protocol HybridState: BusinessState, UIState {
        func reduce(with action: any Relux.Action) async
        func cleanup() async
    }
}

extension Relux {
    struct StateRef: Sendable {
        weak private(set) var objectRef: (any Relux.HybridState)?
    }
}
