//extension Relux {
//    @DispatcherActor
//    public protocol IDispatcher: Sendable {
//        func actions(
//            _ executionType: Relux.ExecutionType,
//            delay: Seconds?,
//            fileID: String,
//            functionName: String,
//            lineNumber: Int,
//            @Relux.ActionResultBuilder actions: @Sendable () -> [Relux.Action],
//            label: (@Sendable () -> String)?
//        ) async -> Relux.ActionResult
//
//        func action(
//            delay: Seconds?,
//            fileID: String,
//            functionName: String,
//            lineNumber: Int,
//            action: @Sendable () -> Relux.Action,
//            label: (@Sendable () -> String)?
//        ) async -> Relux.ActionResult
//    }
//}

extension Relux.Dispatcher {
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
        await _actions(
            executionType,
            delay: delay,
            fileID: fileID,
            functionName: functionName,
            lineNumber: lineNumber,
            actions: actions,
            label: label
        )
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
        await _actions(
            .serially,
            delay: delay,
            fileID: fileID,
            functionName: functionName,
            lineNumber: lineNumber,
            actions: { action() },
            label: label
        )
    }

    @usableFromInline @inline(__always)
    @discardableResult
    internal func _actions(
        _ executionType: Relux.ExecutionType = .serially,
        delay: Seconds? = nil,
        fileID: String = #fileID,
        functionName: String = #function,
        lineNumber: Int = #line,
        @Relux.ActionResultBuilder actions: @Sendable () -> [Relux.Action],
        label: (@Sendable () -> String)? = nil
    ) async -> Relux.ActionResult {
        switch executionType {
            case .serially:
                await self.sequentialPerform(actions(), delay: delay, fileID: fileID, functionName: functionName, lineNumber: lineNumber, label: label)
            case .concurrently:
                await self.concurrentPerform(actions(), delay: delay, fileID: fileID, functionName: functionName, lineNumber: lineNumber, label: label)
        }
    }
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
    await Relux.shared.dispatcher._actions(
        executionType,
        delay: delay,
        fileID: fileID,
        functionName: functionName,
        lineNumber: lineNumber,
        actions: actions,
        label: label
    )
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
    await Relux.shared.dispatcher._actions(
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
public func performAsync(
    _ executionType: Relux.ExecutionType = .serially,
    withPriority taskPriority: TaskPriority? = nil,
    delay: Seconds? = nil,
    fileID: String = #fileID,
    functionName: String = #function,
    lineNumber: Int = #line,
    @Relux.ActionResultBuilder actions: @Sendable @escaping () -> [Relux.Action],
    completion: (@Sendable (Relux.ActionResult) -> ())? = nil,
    label: (@Sendable () -> String)? = nil
) {
    Task(priority: taskPriority) {
        let result = await Relux.shared.dispatcher._actions(
            executionType,
            delay: delay,
            fileID: fileID,
            functionName: functionName,
            lineNumber: lineNumber,
            actions: actions,
            label: label
        )
        completion?(result)
    }
}
