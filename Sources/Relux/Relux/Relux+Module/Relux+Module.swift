public extension Relux {
	protocol Module: Sendable {
		var states: [any Relux.State] { get }
		var uistates: [any Relux.Presentation.StatePresenting] { get }
		var sagas: [any Relux.Saga] { get }
		var routers: [any Relux.Navigation.RouterProtocol] { get }
	}
}
