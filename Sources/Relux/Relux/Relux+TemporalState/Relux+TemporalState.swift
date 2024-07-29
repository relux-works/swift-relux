public extension Relux {
	@MainActor
	protocol TemporalState: Relux.State, Relux.Presentation.StatePresenting {}
}

extension Relux.TemporalState {
	nonisolated var key: ObjectIdentifier { .init(self) }
}


extension Relux {
	struct TemporalStateRef: Sendable {
		weak private(set) var objectRef: (any Relux.TemporalState)?
	}
}
