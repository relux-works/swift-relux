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

@inlinable
@discardableResult
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
        let result = await _actions(executionType, delay: delay, fileID: fileID, functionName: functionName, lineNumber: lineNumber, actions: actions, label: label)
        completion?(result)
    }
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
            await Relux.Dispatcher.sequentialPerform(actions(), delay: delay, fileID: fileID, functionName: functionName, lineNumber: lineNumber, label: label)
        case .concurrently:
            await Relux.Dispatcher.concurrentPerform(actions(), delay: delay, fileID: fileID, functionName: functionName, lineNumber: lineNumber, label: label)
        }
}
