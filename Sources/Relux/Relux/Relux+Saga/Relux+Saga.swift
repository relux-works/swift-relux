extension Relux {
    public protocol Saga: Actor, TypeKeyable{
        var dispatcher: Relux.Dispatcher { get async }
        func apply(_ effect: any Relux.Effect) async
    }
}

extension Relux.Saga {
    internal func apply(_ effect: any Relux.Effect) async -> Relux.ActionResult {
        await self.apply(effect)
        return .success
    }
}

extension Relux.Saga {
    public var dispatcher: Relux.Dispatcher {
        get async { await Relux.shared.dispatcher }
    }

    public static var defaultDispatcher: Relux.Dispatcher {
        get async { await Relux.shared.dispatcher }
    }

    @inlinable
    @discardableResult
    public func action(
        delay: Seconds? = nil,
        fileID: String = #fileID,
        functionName: String = #function,
        lineNumber: Int = #line,
        action: @Sendable () -> Relux.Action,
        label: (@Sendable () -> String)? = nil
    ) async -> Relux.ActionResult {
        await self.dispatcher._actions(
            .serially,
            delay: delay,
            fileID: fileID,
            functionName: functionName,
            lineNumber: lineNumber,
            actions: { action() },
            label: label
        )
    }

    @inlinable
    @discardableResult
    public func actions(
        _ executionType: Relux.ExecutionType = .serially,
        delay: Seconds? = nil,
        fileID: String = #fileID,
        functionName: String = #function,
        lineNumber: Int = #line,
        @Relux.ActionResultBuilder actions: @Sendable () -> [Relux.Action],
        label: (@Sendable () -> String)? = nil
    ) async -> Relux.ActionResult {
        await self.dispatcher._actions(
            executionType,
            delay: delay,
            fileID: fileID,
            functionName: functionName,
            lineNumber: lineNumber,
            actions: actions,
            label: label
        )
    }
}
