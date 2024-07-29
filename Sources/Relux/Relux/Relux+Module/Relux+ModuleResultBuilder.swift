extension Relux {
	@resultBuilder
	public struct ModuleResultBuilder {
		public static func buildBlock() -> [any Module] { [] }
		
		public static func buildBlock(_ modules: any Module...) -> [any Module] {
			modules
		}
	}
}
