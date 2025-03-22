public extension Relux {
	protocol Module: Sendable {
		var states: [any Relux.State] { get }
		var sagas: [any Relux.Saga] { get }
	}
}
