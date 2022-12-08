import Logger

@resultBuilder
public struct PerduxActionCompositionBuilder {
	public static func buildBlock() -> [PerduxAction] { [] }
	
	public static func buildBlock(_ actions: PerduxAction...) -> [PerduxAction] {
		actions
	}
}

public enum ExecutionType {
	case serially
	case concurrently
}

@inlinable
public func actions(
		_ executionType: ExecutionType = .serially,
		delay: Seconds? = nil,
		fileID: String = #fileID,
		functionName: String = #function,
		lineNumber: Int = #line,
		@PerduxActionCompositionBuilder actions: () -> [PerduxAction],
		label: (() -> String)? = nil
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
		action: () -> PerduxAction,
		label: (() -> String)? = nil
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
		_ executionType: ExecutionType = .serially,
		withPriority taskPriority: TaskPriority? = nil,
		delay: Seconds? = nil,
		fileID: String = #fileID,
		functionName: String = #function,
		lineNumber: Int = #line,
		@PerduxActionCompositionBuilder actions: @escaping () -> [PerduxAction],
		label: (() -> String)? = nil
) {

	Task(priority: taskPriority) {
		await _actions(executionType, delay: delay, fileID: fileID, functionName: functionName, lineNumber: lineNumber, actions: actions, label: label)
	}
}


@usableFromInline @inline(__always)
internal func _actions(
		_ executionType: ExecutionType = .serially,
		delay: Seconds? = nil,
		fileID: String = #fileID,
		functionName: String = #function,
		lineNumber: Int = #line,
		@PerduxActionCompositionBuilder actions: () -> [PerduxAction],
		label: (() -> String)? = nil
) async {
	let execStartTime = timestamp.milliseconds
	switch executionType {
	case .serially:
		await ActionDispatcher.sequentialPerform(actions(), delay: delay, fileID: fileID, functionName: functionName, lineNumber: lineNumber)
	case .concurrently:
		await ActionDispatcher.concurrentPerform(actions(), delay: delay, fileID: fileID, functionName: functionName, lineNumber: lineNumber)
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
	action: () -> PerduxAction,
	label: (() -> String)? = nil
) async {
	let execStartTime = timestamp.milliseconds
	await ActionDispatcher.emitAsync(action(), delay: delay, fileID: fileID, functionName: functionName, lineNumber: lineNumber)
	let execDurationMillis = timestamp.milliseconds - execStartTime
	
	if let label {
		if let delay {
			log("\(label()); \(execDurationMillis)ms, including delay \(delay*1000)ms; raw execution duration: \(execDurationMillis - Int(delay*1000))ms", category: .performance)
		} else {
			log("\(label()); \(execDurationMillis)ms", category: .performance)
		}
	}
}



