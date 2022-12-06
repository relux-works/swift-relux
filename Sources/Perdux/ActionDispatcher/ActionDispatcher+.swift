
extension Collection where Element == PerduxAction {
	public func sequentialPerform(
		fileID: String = #fileID,
		functionName: String = #function,
		lineNumber: Int = #line
	) async {
		await ActionDispatcher.sequentialPerform(self.map { $0 }, fileID: fileID, functionName: functionName, lineNumber: lineNumber)
	}
	
	public func concurrentPerform(
		fileID: String = #fileID,
		functionName: String = #function,
		lineNumber: Int = #line
	) async {
		await ActionDispatcher.concurrentPerform(self.map { $0 }, fileID: fileID, functionName: functionName, lineNumber: lineNumber)
	}
	
	public func concurrentPerform(
		delay: Double,
		fileID: String = #fileID,
		functionName: String = #function,
		lineNumber: Int = #line
	) async {
		await ActionDispatcher.concurrentPerform(self.map { $0 }, delay: delay, fileID: fileID, functionName: functionName, lineNumber: lineNumber)
	}
}

extension PerduxAction {
	public func perform(
		fileID: String = #fileID,
		functionName: String = #function,
		lineNumber: Int = #line
	) async {
		await ActionDispatcher.emitAsync(self, fileID: fileID, functionName: functionName, lineNumber: lineNumber)
	}
	
	public func delayedPerform(
		delay: Double,
		fileID: String = #fileID,
		functionName: String = #function,
		lineNumber: Int = #line
	) async {
		await ActionDispatcher.emitAsync(self, delay: delay, fileID: fileID, functionName: functionName, lineNumber: lineNumber)
	}
}
