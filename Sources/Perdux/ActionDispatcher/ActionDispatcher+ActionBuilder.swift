import Foundation

@resultBuilder
public struct PerduxActionCompositionBuilder {
	public static func buildBlock(_ action: PerduxAction) -> PerduxAction { action }
	
    public static func buildBlock() -> [PerduxAction] { [] }

    public static func buildBlock(_ actions: PerduxAction...) -> [PerduxAction] {
        actions
    }
}
