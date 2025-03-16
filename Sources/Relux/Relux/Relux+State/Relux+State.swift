public extension Relux {
    @MainActor
    protocol State: AnyObject, TypeKeyable, Sendable {
        func reduce(with action: any Relux.Action) async
        func cleanup() async
    }
}

extension Relux {
    struct StateRef: Sendable {
        weak private(set) var objectRef: (any Relux.State)?
    }
}
