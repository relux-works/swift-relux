public extension Relux {
	@MainActor
    protocol TemporalState: AnyObject, Sendable {
        func reduce(with action: any Relux.Action) async
        func cleanup() async
    }
}

extension Relux.TemporalState {
	nonisolated var key: ObjectIdentifier { .init(self) }
}


extension Relux {
	struct TemporalStateRef: Sendable {
		weak private(set) var objectRef: (any Relux.TemporalState)?
	}
}
