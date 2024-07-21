import Foundation

extension Relux {
    @resultBuilder
    public struct ActionsBuilder {
        public static func buildBlock() -> [ReluxAction] { [] }

        public static func buildBlock(_ actions: ReluxAction...) -> [ReluxAction] {
            actions
        }
    }
}
