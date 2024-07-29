extension Relux {
	@resultBuilder
	public struct ActionResultBuilder {
		public static func buildBlock() -> [any Relux.Action] { [] }
		
		public static func buildBlock(_ actions: any Relux.Action...) -> [any Relux.Action] {
			actions
		}
	}
}
