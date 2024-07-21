extension Relux {
	@resultBuilder
	public struct StatesBuilder {
		public static func buildBlock() -> [ReluxState] { [] }
		
		public static func buildBlock(_ states: ReluxState...) -> [ReluxState] {
			states
		}
	}
}

public protocol ReluxState: Actor {
    func reduce(with action: ReluxAction) async

    func cleanup() async
}
