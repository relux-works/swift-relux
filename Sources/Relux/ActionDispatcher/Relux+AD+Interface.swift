import Logger

@inlinable
public func actions(
	_ executionType: Relux.AD.ExecutionType = .serially,
	delay: Seconds? = nil,
	fileID: String = #fileID,
	functionName: String = #function,
	lineNumber: Int = #line,
	@Relux.ActionsBuilder actions: @Sendable () -> [ReluxAction],
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
	action: @Sendable () -> ReluxAction,
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
	_ executionType: Relux.AD.ExecutionType = .serially,
	withPriority taskPriority: TaskPriority? = nil,
	delay: Seconds? = nil,
	fileID: String = #fileID,
	functionName: String = #function,
	lineNumber: Int = #line,
	@Relux.ActionsBuilder actions: @Sendable @escaping () -> [ReluxAction],
	label: (@Sendable () -> String)? = nil
) {
	
	Task(priority: taskPriority) {
		await _actions(executionType, delay: delay, fileID: fileID, functionName: functionName, lineNumber: lineNumber, actions: actions, label: label)
	}
}


@usableFromInline @inline(__always)
internal func _actions(
	_ executionType: Relux.AD.ExecutionType = .serially,
	delay: Seconds? = nil,
	fileID: String = #fileID,
	functionName: String = #function,
	lineNumber: Int = #line,
	@Relux.ActionsBuilder actions: @Sendable () -> [ReluxAction],
	label: (@Sendable () -> String)? = nil
) async {
	let execStartTime = timestamp.milliseconds
	switch executionType {
		case .serially:
			await Relux.AD.sequentialPerform(actions(), delay: delay, fileID: fileID, functionName: functionName, lineNumber: lineNumber)
		case .concurrently:
			await Relux.AD.concurrentPerform(actions(), delay: delay, fileID: fileID, functionName: functionName, lineNumber: lineNumber)
	}
	let execDurationMillis = timestamp.milliseconds - execStartTime
	
	if let label {
		if let delay {
			log("\(label()); \(execDurationMillis)ms, including delay \(delay*1000)ms; raw execution duration: \(execDurationMillis - Int(delay*1000))ms", category: .performance)
		} else {
			log("\(label()); \(execDurationMillis)ms", category: .performance)
		}
	}
}


@usableFromInline @inline(__always)
internal func _action(
	delay: Seconds? = nil,
	fileID: String = #fileID,
	functionName: String = #function,
	lineNumber: Int = #line,
	action: @Sendable () -> ReluxAction,
	label: (@Sendable () -> String)? = nil
) async {
	let execStartTime = timestamp.milliseconds
	await Relux.AD.emitAsync(action(), delay: delay, fileID: fileID, functionName: functionName, lineNumber: lineNumber)
	let execDurationMillis = timestamp.milliseconds - execStartTime
	
	if let label {
		if let delay {
			log("\(label()); \(execDurationMillis)ms, including delay \(delay*1000)ms; raw execution duration: \(execDurationMillis - Int(delay*1000))ms", category: .performance)
		} else {
			log("\(label()); \(execDurationMillis)ms", category: .performance)
		}
	}
}



