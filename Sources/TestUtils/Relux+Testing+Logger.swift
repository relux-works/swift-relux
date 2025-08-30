
extension Relux.Testing {
    public final class Logger: Relux.Logger, @unchecked Sendable {
        private let lock = LockedState<Void>()
        
        nonisolated(unsafe)
        public private(set) var actions: [Relux.Action] = []
        
        nonisolated(unsafe)
        public private(set) var effects: [Relux.Effect] = []
        
        public init() {}
        
        public func logAction(
            _ action: Relux.EnumReflectable,
            result: Relux.ActionResult?,
            startTimeInMillis: Int,
            privacy: Relux.OSLogPrivacy,
            fileID: String,
            functionName: String,
            lineNumber: Int
        ) {
            lock.withLock {
                switch action {
                    case let effect as Relux.Effect: effects.append(effect)
                    case let action as Relux.Action: actions.append(action)
                    default: break
                }
            }
        }
    }
}
