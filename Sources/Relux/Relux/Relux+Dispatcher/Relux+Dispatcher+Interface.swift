@inlinable
public func actions(
	_ executionType: Relux.ExecutionType = .serially,
	delay: Seconds? = nil,
	fileID: String = #fileID,
	functionName: String = #function,
	lineNumber: Int = #line,
	@Relux.ActionResultBuilder actions: @Sendable () -> [Relux.Action],
	label: (@Sendable () -> String)? = nil
) async {
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
public func action(
	delay: Seconds? = nil,
	fileID: String = #fileID,
	functionName: String = #function,
	lineNumber: Int = #line,
	action: @Sendable () -> Relux.Action,
	label: (@Sendable () -> String)? = nil
) async {
	await _action(
		delay: delay,
		fileID: fileID,
		functionName: functionName,
		lineNumber: lineNumber,
		action: action,
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
	label: (@Sendable () -> String)? = nil
) {
	
	Task(priority: taskPriority) {
		await _actions(executionType, delay: delay, fileID: fileID, functionName: functionName, lineNumber: lineNumber, actions: actions, label: label)
	}
}


@usableFromInline @inline(__always)
internal func _actions(
	_ executionType: Relux.ExecutionType = .serially,
	delay: Seconds? = nil,
	fileID: String = #fileID,
	functionName: String = #function,
	lineNumber: Int = #line,
	@Relux.ActionResultBuilder actions: @Sendable () -> [Relux.Action],
	label: (@Sendable () -> String)? = nil
) async {
	switch executionType {
		case .serially:
			await Relux.Dispatcher.sequentialPerform(actions(), delay: delay, fileID: fileID, functionName: functionName, lineNumber: lineNumber, label: label)
		case .concurrently:
			await Relux.Dispatcher.concurrentPerform(actions(), delay: delay, fileID: fileID, functionName: functionName, lineNumber: lineNumber, label: label)
	}
}


@usableFromInline @inline(__always)
internal func _action(
	delay: Seconds? = nil,
	fileID: String = #fileID,
	functionName: String = #function,
	lineNumber: Int = #line,
	action: @Sendable () -> Relux.Action,
	label: (@Sendable () -> String)? = nil
) async {
	await Relux.Dispatcher.sequentialPerform([action()], delay: delay, fileID: fileID, functionName: functionName, lineNumber: lineNumber)
}



