public extension Relux.Navigation {
	@resultBuilder
	struct RouterResultBuilder {
		public static func buildBlock() -> [any Relux.Navigation.RouterProtocol] { [] }
		
		public static func buildBlock(_ actions: (any Relux.Navigation.RouterProtocol)...) -> [any Relux.Navigation.RouterProtocol] {
			actions
		}
	}
}

