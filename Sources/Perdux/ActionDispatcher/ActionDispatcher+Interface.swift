import Logger

@inlinable
public func actions(
		_ executionType: ActionDispatcher.ExecutionType = .serially,
		delay: Seconds? = nil,
		fileID: String = #fileID,
		functionName: String = #function,
		lineNumber: Int = #line,
		@PerduxActionCompositionBuilder @_inheritActorContext actions: @Sendable () async -> [PerduxAction],
		label: (() -> String)? = nil
) async {
	let actions = await actions()
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
		@PerduxActionCompositionBuilder @_inheritActorContext action: @Sendable () async -> PerduxAction,
		label: (() -> String)? = nil
) async {
	let action = await action()
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
		_ executionType: ActionDispatcher.ExecutionType = .serially,
		withPriority taskPriority: TaskPriority? = nil,
		delay: Seconds? = nil,
		fileID: String = #fileID,
		functionName: String = #function,
		lineNumber: Int = #line,
		@PerduxActionCompositionBuilder @_inheritActorContext actions: @escaping @Sendable () async -> [PerduxAction],
		label: (() -> String)? = nil
) {
	Task(priority: taskPriority) {
		let actions = await actions()
		await _actions(executionType, delay: delay, fileID: fileID, functionName: functionName, lineNumber: lineNumber, actions: actions, label: label)
	}
}

@inlinable
public func performAsync(
	_ executionType: ActionDispatcher.ExecutionType = .serially,
	withPriority taskPriority: TaskPriority? = nil,
	delay: Seconds? = nil,
	fileID: String = #fileID,
	functionName: String = #function,
	lineNumber: Int = #line,
	@PerduxActionCompositionBuilder @_inheritActorContext action: @escaping @Sendable () async -> PerduxAction,
	label: (() -> String)? = nil
) {
	Task(priority: taskPriority) {
		let action = await action()
		await _action(executionType, delay: delay, fileID: fileID, functionName: functionName, lineNumber: lineNumber, action: action, label: label)
	}
}


@usableFromInline @inline(__always)
internal func _actions(
		_ executionType: ActionDispatcher.ExecutionType = .serially,
		delay: Seconds? = nil,
		fileID: String = #fileID,
		functionName: String = #function,
		lineNumber: Int = #line,
		actions: [PerduxAction],
		label: (() -> String)? = nil
) async {
	let execStartTime = timestamp.milliseconds
	switch executionType {
	case .serially:
		await ActionDispatcher.sequentialPerform(actions, delay: delay, fileID: fileID, functionName: functionName, lineNumber: lineNumber)
	case .concurrently:
		await ActionDispatcher.concurrentPerform(actions, delay: delay, fileID: fileID, functionName: functionName, lineNumber: lineNumber)
	}
	let execDurationMillis = timestamp.milliseconds - execStartTime

	if let label {
		if let delay {
			log("\(label()); \(execDurationMillis)ms, including delay \(delay*1000)ms; raw execution duration: \(execDurationMillis - Int(delay*1000))ms",
				category: .performance,
				fileID: fileID,
				functionName: functionName,
				lineNumber: lineNumber
			)
		} else {
			log(
				"\(label()); \(execDurationMillis)ms",
				category: .performance,
				fileID: fileID,
				functionName: functionName,
				lineNumber: lineNumber
			)
		}
	}
}

@usableFromInline @inline(__always)
internal func _action(
	_ executionType: ActionDispatcher.ExecutionType = .serially,
	delay: Seconds? = nil,
	fileID: String = #fileID,
	functionName: String = #function,
	lineNumber: Int = #line,
	action: PerduxAction,
	label: (() -> String)? = nil
) async {
	let execStartTime = timestamp.milliseconds
	switch executionType {
		case .serially:
			await ActionDispatcher.sequentialPerform([action], delay: delay, fileID: fileID, functionName: functionName, lineNumber: lineNumber)
		case .concurrently:
			await ActionDispatcher.concurrentPerform([action], delay: delay, fileID: fileID, functionName: functionName, lineNumber: lineNumber)
	}
	let execDurationMillis = timestamp.milliseconds - execStartTime
	
	if let label {
		if let delay {
			log("\(label()); \(execDurationMillis)ms, including delay \(delay*1000)ms; raw execution duration: \(execDurationMillis - Int(delay*1000))ms",
				category: .performance,
				fileID: fileID,
				functionName: functionName,
				lineNumber: lineNumber
			)
		} else {
			log(
				"\(label()); \(execDurationMillis)ms",
				category: .performance,
				fileID: fileID,
				functionName: functionName,
				lineNumber: lineNumber
			)
		}
	}
}



