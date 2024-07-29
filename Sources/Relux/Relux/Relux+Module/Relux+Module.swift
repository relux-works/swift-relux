public extension Relux {
	protocol Module: Sendable {
		var states: [Relux.State] { get }
		var uistates: [Relux.Presentation.StatePresenting] { get }
		var sagas: [Relux.Saga] { get }
	}
}
